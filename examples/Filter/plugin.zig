const std = @import("std");
const arbor = @import("arbor");
const param = arbor.param;
const log = arbor.log;
const dsp = arbor.dsp;

const default_cutoff = 1500;
const default_q = std.math.sqrt1_2;

const Filter = struct {
    filter: dsp.Filter,
    last_cutoff: f32,
    last_q: f32,
    params: []const arbor.Parameter = &.{
        param.Float("Freq", 20, 18e3, default_cutoff, .{}),
        param.Float("Q", 0.1, 4, default_q, .{}),
    },
};

// const params = &[_]arbor.Parameter{
//     param.Float("Freq", 20, 18e3, 1500, .{ .flags = .{} }),
// };

const allocator = std.heap.c_allocator;
const num_channels = 2;

export fn init() *arbor.Plugin {
    const self = allocator.create(Filter) catch |e| {
        log.fatal("{t}\n", .{e}, @src());
    };
    self.* = .{
        .filter = dsp.Filter.init(
            allocator,
            num_channels,
            .Lowpass,
            default_cutoff,
            default_q,
        ) catch |e| log.fatal("{t}\n", .{e}, @src()),
        .last_cutoff = default_cutoff,
        .last_q = default_q,
    };
    return arbor.createPlugin(.{
        .allocator = allocator,
        .num_inputs = num_channels,
        .num_outputs = num_channels,
        .params = self.params,
        .interface = .{
            .deinit = deinit,
            .prepare = prepare,
            .process = process,
        },
        .user_data = self,
    });
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
    const q = plugin.getParamValue(f32, "Q");
    if (self.last_cutoff != cutoff) {
        // TODO: Param smoothing
        self.filter.setCutoff(cutoff, plugin.sample_rate);
        self.last_cutoff = cutoff;
    }

    if (self.last_q != q) {
        self.filter.setReso(q, plugin.sample_rate);
        self.last_q = q;
    }

    self.filter.process(buffer);
}
