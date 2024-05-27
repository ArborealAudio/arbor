const std = @import("std");
const builtin = @import("builtin");
const arbor = @import("src/plugin_description.zig");
const PluginConfig = arbor.PluginConfig;
const Format = arbor.Format;
const all_formats = std.enums.values(Format);
const Description = arbor.Description;

comptime {
    const minor_req = 15;
    if (builtin.zig_version.minor != minor_req)
        @compileError(std.fmt.comptimePrint("Requires Zig 0.{d}.x stable", .{minor_req}));
}

// TODO: Implement a MacOS Universal Binary build mode which will build both archs & lipo
// TODO: Configure OSX sysroot so we can supply our own SDK

pub const BuildConfig = struct {
    plugin_config: PluginConfig,
    plugin_config_path: std.Build.LazyPath,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
};

pub fn addPlugin(b: *std.Build, config: BuildConfig, formats: []const Format) !void {
    const root = b.dependencyFromBuildZig(@This(), .{});

    const plugin_config = config.plugin_config;
    const config_mod = b.addModule("config", .{
        .root_source_file = config.plugin_config_path,
    });

    const user_code = b.addLibrary(.{
        .name = "user_code",
        .root_module = b.createModule(.{
            .root_source_file = b.path(config.plugin_config.root_source_file),
            .target = config.target,
            .optimize = config.optimize,
        }),
        .use_llvm = true,
        .use_lld = config.target.result.os.tag == .windows,
    });

    const arbor_mod = b.addModule("arbor", .{
        .root_source_file = root.path("src/arbor.zig"),
        .target = config.target,
        .optimize = config.optimize,
        .link_libc = true,
        .imports = &.{.{
            .name = "config",
            .module = config_mod,
        }},
    });

    user_code.root_module.addImport("arbor", arbor_mod);

    // build UI library
    buildGUI(b, arbor_mod, config.target);

    const copy_step = b.step("copy", "Copy plugin to user plugins dir");

    for (formats) |fmt| {
        const plug = try buildPlugin(b, fmt, config, plugin_config);
        const opt = b.addOptions();
        opt.addOption(Format, "format", fmt);
        arbor_mod.addOptions("build_options", opt);
        plug.root_module.addImport("config", config_mod);
        plug.root_module.addOptions("build_options", opt);
        plug.root_module.addImport("arbor", arbor_mod);
        plug.linkLibrary(user_code);

        const bundle_step = try BundleStep.create(
            b,
            fmt,
            plugin_config,
            config.target.result.os,
            plug,
        );
        bundle_step.step.dependOn(&b.addInstallArtifact(plug, .{}).step);
        b.getInstallStep().dependOn(&bundle_step.step);

        const copy_cmd = try CopyStep.create(b, fmt, config, bundle_step);
        copy_cmd.step.dependOn(b.getInstallStep());
        copy_step.dependOn(&copy_cmd.step);
    }
    // }
}

fn buildGUI(
    b: *std.Build,
    arbor_mod: *std.Build.Module,
    target: std.Build.ResolvedTarget,
) void {
    const dep = b.dependencyFromBuildZig(@This(), .{});
    switch (target.result.os.tag) {
        .linux => {
            arbor_mod.addSystemIncludePath(.{ .cwd_relative = "/usr/include/" });
            arbor_mod.linkSystemLibrary("X11", .{});
            arbor_mod.addCSourceFile(.{
                .file = dep.path("src/gui/gui_x11.c"),
                .flags = &.{"-std=c99"},
            });
        },
        .windows => {
            arbor_mod.linkSystemLibrary("gdi32", .{});
            arbor_mod.linkSystemLibrary("user32", .{});
            arbor_mod.addCSourceFile(.{
                .file = dep.path("src/gui/gui_w32.c"),
                .flags = &.{"-std=c99"},
            });
        },
        .macos => {
            arbor_mod.linkFramework("Cocoa", .{});
            arbor_mod.addCSourceFile(.{
                .file = dep.path("src/gui/gui_mac.m"),
                .flags = &.{"-ObjC"},
            });
        },
        else => @panic("Unimplemented OS\n"),
    }
    arbor_mod.addCSourceFile(.{
        .file = dep.path("src/gui/olive.c"),
        .flags = &.{"-DOLIVEC_IMPLEMENTATION"},
    });
}

fn buildPlugin(
    b: *std.Build,
    current_format: Format,
    build_config: BuildConfig,
    plugin_config: PluginConfig,
) !*std.Build.Step.Compile {
    const dep = b.dependencyFromBuildZig(@This(), .{});
    const opt = b.addOptions();
    opt.addOption(Format, "format", current_format);

    // make sure we have a file name w/ no spaces
    const name = b.dupe(plugin_config.description.name);
    if (std.mem.containsAtLeastScalar(u8, name, 1, ' ')) {
        @panic("Plugin name cannot contains spaces\n");
    }

    const plug_src = switch (current_format) {
        .CLAP => "src/clap_plugin.zig",
        .VST2 => "src/vst2_plugin.zig",
        .VST3 => "src/anv_plugin.zig",
    };
    const plug = b.addLibrary(.{
        .linkage = .dynamic,
        .name = name,
        .root_module = b.createModule(.{
            .root_source_file = dep.path(plug_src),
            .target = build_config.target,
            .optimize = build_config.optimize,
            .pic = true,
            .strip = false,
        }),
        .use_llvm = true,
        .use_lld = build_config.target.result.os.tag == .windows,
    });

    return plug;
}

pub const BundleStep = struct {
    const Step = std.Build.Step;
    step: Step,
    format: Format,
    config: PluginConfig,
    target_os: std.Target.Os,
    build_dep: *Step.Compile,
    bundle_name: ?[]const u8 = null,
    /// path to the generated bundle (which may be just a file)
    bundle_path: ?[]const u8 = null,
    /// path to pdb debug info on windows
    pdb: ?[]const u8 = null,

    pub fn create(
        b: *std.Build,
        format: Format,
        config: PluginConfig,
        target_os: std.Target.Os,
        build_dep: *Step.Compile,
    ) !*BundleStep {
        const self = try b.allocator.create(BundleStep);
        self.* = .{
            .step = Step.init(.{
                .id = .custom,
                .name = "Bundle Step",
                .owner = b,
                .makeFn = make,
            }),
            .format = format,
            .config = config,
            .target_os = target_os,
            .build_dep = build_dep,
        };
        return self;
    }

    pub fn make(step: *Step, _: std.Build.Step.MakeOptions) !void {
        const self: *BundleStep = @fieldParentPtr("step", step);
        const b = self.step.owner;
        const dest = b.install_path;
        const target_os = self.target_os.tag;

        const format_extensions = make: {
            const Array = std.EnumArray(Format, []const u8);
            var arr = Array.initUndefined();
            arr.set(Format.CLAP, ".clap");
            arr.set(Format.VST2, switch (target_os) {
                .windows => ".dll",
                .macos => ".vst",
                .linux => ".so",
                else => @panic("Unsupported OS"),
            });
            arr.set(Format.VST3, ".vst3");
            break :make arr;
        };

<<<<<<< HEAD
        const gen_file = self.build_dep.getEmittedBin().getPath(b);
=======
        const gen_file = self.build_dep.getEmittedBin().generated.getPath();
        if (target_os == .windows) self.pdb = self.build_dep.getEmittedPdb().generated.getPath();
>>>>>>> 31c0287 (ANV: Start working on ANV plugin)
        const ext = format_extensions.get(self.format);
        // make double sure we have a file name w/ no spaces
        const out_name = try b.allocator.dupe(u8, self.build_dep.name);
        std.mem.replaceScalar(u8, out_name, ' ', '_');

        const out_file = try std.mem.concat(b.allocator, u8, &.{
            out_name,
            ext,
        });
        self.bundle_name = out_file;

        switch (target_os) {
            .macos => {
                const bundle = b.pathJoin(&.{ out_file, "Contents" });
                var bundle_dir = try std.fs.cwd().makeOpenPath(b.pathJoin(&.{ dest, bundle }), .{});
                defer bundle_dir.close();
                _ = try std.fs.cwd().updateFile(gen_file, bundle_dir, b.pathJoin(&.{
                    "MacOS",
                    self.build_dep.name,
                }), .{});
                const plist = try bundle_dir.createFile("Info.plist", .{});
                defer plist.close();
                // LOVING THE NEW IO INTERFACE 🤣
                var writer = plist.deprecatedWriter();
                try writer.print(osx_bundle_plist, .{
                    out_name, //CFBundleExecutable
                    self.config.description.id, //CF BundleIdentifier
                    out_name, //CFBundleName
                    out_name, //CFBundleDisplayName
                    self.config.description.version, //CFBundleShortVersion
                    self.config.description.version, //CFBundleVersion
                    self.config.description.copyright, //NSHumanReadableCopyright
                });
                const bndl = try bundle_dir.createFile("PkgInfo", .{});
                defer bndl.close();
                try bndl.writeAll("BNDL????");
            },
            .windows, .linux => {
                if (self.format != .VST3) {
                    var out_dir = try std.fs.cwd().makeOpenPath(dest, .{});
                    defer out_dir.close();
                    _ = try std.fs.cwd().updateFile(gen_file, out_dir, out_file, .{});
                } else {
                    const bin_filename = if (target_os == .linux)
                        try std.mem.concat(b.allocator, u8, &.{ out_name, ".so" })
                    else
                        out_file;
                    const bundle = b.pathJoin(&.{ out_file, "Contents" });
                    const os_name = @tagName(builtin.cpu.arch) ++ "-" ++ @tagName(builtin.os.tag);
                    var bundle_dir = try std.fs.cwd().makeOpenPath(b.pathJoin(&.{ dest, bundle }), .{});
                    defer bundle_dir.close();
                    _ = try std.fs.cwd().updateFile(gen_file, bundle_dir, b.pathJoin(&.{
                        os_name,
                        bin_filename,
                    }), .{});
                }
            },
            else => @panic("Unsupported OS"),
        }

        self.bundle_path = b.pathJoin(&.{
            dest,
            out_file,
        });
    }
};

pub const CopyStep = struct {
    const Step = std.Build.Step;
    step: Step,
    format: Format,
    config: BuildConfig,
    bundle: *BundleStep,

    pub fn create(
        b: *std.Build,
        format: Format,
        config: BuildConfig,
        bundle: *BundleStep,
    ) !*CopyStep {
        const self = try b.allocator.create(CopyStep);
        self.* = .{
            .step = Step.init(.{
                .id = .custom,
                .name = "Copy Step",
                .owner = b,
                .makeFn = make,
            }),
            .config = config,
            .format = format,
            .bundle = bundle,
        };

        return self;
    }

    pub fn make(step: *Step, _: std.Build.Step.MakeOptions) !void {
        const self: *CopyStep = @fieldParentPtr("step", step);
        const b = step.owner;
        const plugin_name = b.dupe(self.config.description.name);
        std.mem.replaceScalar(u8, plugin_name, ' ', '_');
        const target = self.config.target;
        const format = self.format;
        const bundle_name = self.bundle.bundle_name orelse return error.NoBundleName;
        const bundle_path = self.bundle.bundle_path orelse return error.NoBundlePath;
        const os = check: {
            if (target.query.os_tag) |t_os| {
                if (t_os == builtin.os.tag)
                    break :check t_os
                else {
                    std.log.err("Don't run copy step when cross-compiling. Where am I supposed to put the file??\n", .{});
                    return error.CrossCompileCopy;
                }
            } else break :check builtin.os.tag;
        };
        const home_dir = try std.process.getEnvVarOwned(
            b.allocator,
            if (os != .windows) "HOME" else "USERPROFILE",
        );
        const sys_install_path = switch (format) {
            .CLAP => switch (os) {
                .linux => b.pathJoin(&.{ home_dir, "/.clap/" }),
                .macos => b.pathJoin(&.{ home_dir, "/Library/Audio/Plug-Ins/CLAP/" }),
                .windows => "/Program Files/Common Files/CLAP/",
                else => @panic("Unsupported OS"),
            },
            .VST3 => switch (os) {
                .linux => b.pathJoin(&.{ home_dir, "/.vst3/" }),
                .macos => b.pathJoin(&.{ home_dir, "/Library/Audio/Plug-Ins/VST3/" }),
                .windows => "/Program Files/Common Files/VST3/",
                else => @panic("Unsupported OS"),
            },
            .VST2 => switch (os) {
                .linux => b.pathJoin(&.{ home_dir, "/.vst/" }),
                .macos => b.pathJoin(&.{ home_dir, "/Library/Audio/Plug-Ins/VST/" }),
                .windows => "/Program Files/Steinberg/VstPlugins/",
                else => @panic("Unsupported OS"),
            },
        };
        const plugin_dest_path = if (os == .macos or format == .VST3) b.pathJoin(&.{
            sys_install_path,
            bundle_name,
        }) else sys_install_path;

        var plugin_dir = try std.fs.cwd().makeOpenPath(plugin_dest_path, .{});
        defer plugin_dir.close();

        if (os == .macos or format == .VST3) {
            var bundle_dir = try std.fs.cwd().makeOpenPath(bundle_path, .{ .iterate = true });
            defer bundle_dir.close();
            try copyRecursive(b.allocator, bundle_dir, plugin_dir);
        } else {
            _ = try std.fs.cwd().updateFile(bundle_path, plugin_dir, bundle_name, .{});
            if (os == .windows) if (self.bundle.pdb) |pdb| {
                const pdb_name = try std.mem.concat(b.allocator, u8, &.{
                    plugin_name,
                    ".pdb",
                });
                _ = try std.fs.cwd().updateFile(pdb, plugin_dir, pdb_name, .{});
            };
        }
    }
};

const osx_bundle_plist =
    \\<?xml version="1.0" encoding="UTF-8"?>
    \\<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    \\<plist version="1.0">
    \\<dict>
    \\  <key>CFBundleDevelopmentRegion</key>
    \\  <string>English</string>
    \\  <key>CFBundleExecutable</key>
    \\  <string>{s}</string>
    \\  <key>CFBundleGetInfoString</key>
    \\  <string></string>
    \\  <key>CFBundleIconFile</key>
    \\  <string></string>
    \\  <key>CFBundleIdentifier</key>
    \\  <string>{s}</string>
    \\  <key>CFBundleInfoDictionaryVersion</key>
    \\  <string>6.0</string>
    \\  <key>CFBundleName</key>
    \\  <string>{s}</string>
    \\  <key>CFBundleDisplayName</key>
    \\  <string>{s}</string>
    \\  <key>CFBundlePackageType</key>
    \\  <string>BNDL</string>
    \\  <key>CFBundleShortVersionString</key>
    \\  <string>{s}</string>
    \\  <key>CFBundleSignature</key>
    \\  <string>????</string>
    \\  <key>CFBundleVersion</key>
    \\  <string>{s}</string>
    \\  <key>CSResourcesFileMapped</key>
    \\  <true/>
    \\  <key>NSHumanReadableCopyright</key>
    \\  <string>{s}</string>
    \\  <key>NSHighResolutionCapable</key>
    \\  <true/>
    \\</dict>
    \\</plist>
    \\
;

<<<<<<< HEAD
pub fn build(_: *std.Build) void {}
=======
pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    if (b.option(bool, "examples", "Build example plugins")) |_| {
        const format = b.option(Format, "format", "Plugin format");
        const copy_step = b.step("copy", "Copy plugin to user plugins dir");
        inline for (examples) |ex| {
            var config = ex.withSource(b.pathJoin(&.{ "examples", ex.description.name, "plugin.zig" }));
            config = config.withName("Example " ++ ex.description.name);
            config.target = target;
            config.optimize = optimize;
            if (format) |fmt| {
                std.log.info("Building example {s} plugin: {s}\n", .{ @tagName(fmt), ex.description.name });
                const plug = try addExample(b, config, fmt);
                const bundle_step = try BundleStep.create(b, fmt, config, plug);
                bundle_step.step.dependOn(&b.addInstallArtifact(plug, .{}).step);
                b.getInstallStep().dependOn(&bundle_step.step);
                const copy_cmd = try CopyStep.create(b, fmt, config, bundle_step);
                copy_cmd.step.dependOn(b.getInstallStep());
                copy_step.dependOn(&copy_cmd.step);
            } else {
                inline for (formats) |fmt| {
                    std.log.info("Building example {s} plugin: {s}\n", .{ @tagName(fmt), ex.description.name });
                    const plug = try addExample(b, config, fmt);
                    const bundle_step = try BundleStep.create(b, fmt, config, plug);
                    bundle_step.step.dependOn(&b.addInstallArtifact(plug, .{}).step);
                    b.getInstallStep().dependOn(&bundle_step.step);
                    const copy_cmd = try CopyStep.create(b, fmt, config, bundle_step);
                    copy_cmd.step.dependOn(b.getInstallStep());
                    copy_step.dependOn(&copy_cmd.step);
                }
            }
        }
    }

    // Creates a step for unit testing.
    const tests = b.addTest(.{
        .root_source_file = b.path("src/tests.zig"),
        .target = target,
        .optimize = optimize,
    });
    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&tests.step);
}

const default_config = BuildConfig{
    .description = .{
        .name = undefined,
        .id = undefined,
        .company = "Arboreal Audio",
        .version = "0.1.0",
        .copyright = "(c) 2024 Arboreal Audio, LLC",
        .url = "",
        .manual = "",
        .contact = "",
        .description = "Vintage analog warmth",
    },
    .features = features.STEREO | features.EFFECT,
    .root_source_file = undefined,
    .target = undefined,
    .optimize = undefined,
};

const examples = [_]BuildConfig{
    default_config.withName("Distortion").withID("com.Arbor.ExDist").withFeature(features.GUI),
    default_config.withName("Filter").withID("com.Arbor.ExFilter"), // < testing compile w/out GUI
};

// NOTE: WOW had to copy all build logic b/c I couldn't figure out how to diverge
// it based on relative build root. That is to say, you can't use dependency-relative
// paths while using this repo on its own (as you probably would when testing w/
// example plugins) and you can't use build-relative paths when using this as a module,
// so this is a bad solution that is also the only thing I can think to do.

pub fn addExample(b: *std.Build, config: BuildConfig, format: Format) !*std.Build.Step.Compile {
    const target = config.target;
    const optimize = config.optimize;

    const build_options = b.addOptions();
    // NOTE: Explore doing formats as an enum passed in BuildConfig rather than CLI option
    // Or -- CLI option overrides build options or vice-versa.
    build_options.addOption(Format, "format", format);
    build_options.addOption(Description, "plugin_desc", config.description);
    build_options.addOption(arbor.PluginFeatures, "plugin_features", config.features);

    const arbor_mod = b.addModule("arbor", .{
        .root_source_file = b.path("src/arbor.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });
    arbor_mod.addOptions("config", build_options);

    // build UI library
    buildGUIExample(b, arbor_mod, target);

    const plug = try buildExample(b, arbor_mod, format, config);
    plug.root_module.addOptions("config", build_options);

    b.installArtifact(plug);
    return plug;
}

fn buildGUIExample(
    b: *std.Build,
    arbor_mod: *std.Build.Module,
    target: std.Build.ResolvedTarget,
) void {
    switch (target.result.os.tag) {
        .linux => {
            arbor_mod.addSystemIncludePath(.{ .cwd_relative = "/usr/include/" });
            arbor_mod.linkSystemLibrary("X11", .{});
            arbor_mod.addCSourceFile(.{
                .file = b.path("src/gui/gui_x11.c"),
                .flags = &.{"-std=c99"},
            });
        },
        .windows => {
            arbor_mod.linkSystemLibrary("gdi32", .{});
            arbor_mod.linkSystemLibrary("user32", .{});
            arbor_mod.addCSourceFile(.{
                .file = b.path("src/gui/gui_w32.c"),
                .flags = &.{"-std=c99"},
            });
        },
        .macos => {
            arbor_mod.linkFramework("Cocoa", .{});
            arbor_mod.addCSourceFile(.{
                .file = b.path("src/gui/gui_mac.m"),
                .flags = &.{"-ObjC"},
            });
        },
        else => @panic("Unimplemented OS\n"),
    }
    arbor_mod.addCSourceFile(.{
        .file = b.path("src/gui/olive.c"),
        .flags = &.{"-DOLIVEC_IMPLEMENTATION"},
    });
}

fn buildExample(
    b: *std.Build,
    module: *std.Build.Module,
    format: Format,
    config: BuildConfig,
) !*std.Build.Step.Compile {
    // make sure we have a file name w/ no spaces
    const name = try b.allocator.dupe(u8, config.description.name);
    std.mem.replaceScalar(u8, name, ' ', '_');

    const usr_plug = b.addStaticLibrary(.{
        .name = name,
        .root_source_file = b.path(config.root_source_file),
        .target = config.target,
        .optimize = config.optimize,
        .pic = true,
    });
    usr_plug.root_module.addImport("arbor", module);

    const plug_src = switch (format) {
        .CLAP => "src/clap_plugin.zig",
        .VST2 => "src/vst2_plugin.zig",
        .VST3 => "src/anv_plugin.zig",
    };
    const plug = b.addSharedLibrary(.{
        .name = name,
        .root_source_file = b.path(plug_src),
        .target = config.target,
        .optimize = config.optimize,
        .pic = true,
    });
    plug.linkLibrary(usr_plug);

    return plug;
}
>>>>>>> 31c0287 (ANV: Start working on ANV plugin)

const Dir = std.fs.Dir;

fn copyRecursive(allocator: std.mem.Allocator, src: Dir, dest: Dir) !void {
    var walk = try src.walk(allocator);
    defer walk.deinit();

    while (try walk.next()) |file| {
        switch (file.kind) {
            .file => _ = try file.dir.updateFile(
                file.basename,
                dest,
                file.path,
                .{},
            ),
            .directory => try dest.makePath(file.path),
            else => {},
        }
    }
}

test "copy recursive" {
    const alloc = std.testing.allocator;
    var tmp = std.testing.tmpDir(.{ .iterate = true });
    defer tmp.cleanup();
    try tmp.dir.writeFile("Chunk", "This is a chunk");

    var dest = std.testing.tmpDir(.{ .iterate = true });
    defer dest.cleanup();

    try copyRecursive(alloc, tmp.dir, dest.dir);

    const tmp_content = try alloc.alloc(u8, 512);
    defer alloc.free(tmp_content);
    {
        var iter = tmp.dir.iterate();
        while (try iter.next()) |file| {
            if (file.kind == .file) {
                _ = try tmp.dir.readFile(file.name, tmp_content);
            }
        }
    }
    const dest_content = try alloc.alloc(u8, 512);
    defer alloc.free(dest_content);
    {
        var iter = dest.dir.iterate();
        while (try iter.next()) |file| {
            if (file.kind == .file) {
                _ = try tmp.dir.readFile(file.name, dest_content);
            }
        }
    }

    try std.testing.expectEqualStrings(tmp_content, dest_content);
}
