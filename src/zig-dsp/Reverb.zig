//! Reverb processor
const std = @import("std");
const Allocator = std.mem.Allocator;
const Delay = @import("Delay.zig");

const Reverb = @This();

const ORDER = 8; // number of delay lines and assoc. parameters

// Let's try making 4 mono delays with exponentially spread delay times & feedback values
// The layout could be L, R, -L, -R
delay: [ORDER]Delay,
delayTime: [ORDER]f32,
feedback: [ORDER]f32,
inversion: [ORDER]f32,

pub fn init(self: *Reverb, alloc: Allocator, maxDelaySamples: f32) !void {
    var i: u32 = 0;
    var rand = std.rand.DefaultPrng.init(69);
    while (i < ORDER) : (i += 1) {
        self.delay[i].max_delay = @floatToInt(u32, maxDelaySamples);
        try self.delay[i].init(alloc, 1);
        self.delayTime[i] = @intToFloat(f32, i + 1) / @intToFloat(f32, self.delayTime.len) * maxDelaySamples;
        self.delay[i].delay_time = self.delayTime[i];
        self.feedback[i] = @intToFloat(f32, i + 1) / @intToFloat(f32, self.delayTime.len) * 0.5;
        self.inversion[i] = if (rand.next() % 2 == 0) 1.0 else -1.0;
    }
}

pub fn deinit(self: *Reverb, alloc: Allocator) void {
    for (self.delay, 0..) |_, i| {
        self.delay[i].deinit(alloc);
        alloc.destroy(&self.delay[i]);
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
    var ds: [self.delay.len]f32 = undefined;
    var out = [2]f32{ 0, 0 };
    for (self.delay, 0..) |_, j| {
        ds[j] = self.delay[j].popSample(0);
    }

    processHouseholderMatrix(&ds);

    for (self.delay, 0..) |_, i| {
        const input = if (i % 2 == 1)
            inR + (ds[i] * self.feedback[i])
        else
            inL + (ds[i] * self.feedback[i]);

        self.delay[i].pushSample(0, input);

        if (i % 2 == 1)
            out[1] += self.inversion[i] * ds[i] * (1.0 / @intToFloat(f32, self.delay.len))
        else
            out[0] += self.inversion[i] * ds[i] * (1.0 / @intToFloat(f32, self.delay.len));
    }
    // self.delay[0].pushSample(0, inL + (ds[0] * self.feedback[0]));
    // self.delay[1].pushSample(0, inR + (ds[1] * self.feedback[1]));
    // self.delay[2].pushSample(0, inL + (-ds[2] * self.feedback[2]));
    // self.delay[3].pushSample(0, inR + (-ds[3] * self.feedback[3]));
    // out[0] = (ds[0] * 0.5) + (ds[2] * 0.5);
    // out[1] = (ds[1] * 0.5) + (ds[3] * 0.5);
    return out;
}
