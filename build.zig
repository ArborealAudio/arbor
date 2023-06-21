const std = @import("std");
const builtin = @import("builtin");
const raylib = @import("lib/raylib/src/build.zig");

const Format = enum { CLAP, VST3 };

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

    const format = b.option(Format, "format", "Plugin format");

    if (format == null)
        std.debug.panic("Provide a format\n", .{});

    var plugin_name: []const u8 = undefined;
    var root_file: []const u8 = undefined;
    var sdk_include: []const u8 = undefined;
    var lib_dir: []const u8 = undefined;

    switch (format.?) {
        .CLAP => {
            root_file = "src/clap_plugin.zig";
            sdk_include = "lib/clap/include";
            lib_dir = "/home/alex/.clap/clap-raw.clap";
            plugin_name = "clap-raw.clap";
        },
        .VST3 => {
            root_file = "src/vst3_plugin.zig";
            sdk_include = "";
            lib_dir = "/home/alex/.vst3/vst3-raw.vst3";
            plugin_name = "vst3-raw.vst3";
        },
    }

    const plugin = b.addSharedLibrary(.{
        .name = plugin_name,
        // In this case the main source file is merely a path, however, in more
        // complicated build scripts, this could be a generated file.
        .root_source_file = .{ .path = root_file },
        .target = target,
        .optimize = optimize,
    });

    plugin.linkLibC();
    plugin.linkLibrary(raylib.addRaylib(b, target, optimize));
    if (plugin.target.isDarwin())
        plugin.addCSourceFile("src/gui/gui_mac.m", &[_][]const u8{"-ObjC"})
    else if (plugin.target.isWindows())
        plugin.addCSourceFile("src/gui/gui_w32.c", &[_][]const u8{"-std=c99"})
    else if (plugin.target.isLinux())
        plugin.addCSourceFile("src/gui/gui_x11.c", &[_][]const u8{"-std=c99"});
    plugin.addIncludePath(sdk_include);
    plugin.addIncludePath("lib/raylib/src");

    // This declares intent for the library to be installed into the standard
    // location when the user invokes the "install" step (the default step when
    // running `zig build`).
    b.lib_dir = lib_dir;
    const install = b.addInstallArtifact(plugin);
    install.dest_sub_path = plugin_name;
    b.getInstallStep().dependOn(&install.step);

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
