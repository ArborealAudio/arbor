//! Component.zig
//! Module for drawing GUI widgets

const std = @import("std");
const arbor = @import("../arbor.zig");
const Gui = arbor.Gui;
const draw = @import("draw.zig");
const Vec2 = draw.Vec2;

pub const Component = @This();

pub const Label = struct {
    pub const Flags = packed struct {
        center_x: bool = true,
        center_y: bool = true,
        background: bool = false,
        border: bool = false,
    };

    text: []const u8,
    height: u32,
    flags: Flags = .{},
    color: u32,
    background: u32 = 0,
    border: u32 = 0,
};

canvas: draw.Canvas,
id: u32 = undefined,
pos: Vec2,
width: f32,
height: f32,
fill_color: u32,
border_color: u32,
border_size: u32 = 0,

value: f32,

label: ?Label,

is_mouse_over: bool = false,

draw_proc: *const fn (self: Component) void,

pub fn hit_test(self: Component, pt: Vec2) bool {
    return (pt.x >= self.pos.x and
        pt.y >= self.pos.y and
        pt.x <= self.pos.x + self.width and
        pt.y <= self.pos.y + self.height);
}

pub fn setValue(self: *Component, val: f32) void {
    self.value = val;
}

pub fn draw_slider(self: Component) void {
    const height = if (self.label == null)
        self.height
    else
        self.height - @as(f32, @floatFromInt(self.label.?.height));
    const val_height = height * self.value;
    const top = self.pos.y + (height - val_height);
    // draw borders
    draw.olivec_rect(
        self.canvas,
        @intFromFloat(self.pos.x),
        @intFromFloat(self.pos.y),
        @intFromFloat(self.width),
        @intFromFloat(height),
        self.border_color,
    );

    draw.olivec_rect(
        self.canvas,
        @intFromFloat(self.pos.x),
        @intFromFloat(top),
        @intFromFloat(self.width),
        @intFromFloat(val_height),
        self.fill_color,
    );

    if (self.label) |l| {
        const text_y = self.pos.y + height;
        const text_x = self.pos.x;
        draw.drawText(self.canvas, l, .{
            .x = @intFromFloat(text_x),
            .y = @intFromFloat(text_y),
            .width = @intFromFloat(self.width),
            .height = l.height,
        });
    }
}

pub const Knob = struct {
    // pointer length as a fraction of radius
    pointer_length: f32 = 0.5,
    // pointer thickness in pixels
    pointer_thickness: f32 = 5.0,

    flags: Flags = .{},

    label: Label,

    // const Label = struct {
    //     text: []const u8,
    //     size: f32,
    //     position: Position = .Below,
    //     spacing: i32 = 5,

    //     const Position = enum {
    //         Above,
    //         Below,
    //         Left,
    //         Right,
    //     };
    // };

    const Flags = packed struct {
        draw_label: bool = true,
        drop_shadow: bool = false,
    };

    pub fn draw_knob(self: Component) void {
        const radius: f32 = self.width / 2.0;
        const centerX = self.pos.x + radius;
        const centerY = self.pos.y + radius;
        // if (self.flags.filled)
        //     rl.DrawCircle(self.centerX, self.centerY, radius, self.color)
        // else
        //     rl.DrawCircleLines(self.centerX, self.centerY, radius, self.color);
        // Gui.drawCircle(bits, .{
        //     .pos = .{ .x = centerX, .y = centerY },
        //     .radius = self.width,
        // }, self.fill_color, self.border_color, self.border_size);
        draw.olivec_circle(self.canvas.*, centerX, centerY, @intFromFloat(radius), self.fill_color);

        const min_knob_pos: f32 = std.math.pi * 0.25;
        const max_knob_pos: f32 = std.math.pi * 1.75;
        // point along circumference to draw pointer
        const pointer_angle = min_knob_pos + self.value * (max_knob_pos - min_knob_pos);
        const cos = @cos(pointer_angle);
        const sin = @sin(pointer_angle);
        const x1 = centerX + (cos * radius);
        const y1 = centerY + (sin * radius);

        draw.olivec_circle(self.canvas.*, x1, y1, @intFromFloat(10), self.border_color);

        // Gui.drawCircle(
        //     bits,
        //     .{ .pos = .{ .x = x1, .y = y1 }, .radius = 10 },
        //     0xffff0000,
        //     0,
        //     0,
        // );

        // if (self.flags.draw_label) {
        //     var label = self.label.text;
        //     const max_chars = 4;
        //     if (self.is_mouse_over) {
        //         var buf: [max_chars + 1]u8 = undefined;
        //         label = std.fmt.bufPrintZ(&buf, "{d:.2}", .{self.value}) catch @panic("Buffer write error");
        //     }
        //     const text_width = rl.MeasureTextEx(Gui.font, label, self.label.size, 1.5);
        //     const half_text = text_width.x / 2.0;
        //     rl.DrawTextEx(Gui.font, label, .{ .x = @as(f32, @floatFromInt(self.centerX)) - half_text, .y = @as(f32, @floatFromInt(self.centerY + self.label.spacing)) + radius }, self.label.size, 1.5, rl.RAYWHITE);
        // }
    }
};
