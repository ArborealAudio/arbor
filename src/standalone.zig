//! standalone "plugin" application

const std = @import("std");
const builtin = @import("builtin");
const rl = @cImport({
    @cInclude("raylib.h");
});

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
pub const allocator = gpa.allocator();

const Plugin = @import("Plugin.zig");
const Gui = @import("gui//Gui.zig");

pub fn main() !void {
    rl.InitAudioDevice();
    defer rl.CloseAudioDevice();

    var plugin = try allocator.create(Plugin);
    plugin.* = .{ .reverb = .{
        .plugin = plugin,
    } };
    defer plugin.deinit(allocator);

    var stream = rl.LoadAudioStream(@intFromFloat(plugin.sampleRate), 32, plugin.numChannels);
    rl.SetAudioStreamBufferSizeDefault(@intCast(plugin.maxNumSamples));

    try plugin.init(allocator, plugin.sampleRate, plugin.maxNumSamples);

    rl.SetAudioStreamCallback(stream, processAudio);

    rl.PlayAudioStream(stream);

    plugin.gui = try Gui.init(allocator, plugin);
    defer plugin.gui.?.deinit(allocator);

    while (!rl.WindowShouldClose()) {
        plugin.gui.?.render(); // TODO: Render GUI on separate thread
    }
}

fn processAudio(data: ?*anyopaque, frames: u32) callconv(.C) void {
    _ = frames;
    _ = data;
    // var i: u32 = 0;
    // var buffer: [*]f32 = @alignCast(data);
    // while (i < frames) : (i += 1) {
    //     buffer[i] = 1.0;
    // }
}
