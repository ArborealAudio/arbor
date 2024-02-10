//! Plugin.zig
//! This is where you will define the properties of your plugin
const Self = @This();
const std = @import("std");
const build_options = @import("build_options");
const clap = @cImport({
    @cInclude("clap/clap.h");
});
const Params = @import("Params.zig");
const Gui = @import("Gui.zig");
const Reverb = @import("zig-dsp/Reverb.zig");

pub const Format = enum { CLAP, VST3, VST2 };
const format = build_options.format;
// const format = std.build.option(Format, "format", "Plugin format");

pub const Description = struct {
    pub const plugin_name = "ZigVerb";
    pub const vendor_name = "Arboreal Audio";
    pub const version = "0.1";
    pub const version_int = 0x000100;
    pub const url = "https://arborealaudio.com";
    pub const contact_address = "contact@arborealaudio.com";
    pub const format_desc = switch (format) {
        .CLAP => FormatDesc.clap_desc,
        .VST3 => FormatDesc.vst3_desc,
        else => {},
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

pub var parameter_changed = [_]bool{false} ** Params.num_params;

pub fn onParamChange(self: *Self, id: u32) void {
    if (id == Params.nameToID("feedback") catch @panic("Param not found\n")) {
        self.reverb.update_feedback = true;
    }
}

params: Params = Params{},

reverb: Reverb,

gui: ?*Gui = null,

sample_rate: f64 = 44100.0,
numChannels: u32 = 2,
maxNumSamples: u32 = 128,

latency: u32 = 0,

/// function called on plugin creation
pub fn init(allocator: std.mem.Allocator) *Self {
    var plugin = allocator.create(Self) catch |e| {
        std.log.err("{}\n", .{e});
        std.process.exit(1);
    };
    plugin.* = .{ .reverb = .{ .plugin = plugin, .feedback_param = &plugin.params.values.feedback } };
    return plugin;
}

/// setup plugin for processing
pub fn prepare(self: *Self, allocator: std.mem.Allocator, sample_rate: f64, max_frames: u32) !void {
    self.sample_rate = sample_rate;
    self.maxNumSamples = max_frames;
    self.reverb.prepare(allocator, self.sample_rate, @floatCast(0.125 * self.sample_rate)) catch |e| {
        std.log.err("Failed to initialize reverb: {}\n", .{e});
        std.process.exit(1);
    };
}

pub fn deinit(self: *Self, allocator: std.mem.Allocator) void {
    self.reverb.deinit(allocator);
    allocator.destroy(self);
}

pub fn processAudio(self: *Self, in: [*][*]f32, out: [*][*]f32, num_frames: usize) void {
    const mix = self.params.values.mix;
    for (0..num_frames) |i| {
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
