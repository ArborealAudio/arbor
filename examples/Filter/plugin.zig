const std = @import("std");
const arbor = @import("arbor");
const param = arbor.param;
const log = arbor.log;
const dsp = arbor.dsp;

const Filter = @This();

const params = &[_]arbor.Parameter{
    param.Float("Freq", 20, 18e3, 1500, .{ .flags = .{} }),
};

const allocator = std.heap.c_allocator;

filter: dsp.Filter,
last_cutoff: f32,

export fn init() *arbor.Plugin {
    const self = allocator.create(Filter) catch |e| {
        log.fatal("{!}\n", .{e}, @src());
    };
    self.* = .{
        .filter = dsp.Filter.init(
            allocator,
            2,
            .FirstOrderLowpass,
            params[0].default_value,
            std.math.sqrt1_2,
        ) catch |e| log.fatal("{!}\n", .{e}, @src()),
        .last_cutoff = params[0].default_value,
    };
    const plugin = arbor.init(allocator, params, .{
        .deinit = deinit,
        .prepare = prepare,
        .process = process,
    });
    plugin.user = self;
    return plugin;
}

fn deinit(plugin: *arbor.Plugin) void {
    // Free your user data
    const self = plugin.getUser(Filter);
    self.filter.deinit();
    allocator.destroy(self);
}

fn prepare(plugin: *arbor.Plugin, sample_rate: f32, max_frames: u32) void {
    plugin.sample_rate = sample_rate;
    plugin.max_frames = max_frames;
    const self = plugin.getUser(Filter);
    self.filter.setSampleRate(sample_rate);
}

fn process(plugin: *arbor.Plugin, buffer: arbor.AudioBuffer(f32)) void {
    const self = plugin.getUser(Filter);
    const cutoff = plugin.getParamValue(f32, "Freq");
    if (self.last_cutoff != cutoff) {
        // TODO: Param smoothing
        self.filter.setCutoff(cutoff, plugin.sample_rate);
        self.last_cutoff = cutoff;
    }

    self.filter.process(buffer.input, buffer.output);
}
