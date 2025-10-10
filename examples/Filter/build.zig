const std = @import("std");
const arbor = @import("arbor");

pub fn build(b: *std.Build) !void {
    try arbor.addPlugin(b, .{
        .plugin_config = @import("config.zon"),
        .plugin_config_path = b.path("config.zon"),
        .target = b.standardTargetOptions(.{}),
        .optimize = b.standardOptimizeOption(.{}),
    }, &.{ .CLAP, .VST2 });
}
