//! olivec bindings for zig

const std = @import("std");

pub const Font = extern struct {
    width: usize,
    height: usize,
    glyphs: [*]const u8,
};

pub const DEFAULT_FONT_HEIGHT = 6;
pub const DEFAULT_FONT_WIDTH = 6;

pub const Canvas = extern struct {
    pixels: [*]u32,
    width: usize,
    height: usize,
    stride: usize,
};

pub fn canvas_null() Canvas {
    return std.mem.zeroes(Canvas);
}

pub fn get_pixel(c: Canvas, x: usize, y: usize) u32 {
    return c.pixels[y * c.stride + x];
}

pub extern fn olivec_canvas(pixels: [*]u32, width: usize, height: usize, stride: usize) Canvas;
pub extern fn olivec_subcanvas(c: Canvas, x: i32, y: i32, w: i32, h: i32) Canvas;
pub extern fn olivec_in_bounds(c: Canvas, x: i32, y: i32) bool;
pub extern fn olivec_blend_color(c1: ?*u32, c2: u32) void;
pub extern fn olivec_fill(c: Canvas, color: u32) void;
pub extern fn olivec_rect(c: Canvas, x: i32, y: i32, w: i32, h: i32, color: u32) void;
pub extern fn olivec_frame(c: Canvas, x: i32, y: i32, w: i32, h: i32, thiccness: usize, color: u32) void;
pub extern fn olivec_circle(c: Canvas, center_x: i32, center_y: i32, r: i32, color: u32) void;
pub extern fn olivec_ellipse(c: Canvas, center_x: i32, center_y: i32, rx: i32, ry: i32, color: u32) void;
pub extern fn olivec_line(c: Canvas, x1: i32, y1: i32, x2: i32, y2: i32, color: u32) void;
pub extern fn olivec_normalize_triangle(width: usize, height: usize, x1: i32, y1: i32, x2: i32, y2: i32, x3: i32, y3: i32, lx: ?*i32, hx: ?*i32, ly: ?*i32, hy: ?*i32) bool;
pub extern fn olivec_barycentric(x1: i32, y1: i32, x2: i32, y2: i32, x3: i32, y3: i32, xp: i32, yp: i32, u1: ?*i32, u2: ?*i32, det: ?*i32) bool;
pub extern fn olivec_triangle(c: Canvas, x1: i32, y1: i32, x2: i32, y2: i32, x3: i32, y3: i32, color: u32) void;
pub extern fn olivec_triangle3c(c: Canvas, x1: i32, y1: i32, x2: i32, y2: i32, x3: i32, y3: i32, color1: u32, color2: u32, color3: u32) void;
pub extern fn olivec_triangle3z(c: Canvas, x1: i32, y1: i32, x2: i32, y2: i32, x3: i32, y3: i32, z1: i32, z2: i32, z3: i32) void;
pub extern fn olivec_triangle3uv(c: Canvas, x1: i32, y1: i32, x2: i32, y2: i32, x3: i32, y3: i32, tx1: f32, ty1: f32, tx2: f32, ty2: f32, tx3: f32, ty3: f32, z1: f32, z2: f32, z3: f32, texture: Canvas) void;
pub extern fn olivec_triangle3uv_bilinear(c: Canvas, x1: i32, y1: i32, x2: i32, y2: i32, x3: i32, y3: i32, tx1: f32, ty1: f32, tx2: f32, ty2: f32, tx3: f32, ty3: f32, z1: f32, z2: f32, z3: f32, texture: Canvas) void;
pub extern fn olivec_text(c: Canvas, text: [*]const u8, x: i32, y: i32, font: Font, size: usize, color: u32) void;
pub extern fn olivec_sprite_blend(c: Canvas, x: i32, y: i32, w: i32, h: i32, sprite: Canvas) void;
pub extern fn olivec_sprite_copy(c: Canvas, x: i32, y: i32, w: i32, h: i32, sprite: Canvas) void;
pub extern fn olivec_sprite_copy_bilinear(c: Canvas, x: i32, y: i32, w: i32, h: i32, sprite: Canvas) void;
pub extern fn olivec_pixel_bilinear(sprite: Canvas, nx: i32, ny: i32, w: i32, h: i32) u32;

pub const NormalizedRect = struct {
    x1: i32,
    x2: i32,
    y1: i32,
    y2: i32,
    ox1: i32,
    ox2: i32,
    oy1: i32,
    oy2: i32,
};

pub extern fn olivec_normalize_rect(x: i32, y: i32, w: i32, h: i32, canvas_width: usize, canvas_height: usize, nr: ?*NormalizedRect) bool;
