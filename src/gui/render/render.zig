const std = @import("std");
const math = std.math;
const builtin = @import("builtin");

pub const d2d = @import("d2d.zig");

const os = builtin.target.os.tag;

pub const Graphics = switch (os) {
    .windows => d2d.Context,
    else => @panic("Unimplemented OS"),
};

pub const Window = switch (os) {
    .windows => d2d.HWND,
    .macos => *opaque {},
    .linux => c_ulong,
    else => @panic("Unsupported OS"),
};

pub const init = switch (os) {
    .windows => d2d.init,
    else => @panic("Unimplemented OS"),
};

pub const Vec2 = extern struct {
    x: f32,
    y: f32,
};

pub const Vec2i = extern struct {
    x: i32,
    y: i32,
};

pub const Vec2u = extern struct {
    x: u32,
    y: u32,

    pub fn fromVec2i(v: Vec2i) Vec2u {
        std.debug.assert(v.x >= 0 and v.y >= 0);
        return .{ .x = @intCast(v.x), .y = @intCast(v.y) };
    }
};

pub const Rect = extern struct {
    x: f32,
    y: f32,
    width: f32,
    height: f32,

    pub const zero = std.mem.zeroes(Rect);

    /// Platform-specfic rect struct, may have different fields than our Rect type
    pub const PlatformRect = switch (os) {
        .windows => d2d.Rect,
        else => @panic("Unimplemented OS"),
    };

    pub fn intersection(a: Rect, b: Rect) Rect {
        var rect = Rect{ .x = 0, .y = 0, .width = 0, .height = 0 };
        rect.x = @max(b.x, a.x);
        rect.y = @max(b.y, a.y);
        rect.width = @min(a.width, b.width);
        rect.height = @min(a.height, b.height);
        return rect;
    }

    pub fn toPlatform(self: Rect) PlatformRect {
        switch (os) {
            .windows => return .{
                .left = self.x,
                .top = self.y,
                .right = self.x + self.width,
                .bottom = self.y + self.height,
            },
            else => @panic("Unimlpemented OS"),
        }
    }
};

pub const Recti = extern struct {
    x: u32,
    y: u32,
    width: u32,
    height: u32,

    pub const zero = std.mem.zeroes(Recti);

    pub fn intersection(a: Recti, b: Recti) Recti {
        var rect = Recti{ .x = 0, .y = 0, .width = 0, .height = 0 };
        rect.x = @max(b.x, a.x);
        rect.y = @max(b.y, a.y);
        rect.width = @min(a.width, b.width);
        rect.height = @min(a.height, b.height);
        return rect;
    }
};

pub const Color = extern struct {
    pub const Format = enum {
        ARGB,
        RGBA,
    };
    r: u8,
    g: u8,
    b: u8,
    a: u8,

    pub const PlatformColor = switch (os) {
        .windows => d2d.Color,
        else => @panic("Unimplemented OS"),
    };

    pub const White = Color{ .r = 0xff, .g = 0xff, .b = 0xff, .a = 0xff };
    pub const Black = Color{ .r = 0, .g = 0, .b = 0, .a = 0xff };
    pub const NULL = std.mem.zeroes(Color);

    pub fn toBits(self: Color, format: Format) u32 {
        switch (format) {
            .ARGB => {
                return (@as(u32, self.a) << 24) | (@as(u32, self.r) << 16) |
                    (@as(u32, self.g) << 8) | self.b;
            },
            .RGBA => return @bitCast(self),
        }
    }

    pub fn fromBits(bits: u32, format: Format) Color {
        switch (format) {
            .ARGB => return .{
                .a = @truncate(bits >> 24),
                .r = @truncate(bits >> 16),
                .g = @truncate(bits >> 8),
                .b = @truncate(bits),
            },
            .RGBA => return @bitCast(bits),
        }
    }

    pub fn withOpacity(color: Color, opacity: u8) Color {
        var new = color;
        new.a = opacity;
        return new;
    }

    pub fn toPlatform(self: Color) PlatformColor {
        const max: f32 = math.maxInt(u8);
        return .{
            .r = @as(f32, @floatFromInt(self.r)) / max,
            .g = @as(f32, @floatFromInt(self.g)) / max,
            .b = @as(f32, @floatFromInt(self.b)) / max,
            .a = @as(f32, @floatFromInt(self.a)) / max,
        };
    }
};
