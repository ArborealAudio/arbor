const std = @import("std");
const builtin = @import("builtin");
const Plugin = @import("src/Plugin.zig");
const Format = Plugin.Format;

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    //TODO: Implement a Universal Binary build mode which will build both archs & lipo

    const optimize = b.standardOptimizeOption(.{});

    const build_options = b.addOptions();
    const format = b.option(Format, "format", "Plugin format");
    const system_install = b.option(bool, "install", "Install plugin to default system directory");

    if (format == null) {
        std.log.err("Provide a format\n", .{});
        std.process.exit(1);
    }
    build_options.addOption(Format, "format", format.?);

    const plugin_name = "ZigVerb";
    const filename = switch (format.?) {
        .CLAP => plugin_name ++ ".clap",
        .VST3 => plugin_name ++ ".vst3",
        .VST2 => plugin_name ++ ".vst",
    };
    const root_file = switch (format.?) {
        .CLAP => "src/clap_plugin.zig",
        .VST3 => "src/vst3_plugin.zig",
        .VST2 => "src/vst2_plugin.zig",
    };
    const sdk_include = switch (format.?) {
        .CLAP => "lib/clap/include",
        else => "",
    };
    const install_dir = switch (format.?) {
        .CLAP => switch (target.getOsTag()) {
            .linux => "/home/alex/.clap/",
            .macos => "/Users/alex/Library/Audio/Plug-Ins/CLAP/",
            .windows => "/Program Files/Common Files/CLAP/",
            else => {
                std.log.err("Unsupported OS\n", .{});
                std.process.exit(1);
            },
        },
        .VST3 => switch (target.getOsTag()) {
            .linux => "/home/alex/.vst3/",
            .macos => "/Users/alex/Library/Audio/Plug-Ins/VST3/",
            .windows => "/Program Files/Common Files/VST3/",
            else => {
                std.log.err("Unsupported OS\n", .{});
                std.process.exit(1);
            },
        },
        .VST2 => switch (target.getOsTag()) {
            .linux => "/home/alex/.vst/",
            .macos => "/Users/alex/Library/Audio/Plug-Ins/VST/",
            .windows => "/Program Files/Common Files/VST/",
            else => {
                std.log.err("Unsupported OS\n", .{});
                std.process.exit(1);
            },
        },
    };

    const plugin = b.addSharedLibrary(.{
        .name = plugin_name,
        .root_source_file = .{ .path = root_file },
        .target = target,
        .optimize = optimize,
    });

    plugin.addOptions("build_options", build_options);

    // TODO: Configuring OSX sysroot

    if (plugin.target.isDarwin()) {
        plugin.linkFramework("Cocoa");
        plugin.addCSourceFile(.{
            .file = .{ .path = "src/gui/gui_mac.m" },
            .flags = &[_][]const u8{"-ObjC"},
        });
    } else if (plugin.target.isWindows()) {
        plugin.addCSourceFile(.{
            .file = .{ .path = "src/gui/gui_w32.c" },
            .flags = &[_][]const u8{"-std=c99"},
        });
    } else if (plugin.target.isLinux()) {
        plugin.addCSourceFile(.{
            .file = .{ .path = "src/gui/gui_x11.c" },
            .flags = &[_][]const u8{"-std=c99"},
        });
    }
    plugin.addIncludePath(.{ .path = "src" });
    plugin.addIncludePath(.{ .path = sdk_include });

    if (system_install) |_| {
        b.lib_dir = install_dir;
    }
    const output = b.addInstallArtifact(plugin, .{});
    output.dest_sub_path = filename;
    b.getInstallStep().dependOn(&output.step);

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
