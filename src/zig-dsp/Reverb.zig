//! Reverb processor
const std = @import("std");
const Allocator = std.mem.Allocator;
const Delay = @import("Delay.zig");
const Filter = @import("Filter.zig");
const Plugin = @import("../Plugin.zig");

const Reverb = @This();

const INPUT_DIFF_ORDER = 4;

const EARLY_REF_ORDER = 4;

const TAIL_ORDER = 9; // number of delay lines and assoc. parameters for reverb tail
const DELAYS_PER_BLOCK = 3;
const TAIL_BLOCKS = TAIL_ORDER / DELAYS_PER_BLOCK; // each block represents an output tap

const MAX_FEEDBACK = 0.35;

const MOD_RATE_BASE = 0.1;
const MOD_DEPTH_BASE = 1.0;

plugin: *Plugin,

early_ref: [EARLY_REF_ORDER]Delay = undefined,

input_diff: [INPUT_DIFF_ORDER]Delay = undefined,

tail_delay: [TAIL_ORDER]Delay = undefined,
tail_delayTime: [TAIL_ORDER]f32 = undefined,

feedback: [TAIL_BLOCKS]f32 = undefined,
feedback_param: *f64,
inversion: [TAIL_ORDER]f32 = undefined,

input_filter: Filter = undefined,

tail_filter: [TAIL_BLOCKS]Filter = undefined,

m_sum: [2]f32 = [_]f32{ 0.0, 0.0 },
m_ff: [2]f32 = [_]f32{ 0.0, 0.0 },

update_feedback: bool = false,

// early reflection delays in ms
const early_ref_time = [EARLY_REF_ORDER]f32{ 32, 54, 23, 69 };

pub fn prepare(
    self: *Reverb,
    alloc: Allocator,
    s_rate: f64,
    max_delay: f32,
) !void {
    var rand = std.rand.DefaultPrng.init(69);

    const max_early_ref_delay: u32 = @intFromFloat(0.1 * s_rate);

    const max_feedback: f32 = @floatCast(self.feedback_param.*);

    const srate_f: f32 = @floatCast(s_rate);

    for (&self.early_ref, 0..) |*d, i| {
        d.* = try Delay.init(alloc, srate_f, max_early_ref_delay, 1, 0, 0);
        d.delay_time = (early_ref_time[i] / 1000.0) * srate_f;
    }

    for (&self.input_diff, 0..) |*d, i| {
        d.* = try Delay.init(alloc, srate_f, 500, 2, 0, 0);
        d.delay_time = 500.0 / (@as(f32, @floatFromInt(i + 1)));
    }

    for (&self.tail_delay, 0..) |*d, i| {
        d.* = try Delay.init(
            alloc,
            srate_f,
            @as(u32, @intFromFloat(max_delay)),
            2,
            MOD_RATE_BASE,
            MOD_DEPTH_BASE,
        );
        // self.updateModRate(i, @floatCast(MAX_FEEDBACK * self.feedback_param.*));
        // self.updateModDepth(i);
        self.tail_delayTime[i] = @sqrt(@as(f32, @floatFromInt(i + 1)) / TAIL_ORDER) * max_delay;
        std.debug.print("Delay {d}: {d}\n", .{ i, self.tail_delayTime[i] });
        d.delay_time = self.tail_delayTime[i];
        self.inversion[i] = if (rand.next() % 2 == 0) 1.0 else -1.0;
    }

    for (&self.feedback, 0..) |*f, i| {
        f.* = @sqrt(TAIL_BLOCKS / @as(f32, @floatFromInt(i + 1))) * max_feedback;
    }

    for (&self.tail_filter, 0..) |*f, i| {
        f.filter_type = .Lowpass;
        f.init(
            alloc,
            2,
            srate_f,
            8000.0 * @sqrt(TAIL_BLOCKS / @as(f32, @floatFromInt(i + 1))),
            std.math.sqrt1_2,
        );
    }

    self.input_filter.filter_type = .Lowpass;
    self.input_filter.init(alloc, 2, srate_f, 12000.0, std.math.sqrt1_2);
}

fn updateModRate(self: *Reverb, i: usize, feedback: f32) void {
    self.tail_delay[i].mod.mod_rate = MOD_RATE_BASE + feedback;
}

fn updateModDepth(self: *Reverb, i: usize) void {
    self.tail_delay[i].mod.mod_depth = @as(f32, @floatFromInt(i)) + MOD_DEPTH_BASE * @as(f32, @floatFromInt(self.tail_delay.len));
}

pub fn updateFeedback(self: *Reverb) void {
    const total_feedback: f32 = @floatCast(self.feedback_param.* * MAX_FEEDBACK);
    for (&self.feedback, 0..) |*f, i| {
        f.* = @sqrt(TAIL_BLOCKS / @as(f32, @floatFromInt(i + 1))) * total_feedback;
    }
    for (&self.tail_delay, 0..) |_, i| {
        _ = i;
        // self.updateModRate(i, total_feedback);
        // self.updateModDepth(i);
    }
}

pub fn deinit(self: *Reverb, alloc: Allocator) void {
    for (&self.early_ref) |*d|
        d.deinit(alloc);
    for (&self.input_diff) |*d|
        d.deinit(alloc);
    for (&self.tail_filter) |*f|
        f.deinit(alloc);
    for (&self.tail_delay) |*d|
        d.deinit(alloc);
    self.input_filter.deinit(alloc);
}

// TODO: Add filtering
fn processEarlyReflections(self: *Reverb, in: [2]f32) [2]f32 {
    var out = [2]f32{ 0, 0 };
    for (&self.early_ref, 0..) |*d, i| {
        const ch: u32 = if (i % 2 == 0) 0 else 1;
        d.pushSample(0, in[ch]);
        out[ch] += d.popSample(0);
    }
    return out;
}

// TODO: Add filtering
fn processInputDiffusion(self: *Reverb, in: [2]f32) [2]f32 {
    var out = [2]f32{ in[0], in[1] };
    for (&self.input_diff) |*d| {
        var ch: u32 = 0;
        while (ch < 2) : (ch += 1) {
            const d_out = d.popSample(ch);
            out[ch] += d_out * -0.5;
            d.pushSample(ch, out[ch]);
            out[ch] = d_out + (out[ch] * 0.5);
        }
    }
    return out;
}

/// process sub-section of reverb tail
/// index: starting delay index. Must be < ORDER - 2
/// dry: input sample from outer function
/// fIn: forward-fed output of last allpass block
/// returns forward output
fn processSubSection(self: *Reverb, index: u32, ch: u32, dry: f32, f_in: f32) f32 {
    var d = self.tail_delay[index].popSampleWithMod(ch);
    var sum = dry + f_in + (d * -0.5);
    self.tail_delay[index].pushSample(ch, sum);
    var out = sum * 0.5 + d;

    var d2 = self.tail_delay[index + 1].popSampleWithMod(ch);
    out += d2 * -0.5;
    self.tail_delay[index + 1].pushSample(ch, out);
    var out2 = out * 0.5 + d2;

    self.tail_delay[index + 2].pushSample(ch, out2);

    self.m_sum[ch] += self.tail_delay[index + 2].popSampleWithMod(ch);
    return self.m_sum[ch];
}

pub fn processSample(self: *Reverb, in: [2]f32) [2]f32 {
    if (self.update_feedback) {
        self.updateFeedback();
        self.update_feedback = false;
    }

    self.m_sum[0] = 0;
    self.m_sum[1] = 0;
    var i: u32 = 0;
    var n: u32 = 0;

    const filt_L = self.input_filter.processSample(0, in[0]);
    const filt_R = self.input_filter.processSample(1, in[1]);

    const er = self.processEarlyReflections([_]f32{ filt_L, filt_R });
    const diff = self.processInputDiffusion([_]f32{ filt_L, filt_R });

    while (i < TAIL_ORDER) : (i += DELAYS_PER_BLOCK) {
        std.debug.assert(i + 2 < TAIL_ORDER);
        for (&self.m_ff, 0..) |*ff, ch| {
            ff.* = self.processSubSection(i, @intCast(ch), diff[ch], ff.*);
            ff.* = self.tail_filter[n].processSample(@intCast(ch), ff.*);
            ff.* *= self.feedback[n];
        }
        n += 1;
    }

    return [_]f32{ self.m_sum[0] + er[0], self.m_sum[1] + er[1] };
}

pub fn process(self: *Reverb, in: [*][*]f32, num_samples: usize) void {
    for (0..num_samples) |i| {
        const out = self.processSample(&[_]f32{ in[0][i], in[1][i] });
        in[0][i] = out[0][i];
        in[1][i] = out[1][i];
    }
}
