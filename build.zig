const std = @import("std");
const builtin = @import("builtin");
const Plugin = @import("src/Plugin.zig");
const plugin_name = Plugin.Description.plugin_name;
const Format = Plugin.Format;

// TODO: Implement a MacOS Universal Binary build mode which will build both archs & lipo

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    // const os_tag = target.result.os.tag;

    const build_options = b.addOptions();
    const format = b.option(Format, "format", "Plugin format") orelse .CLAP;
    const system_install = b.option(
        bool,
        "install",
        "Install plugin to default system directory",
    ) orelse false;
    _ = system_install;

    build_options.addOption(Format, "format", format);

    const root_file = switch (format) {
        .CLAP => "src/clap_plugin.zig",
        .VST3 => "src/vst3_plugin.zig",
        .VST2 => "src/vst2_plugin.zig",
    };
    const sdk_include = switch (format) {
        .CLAP => "lib/clap/include",
        else => "",
    };

    const plugin = b.addSharedLibrary(.{
        .name = plugin_name,
        .root_source_file = .{ .path = root_file },
        .target = target,
        .optimize = optimize,
    });

    plugin.root_module.addOptions("build_options", build_options);

    // TODO: Configuring OSX sysroot

    // build platform UI library
    const gui = buildPlatformGUI(b, target, optimize);
    plugin.root_module.addImport("platform", gui);
    plugin.addIncludePath(.{ .path = "src" });
    plugin.addIncludePath(.{ .path = sdk_include });

    b.installArtifact(plugin);

    // Creates a step for unit testing.
    const clap_tests = b.addTest(.{
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
    test_step.dependOn(&clap_tests.step);
    test_step.dependOn(&vst3_tests.step);
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
        else => @panic("Unimplemented OS\n"),
    }

    mod.linkLibrary(lib);

    return mod;
}

// ISSUE: Is the Zig build system broken? Is it just so much smarter than me that I can't
// figure out how to copy a file? Not sure. Either way, the below does not work as a system
// command bassed as a build action. Maybe someday.
fn getPluginCopyCmd(
    os: std.Target.Os.Tag,
    format: Format,
    output: *std.Build.Step.InstallArtifact,
) []const []const u8 {
    std.log.warn("Bro you are hard-coding your own home dir\n", .{});
    const install_dir = switch (format) {
        .CLAP => switch (os) {
            .linux => "/home/alex/.clap/",
            .macos => "/Users/alex/Library/Audio/Plug-Ins/CLAP/",
            .windows => "/Program Files/Common Files/CLAP/",
            else => @panic("Unsupported OS"),
        },
        .VST3 => switch (os) {
            .linux => "/home/alex/.vst3/",
            .macos => "/Users/alex/Library/Audio/Plug-Ins/VST3/",
            .windows => "/Program Files/Common Files/VST3/",
            else => @panic("Unsupported OS"),
        },
        .VST2 => switch (os) {
            .linux => "/home/alex/.vst/",
            .macos => "/Users/alex/Library/Audio/Plug-Ins/VST/",
            .windows => "/Program Files/Steinberg/VstPlugins/",
            else => @panic("Unsupported OS"),
        },
    };

    // get generated file
    const file = if (output.emitted_bin) |bin|
        bin.generated.getPath()
    else
        @panic("No generated file\n");

    // get copy cmd
    switch (os) {
        .windows => {
            switch (format) {
                .CLAP => return &.{
                    "copy",
                    file,
                    install_dir,
                },
                else => @panic("TODO"),
            }
        },
        else => @panic("TODO"),
    }
}
