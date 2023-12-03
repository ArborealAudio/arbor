//! Stereo Delay processor

const std = @import("std");
const Allocator = std.mem.Allocator;

const Delay = @This();

const Mod = struct {
    mod_rate: f32, // time in Hz
    mod_depth: f32,
    mod_inc: f32 = undefined,
    mod_i: f32 = 0,

    pub fn init(rate: f32, depth: f32, srate: f32) Mod {
        return .{
            .mod_rate = rate,
            .mod_depth = depth,
            .mod_inc = rate / srate,
        };
    }

    pub fn next(self: *Mod) f32 {
        const val = @sin(std.math.tau * self.mod_i);
        self.mod_i += self.mod_inc;
        if (self.mod_i > 1) self.mod_i -= 1;
        return val * self.mod_depth;
    }
};

delay_time: f32 = 0, // delay time in samples

buffer: [][]f32,

max_delay: u32,

write_pos: []usize,
read_pos: []usize,

mod: Mod,

/// setup delay processor, allocate internal buffers
pub fn init(alloc: Allocator, srate: f32, max_delay: u32, num_channels: usize) !Delay {
    var delay: Delay = .{
        .max_delay = max_delay,
        .buffer = try alloc.alloc([]f32, num_channels),
        .write_pos = try alloc.alloc(usize, num_channels),
        .read_pos = try alloc.alloc(usize, num_channels),
        .mod = Mod.init(0.5, 10, srate),
    };
    for (delay.buffer) |*ch| {
        ch.* = try alloc.alloc(f32, 2 * delay.max_delay);
    }
    for (delay.write_pos) |*p| p.* = 0;
    for (delay.read_pos) |*p| p.* = 0;

    return delay;
}

pub fn deinit(self: *Delay, alloc: Allocator) void {
    for (self.buffer, 0..) |_, i| {
        alloc.free(self.buffer[i]);
    }
    alloc.free(self.buffer);
}

// get modulated delay time according to mod settings
pub fn modulate(self: *Delay) f32 {
    return self.delay_time + self.mod.next();
}

pub fn pushSample(self: *Delay, ch: usize, input: f32) void {
    self.buffer[ch][self.write_pos[ch]] = input;
    self.write_pos[ch] = (self.write_pos[ch] + self.max_delay - 1) % self.max_delay;
}

pub fn popSample(self: *Delay, ch: usize) f32 {
    var out: f32 = 0;
    var delay_pos = @as(usize, @intFromFloat(self.delay_time)) + self.read_pos[ch];
    if (delay_pos + 1 >= self.max_delay) {
        delay_pos %= self.max_delay;
    }
    out = self.buffer[ch][delay_pos];
    self.read_pos[ch] = (self.read_pos[ch] + self.max_delay - 1) % self.max_delay;
    return out;
}

pub fn popSampleWithMod(self: *Delay, ch: usize) f32 {
    var out: f32 = 0;
    var delay_pos = @as(usize, @intFromFloat(self.modulate())) + self.read_pos[ch];
    if (delay_pos + 1 >= self.max_delay) {
        delay_pos %= self.max_delay;
    }
    out = self.buffer[ch][delay_pos];
    self.read_pos[ch] = (self.read_pos[ch] + self.max_delay - 1) % self.max_delay;
    return out;
}
