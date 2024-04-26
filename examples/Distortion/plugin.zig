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

export const plugin_params = &[_]arbor.Parameter{
    arbor.param.create("Gain", .{ 1.0, 12.0, 1.0 }),
};

some_data: i32 = 0,

// this probs shouldn't be static
var arena = std.heap.ArenaAllocator.init(std.heap.c_allocator);
const allocator = arena.allocator();

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
    _ = plugin;
    // only 1 free needed with an arena
    arena.deinit();
}

export fn prepare(plugin: *arbor.Plugin, sample_rate: f32, max_num_frames: u32) void {
    _ = plugin;
    _ = sample_rate;
    _ = max_num_frames;
}

export fn process(plugin: *arbor.Plugin, buffer: arbor.AudioBuffer) void {
    _ = plugin;
    const in = buffer.input;
    var out = buffer.output;

    for (in.ptr[0..buffer.num_ch], 0..) |ch, ch_idx| {
        for (ch[0..buffer.num_samples], 0..) |sample, i| {
            out.ptr[ch_idx][i] = sample * 0.5;
        }
    }
}
