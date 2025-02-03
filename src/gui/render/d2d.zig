const std = @import("std");
const windows = std.os.windows;
pub const HWND = windows.HWND;
const wchar = windows.WCHAR;

const toUtf16 = std.unicode.utf8ToUtf16LeAllocZ;
var g_unicode_buf: [128]u8 = .{0} ** 128;
var unicode_fba_impl = std.heap.FixedBufferAllocator.init(g_unicode_buf);
const unicode_fba = unicode_fba_impl.allocator();

// (big ol') TODO: Use marlersoft/zigwin32 as the Windows layer, eliminate
// our C++ library. Then these structs below will just be aliases of the direct
// Win32 types, and we dont' have to deal with compiling C and keeping 1,000
// different API declarations in sync.

pub const Context = opaque {
    pub fn deinit(self: *Context) void {
        d2dl_deinit(self);
    }

    pub fn setParent(self: *Context, parent: HWND) void {
        d2dl_setParent(self, parent);
    }

    pub fn setVisible(self: *Context, visible: bool) void {
        d2dl_setVisible(self, visible);
    }

    pub fn beginDrawing(self: *Context) void {
        d2dl_beginDrawing(self);
    }

    pub fn endDrawing(self: *Context) void {
        d2dl_endDrawing(self);
    }

    pub fn clear(self: *Context, color: Color) void {
        d2dl_clear(self, color);
    }

    pub fn drawRect(self: *Context, rect: Rect, stroke_width: f32, color: Color) void {
        d2dl_drawRect(self, rect, stroke_width, color);
    }
    pub fn fillRect(self: *Context, rect: Rect, color: Color) void {
        d2dl_fillRect(self, rect, color);
    }
    pub fn drawRoundedRect(self: *Context, rect: Rect, radius: f32, stroke_width: f32, color: Color) void {
        d2dl_drawRoundedRect(self, rect, radius, stroke_width, color);
    }
    pub fn fillRoundedRect(self: *Context, rect: Rect, radius: f32, color: Color) void {
        d2dl_fillRoundedRect(self, rect, radius, color);
    }
    pub fn drawEllipse(self: *Context, center: Point, rx: f32, ry: f32, stroke_width: f32, color: Color) void {
        d2dl_drawEllipse(self, center, rx, ry, stroke_width, color);
    }
    pub fn fillEllipse(self: *Context, center: Point, rx: f32, ry: f32, color: Color) void {
        d2dl_fillEllipse(self, center, rx, ry, color);
    }
    pub fn loadFont(self: *Context, font_name: []const u8, size: f32) void {
        const wtext: [:0]u16 = toUtf16(unicode_fba, font_name) catch |e| @panic(@errorName(e));
        d2dl_loadFont(self, wtext, size);
    }
    pub fn drawText(self: *Context, text: []const u8, rect: Rect, color: Color) void {
        const wtext: [:0]u16 = toUtf16(unicode_fba, text) catch |e| @panic(@errorName(e));
        d2dl_drawText(self, wtext, rect, color);
    }
    pub fn getRenderSize(self: *Context) Size {
        return d2dl_getRenderSize(self);
    }
    pub fn setRenderSize(self: *Context, size: Size) void {
        d2dl_setRenderSize(self, size);
    }
};

const WindowType = union(enum) {
    desktop,
    child: struct { user: *anyopaque },
};

pub fn init(
    width: i32,
    height: i32,
    window_title: [:0]const u8,
    window_type: WindowType,
) !*Context {
    switch (window_type) {
        .desktop => return d2dl_initDesktopWindow(width, height, window_title) orelse {
            return error.WindowInitFailed;
        },
        .child => |child| return d2dl_initChildWindow(
            child.user,
            width,
            height,
            window_title,
        ) orelse return error.WindowInitFailed,
    }
}

// Direct2D-compatible render data

pub const Color = extern struct {
    r: f32,
    g: f32,
    b: f32,
    a: f32 = 1,
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
    left: f32,
    top: f32,
    right: f32,
    bottom: f32,
};

extern fn d2dl_initDesktopWindow(width: c_int, height: c_int, window_title: [*:0]const u8) ?*Context;
extern fn d2dl_initChildWindow(user: *anyopaque, width: c_int, height: c_int, window_title: [*:0]const u8) ?*Context;
extern fn d2dl_deinit(*Context) void;
extern fn d2dl_beginDrawing(*Context) void;
extern fn d2dl_endDrawing(*Context) void;
extern fn d2dl_clear(*Context, color: Color) void;
extern fn d2dl_drawRect(*Context, rect: Rect, stroke_width: f32, color: Color) void;
extern fn d2dl_fillRect(*Context, rect: Rect, color: Color) void;
extern fn d2dl_drawRoundedRect(*Context, rect: Rect, radius: f32, stroke_width: f32, color: Color) void;
extern fn d2dl_fillRoundedRect(*Context, rect: Rect, radius: f32, color: Color) void;
extern fn d2dl_drawEllipse(*Context, center: Point, rx: f32, ry: f32, stroke_width: f32, color: Color) void;
extern fn d2dl_fillEllipse(*Context, center: Point, rx: f32, ry: f32, color: Color) void;
extern fn d2dl_drawText(*Context, text: [*]const wchar, rect: Rect, color: Color) void;
extern fn d2dl_getRenderSize(*Context) Size;
extern fn d2dl_setRenderSize(*Context, size: Size) void;
extern fn d2dl_loadFont(*Context, font_name: [*]const wchar, size: f32) void;
extern fn d2dl_setParent(*Context, hwnd: HWND) void;
extern fn d2dl_setVisible(*Context, bool) void;
