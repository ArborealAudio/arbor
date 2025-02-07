const std = @import("std");
const math = std.math;
const builtin = @import("builtin");

const arbor = @import("root");
pub const d2d = @import("d2d.zig");

const os = builtin.target.os.tag;

pub const Window = switch (os) {
    .windows => d2d.HWND,
    .macos => ?*anyopaque,
    .linux => c_ulong,
    else => @panic("Unsupported OS"),
};

pub const Timer = switch (os) {
    .windows => c_uint,
    .macos => *opaque {},
    else => @panic("Unsupported OS"),
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

pub const Point = extern struct {
    x: f32,
    y: f32,
};

pub const Size = extern struct {
    width: f32,
    height: f32,
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
    a: u8 = 0xff,

    pub const White = Color{ .r = 0xff, .g = 0xff, .b = 0xff };
    pub const Black = Color{ .r = 0, .g = 0, .b = 0 };
    pub const Red = Color{ .r = 0xff, .g = 0, .b = 0 };
    pub const Green = Color{ .r = 0, .g = 0xff, .b = 0 };
    pub const Blue = Color{ .r = 0, .g = 0, .b = 0xff };
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

    pub fn toFloat(self: Color) Colorf {
        const max: f32 = math.maxInt(u8);
        return .{
            .r = @as(f32, @floatFromInt(self.r)) / max,
            .g = @as(f32, @floatFromInt(self.g)) / max,
            .b = @as(f32, @floatFromInt(self.b)) / max,
            .a = @as(f32, @floatFromInt(self.a)) / max,
        };
    }
};

pub const Colorf = extern struct {
    pub const Format = enum {
        ARGB,
        RGBA,
    };
    r: f32,
    g: f32,
    b: f32,
    a: f32 = 1,

    pub fn toInt(self: Colorf) Color {
        return .{
            .r = self.r * 255,
            .g = self.g * 255,
            .b = self.b * 255,
            .a = self.a * 255,
        };
    }
};

pub fn init(user: *anyopaque, width: u32, height: u32, title: [:0]const u8) !*Context {
    return guiInitChildWindow(user, @intCast(width), @intCast(height), title.ptr) orelse
        return error.WindowInitFailed;
}

pub const Context = opaque {
    pub fn deinit(self: *Context) void {
        guiDeinit(self);
    }

    pub fn setParent(self: *Context, parent: Window) void {
        guiSetParent(self, parent);
    }

    pub fn setVisible(self: *Context, visible: bool) void {
        guiSetVisible(self, visible);
    }

    /// Request a redraw of the OS window
    pub fn redraw(self: *Context) void {
        guiRedraw(self);
    }

    pub fn beginDrawing(self: *Context) void {
        guiBeginDrawing(self);
    }

    pub fn endDrawing(self: *Context) void {
        guiEndDrawing(self);
    }

    pub fn clear(self: *Context, color: Colorf) void {
        guiClear(self, color);
    }

    pub fn drawRect(self: *Context, rect: Rect, stroke_width: f32, color: Colorf) void {
        guiDrawRect(self, rect, stroke_width, color);
    }

    pub fn fillRect(self: *Context, rect: Rect, color: Colorf) void {
        guiFillRect(self, rect, color);
    }

    pub fn drawRoundedRect(
        self: *Context,
        rect: Rect,
        radius: f32,
        stroke_width: f32,
        color: Colorf,
    ) void {
        guiDrawRoundedRect(self, rect, radius, stroke_width, color);
    }

    pub fn fillRoundedRect(self: *Context, rect: Rect, radius: f32, color: Colorf) void {
        guiFillRoundedRect(self, rect, radius, color);
    }

    pub fn loadFont(self: *Context, font_name: [:0]const u8, size: f32) void {
        guiLoadFont(self, font_name, size);
    }

    pub fn drawText(self: *Context, text: [:0]const u8, rect: Rect, color: Colorf) void {
        guiDrawText(self, text, rect, color);
    }

    pub fn getRenderSize(self: *Context) Size {
        return guiGetRenderSize(self);
    }
};

extern fn guiInitChildWindow(*anyopaque, c_int, c_int, [*:0]const u8) ?*Context;
extern fn guiDeinit(*Context) void;
extern fn guiSetParent(*Context, Window) void;
extern fn guiSetVisible(*Context, bool) void;
extern fn guiRedraw(*Context) void;
extern fn guiBeginDrawing(*Context) void;
extern fn guiEndDrawing(*Context) void;
extern fn guiClear(*Context, Colorf) void;
extern fn guiDrawRect(*Context, Rect, f32, Colorf) void;
extern fn guiFillRect(*Context, Rect, Colorf) void;
extern fn guiDrawRoundedRect(*Context, Rect, f32, f32, Colorf) void;
extern fn guiFillRoundedRect(*Context, Rect, f32, Colorf) void;
extern fn guiLoadFont(*Context, [*:0]const u8, f32) void;
extern fn guiDrawText(*Context, [*:0]const u8, Rect, Colorf) void;
extern fn guiGetRenderSize(*Context) Size;
