const std = @import("std");
const builtin = @import("builtin");
const raylib = @import("lib/raylib/src/build.zig");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    var target = b.standardTargetOptions(.{});

    // Standard optimization options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall. Here we do not
    // set a preferred release mode, allowing the user to decide how to optimize.
    const optimize = b.standardOptimizeOption(.{});

    const plugin_name = "clap-raw";

    const plugin = b.addSharedLibrary(.{
        .name = plugin_name,
        // In this case the main source file is merely a path, however, in more
        // complicated build scripts, this could be a generated file.
        .root_source_file = .{ .path = "src/Plugin.zig" },
        .target = target,
        .optimize = optimize,
    });

    plugin.linkLibC();
    plugin.linkLibrary(raylib.addRaylib(b, target, optimize));
    if (plugin.target.isDarwin())
        plugin.addCSourceFile("src/gui/gui_mac.m", &[_][]const u8{"-ObjC"})
    else if (plugin.target.isWindows())
        plugin.addCSourceFile("src/gui/gui_w32.c", &[_][]const u8{"-std=c99"});
    plugin.addIncludePath("lib/clap/include");
    plugin.addIncludePath("lib/raylib/src");

    // This declares intent for the library to be installed into the standard
    // location when the user invokes the "install" step (the default step when
    // running `zig build`).
    const install = b.addInstallArtifact(plugin);
    install.dest_sub_path = plugin_name ++ ".clap";
    b.getInstallStep().dependOn(&install.step);

    // Creates a step for unit testing.
    const main_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/Plugin.zig" },
        .target = target,
        .optimize = optimize,
    });

    // This creates a build step. It will be visible in the `zig build --help` menu,
    // and can be selected like this: `zig build test`
    // This will evaluate the `test` step rather than the default, which is "install".
    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);
}
