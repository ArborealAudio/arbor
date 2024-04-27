const std = @import("std");
const arbor = @import("src/arbor.zig");
const Format = arbor.Format;

// TODO: Implement a MacOS Universal Binary build mode which will build both archs & lipo
// TODO: Configure OSX sysroot so we can supply our own SDK

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const build_options = b.addOptions();
    const format = b.option(Format, "format", "Plugin format") orelse .CLAP;
    build_options.addOption(Format, "format", format);

    const arbor_mod = b.addModule("arbor", .{
        .root_source_file = b.path("src/arbor.zig"),
        .target = target,
        .optimize = optimize,
    });
    arbor_mod.addOptions("build_options", build_options);

    // build platform UI library
    arbor_mod.addImport("platform", buildPlatformGUI(b, target, optimize));
    arbor_mod.addImport("olivec", buildOlivec(b, target, optimize));

    const example = b.option([]const u8, "example", "Build an example plugin") orelse "";
    if (!std.mem.eql(u8, example, "")) {
        const plug = try buildExample(b, format, example, arbor_mod, target, optimize);
        b.installArtifact(plug);
        std.log.info("Built example: {s}\n", .{example});
        const copy_cmd = try CopyStep.createStep(b, format, target, plug);
        copy_cmd.step.dependOn(b.getInstallStep());
        const copy_step = b.step("copy", "Copy plugin to system dir");
        copy_step.dependOn(&copy_cmd.step);
    }

    // Creates a step for unit testing.
    // const clap_tests = b.addTest(.{
    //     .root_source_file = .{ .path = "src/clap_plugin.zig" },
    //     .target = target,
    //     .optimize = optimize,
    // });

    // const vst3_tests = b.addTest(.{
    //     .root_source_file = .{ .path = "src/vst3_plugin.zig" },
    //     .target = target,
    //     .optimize = optimize,
    // });

    // This creates a build step. It will be visible in the `zig build --help` menu,
    // and can be selected like this: `zig build test`
    // This will evaluate the `test` step rather than the default, which is "install".
    // const test_step = b.step("test", "Run library tests");
    // test_step.dependOn(&clap_tests.step);
    // test_step.dependOn(&vst3_tests.step);
}

fn buildPlatformGUI(
    b: *std.Build,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
) *std.Build.Module {
    const mod = b.addModule("GUI", .{
        .root_source_file = .{ .path = "src/gui/Platform.zig" },
        .link_libc = true,
        .target = target,
        .optimize = optimize,
    });
    mod.addIncludePath(.{ .path = "src" });
    const lib = b.addStaticLibrary(.{
        .name = "arbor-gui",
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });

    switch (lib.rootModuleTarget().os.tag) {
        .linux => {
            lib.addSystemIncludePath(.{ .path = "/usr/include/" });
            lib.linkSystemLibrary2("X11", .{ .needed = true });
            lib.addCSourceFile(.{
                .file = .{ .path = "src/gui/gui_x11.c" },
                .flags = &.{"-std=c99"},
            });
        },
        .windows => {
            lib.linkSystemLibrary2("gdi32", .{ .needed = true });
            lib.linkSystemLibrary2("user32", .{ .needed = true });
            lib.addCSourceFile(.{
                .file = .{ .path = "src/gui/gui_w32.c" },
                .flags = &.{"-std=c99"},
            });
        },
        .macos => {
            lib.linkFramework("Cocoa");
            lib.addCSourceFile(.{
                .file = b.path("src/gui/gui_mac.m"),
                .flags = &.{"-ObjC"},
            });
        },
        else => @panic("Unimplemented OS\n"),
    }

    mod.linkLibrary(lib);

    return mod;
}

fn buildOlivec(
    b: *std.Build,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
) *std.Build.Module {
    const mod = b.addModule("olivec", .{
        .root_source_file = b.path("src/olivec.zig"),
        .target = target,
        .optimize = optimize,
    });

    const lib = b.addStaticLibrary(.{
        .name = "olivec",
        .target = target,
        .optimize = optimize,
    });
    lib.addCSourceFile(.{
        .file = b.path("src/olive.c"),
        .flags = &.{"-DOLIVEC_IMPLEMENTATION"},
    });
    mod.linkLibrary(lib);

    return mod;
}

fn buildExample(
    b: *std.Build,
    format: Format,
    example: []const u8,
    module: *std.Build.Module,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
) !*std.Build.Step.Compile {
    const lib_src = try std.mem.concat(
        b.allocator,
        u8,
        &.{ "examples/", example, "/plugin.zig" },
    );
    const lib = b.addStaticLibrary(.{
        .name = example,
        .target = target,
        .optimize = optimize,
        .root_source_file = b.path(lib_src),
    });
    lib.root_module.addImport("arbor", module);

    const plug_src = switch (format) {
        .CLAP => "src/clap_plugin.zig",
        else => @panic("TODO: This plugin format\n"),
    };
    const plug = b.addSharedLibrary(.{
        .name = example,
        .target = target,
        .optimize = optimize,
        .root_source_file = b.path(plug_src),
    });
    plug.linkLibrary(lib);

    return plug;
}

pub const CopyStep = struct {
    const Step = std.Build.Step;
    step: Step,
    format: Format,
    target: std.Build.ResolvedTarget,
    artifact: *Step.Compile,

    pub fn createStep(
        b: *std.Build,
        format: Format,
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
            .format = format,
            .target = target,
            .artifact = artifact,
        };

        return self;
    }

    pub fn make(step: *Step, _: *std.Progress.Node) !void {
        const self: *CopyStep = @fieldParentPtr("step", step);
        try pluginCopyStep(step.owner, self.target, self.format, self.artifact);
    }
};

fn pluginCopyStep(
    b: *std.Build,
    target: std.Build.ResolvedTarget,
    format: Format,
    output: *std.Build.Step.Compile,
) !void {
    _ = b;
    var arena = std.heap.ArenaAllocator.init(std.heap.c_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    const os = target.result.os.tag;
    const home_dir = try std.process.getEnvVarOwned(allocator, "HOME");
    const install_dir = switch (format) {
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

    var plugin_dir = try std.fs.openDirAbsolute(install_dir, .{});
    defer plugin_dir.close();
    // TODO: Don't hardcode MacOS shite, make a OS functions if yo uahve  to
    const dest = try std.mem.concat(allocator, u8, &.{ output.name, ".clap/Contents" });
    var contents_dir = try plugin_dir.makeOpenPath(dest, .{});
    defer contents_dir.close();
    const gen_file = output.getEmittedBin().generated.getPath();
    // write copy bin file
    _ = try std.fs.cwd().updateFile(
        gen_file,
        contents_dir,
        try std.mem.concat(allocator, u8, &.{ "MacOS/", output.name }),
        .{},
    );

    // write MacOS plist & bundle thing
    // TODO: Actually format the plist
    if (os == .macos) {
        const plist = try contents_dir.createFile("Info.plist", .{});
        defer plist.close();
        try plist.writer().print(osx_bundle_plist, .{
            output.name, //CFBundleExecutable
            "com.ArborealAudio.Distortion", //CF BundleIdentifier
            output.name, //CFBundleName
            "0.1", //CFBundleShortVersion
            "0.1", //CFBundleVersion
            "(c) 2024 Arboreal Audio, LLC", //NSHumanReadableCopyright
        });
        const bndl = try contents_dir.createFile("PkgInfo", .{});
        defer bndl.close();
        try bndl.writeAll("BNDL????");
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
