const std = @import("std");
const builtin = @import("builtin");
const arbor = @import("src/arbor.zig");
const Format = arbor.Format;
const Description = arbor.Plugin.Description;
pub const features = arbor.features;

comptime {
    if (builtin.zig_version.minor != 12) @compileError("Requires Zig 0.12 stable");
}

// TODO: Implement a MacOS Universal Binary build mode which will build both archs & lipo
// TODO: Configure OSX sysroot so we can supply our own SDK

pub const BuildConfig = struct {
    description: Description,
    features: arbor.PluginFeatures,
    root_source_file: []const u8,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
};

pub fn addPlugin(b: *std.Build, config: BuildConfig) !void {
    const root = b.dependencyFromBuildZig(@This(), .{});
    const target = config.target;
    const optimize = config.optimize;

    const build_options = b.addOptions();
    // NOTE: Explore doing formats as an enum passed in BuildConfig rather than CLI option
    // Or -- CLI option overrides build options or vice-versa.
    const format = b.option(Format, "format", "Plugin format") orelse .CLAP;
    build_options.addOption(Format, "format", format);
    build_options.addOption(Description, "plugin_desc", config.description);
    build_options.addOption(arbor.PluginFeatures, "plugin_features", config.features);

    const arbor_mod = b.addModule("arbor", .{
        .root_source_file = root.path("src/arbor.zig"),
        .target = target,
        .optimize = optimize,
    });
    arbor_mod.addOptions("build_options", build_options);

    // build UI library
    buildGUI(b, arbor_mod, target, optimize);

    const plug = try buildPlugin(b, arbor_mod, format, config);
    plug.root_module.addOptions("build_options", build_options);

    b.installArtifact(plug);
    const copy_cmd = try CopyStep.createStep(b, format, config, target, plug);
    copy_cmd.step.dependOn(b.getInstallStep());
    _ = b.step("copy", "Copy plugin to user plugins dir").dependOn(&copy_cmd.step);

    // Creates a step for unit testing.
    const tests = b.addTest(.{
        .root_source_file = root.path("src/tests.zig"),
        .target = target,
        .optimize = optimize,
    });
    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&tests.step);
}

fn buildGUI(
    b: *std.Build,
    arbor_mod: *std.Build.Module,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
) void {
    const dep = b.dependencyFromBuildZig(@This(), .{});
    // NOTE: Is it really necessary to make it a static lib? Could we just add
    // the relevant C files to the plugin?
    const platform = b.addStaticLibrary(.{
        .name = "platform-gui",
        .root_source_file = dep.path("src/gui/platform.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });
    switch (target.result.os.tag) {
        .linux => {
            platform.addSystemIncludePath(.{ .path = "/usr/include/" });
            platform.linkSystemLibrary("X11");
            platform.addCSourceFile(.{
                .file = dep.path("src/gui/gui_x11.c"),
                .flags = &.{"-std=c99"},
            });
        },
        .windows => {
            platform.linkSystemLibrary("gdi32");
            platform.linkSystemLibrary("user32");
            platform.addCSourceFile(.{
                .file = dep.path("src/gui/gui_w32.c"),
                .flags = &.{"-std=c99"},
            });
        },
        .macos => {
            platform.linkFramework("Cocoa");
            platform.addCSourceFile(.{
                .file = dep.path("src/gui/gui_mac.m"),
                .flags = &.{"-ObjC"},
            });
        },
        else => @panic("Unimplemented OS\n"),
    }
    arbor_mod.linkLibrary(platform);
    arbor_mod.addCSourceFile(.{
        .file = dep.path("src/gui/olive.c"),
        .flags = &.{"-DOLIVEC_IMPLEMENTATION"},
    });
}

fn buildPlugin(
    b: *std.Build,
    module: *std.Build.Module,
    format: Format,
    config: BuildConfig,
) !*std.Build.Step.Compile {
    const dep = b.dependencyFromBuildZig(@This(), .{});
    // make sure we have a file name w/ no spaces
    const name = try b.allocator.dupe(u8, config.description.name);
    std.mem.replaceScalar(u8, name, ' ', '_');

    const usr_plug = b.addStaticLibrary(.{
        .name = name,
        .root_source_file = b.path(config.root_source_file),
        .target = config.target,
        .optimize = config.optimize,
    });
    usr_plug.root_module.addImport("arbor", module);

    const plug_src = switch (format) {
        .CLAP => "src/clap_plugin.zig",
        else => @panic("TODO: This format"),
    };
    const plug = b.addSharedLibrary(.{
        .name = name,
        .root_source_file = dep.path(plug_src),
        .target = config.target,
        .optimize = config.optimize,
    });
    plug.linkLibrary(usr_plug);

    return plug;
}

pub fn build(b: *std.Build) !void {
    _ = b;
}

pub const CopyStep = struct {
    const Step = std.Build.Step;
    step: Step,
    format: Format,
    config: BuildConfig,
    target: std.Build.ResolvedTarget,
    artifact: *Step.Compile,

    pub fn createStep(
        b: *std.Build,
        format: Format,
        config: BuildConfig,
        target: std.Build.ResolvedTarget,
        artifact: *Step.Compile,
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
            .target = target,
            .artifact = artifact,
        };

        return self;
    }

    pub fn make(step: *Step, _: *std.Progress.Node) !void {
        const self: *CopyStep = @fieldParentPtr("step", step);
        try pluginCopyStep(step.owner, self.config, self.target, self.format, self.artifact);
    }
};

fn pluginCopyStep(
    b: *std.Build,
    config: BuildConfig,
    target: std.Build.ResolvedTarget,
    format: Format,
    output: *std.Build.Step.Compile,
) !void {
    var arena = std.heap.ArenaAllocator.init(b.allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    const os = target.result.os.tag;
    const home_dir = try std.process.getEnvVarOwned(
        allocator,
        if (os != .windows) "HOME" else "USERPROFILE",
    );
    const sys_install_path = switch (format) {
        .CLAP => switch (os) {
            .linux => try std.mem.concat(allocator, u8, &.{ home_dir, "/.clap/" }),
            .macos => try std.mem.concat(allocator, u8, &.{ home_dir, "/Library/Audio/Plug-Ins/CLAP/" }),
            .windows => "/Program Files/Common Files/CLAP/",
            else => @panic("Unsupported OS"),
        },
        .VST3 => switch (os) {
            .linux => try std.mem.concat(allocator, u8, &.{ home_dir, "/.vst3/" }),
            .macos => try std.mem.concat(allocator, u8, &.{ home_dir, "/Library/Audio/Plug-Ins/VST3/" }),
            .windows => "/Program Files/Common Files/VST3/",
            else => @panic("Unsupported OS"),
        },
        .VST2 => switch (os) {
            .linux => try std.mem.concat(allocator, u8, &.{ home_dir, "/.vst/" }),
            .macos => try std.mem.concat(allocator, u8, &.{ home_dir, "/Library/Audio/Plug-Ins/VST/" }),
            .windows => "/Program Files/Steinberg/VstPlugins/",
            else => @panic("Unsupported OS"),
        },
    };

    var plugin_dir = try std.fs.openDirAbsolute(sys_install_path, .{});
    defer plugin_dir.close();
    const gen_file = output.getEmittedBin().generated.getPath();

    // make double sure we have a file name w/ no spaces
    const out_name = try b.allocator.dupe(u8, output.name);
    std.mem.replaceScalar(u8, out_name, ' ', '_');

    switch (os) {
        .macos => {
            const extension = switch (format) {
                .CLAP => ".clap/Contents",
                .VST3 => ".vst3/Contents",
                .VST2 => ".vst/Contents",
            };
            const contents_path = try std.mem.concat(allocator, u8, &.{ out_name, extension });
            var contents_dir = try plugin_dir.makeOpenPath(contents_path, .{});
            defer contents_dir.close();
            _ = try std.fs.cwd().updateFile(
                gen_file,
                contents_dir,
                try std.mem.concat(allocator, u8, &.{ "MacOS/", out_name }),
                .{},
            );
            const plist = try contents_dir.createFile("Info.plist", .{});
            defer plist.close();
            try plist.writer().print(osx_bundle_plist, .{
                out_name, //CFBundleExecutable
                config.description.id, //CF BundleIdentifier
                out_name, //CFBundleName
                config.description.version, //CFBundleShortVersion
                config.description.version, //CFBundleVersion
                config.description.copyright, //NSHumanReadableCopyright
            });
            const bndl = try contents_dir.createFile("PkgInfo", .{});
            defer bndl.close();
            try bndl.writeAll("BNDL????");
        },
        .linux => {
            const extension = switch (format) {
                .CLAP => ".clap",
                .VST3 => ".vst3/Contents",
                .VST2 => ".so",
            };
            const contents_path = try std.mem.concat(allocator, u8, &.{ out_name, extension });
            if (format != .VST3) {
                _ = try std.fs.cwd().updateFile(
                    gen_file,
                    plugin_dir,
                    contents_path,
                    .{},
                );
            } else {
                var dest_dir = try plugin_dir.makeOpenPath(contents_path, .{});
                defer dest_dir.close();
                _ = try std.fs.cwd().updateFile(
                    gen_file,
                    dest_dir,
                    try std.mem.concat(allocator, u8, &.{ "x86_64-linux/", out_name, ".so" }),
                    .{},
                );
            }
        },
        .windows => {
            const extension = switch (format) {
                .CLAP => ".clap",
                .VST3 => ".vst3/Contents",
                .VST2 => ".dll",
            };
            const contents_path = try std.mem.concat(allocator, u8, &.{ out_name, extension });
            if (format != .VST3) {
                if (plugin_dir.access(contents_path, .{})) {} else |err| {
                    if (err == error.FileNotFound) {
                        var dest_file = try plugin_dir.createFile(contents_path, .{});
                        defer dest_file.close();
                    } else return err;
                }
                _ = try std.fs.cwd().updateFile(gen_file, plugin_dir, contents_path, .{});
                if (output.root_module.optimize) |opt| {
                    if (opt == .Debug) {
                        const gen_pdb = output.getEmittedPdb().generated.getPath();
                        _ = try std.fs.cwd().updateFile(
                            gen_pdb,
                            plugin_dir,
                            try std.mem.concat(allocator, u8, &.{ out_name, ".pdb" }),
                            .{},
                        );
                    }
                }
            }
        },
        else => @panic("Unsupported OS"),
    }
}

const osx_bundle_plist =
    \\<?xml version="1.0" encoding="UTF-8"?>
    \\<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    \\<plist version="1.0">
    \\<dict>
    \\	<key>CFBundleDevelopmentRegion</key>
    \\	<string>English</string>
    \\	<key>CFBundleExecutable</key>
    \\	<string>{s}</string>
    \\	<key>CFBundleGetInfoString</key>
    \\	<string></string>
    \\	<key>CFBundleIconFile</key>
    \\	<string></string>
    \\	<key>CFBundleIdentifier</key>
    \\	<string>{s}</string>
    \\	<key>CFBundleInfoDictionaryVersion</key>
    \\	<string>6.0</string>
    \\	<key>CFBundleName</key>
    \\	<string>{s}</string>
    \\	<key>CFBundlePackageType</key>
    \\	<string>BNDL</string>
    \\	<key>CFBundleShortVersionString</key>
    \\	<string>{s}</string>
    \\	<key>CFBundleSignature</key>
    \\	<string>????</string>
    \\	<key>CFBundleVersion</key>
    \\	<string>{s}</string>
    \\	<key>CSResourcesFileMapped</key>
    \\	<true/>
    \\	<key>NSHumanReadableCopyright</key>
    \\	<string>{s}</string>
    \\  <key>NSHighResolutionCapable</key>
    \\  <true/>
    \\</dict>
    \\</plist>
    \\
;
