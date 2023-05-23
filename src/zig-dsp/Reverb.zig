//! Reverb processor
const std = @import("std");
const Allocator = std.mem.Allocator;
const Delay = @import("Delay.zig");
const Filter = @import("Filter.zig");

const Reverb = @This();

const ORDER = 9; // number of delay lines and assoc. parameters
const SUB_SECTION = ORDER / 3;

delay: [ORDER]Delay,
delayTime: [ORDER]f32,
feedback: [ORDER]f32,
inversion: [ORDER]f32,

filter: [ORDER]Filter,

pub fn init(self: *Reverb, alloc: Allocator, sampleRate: f64, maxDelaySamples: f32) !void {
    var rand = std.rand.DefaultPrng.init(69);
    var i: u32 = 0;
    while (i < ORDER) : (i += 1) {
        self.delay[i].max_delay = @floatToInt(u32, maxDelaySamples);
        try self.delay[i].init(alloc, 1);
        self.delayTime[i] = @intToFloat(f32, i + 1) / @intToFloat(f32, self.delayTime.len) * maxDelaySamples;
        self.delay[i].delay_time = self.delayTime[i];
        self.feedback[i] = @intToFloat(f32, i + 1) / @intToFloat(f32, self.delayTime.len) * 0.5;
        self.inversion[i] = if (rand.next() % 2 == 0) 1.0 else -1.0;
        self.filter[i].init(alloc, 1, @floatCast(f32, sampleRate), 10000.0 / @intToFloat(f32, i + 1), std.math.sqrt1_2);
    }
}

pub fn deinit(self: *Reverb, alloc: Allocator) void {
    for (&self.delay) |*d| {
        d.deinit(alloc);
        alloc.destroy(d);
    }
}

fn processHouseholderMatrix(in: []f32) void {
    const h_mult = -2.0 / @intToFloat(f32, in.len);
    var sum: f32 = 0;
    for (in, 0..) |_, i|
        sum += in[i];
    sum *= h_mult;
    for (in, 0..) |_, i|
        in[i] += sum;
}

pub fn processSample(self: *Reverb, inL: f32, inR: f32) [2]f32 {
    var ds: [ORDER]f32 = undefined;
    var out = [2]f32{ 0, 0 };
    for (&self.delay, 0..) |*d, j| {
        ds[j] = d.popSample(0);
    }

    processHouseholderMatrix(&ds);

    for (self.delay, 0..) |_, i| {
        var input = if (i % 2 == 1)
            inR + (ds[i] * self.feedback[i] * 0.5)
        else
            inL + (ds[i] * self.feedback[i] * 0.5);

        input = self.filter[i].processSample(0, input);

        self.delay[i].pushSample(0, input);

        if (i % 2 == 1)
            out[1] += -0.5 * input + ds[i]
        else
            out[0] += -0.5 * input + ds[i];
    }
    return out;
}
