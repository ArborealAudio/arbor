const std = @import("std");
const arbor = @import("arbor");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    try arbor.addPlugin(b, .{
        .plugin_config = @import("config.zon"),
        .plugin_config_path = b.path("config.zon"),
        .target = target,
        .optimize = optimize,
    }, &.{ .CLAP, .VST2, .VST3 });
}
