//! Trying to reinvent the filter for all time
//! (1 year later: ^ Not sure what I meant by that. I think just that these
//! should be the "default" IIRs instead of RBJ Cookbook)
//! Derived from "Matched Second Order Filters" (2016) and
//! "Matched One-Pole Digital Shelving Filters" (2019) by Martin Vicanek

const std = @import("std");

const Filter = @This();

pub const Coeffs = struct {
    a1: f32,
    a2: f32,
    b0: f32,
    b1: f32,
    b2: f32,
};

pub const Type = enum {
    Lowpass,
    Highpass,
    Bandpass,
    FirstOrderLowpass,
    FirstOrderHighpass,
    FirstOrderLowshelf,
    FirstOrderHighshelf,
    // TODO: 2nd-order shelves: https://vicanek.de/articles/2poleShelvingFits.pdf
};

cutoff: f32,
reso: f32,
gain: f32 = 1,
coeffs: Coeffs,
filter_type: Type = .Lowpass,

xn: [][]f32,
yn: [][]f32,

allocator: std.mem.Allocator,

/// Create the filter and allocate its underlying memory
pub fn init(
    allocator: std.mem.Allocator,
    num_channels: u32,
    filter_type: Type,
    cutoff: f32,
    reso: f32,
) !Filter {
    const self: Filter = .{
        .allocator = allocator,
        .filter_type = filter_type,
        .reso = reso,
        .cutoff = cutoff,
        .coeffs = std.mem.zeroes(Coeffs),
        .xn = try allocator.alloc([]f32, num_channels),
        .yn = try allocator.alloc([]f32, num_channels),
    };

    for (self.xn) |*xn|
        xn.* = try allocator.alloc(f32, 2);
    for (self.yn) |*yn|
        yn.* = try allocator.alloc(f32, 2);

    return self;
}

/// deallocate filter state
pub fn deinit(self: *Filter) void {
    for (self.xn, 0..) |_, i|
        self.allocator.free(self.xn[i]);
    for (self.yn, 0..) |_, i|
        self.allocator.free(self.yn[i]);
    self.allocator.free(self.xn);
    self.allocator.free(self.yn);
}

pub fn reset(self: *Filter) void {
    for (self.xn, 0..) |_, i|
        self.xn[i] = [2]f32{ 0.0, 0.0 };

    for (self.yn, 0..) |_, i|
        self.yn[i] = [2]f32{ 0.0, 0.0 };
}

/// Must call this before processing or coefficients won't be initialized
pub fn setSampleRate(self: *Filter, sample_rate: f32) void {
    self.setCoeffs(sample_rate);
}

pub fn setCutoff(self: *Filter, cutoff: f32, sample_rate: f32) void {
    self.cutoff = cutoff;
    self.setCoeffs(sample_rate);
}

pub fn setReso(self: *Filter, reso: f32, sample_rate: f32) void {
    self.reso = reso;
    self.setCoeffs(sample_rate);
}

fn setCoeffs(self: *Filter, sr: f32) void {
    const w0 = std.math.tau * (self.cutoff / sr);
    const q = 1.0 / (2.0 * self.reso);
    const tmp = @exp(-q * w0);
    var a1: f32 = 0;
    var a2: f32 = 0;
    var b0: f32 = 0;
    var b1: f32 = 0;
    var b2: f32 = 0;
    a1 = -2.0 * tmp;
    if (q <= 1.0)
        a1 *= @cos(@sqrt(1.0 - q * q) * w0)
    else
        a1 *= std.math.cosh(@sqrt(q * q - 1.0) * w0);
    a2 = tmp * tmp;

    const f0 = self.cutoff / (sr * 0.5);
    const freq2 = f0 * f0;
    const reso2 = self.reso * self.reso;
    const fac = (1.0 - freq2) * (1.0 - freq2);

    switch (self.filter_type) {
        .Lowpass => {
            const r0 = 1.0 + a1 + a2;
            const r1_num = (1.0 - a1 + a2) * freq2;
            const r1_denom = @sqrt(fac + freq2 / (reso2));
            const r1 = r1_num / r1_denom;

            b0 = (r0 + r1) / 2.0;
            b1 = r0 - b0;
            b2 = 0;
        },
        .Highpass => {
            const r1_num = 1.0 - a1 + a2;
            const r1_denom = @sqrt(fac + freq2 / (reso2));
            const r1 = r1_num / r1_denom;

            b0 = r1 / 4.0;
            b1 = -2.0 * b0;
            b2 = b0;
        },
        .Bandpass => {
            const r0 = (1.0 + a1 + a2) / (std.math.pi * f0 * self.reso);
            const r1_num = (1.0 - a1 + a2) * (f0 / self.reso);
            const r1_denom = @sqrt(fac + freq2 / (reso2));
            const r1 = r1_num / r1_denom;

            b1 = -r1 / 2.0;
            b0 = (r0 - b1) / 2.0;
            b2 = -b0 - b1;
        },
        .FirstOrderLowpass => {
            const fc = self.cutoff / sr;
            a1 = -@exp(-fc * std.math.tau);
            const gain_nyq = @sqrt(fc * fc / (0.25 + fc * fc));
            b0 = 0.5 * (gain_nyq * (1 - a1) + 1 + a1);
            b1 = 1 + a1 - b0;
            b2 = 0;
            a2 = 0;
        },
        .FirstOrderHighpass => {
            const fc = self.cutoff / sr;
            a1 = -@exp(-fc * std.math.tau);
            const gain_nyq = @sqrt(0.25 / (0.25 + fc * fc));
            b0 = 0.5 * gain_nyq * (1 - a1);
            b1 = -b0;
            a2 = 0;
            b2 = 0;
        },
        .FirstOrderHighshelf => {
            const pi_sqr_2 = 2.0 / (std.math.pi * std.math.pi);
            const alpha = pi_sqr_2 * (1 + 1 / (self.gain * freq2)) - 0.5;
            const beta = pi_sqr_2 * (1 + self.gain / freq2) - 0.5;
            a1 = -alpha / (1 + alpha + @sqrt(1 + 2 * alpha));
            const b = -beta / (1 + beta + @sqrt(1 + 2 * beta));
            b0 = (1 + a1) / (1 + b);
            b1 = b * b0;
            a2 = 0;
            b2 = 0;
        },
        .FirstOrderLowshelf => {
            const igain = 1 / self.gain;
            const pi_sqr_2 = 2.0 / (std.math.pi * std.math.pi);
            const alpha = pi_sqr_2 * (1 + 1 / (igain * freq2)) - 0.5;
            const beta = pi_sqr_2 * (1 + igain / freq2) - 0.5;
            a1 = -alpha / (1 + alpha + @sqrt(1 + 2 * alpha));
            const b = -beta / (1 + beta + @sqrt(1 + 2 * beta));
            b0 = self.gain * ((1 + a1) / (1 + b));
            b1 = b * b0;
            a2 = 0;
            b2 = 0;
        },
    }

    self.coeffs = .{
        .a1 = a1,
        .a2 = a2,
        .b0 = b0,
        .b1 = b1,
        .b2 = b2,
    };
}

pub fn process(self: *Filter, in: []const []const f32, out: []const []f32) void {
    for (in, 0..) |ch, ch_idx| {
        for (ch, 0..) |samp, i| {
            out[ch_idx][i] = self.processSample(ch_idx, samp);
        }
    }
}

pub fn processSample(self: *Filter, ch: usize, in: f32) f32 {
    std.debug.assert(ch < self.xn.len and ch < self.yn.len);
    const b = self.coeffs.b0 * in + self.coeffs.b1 * self.xn[ch][0] + self.coeffs.b2 * self.xn[ch][1];
    const a = -self.coeffs.a1 * self.yn[ch][0] - self.coeffs.a2 * self.yn[ch][1];
    const out = a + b;
    self.xn[ch][1] = self.xn[ch][0];
    self.xn[ch][0] = in;
    self.yn[ch][1] = self.yn[ch][0];
    self.yn[ch][0] = out;
    return out;
}
