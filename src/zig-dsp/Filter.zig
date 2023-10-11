//! Trying to reinvent the filter for all time
// Derived from "Matched Second Order Filters" by Martin Vicanek (2016)

const std = @import("std");

const Filter = @This();

cutoff: f32 = undefined,
reso: f32 = undefined,
coeffs: Coeffs = undefined,
filter_type: Type = .Lowpass,

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

pub const Type = enum {
    Lowpass,
    Highpass,
    Bandpass,
};

/// initialize filter coefficients
pub fn init(
    self: *Filter,
    allocator: std.mem.Allocator,
    numChannels: u32,
    sample_rate: f32,
    cutoff: f32,
    reso: f32,
) void {
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

// deallocate filter state
pub fn deinit(self: *Filter, allocator: std.mem.Allocator) void {
    for (self.xn, 0..) |_, i|
        allocator.free(self.xn[i]);
    for (self.yn, 0..) |_, i|
        allocator.free(self.yn[i]);
    allocator.free(self.xn);
    allocator.free(self.yn);
}

pub fn reset(self: *Filter) void {
    for (self.xn, 0..) |_, i|
        self.xn[i] = [2]f32{ 0.0, 0.0 };

    for (self.yn, 0..) |_, i|
        self.yn[i] = [2]f32{ 0.0, 0.0 };
}

pub fn setCoeffs(self: *Filter) void {
    const w0 = 2.0 * std.math.pi * self.cutoff / self.sample_rate;
    const q = 1.0 / (2.0 * self.reso);
    const tmp = @exp(-q * w0);
    self.coeffs.a1 = -2.0 * tmp;
    if (q <= 1.0)
        self.coeffs.a1 *= @cos(@sqrt(1.0 - q * q) * w0)
    else
        self.coeffs.a1 *= std.math.cosh(@sqrt(q * q - 1.0) * w0);
    self.coeffs.a2 = tmp * tmp;

    const f0 = self.cutoff / (self.sample_rate * 0.5);
    const freq2 = f0 * f0;
    const fac = (1.0 - freq2) * (1.0 - freq2);

    switch (self.filter_type) {
        .Lowpass => {
            const r0 = 1.0 + self.coeffs.a1 + self.coeffs.a2;
            const r1_num = (1.0 - self.coeffs.a1 + self.coeffs.a2) * freq2;
            const r1_denom = @sqrt(fac + freq2 / (self.reso * self.reso));
            const r1 = r1_num / r1_denom;

            self.coeffs.b0 = (r0 + r1) / 2.0;
            self.coeffs.b1 = r0 - self.coeffs.b0;
            self.coeffs.b2 = 0.0;
        },
        .Highpass => {
            const r1_num = 1.0 - self.coeffs.a1 + self.coeffs.a2;
            const r1_denom = @sqrt(fac + freq2 / (self.reso * self.reso));
            const r1 = r1_num / r1_denom;

            self.coeffs.b0 = r1 / 4.0;
            self.coeffs.b1 = -2.0 * self.coeffs.b0;
            self.coeffs.b2 = self.coeffs.b0;
        },
        .Bandpass => {
            const r0 = (1.0 + self.coeffs.a1 + self.coeffs.a2) / (std.math.pi * f0 * self.reso);
            const r1_num = (1.0 - self.coeffs.a1 + self.coeffs.a2) * (f0 / self.reso);
            const r1_denom = @sqrt(fac + freq2 / (self.reso * self.reso));
            const r1 = r1_num / r1_denom;

            self.coeffs.b1 = -r1 / 2.0;
            self.coeffs.b0 = (r0 - self.coeffs.b1) / 2.0;
            self.coeffs.b2 = -self.coeffs.b0 - self.coeffs.b1;
        },
    }
}

pub fn processSample(self: *Filter, ch: u32, in: f32) f32 {
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
