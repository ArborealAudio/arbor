//! Components.zig
//! Module for drawing GUI widgets

const std = @import("std");
const Params = @import("Params.zig");
const Gui = @import("Gui.zig");

pub fn getComponentID(param_name: []const u8) u32 {
    return Params.nameToID(param_name) catch @panic("Component not found");
}

pub const Knob = struct {
    id: u32 = undefined,

    centerX: f32,
    centerY: f32,
    width: f32,

    fill_color: u32,
    border_color: u32,
    border_size: f32 = 0,

    // pointer length as a fraction of radius
    pointer_length: f32 = 0.5,
    // pointer thickness in pixels
    pointer_thickness: f32 = 5.0,

    // associated parameter value, normalized to 0-1 range
    value: f64 = undefined,

    flags: Flags = .{},

    is_mouse_over: bool = false,

    label: Label,

    const Label = struct {
        text: []const u8,
        size: f32,
        position: Position = .Below,
        spacing: i32 = 5,

        const Position = enum {
            Above,
            Below,
            Left,
            Right,
        };
    };

    const Flags = packed struct {
        draw_label: bool = true,
        drop_shadow: bool = false,
    };

    pub fn draw(self: *Knob, bits: []u32) void {
        const radius: f32 = self.width / 2.0;
        // if (self.flags.filled)
        //     rl.DrawCircle(self.centerX, self.centerY, radius, self.color)
        // else
        //     rl.DrawCircleLines(self.centerX, self.centerY, radius, self.color);
        Gui.drawCircle(bits, .{
            .pos = .{ .x = self.centerX, .y = self.centerY },
            .radius = self.width,
        }, self.fill_color, self.border_color, self.border_size);

        const min_knob_pos: f32 = std.math.pi * 0.25;
        const max_knob_pos: f32 = std.math.pi * 1.75;
        // point along circumference to draw pointer
        const pointer_angle = min_knob_pos + @as(f32, @floatCast(self.value)) * (max_knob_pos - min_knob_pos);
        const cos = @cos(pointer_angle);
        const sin = @sin(pointer_angle);
        const x1 = self.centerX + (cos * radius);
        const y1 = self.centerY + (sin * radius);

        Gui.drawCircle(
            bits,
            .{
                .pos = .{ .x = x1, .y = y1 },
                .radius = 10,
            },
            0xffff0000,
            0,
            0,
        );

        if (self.flags.draw_label) {
            var label = self.label.text;
            const max_chars = 4;
            if (self.is_mouse_over) {
                var buf: [max_chars + 1]u8 = undefined;
                label = std.fmt.bufPrintZ(&buf, "{d:.2}", .{self.value}) catch @panic("Buffer write error");
            }
            // const text_width = rl.MeasureTextEx(Gui.font, label, self.label.size, 1.5);
            // const half_text = text_width.x / 2.0;
            // rl.DrawTextEx(Gui.font, label, .{ .x = @as(f32, @floatFromInt(self.centerX)) - half_text, .y = @as(f32, @floatFromInt(self.centerY + self.label.spacing)) + radius }, self.label.size, 1.5, rl.RAYWHITE);
        }
    }

    pub fn isMouseDown(self: *Knob, pt: Gui.Vec2) bool {
        const radius = self.width / 2;
        return (pt.x >= self.centerX - radius and
            pt.y >= self.centerY - radius and
            pt.x <= self.centerX + radius and
            pt.y <= self.centerY + radius);
    }
};
