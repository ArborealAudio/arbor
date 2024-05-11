//! WARNING: STALE FILE -- NEEDS UPDATE
//! Stereo Delay processor with optional modulation

const std = @import("std");
const Allocator = std.mem.Allocator;

const Delay = @This();

const Mod = struct {
    mod_rate: f32, // time in Hz
    mod_depth: f32, // essentially num samples to mod delay by
    mod_inc: f32,
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

write_pos: [2]usize = [_]usize{ 0, 0 },
read_pos: [2]usize = [_]usize{ 0, 0 },

mod: Mod,

/// setup delay processor, allocate internal buffers
pub fn init(
    alloc: Allocator,
    srate: f32,
    max_delay: u32,
    num_channels: usize,
    mod_rate: f32,
    mod_depth: f32,
) !Delay {
    var delay: Delay = .{
        .max_delay = max_delay,
        .buffer = try alloc.alloc([]f32, num_channels),
        .mod = Mod.init(mod_rate, mod_depth, srate),
    };
    for (delay.buffer) |*ch| {
        ch.* = try alloc.alloc(f32, 2 * delay.max_delay);
    }
    for (&delay.write_pos) |*p| p.* = 0;
    for (&delay.read_pos) |*p| p.* = 0;

    return delay;
}

pub fn deinit(self: *Delay, alloc: Allocator) void {
    for (self.buffer) |*b| {
        alloc.free(b.*);
    }
    alloc.free(self.buffer);
}

pub fn modDelay(self: *Delay) void {
    // ISSUE: We're sometimes getting < 0 delay values in
    // std.debug.assert(delay >= 0);
    const m = self.mod.next();
    const delay = m + self.delay_time;
    // if (delay < 0) {
    //     std.debug.print("Delay < 0\nIn: {d} Current: {d}\n", .{ delay, self.delay_time });
    //     std.debug.assert(false);
    // }
    self.delay_time = @max(0, @min(delay, @as(f32, @floatFromInt(self.max_delay))));
}

pub fn pushSample(self: *Delay, ch: usize, input: f32) void {
    self.buffer[ch][self.write_pos[ch]] = input;
    self.write_pos[ch] = (self.write_pos[ch] + self.max_delay - 1) % self.max_delay;
}

pub fn popSample(self: *Delay, ch: usize) f32 {
    const out = self.interpolate(ch);
    self.read_pos[ch] = (self.read_pos[ch] + self.max_delay - 1) % self.max_delay;
    return out;
}

pub fn popSampleWithMod(self: *Delay, ch: usize) f32 {
    if (ch == self.buffer.len - 1)
        self.modDelay();
    const out = self.interpolate(ch);
    self.read_pos[ch] = (self.read_pos[ch] + self.max_delay - 1) % self.max_delay;
    return out;
}

// perform linear interpolation
fn interpolate(self: *Delay, ch: usize) f32 {
    const delay_int: usize = @intFromFloat(self.delay_time);
    const delay_frac: f32 = self.delay_time - @as(f32, @floatFromInt(delay_int));
    var index1 = self.read_pos[ch] + delay_int;
    var index2 = index1 + 1;
    if (index2 >= self.max_delay) {
        index1 %= self.max_delay;
        index2 %= self.max_delay;
    }

    const value1 = self.buffer[ch][index1];
    const value2 = self.buffer[ch][index2];

    return value1 + delay_frac * (value2 - value1);
}
