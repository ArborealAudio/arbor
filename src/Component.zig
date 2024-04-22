//! Component.zig
//! Module for drawing GUI widgets

const std = @import("std");
const Params = @import("Params.zig");
const Gui = @import("Gui.zig");
const olivec = @import("olivec");
const Vec2 = Gui.Vec2;
const Text = @import("Text.zig");

pub const Component = @This();

const Label = struct {
    text: []const u8,
    height: u32,
};

canvas: *olivec.Canvas,
id: u32 = undefined,
type: union {
    knob: Knob,
    slider: Slider,
},
pos: Vec2,
width: f32,
height: f32,
fill_color: u32,
border_color: u32,
border_size: u32 = 0,

value: f32,

label: ?Label,

is_mouse_over: bool = false,

draw: *const fn (self: Component) void,

pub fn getComponentID(param_name: []const u8) u32 {
    return Params.nameToID(param_name) catch @panic("Component not found");
}

pub fn hit_test(self: Component, pt: Vec2) bool {
    return (pt.x >= self.pos.x and
        pt.y >= self.pos.y and
        pt.x <= self.pos.x + self.width and
        pt.y <= self.pos.y + self.height);
}

pub const Slider = struct {
    pub fn draw(self: Component) void {
        const height = if (self.label == null)
            self.height
        else
            self.height - @as(f32, @floatFromInt(self.label.?.height));
        const val_height = height * self.value;
        const top = self.pos.y + (height - val_height);
        // draw borders
        olivec.olivec_rect(
            self.canvas.*,
            @intFromFloat(self.pos.x),
            @intFromFloat(self.pos.y),
            @intFromFloat(self.width),
            @intFromFloat(height),
            self.border_color,
        );

        olivec.olivec_rect(
            self.canvas.*,
            @intFromFloat(self.pos.x),
            @intFromFloat(top),
            @intFromFloat(self.width),
            @intFromFloat(val_height),
            self.fill_color,
        );

        if (self.label) |l| {
            // TODO: Just pass the component's bounds, and the text drawing
            // can take care of the positioning, probably via a parameter
            const text_y = self.pos.y + height;
            const text_x = self.pos.x - self.width / 2;
            Text.drawText(l.text, self.canvas.pixels, .{
                .x = @intFromFloat(text_x),
                .y = @intFromFloat(text_y),
                .width = @intFromFloat(self.width),
                .height = l.height,
            }, 2, 0xffffffff);
        }
    }
};

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

    pub fn draw(self: Component) void {
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
        olivec.olivec_circle(self.canvas.*, centerX, centerY, @intFromFloat(radius), self.fill_color);

        const min_knob_pos: f32 = std.math.pi * 0.25;
        const max_knob_pos: f32 = std.math.pi * 1.75;
        // point along circumference to draw pointer
        const pointer_angle = min_knob_pos + self.value * (max_knob_pos - min_knob_pos);
        const cos = @cos(pointer_angle);
        const sin = @sin(pointer_angle);
        const x1 = centerX + (cos * radius);
        const y1 = centerY + (sin * radius);

        olivec.olivec_circle(self.canvas.*, x1, y1, @intFromFloat(10), self.border_color);

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

test "Type union" {
    const comp: Component = .{
        .id = 0,
        .type = .{
            .slider = .{},
        },
        .draw = Slider.draw,
        .pos = .{ .x = 0, .y = 0 },
        .width = 100,
        .height = 100,
        .fill_color = 0xff_00_00_ff,
        .border_color = 0xff_00_00_ff,
        .value = 1,
    };
    _ = comp;
    try std.testing.expect(true);
}
