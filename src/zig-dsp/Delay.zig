//! Stereo Delay processor

const std = @import("std");
const Allocator = std.mem.Allocator;

const Delay = @This();

delay_time: f32, // delay time in samples

buffer: [][]f32,

max_delay: u32,

write_pos: [2]usize,
read_pos: [2]usize,

/// setup delay processor, allocate internal buffers. Pass in maximum delay in samples
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
    // self.write_pos[ch] += 1;
    // if (self.write_pos[ch] >= self.max_delay)
    //     self.write_pos[ch] = 0;
    self.write_pos[ch] = (self.write_pos[ch] + self.max_delay - 1) % self.max_delay;
}

pub fn popSample(self: *Delay, ch: usize) f32 {
    var out: f32 = 0.0;
    var delayPos = @floatToInt(usize, self.delay_time) + self.read_pos[ch];
    if (delayPos + 1 >= self.max_delay) {
        delayPos %= self.max_delay;
    }
    out = self.buffer[ch][delayPos];
    // self.read_pos[ch] += 1;
    // if (self.read_pos[ch] >= self.max_delay)
    //     self.read_pos[ch] = 0;
    self.read_pos[ch] = (self.read_pos[ch] + self.max_delay - 1) % self.max_delay;
    return out;
}
