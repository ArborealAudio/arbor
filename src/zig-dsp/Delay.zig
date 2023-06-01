//! Stereo Delay processor

const std = @import("std");
const Allocator = std.mem.Allocator;

const Delay = @This();

delay_time: f32 = 0, // delay time in samples

buffer: [][]f32 = undefined,

max_delay: u32 = undefined, // set this prior to processing & init-ing!

write_pos: [2]usize = undefined,
read_pos: [2]usize = undefined,

/// setup delay processor, allocate internal buffers
pub fn init(self: *Delay, alloc: Allocator, numChannels: usize) !void {
    self.buffer = try alloc.alloc([]f32, numChannels);
    for (self.buffer, 0..) |_, ch| {
        self.buffer[ch] = try alloc.alloc(f32, self.max_delay);
    }
    self.write_pos[0] = 0;
    self.write_pos[1] = 0;
    self.read_pos[0] = 0;
    self.read_pos[1] = 0;
}

pub fn deinit(self: *Delay, alloc: Allocator) void {
    for (self.buffer) |ch| {
        alloc.free(ch);
    }
    alloc.free(self.buffer);
}

pub fn pushSample(self: *Delay, ch: usize, input: f32) void {
    self.buffer[ch][self.write_pos[ch]] = input;
    self.write_pos[ch] = (self.write_pos[ch] + self.max_delay - 1) % self.max_delay;
}

pub fn popSample(self: *Delay, ch: usize) f32 {
    var out: f32 = 0.0;
    var delayPos = @floatToInt(usize, self.delay_time) + self.read_pos[ch];
    if (delayPos + 1 >= self.max_delay) {
        delayPos %= self.max_delay;
    }
    out = self.buffer[ch][delayPos];
    self.read_pos[ch] = (self.read_pos[ch] + self.max_delay - 1) % self.max_delay;
    return out;
}
