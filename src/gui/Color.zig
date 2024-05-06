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
    switch (color_space) {
        .ARGB => {
            return (@as(u32, self.a) << 24) | (@as(u32, self.r) << 16) |
                (@as(u32, self.g) << 8) | self.b;
        },
        .ABGR => {
            return (@as(u32, self.a) << 24) | (@as(u32, self.b) << 16) |
                (@as(u32, self.g) << 8) | self.r;
        },
    }
}

pub fn fromBits(bits: u32) Color {
    switch (color_space) {
        .ARGB => {
            return .{
                .a = @truncate(bits >> 24),
                .r = @truncate(bits >> 16),
                .g = @truncate(bits >> 8),
                .b = @truncate(bits),
            };
        },
        .ABGR => {
            return .{
                .a = @truncate(bits >> 24),
                .b = @truncate(bits >> 16),
                .g = @truncate(bits >> 8),
                .r = @truncate(bits),
            };
        },
    }
}

pub fn withOpacity(color: Color, opacity: u8) Color {
    var new = color;
    new.a = opacity;
    return new;
}

pub const ColorSpace = enum {
    ARGB,
    ABGR,
};

pub const color_space: ColorSpace = switch (builtin.os.tag) {
    .linux, .windows => .ARGB,
    .macos => .ABGR,
    else => @panic("Unsupported OS"),
};
