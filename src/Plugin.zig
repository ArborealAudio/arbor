//! Plugin.zig
//! This is where you will define the properties of your plugin
const Self = @This();
const std = @import("std");
const Params = @import("Params.zig");
const Gui = @import("gui/Gui.zig");
const Reverb = @import("zig-dsp/Reverb.zig");

pub const Description = struct {
    pub const plugin_name = "ZigVerb";
    pub const vendor_name = "Arboreal Audio";
    pub const version = "0.1";
    pub const url = "https://arborealaudio.com";
    pub const contact_address = "contact@arborealaudio.com";

    // TODO: Make a clean way to define features, ideally
    // one that will have you define just once features shared btw
    // CLAP & VST, and the format-specific features can be defined separately
    // PROBABLY: Should just define different enums for format features
    pub const vst3_desc: VST3Description = .{
        .uid = "AAu.ZigVerb.vst3",
        .category = "Audio Module Class",
        .features = &[_][]const u8{ "Fx", "Reverb" },
        .sdk_version = "3.7.7",
    };

    const VST3Description = struct {
        uid: []const u8,
        features: []const []const u8,
        category: []const u8,
        sdk_version: []const u8,
    };
};

pub var parameter_changed = [_]bool{false} ** Params.numParams;
params: Params = Params{},

reverb: Reverb = Reverb{},

// gui: ?*Gui = null,

sampleRate: f64 = 44100.0,
numChannels: u32 = 2,
maxNumSamples: u32 = undefined,

latency: u32 = 0,

/// setup plugin for processing
pub fn init(self: *Self, allocator: std.mem.Allocator, sample_rate: f64, max_frames: u32) !void {
    self.sampleRate = sample_rate;
    self.maxNumSamples = max_frames;
    self.reverb.init(allocator, self.sampleRate, 0.125 * @floatCast(f32, self.sampleRate)) catch unreachable;
}

pub fn deinit(self: *Self, allocator: std.mem.Allocator) void {
    self.reverb.deinit(allocator);
}

pub fn processAudio(self: *Self, in: [2][*]f32, out: [2][*]f32, numFrames: u32) void {
    var i: u32 = 0;
    const mix = self.params.values.mix;
    while (i < numFrames) : (i += 1) {
        const rev_out = self.reverb.processSample([_]f32{ in[0][i], in[1][i] });

        const wet_level = if (mix < 0.5) mix * 2.0 else 1.0;
        const dry_level = if (mix < 0.5) 1.0 else (1.0 - mix) * 2.0;

        const outL = (rev_out[0] * wet_level) + (in[0][i] * dry_level);
        const outR = (rev_out[1] * wet_level) + (in[1][i] * dry_level);

        // write output
        out[0][i] = @floatCast(f32, outL);
        out[1][i] = @floatCast(f32, outR);
    }
}
