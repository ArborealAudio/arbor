const builtin = @import("builtin");

const Color = @This();

r: u8,
g: u8,
b: u8,
a: u8,

pub fn bits(self: Color) u32 {
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

pub const ColorSpace = enum {
    ARGB,
    ABGR,
};

pub const color_space: ColorSpace = switch (builtin.os.tag) {
    .linux, .windows => .ARGB,
    .macos => .ABGR,
    else => @panic("Unsupported OS"),
};
