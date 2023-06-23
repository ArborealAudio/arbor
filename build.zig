const std = @import("std");
const builtin = @import("builtin");
const raylib = @import("lib/raylib/src/build.zig");
const Plugin = @import("src/Plugin.zig");
const Format = Plugin.Format;

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    //TODO: Implement a Universal Binary build mode which will build both archs & lipo

    const optimize = b.standardOptimizeOption(.{});

    const build_options = b.addOptions();
    const format = b.option(Format, "format", "Plugin format");

    if (format == null) {
        std.log.err("Provide a format\n", .{});
        std.process.exit(1);
    }
    build_options.addOption(Format, "format", format.?);

    const plugin_name = "ZigVerb";
    const filename = plugin_name ++ switch (format.?) {
        .CLAP => ".clap",
        .VST3 => ".vst3",
    };
    const root_file = if (format.? == .CLAP) "src/clap_plugin.zig" else "src/vst3_plugin.zig";
    const sdk_include = if (format.? == .CLAP) "lib/clap/include" else "";
    const install_dir = switch (format.?) {
        .CLAP => switch (target.getOsTag()) {
            .linux => "/home/alex/.clap/" ++ filename,
            .macos => "/Users/alex/Library/Audio/Plug-Ins/CLAP/" ++ filename,
            .windows => "/Program Files/Common Files/CLAP/" ++ filename ++ "/",
            else => {
                std.log.err("Unsupported OS\n", .{});
                std.process.exit(1);
            },
        },
        .VST3 => switch (target.getOsTag()) {
            .linux => "/home/alex/.vst3/" ++ filename,
            .macos => "/Users/alex/Library/Audio/Plug-Ins/VST3/" ++ filename,
            .windows => "/Program Files/Common Files/VST3/" ++ filename ++ "/",
            else => {
                std.log.err("Unsupported OS\n", .{});
                std.process.exit(1);
            },
        },
    };

    const plugin = b.addSharedLibrary(.{
        .name = plugin_name,
        // In this case the main source file is merely a path, however, in more
        // complicated build scripts, this could be a generated file.
        .root_source_file = .{ .path = root_file },
        .target = target,
        .optimize = optimize,
    });

    plugin.addOptions("build_options", build_options);

    if (plugin.optimize == .ReleaseFast)
        plugin.strip = true;

    // if (b.sysroot == null) {
    //     std.log.warn("No sysroot defined. Building for MacOS may have undefined symbols\n", .{});
    // } else std.log.info("sysroot: {s}\n", .{b.sysroot.?});

    plugin.linkLibC();
    plugin.linkLibrary(raylib.addRaylib(b, target, optimize, .{}));
    if (plugin.target.isDarwin()) {
        plugin.addCSourceFile("src/gui/gui_mac.m", &[_][]const u8{"-ObjC"});
    } else if (plugin.target.isWindows())
        plugin.addCSourceFile("src/gui/gui_w32.c", &[_][]const u8{"-std=c99"})
    else if (plugin.target.isLinux())
        plugin.addCSourceFile("src/gui/gui_x11.c", &[_][]const u8{"-std=c99"});
    plugin.addIncludePath(sdk_include);
    plugin.addIncludePath("lib/raylib/src");
    plugin.addIncludePath("lib/raylib/src/external/glfw/include");

    const install = b.addInstallArtifact(plugin);
    install.dest_sub_path = plugin_name;
    b.getInstallStep().dependOn(&install.step);

    // step for copying built binary to system directory
    const copy_step = b.step("copy", "Copy the built artifact to default system location");
    const copy = b.addSystemCommand(&[_][]const u8{"/bin/cp"});
    copy.addFileSourceArg(install.artifact.getOutputSource());
    copy.addArg(install_dir);
    copy_step.dependOn(&copy.step);

    // Creates a step for unit testing.
    const main_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/clap_plugin.zig" },
        .target = target,
        .optimize = optimize,
    });

    const vst3_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/vst3_plugin.zig" },
        .target = target,
        .optimize = optimize,
    });

    // This creates a build step. It will be visible in the `zig build --help` menu,
    // and can be selected like this: `zig build test`
    // This will evaluate the `test` step rather than the default, which is "install".
    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);
    test_step.dependOn(&vst3_tests.step);
}
