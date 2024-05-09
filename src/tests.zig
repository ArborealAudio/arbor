const std = @import("std");
const arbor = @import("arbor.zig");

test "Plugin features" {
    const span = std.mem.span;
    const features: arbor.PluginFeatures = arbor.features.STEREO | arbor.features.SYNTH |
        arbor.features.EQ | arbor.features.EFFECT;

    try std.testing.expect(features & arbor.features.EFFECT > 0);
    try std.testing.expect(features & arbor.features.INSTRUMENT == 0);
    var parsed = try arbor.parseClapFeatures(features);

    var i: u32 = 0;
    while (i < parsed.constSlice().len) : (i += 1) {
        const feat = parsed.slice()[i];
        if (feat == null) break;
        if (i == 0)
            try std.testing.expectEqualStrings(span(feat.?), "stereo");
        if (i == 1)
            try std.testing.expectEqualStrings(span(feat.?), "audio-effect");
        if (i == 2)
            try std.testing.expectEqualStrings(span(feat.?), "equalizer");
        if (i == 3)
            try std.testing.expectEqualStrings(span(feat.?), "synthesizer");
    }
}

test "Version int" {
    const vint = try arbor.Vst2VersionInt("0.1.0");
    try std.testing.expectEqual(10, vint);
    const update = try arbor.Vst2VersionInt("2.3.5");
    try std.testing.expectEqual(235, update);
}
