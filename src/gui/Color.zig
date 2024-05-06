const builtin = @import("builtin");

const Color = @This();

r: u8,
g: u8,
b: u8,
a: u8,

pub const WHITE = Color{ .r = 0xff, .g = 0xff, .b = 0xff, .a = 0xff };
pub const BLACK = Color{ .r = 0, .g = 0, .b = 0, .a = 0xff };
pub const NULL = @import("std").mem.zeroes(Color);

pub fn toBits(self: Color) u32 {
    return (@as(u32, self.a) << 24) | (@as(u32, self.r) << 16) |
        (@as(u32, self.g) << 8) | self.b;
}

pub fn fromBits(bits: u32) Color {
    return .{
        .a = @truncate(bits >> 24),
        .r = @truncate(bits >> 16),
        .g = @truncate(bits >> 8),
        .b = @truncate(bits),
    };
}

pub fn withOpacity(color: Color, opacity: u8) Color {
    var new = color;
    new.a = opacity;
    return new;
}
