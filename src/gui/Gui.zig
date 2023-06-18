//! Gui.zig
//! Where you layout GUI properties & behavior

const Self = @This();
const rl = @cImport({
    @cInclude("raylib.h");
});
const Plugin = @import("../Plugin.zig");

pub const GUI_WIDTH: c_uint = 800;
pub const GUI_HEIGHT: c_uint = 600;
const centerX: f32 = @as(f32, GUI_WIDTH) / 2.0;
const centerY: f32 = @as(f32, GUI_HEIGHT) / 2.0;

pub const mix_slider = rl.Rectangle{
    .x = centerX - 25.0,
    .y = centerY - 50.0,
    .width = 50.0,
    .height = 100.0,
};

pub fn render(plugin: *Plugin) void {
    rl.BeginDrawing();

    rl.ClearBackground(.{
        .r = 194,
        .g = 194,
        .b = 194,
        .a = 255,
    });

    const reverb_amount = @floatCast(f32, plugin.params.values.mix);

    var d_mix_slider = mix_slider;
    d_mix_slider.height = mix_slider.height * reverb_amount;
    d_mix_slider.y = mix_slider.y + (mix_slider.height - d_mix_slider.height);

    rl.DrawRectangleRec(mix_slider, rl.BLACK);
    rl.DrawRectangleRec(d_mix_slider, rl.RED);

    rl.EndDrawing();
}
