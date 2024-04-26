const std = @import("std");
const arbor = @import("arbor");
const log = arbor.log;

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
};

const plugin_params = &[_]arbor.Parameter{
    arbor.param.create("Gain", .{ 1.0, 30.0, 1.0 }),
    arbor.param.create("Out", .{ 0.0, 12.0, 1.0 }),
    arbor.param.create("Mode", .{Mode.Vintage}),
};

some_data: i32 = 0,

const allocator = std.heap.c_allocator;

export fn init() *arbor.Plugin {
    const plugin = arbor.configure(allocator, plugin_params);
    // create a user plugin since we have some data of our own
    const user_plugin = allocator.create(@This()) catch |e|
        log.fatal("Plugin create failed: {}\n", .{e});
    user_plugin.* = .{}; // initialize
    // set the pointer
    plugin.user = user_plugin;

    return plugin;
}

export fn deinit(plugin: *arbor.Plugin) void {
    if (plugin.user) |p|
        allocator.destroy(@as(*@This(), @ptrCast(@alignCast(p))));
    allocator.destroy(plugin);
}

export fn prepare(plugin: *arbor.Plugin, sample_rate: f32, max_num_frames: u32) void {
    _ = plugin;
    _ = sample_rate;
    _ = max_num_frames;
}

export fn process(plugin: *arbor.Plugin, buffer: arbor.AudioBuffer) void {
    const in_gain = plugin.params[0];
    const out_gain = plugin.params[1];

    const mode: Mode = @enumFromInt(@as(u32, @intFromFloat(@round(plugin.params[2]))));

    for (buffer.input[0..buffer.num_ch], 0..) |ch, ch_idx| {
        for (ch[0..buffer.num_samples], 0..) |sample, idx| {
            if (mode == .Modern) {
                buffer.output[ch_idx][idx] = std.math.tanh(in_gain * sample) * out_gain;
            } else {
                var x = sample;
                x *= in_gain;
                if (x > 0) {
                    x = @min(1, x);
                    x = (3 / 2) * (x - (x * x * x) / 3);
                } else x = (3 / 2) * std.math.tanh(x);
                x *= out_gain;
                buffer.output[ch_idx][idx] = x;
            }
        }
    }
}