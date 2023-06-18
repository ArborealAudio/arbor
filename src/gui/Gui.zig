//! Gui.zig
//! Where you layout GUI properties & behavior

const Self = @This();
const rl = @cImport({
    @cInclude("raylib.h");
});
const Plugin = @import("../Plugin.zig");
const Components = @import("Components.zig");

pub const GUI_WIDTH: c_uint = 600;
pub const GUI_HEIGHT: c_uint = 600;
const centerX: f32 = @as(f32, GUI_WIDTH) / 2.0;
const centerY: f32 = @as(f32, GUI_HEIGHT) / 2.0;

pub fn render(plugin: *Plugin) void {
    rl.BeginDrawing();

    rl.ClearBackground(.{
        .r = 24,
        .g = 43,
        .b = 51,
        .a = 255,
    });

    const reverb_amount = @floatCast(f32, plugin.params.values.mix);
    _ = reverb_amount;

    rl.DrawCircleLines(@floatToInt(c_int, centerX), @floatToInt(c_int, centerY), 100.0, rl.RAYWHITE);

    rl.EndDrawing();
}
