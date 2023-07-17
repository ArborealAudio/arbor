//! Plugin.zig
//! This is where you will define the properties of your plugin
const Self = @This();
const std = @import("std");
const build_options = @import("build_options");
const clap = @cImport({
    @cInclude("clap/clap.h");
});
const Params = @import("Params.zig");
const Gui = @import("gui/Gui.zig");
const Reverb = @import("zig-dsp/Reverb.zig");

pub const Format = enum { CLAP, VST3, Standalone };
const format = build_options.format;
// const format = std.build.option(Format, "format", "Plugin format");

pub const Description = struct {
    pub const plugin_name = "ZigVerb";
    pub const vendor_name = "Arboreal Audio";
    pub const version = "0.1";
    pub const url = "https://arborealaudio.com";
    pub const contact_address = "contact@arborealaudio.com";
    pub const format_desc = switch (format) {
        .CLAP => FormatDesc.clap_desc,
        .VST3 => FormatDesc.vst3_desc,
        .Standalone => {},
    };

    // TODO: Make a clean way to define features, ideally
    // one that will have you define just once features shared btw
    // CLAP & VST, and the format-specific features can be defined separately
    // PROBABLY: Should just define different enums for format features
    pub const FormatDesc = union {
        const vst3_desc: VST3Description = .{
            .uid = "AAu.ZigVerb.vst3",
            .category = "Audio Module Class",
            .features = &[_][]const u8{ "Fx", "Reverb" },
            .sdk_version = "3.7.8",
        };
        const clap_desc: clap.clap_plugin_descriptor_t = .{
            .clap_version = clap.clap_version_t{
                .major = clap.CLAP_VERSION_MAJOR,
                .minor = clap.CLAP_VERSION_MINOR,
                .revision = clap.CLAP_VERSION_REVISION,
            },
            .id = "AAu.ZigVerb.clap",
            .name = plugin_name,
            .vendor = vendor_name,
            .url = url,
            .manual_url = "",
            .support_url = contact_address,
            .version = version,
            .description = "Vintage analog warmth",
            .features = &[_][*c]const u8{ "stereo", "audio-effect", null },
        };
    };

    const VST3Description = struct {
        uid: []const u8,
        features: []const []const u8,
        category: []const u8,
        sdk_version: []const u8,
    };
};

pub var parameter_changed = [_]bool{false} ** Params.numParams;

pub fn onParamChange(self: *Self, id: u32) void {
    if (id == Params.nameToID("feedback") catch @panic("Param not found"))
        self.reverb.update_feedback = true;
}

params: Params = Params{},

reverb: Reverb,

gui: ?*Gui = null,

sampleRate: f64 = 44100.0,
numChannels: u32 = 2,
maxNumSamples: u32 = 128,

latency: u32 = 0,

/// setup plugin for processing
pub fn init(self: *Self, allocator: std.mem.Allocator, sample_rate: f64, max_frames: u32) !void {
    self.sampleRate = sample_rate;
    self.maxNumSamples = max_frames;
    self.reverb.init(allocator, self, self.sampleRate, @floatCast(0.125 * self.sampleRate)) catch {
        std.log.err("Failed to initialize reverb\n", .{});
        std.process.exit(1);
    };
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
        out[0][i] = @floatCast(outL);
        out[1][i] = @floatCast(outR);
    }
}
