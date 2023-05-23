//! Trying to reinvent the filter for all time
// Derived from "Matched Second Order Filters" by Martin Vicanek (2016)

const std = @import("std");

const Filter = @This();

cutoff: f32,
reso: f32,
coeffs: Coeffs,

xn: [][]f32 = undefined,
yn: [][]f32 = undefined,

sample_rate: f32,

pub const Coeffs = struct {
    a1: f32,
    a2: f32,
    b0: f32,
    b1: f32,
    b2: f32,
};

/// initialize filter coefficients
pub fn init(self: *Filter, allocator: std.mem.Allocator, numChannels: u32, sample_rate: f32, cutoff: f32, reso: f32) void {
    self.reso = reso;
    self.cutoff = cutoff;
    self.sample_rate = sample_rate;

    self.xn = allocator.alloc([]f32, numChannels) catch unreachable;
    self.yn = allocator.alloc([]f32, numChannels) catch unreachable;
    for (self.xn, 0..) |_, i|
        self.xn[i] = allocator.alloc(f32, 2) catch unreachable;
    for (self.yn, 0..) |_, i|
        self.yn[i] = allocator.alloc(f32, 2) catch unreachable;

    self.setCoeffs();
}

pub fn reset(self: *Filter) void {
    for (self.xn, 0..) |_, i|
        self.xn[i] = [2]f32{ 0.0, 0.0 };

    for (self.yn, 0..) |_, i|
        self.yn[i] = [2]f32{ 0.0, 0.0 };
}

pub fn setCoeffs(self: *Filter) void {
    const w0 = 2.0 * std.math.pi * (self.cutoff / self.sample_rate);
    const q = 1.0 / (2.0 * self.reso);
    const tmp = std.math.exp(-q * w0);
    self.coeffs.a1 = -2.0 * tmp;
    if (q <= 1.0)
        self.coeffs.a1 *= std.math.cos(std.math.sqrt(1.0 - q * q) * w0)
    else
        self.coeffs.a1 *= std.math.cosh(std.math.sqrt(q * q - 1.0) * w0);
    self.coeffs.a2 = tmp * tmp;

    const f0 = self.cutoff / self.sample_rate;
    const freq2 = f0 * f0;
    const r0 = 1.0 + self.coeffs.a1 + self.coeffs.a2;
    const r1_num = (1.0 - self.coeffs.a1 + self.coeffs.a2) * freq2;
    const r1_f2 = (1.0 - freq2) * (1.0 - freq2);
    const r1_denom = std.math.sqrt(r1_f2 + freq2 / (self.reso * self.reso));

    const r1 = r1_num / r1_denom;

    self.coeffs.b0 = (r0 + r1) / 2.0;
    self.coeffs.b1 = r0 - self.coeffs.b0;
    self.coeffs.b2 = 0.0;
}

pub fn processSample(self: *Filter, ch: u32, in: f32) f32 {
    const b = self.coeffs.b0 * in + self.coeffs.b1 * self.xn[ch][0] + self.coeffs.b2 * self.xn[ch][1];
    const a = -self.coeffs.a1 * self.yn[ch][0] - self.coeffs.a2 * self.yn[ch][1];
    const out = a + b;
    self.xn[ch][1] = self.xn[ch][0];
    self.xn[ch][0] = in;
    self.yn[ch][1] = self.yn[ch][0];
    self.yn[ch][0] = out;
    return out;
}
