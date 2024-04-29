pub const olivec = @import("olivec.zig");
pub usingnamespace olivec;
pub const Text = @import("Text.zig");
pub usingnamespace Text;
pub const Color = @import("Color.zig");
pub usingnamespace Color;
// pub usingnamespace @This();

pub const Vec2 = extern struct {
    x: f32,
    y: f32,
};

pub const Vec2i = extern struct {
    x: i32,
    y: i32,
};

pub const Rect = extern struct {
    x: f32,
    y: f32,
    width: f32,
    height: f32,

    pub fn intersection(a: Rect, b: Rect) Rect {
        var rect = Rect{ .x = 0, .y = 0, .width = 0, .height = 0 };
        rect.x = @max(b.x, a.x);
        rect.y = @max(b.y, a.y);
        rect.width = @min(a.width, b.width);
        rect.height = @min(a.height, b.height);
        return rect;
    }
};

pub const Recti = extern struct {
    x: u32,
    y: u32,
    width: u32,
    height: u32,

    pub fn intersection(a: Recti, b: Recti) Recti {
        var rect = Recti{ .x = 0, .y = 0, .width = 0, .height = 0 };
        rect.x = @max(b.x, a.x);
        rect.y = @max(b.y, a.y);
        rect.width = @min(a.width, b.width);
        rect.height = @min(a.height, b.height);
        return rect;
    }
};

pub const Circle = struct {
    pos: Vec2, // center pos
    radius: f32,
};
