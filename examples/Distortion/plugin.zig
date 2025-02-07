const std = @import("std");
const arbor = @import("arbor");
const param = arbor.param;
const log = arbor.log;

const Distortion = @This();

const Mode = enum {
    Vintage,
    Modern,
    Apocalypse,
};

const plugin_params = &[_]arbor.Parameter{
    param.Float("Gain", 0, 30, 0, .{ .flags = .{}, .value_to_text = dbValToText }),
    param.Float("Out", -12, 12, 0, .{ .flags = .{}, .value_to_text = dbValToText }),
    param.Choice("Mode", Mode.Vintage, .{ .flags = .{} }), // optionally pass a list of names
};

const allocator = std.heap.c_allocator;

export fn init() *arbor.Plugin {
    const plugin = arbor.init(allocator, plugin_params, .{
        .deinit = deinit,
        .prepare = prepare,
        .process = process,
        .gui_init = gui_init,
    });
    return plugin;
}

fn deinit(plugin: *arbor.Plugin) void {
    _ = plugin;
    // If we set user data in init(), you would free it here
}

fn prepare(plugin: *arbor.Plugin, sample_rate: f32, max_num_frames: u32) void {
    plugin.sample_rate = sample_rate;
    plugin.max_frames = max_num_frames;
}

fn process(plugin: *arbor.Plugin, buffer: arbor.AudioBuffer(f32)) void {
    const in_gain_db = plugin.getParamValue(f32, "Gain");
    const out_gain_db = plugin.getParamValue(f32, "Out");
    const mode = plugin.getParamValue(Mode, "Mode");

    const in_gain = std.math.pow(f32, 10, in_gain_db * 0.05);
    const out_gain = std.math.pow(f32, 10, out_gain_db * 0.05);

    for (buffer.input, 0..) |ch, ch_idx| {
        var out = buffer.output[ch_idx];
        for (ch, 0..) |sample, idx| {
            // For performance reasons, you wouldn't want to branch inside
            // this loop, but...example
            switch (mode) {
                .Modern => {
                    var x = sample;
                    x *= in_gain;
                    x = @min(1, @max(-1, x));
                    out[idx] = (5.0 / 4.0) * (x - (x * x * x * x * x) / 5) * out_gain;
                },
                .Vintage => {
                    var x = sample;
                    x *= in_gain;
                    if (x < 0) {
                        x = @max(-1, x);
                        x = (3.0 / 2.0) * (x - (x * x * x) / 3.0);
                    } else x = (3.0 / 2.0) * std.math.tanh(x);
                    x *= out_gain;
                    out[idx] = x;
                },
                .Apocalypse => {
                    var x = sample;
                    x *= in_gain * 2;
                    x -= @abs(@sin(x / std.math.two_sqrtpi));
                    x += @abs(@sin(x / std.math.pi));
                    x = 2 * @sin(x / std.math.tau);
                    x = @min(1, @max(-1, x));
                    x *= out_gain;
                    out[idx] = x;
                },
            }
        }
    }
}

fn dbValToText(value: f32, buf: []u8) usize {
    const out = std.fmt.bufPrint(buf, "{d:.2} dB", .{value}) catch |e| {
        log.err("{!}\n", .{e}, @src());
        return 0;
    };
    return out.len;
}

const Graphics = arbor.Gui.Graphics;
const Color = arbor.Gui.Color;

pub const WIDTH = 500;
pub const HEIGHT = 600;
const background_color = Color{ .r = 0, .g = 0x80, .b = 0x80, .a = 0xff };

const slider_dark = Color{ .r = 0, .g = 0x70, .b = 0x70, .a = 0xff };
const silver = Color.fromBits(0xff_aa_aa_aa, .ARGB);

const highlight_color = Color{ .r = 0x9f, .g = 0xc4, .b = 0x72, .a = 0xff };
const border_color = Color{ .r = 0x9f, .g = 0xbb, .b = 0x95, .a = 0xff };

const TITLE = "DISTORTION";

// Implement the GUI initialization function
fn gui_init(plugin: *arbor.Plugin) void {
    _ = arbor.Gui.init(plugin, .{
        .width = WIDTH,
        .height = HEIGHT,
        .timer_ms = 1000 / 60,
        .interface = .{
            .deinit = gui_deinit,
            .render = gui_render,
        },
    });
}

fn gui_deinit(gui: *arbor.Gui) void {
    _ = gui;
}

fn gui_render(gui: *arbor.Gui) void {
    const g = gui.g;
    // const gui_size = g.getRenderSize();

    g.beginDrawing();
    // draw our background and frame
    g.clear(background_color.toFloat());
    g.drawRect(
        .{ .x = 2, .y = 2, .width = WIDTH - 4, .height = HEIGHT - 4 },
        4,
        border_color.toFloat(),
    );

    // draw plugin title
    const title_width = WIDTH / 3;
    const title_bounds = arbor.Gui.Rect{
        .x = (WIDTH / 2) - (title_width / 2),
        .y = 10,
        .width = title_width,
        .height = 50,
    };
    g.fillRect(title_bounds, silver.toFloat());
    g.drawText(TITLE, title_bounds, slider_dark.toFloat());

    g.endDrawing();

    // draw each component
    // for (gui.components.items) |*c| {
    //     c.interface.draw_proc(c, gui.canvas);
    // }

    // render logo
    // draw.olivec_sprite_blend(gui.canvas, 6, 6, 64, 64, logo_canvas);
}

// TODO: Write Zig bindings for Olivec so we can run it at comptime
// var logo_pix: [32 * 32]u32 = undefined;
// var logo_canvas: draw.Canvas = .{
//     .pixels = @ptrCast(&logo_pix),
//     .width = 32,
//     .height = 32,
//     .stride = 32,
// };

// fn drawLogo() void {
//     const cx = 15;
//     const cy = 15;
//     draw.olivec_fill(logo_canvas, 0);
//     draw.olivec_circle(logo_canvas, cx, cy, 16, silver.toBits());
//     draw.olivec_line(logo_canvas, cx, 0, cx, 32, slider_dark.toBits());
//     var i: u32 = 3;
//     while (i < cy + 2) : (i += 3) {
//         const w = i * 2;
//         const x = 15 - (w / 2);
//         draw.olivec_line(
//             logo_canvas,
//             @intCast(x),
//             @intCast(i),
//             @intCast(x + w),
//             @intCast(i),
//             slider_dark.toBits(),
//         );
//     }
// }
