const std = @import("std");
const arbor = @import("arbor");

pub fn build(b: *std.Build) !void {
    try arbor.addPlugin(b, .{
        .description = .{
            .name = "Example Distortion",
            .id = "com.Arbor.ExDist",
            .company = "Arboreal Audio",
            .version = "0.1.0",
            .copyright = "(c) 2024 Arboreal Audio, LLC",
            .url = "",
            .manual = "",
            .contact = "",
            .description = "Vintage analog warmth",
        },
        .features = arbor.features.STEREO | arbor.features.EFFECT |
            arbor.features.GUI,
        .root_source_file = "plugin.zig",
        .target = b.standardTargetOptions(.{}),
        .optimize = b.standardOptimizeOption(.{}),
    });
}
