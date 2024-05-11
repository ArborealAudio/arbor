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

const draw = arbor.Gui.draw;

pub const WIDTH = 500;
pub const HEIGHT = 600;
const background_color = draw.Color{ .r = 0, .g = 0x80, .b = 0x80, .a = 0xff };

const slider_dark = draw.Color{ .r = 0, .g = 0x70, .b = 0x70, .a = 0xff };
const silver = draw.Color.fromBits(0xff_aa_aa_aa);

const highlight_color = draw.Color{ .r = 0x9f, .g = 0xc4, .b = 0x72, .a = 0xff };
const border_color = draw.Color{ .r = 0x9f, .g = 0xbb, .b = 0x95, .a = 0xff };

const TITLE = "DISTORTION";

// Export an entry to our GUI implementation
export fn gui_init(plugin: *arbor.Plugin) void {
    const gui = arbor.Gui.init(plugin.allocator, .{
        .layout = .default,
        .width = WIDTH,
        .height = HEIGHT,
        .timer_ms = 16,
        .interface = .{
            .deinit = gui_deinit,
            .render = gui_render,
        },
    });
    plugin.gui = gui;

    // we can draw the logo here and just copy its memory to the global canvas
    // in our render function
    drawLogo();

    // TODO: Allow the user to describe layout in more relative terms rather
    // than computing based on window size, etc.
    // somehting like getNextLayoutSection() and it will provide a rect which corresponds
    // to the appropriate area based on a layout chosen *prior* to instantiating components
    const slider_height = 200;
    const slider_gap = 90; // gap on either side of slider
    // create pointers, assign IDs and values
    // this is how the components get "attached" to parameters
    // setup unique properties here
    for (0..plugin.param_info.len) |i| {
        const param_info = plugin.getParamWithId(@intCast(i)) catch |e| {
            log.err("{!}\n", .{e}, @src());
            return;
        };
        if (!std.mem.eql(u8, param_info.name, "Mode")) {
            const width = (WIDTH / 2) - (slider_gap * 2);
            gui.addComponent(.{
                // given the gui.allocator, the memory will be cleaned up
                // on global GUI deinit. Otherwise, deallocate manually.
                .sub_type = arbor.Gui.Slider.init(gui.allocator, param_info, silver),
                .interface = arbor.Gui.Slider.interface,
                .value = param_info.getNormalizedValue(plugin.params[i]),
                .bounds = .{
                    .x = @intCast(i * (WIDTH / 2) + slider_gap),
                    .y = (HEIGHT / 2) - (slider_height / 2),
                    .width = width,
                    .height = slider_height,
                },
                .background_color = slider_dark,
                .label = .{
                    .text = param_info.name,
                    .height = 18,
                    .color = draw.Color.WHITE,
                    .border = silver,
                    .flags = .{
                        .border = true,
                        .center_x = true,
                        .center_y = false,
                    },
                },
            });
        } else { // mode menu
            const menu_width = WIDTH / 2;
            const menu_height = HEIGHT / 8;
            const bot_pad = 50;
            gui.addComponent(.{
                .sub_type = arbor.Gui.Menu.init(gui.allocator, param_info.enum_choices orelse {
                    log.err("No enum choices available\n", .{}, @src());
                    return;
                }, silver, 3, highlight_color),
                .interface = arbor.Gui.Menu.interface,
                .value = param_info.getNormalizedValue(plugin.params[i]), // don't bother normalizing since we just care about the int
                .bounds = .{
                    .x = (WIDTH - menu_width) - menu_width / 2,
                    .y = HEIGHT - menu_height - bot_pad,
                    .width = menu_width,
                    .height = menu_height,
                },
                .background_color = slider_dark,
                .label = .{
                    .text = param_info.name,
                    .height = menu_height / 2,
                    .color = draw.Color.WHITE,
                },
            });
        }
    }
}

fn gui_deinit(gui: *arbor.Gui) void {
    _ = gui;
}

fn gui_render(gui: *arbor.Gui) void {
    // draw our background and frame
    draw.olivec_fill(gui.canvas, background_color.toBits());
    draw.olivec_frame(gui.canvas, 2, 2, WIDTH - 4, HEIGHT - 4, 4, border_color.toBits());

    // draw plugin title
    const title_width = WIDTH / 3;
    draw.drawText(gui.canvas, .{
        .text = TITLE,
        .height = 25,
        .color = slider_dark,
        .background = silver,
        .flags = .{ .background = true },
    }, .{
        .x = (WIDTH / 2) - (title_width / 2),
        .y = 10,
        .width = title_width,
        .height = 50,
    });

    // draw each component
    for (gui.components.items) |*c| {
        c.interface.draw_proc(c, gui.canvas);
    }

    // render logo
    draw.olivec_sprite_blend(gui.canvas, 6, 6, 64, 64, logo_canvas);
}

// TODO: Write Zig bindings for Olivec so we can run it at comptime
var logo_pix: [32 * 32]u32 = undefined;
var logo_canvas: draw.Canvas = .{
    .pixels = @ptrCast(&logo_pix),
    .width = 32,
    .height = 32,
    .stride = 32,
};

fn drawLogo() void {
    const cx = 15;
    const cy = 15;
    draw.olivec_fill(logo_canvas, 0);
    draw.olivec_circle(logo_canvas, cx, cy, 16, silver.toBits());
    draw.olivec_line(logo_canvas, cx, 0, cx, 32, slider_dark.toBits());
    var i: u32 = 3;
    while (i < cy + 2) : (i += 3) {
        const w = i * 2;
        const x = 15 - (w / 2);
        draw.olivec_line(
            logo_canvas,
            @intCast(x),
            @intCast(i),
            @intCast(x + w),
            @intCast(i),
            slider_dark.toBits(),
        );
    }
}
