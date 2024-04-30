const std = @import("std");
const arbor = @import("arbor");
const param = arbor.param;
const log = arbor.log;

const Distortion = @This();

export const plugin_desc = arbor.createFormatDescription(.{
    .id = "com.ArborealAudio.ZigVerb",
    .name = "Example Distortion",
    .company = "Arboreal Audio",
    .version = "0.1",
    .url = "https://arborealaudio.com",
    .contact = "contact@arborealaudio.com",
    .manual = "https://manuals.arborealaudio.com/Distortion",
    .description = "Basic distortion plugin",
});

const Mode = enum {
    Vintage,
    Modern,
    Apocalypse,
};

const plugin_params = &[_]arbor.Parameter{
    param.create("Gain", .{ 1.0, 30.0, 1.0 }),
    param.create("Out", .{ 0.0, 12.0, 1.0 }),
    // TODO: Read enum fields by default. Passing a list of choices should be optional
    param.create("Mode", .{ Mode.Vintage, &.{ "Vintage", "Modern", "Apocalypse" } }),
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
    // Free your plugin if we set one
    if (plugin.user) |p| {
        const self = arbor.cast(*Distortion, p);
        plugin.allocator.destroy(self);
    }
    // Deinit the outer plugin like this
    arbor.deinit(plugin);
}

fn prepare(plugin: *arbor.Plugin, sample_rate: f32, max_num_frames: u32) void {
    _ = plugin;
    _ = sample_rate;
    _ = max_num_frames;
}

fn process(plugin: *arbor.Plugin, buffer: arbor.AudioBuffer(f32)) void {
    const in_gain = plugin.getParamValue(f32, "Gain");
    const out_gain = plugin.getParamValue(f32, "Out");
    const mode = plugin.getParamValue(Mode, "Mode");

    const start = buffer.offset;
    const end = buffer.offset + buffer.frames;

    for (buffer.input[0..buffer.num_ch], 0..) |ch, ch_idx| {
        var out = buffer.output[ch_idx];
        for (ch[start..end], start..) |sample, idx| {
            // You wouldn't want to branch inside this loop, but...example
            switch (mode) {
                .Modern => {
                    out[idx] = (3.0 / 2.0) * std.math.tanh(in_gain * sample) * out_gain;
                },
                .Vintage => {
                    var x = sample;
                    x *= in_gain;
                    if (x > 0) {
                        x = @min(1, x);
                        x = (3.0 / 2.0) * (x - (x * x * x) / 3.0);
                    } else x = (3.0 / 2.0) * std.math.tanh(x);
                    x *= out_gain;
                    out[idx] = x;
                },
                .Apocalypse => {
                    var x = sample;
                    x *= in_gain;
                    x = @abs(x);
                    x *= out_gain;
                    out[idx] = x;
                },
            }
        }
    }
}

const draw = arbor.Gui.draw;

pub const WIDTH = 500;
pub const HEIGHT = 600;
const background_color = draw.Color{ .r = 0, .g = 0x80, .b = 0x80, .a = 0xff };
const border_color = draw.Color{ .r = 0xc0, .g = 0xf0, .b = 0xc0, .a = 0xff };

// Since we passed a pointer to our outer struct, the user ptr will refer to it
export fn gui_init(plugin: *arbor.Plugin) void {
    const gui = arbor.Gui.init(plugin, allocator, WIDTH, HEIGHT);
    plugin.gui = gui;

    // TODO: Allow the user to describe layout in more relative terms rather
    // than computing based on window size, etc.
    const slider_width = (WIDTH / plugin_params.len) / 2;
    const gap = WIDTH / 8;
    // create pointers, assign IDs and values
    // this is how the components get "attached" to parameters
    // setup unique properties here
    for (0..plugin_params.len) |i| {
        const param_info = plugin.getParamId(@intCast(i)) catch |e| {
            log.err("{}\n", .{e});
            return;
        };
        gui.addComponent(.{
            .canvas = gui.canvas,
            .id = @intCast(i),
            .draw_proc = arbor.Gui.Component.draw_slider,
            .value = param_info.getNormalizedValue(plugin.params[i]),
            .pos = .{
                .x = @floatFromInt(i * slider_width + gap * (i + 1)),
                .y = HEIGHT / 2 - 100,
            },
            .width = @as(f32, @floatFromInt(slider_width)),
            .height = 200,
            .fill_color = (draw.Color{ .a = 0xff, .r = 0xcc, .g = 0xcc, .b = 0xcc }).bits(),
            .border_color = (draw.Color{ .a = 0xff, .g = 0x70, .r = 0, .b = 0x70 }).bits(),
            .label = .{
                .text = param_info.name,
                .height = 18,
                .color = 0xffffffff,
                .border = (draw.Color{ .a = 0xff, .r = 0xcc, .g = 0xcc, .b = 0xcc }).bits(),
                .flags = .{
                    .border = true,
                    .center_x = true,
                    .center_y = false,
                },
            },
        });
    }
}

export fn gui_deinit(plugin: *arbor.Plugin) void {
    if (plugin.gui) |gui| gui.deinit();
}

fn poll_event(plugin: *arbor.Plugin) void {
    const gui = plugin.gui orelse {
        log.err("Gui is null\n", .{});
        return;
    };

    while (gui.nextEvent()) |event| {
        switch (event) {
            .drag => |drag| {
                // get parameter value of component under mouse
                const param_info = plugin.getParamId(@intCast(drag.id)) catch |e| {
                    log.err("{}\n", .{e});
                    return;
                };
                var p_val = param_info.getNormalizedValue(plugin.params[drag.id]);
                p_val += -drag.mouse_delta.y * 0.025;
                p_val = @min(1, @max(0, p_val));
                // change parameter
                // TODO: Figure out a better way to sync GUI values & param values.
                // PRobably via a two-way event system
                // WE're currently "hard-syncing" by reading the direct param
                // values here
                plugin.params[drag.id] = param_info.valueFromNormalized(p_val);
                const component = gui.getComponent(drag.id);
                component.setValue(p_val);
            },
            else => {},
        }
    }
}

export fn gui_render(plugin: *arbor.Plugin) void {
    if (plugin.gui) |gui| {
        poll_event(plugin);
        draw.olivec_fill(gui.canvas, background_color.bits());
        draw.olivec_frame(gui.canvas, 2, 2, WIDTH - 4, HEIGHT - 4, 4, border_color.bits());

        for (gui.components.items) |c| {
            c.draw_proc(c);
        }
    }
}
