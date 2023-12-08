//! clap_plugin.zig
//! definitions for CLAP plugin

const std = @import("std");
const Plugin = @import("Plugin.zig");
const Params = @import("Params.zig");
const Mutex = std.Thread.Mutex;
const Reverb = @import("zig-dsp/Reverb.zig");
const Gui = @import("Gui.zig");
const ClapGui = @import("gui/clap_gui.zig");

pub const clap = @cImport({
    @cInclude("clap/clap.h");
});

fn plug_cast(ptr: ?*anyopaque) *Self {
    std.debug.assert(ptr != null);
    return @ptrCast(@alignCast(ptr.?));
}
const allocator = std.heap.page_allocator;

pub const PluginDesc = Plugin.Description.format_desc;

const Self = @This();

plugin: *Plugin,

// need a sub-struct to hold clap-specific data
clap_plugin: clap.clap_plugin_t, // this basically owns a pointer to its owner in the form of plugin_data
host: [*c]const clap.clap_host_t,
host_latency: [*c]const clap.clap_host_latency_t,
host_log: ?*const clap.clap_host_log_t,
host_thread_check: [*c]const clap.clap_host_thread_check_t,
host_state: [*c]const clap.clap_host_state_t,
host_params: [*c]const clap.clap_host_params_t,
host_timer_support: [*c]const clap.clap_host_timer_support_t,
timer_id: clap.clap_id,

need_repaint: bool = false,

const AudioPorts = struct {
    fn count(plugin: [*c]const clap.clap_plugin_t, is_input: bool) callconv(.C) u32 {
        _ = is_input;
        _ = plugin;
        return 1;
    }

    fn get(
        plugin: [*c]const clap.clap_plugin_t,
        index: u32,
        is_input: bool,
        info: [*c]clap.clap_audio_port_info_t,
    ) callconv(.C) bool {
        _ = is_input;
        if (index > 1)
            return false;
        info.* = .{
            .id = 0,
            .name = undefined,
            .channel_count = 2,
            .flags = clap.CLAP_AUDIO_PORT_IS_MAIN,
            .port_type = &clap.CLAP_PORT_STEREO,
            .in_place_pair = clap.CLAP_INVALID_ID,
        };
        std.log.defaultLog(.info, .default, "Audio port: {s}", .{info.*.name});
        var plug = plug_cast(plugin.*.plugin_data).plugin;
        plug.numChannels = info.*.channel_count;
        return true;
    }

    const Data = clap.clap_plugin_audio_ports_t{
        .count = count,
        .get = get,
    };
};

const NotePorts = struct {
    fn count(plugin: [*c]const clap.clap_plugin_t, is_input: bool) callconv(.C) u32 {
        _ = is_input;
        _ = plugin;
        return 0;
    }

    fn get(
        plugin: [*c]const clap.clap_plugin_t,
        index: u32,
        is_input: bool,
        info: [*c]clap.clap_note_port_info_t,
    ) callconv(.C) bool {
        _ = is_input;
        _ = plugin;
        if (index > 0)
            return false;
        info.*.id = 0;
        std.log.defaultLog(.info, .default, "Note port: {s}", .{info.*.name});
        info.*.supported_dialects = clap.CLAP_NOTE_DIALECT_MIDI;
        info.*.preferred_dialect = clap.CLAP_NOTE_DIALECT_CLAP;
        return true;
    }

    const Data = clap.clap_plugin_note_ports_t{
        .count = count,
        .get = get,
    };
};

// Latency
pub const Latency = struct {
    fn getLatency(plugin: [*c]const clap.clap_plugin_t) callconv(.C) u32 {
        const plug = plug_cast(plugin.*.plugin_data).plugin;
        return plug.latency;
    }
    const Data = clap.clap_plugin_latency_t{
        .get = getLatency,
    };
};

// state
const State = struct {
    pub fn save(
        plugin: [*c]const clap.clap_plugin_t,
        stream: [*c]const clap.clap_ostream_t,
    ) callconv(.C) bool {
        const plug = plug_cast(plugin.*.plugin_data).plugin;
        const numParams = Params.num_params;
        // PROBLEM: This crashes the plugin!
        return @sizeOf(f32) * numParams == stream.*.write.?(stream, @as(
            [*]f32,
            @ptrCast(&plug.*.params.values),
        ), @sizeOf(f32) * numParams);
    }

    pub fn load(
        plugin: [*c]const clap.clap_plugin_t,
        stream: [*c]const clap.clap_istream_t,
    ) callconv(.C) bool {
        const plug = plug_cast(plugin.*.plugin_data).plugin;
        // var mutex = Mutex{};
        // mutex.lock();
        // defer mutex.unlock();
        const numParams = Params.num_params;
        return @sizeOf(f32) * numParams == stream.*.read.?(stream, @as(
            [*]f32,
            @ptrCast(&plug.params.values),
        ), @sizeOf(f32) * numParams);
    }

    const Data = clap.clap_plugin_state_t{
        .save = save,
        .load = load,
    };
};

// Timer
const Timer = struct {
    fn onTimer(plugin: [*c]const clap.clap_plugin_t, timerID: clap.clap_id) callconv(.C) void {
        _ = timerID;
        var self = plug_cast(plugin.*.plugin_data);
        var plug = self.plugin;

        // currently just infinitely repainting...
        // MAYBE: we should check if a repaint is needed
        // so that means moving the interaction logic to here
        // BUT: It doesn't work! Never gets a gesture
        if (plug.gui != null) {
            plug.gui.?.render();
            // self.need_repaint = false;
        }
    }

    pub const Data = clap.clap_plugin_timer_support_t{
        .on_timer = onTimer,
    };
};

pub fn init(plugin: [*c]const clap.clap_plugin) callconv(.C) bool {
    var c_plug = plug_cast(plugin.*.plugin_data);

    {
        var ptr = c_plug.*.host.*.get_extension.?(c_plug.*.host, &clap.CLAP_EXT_LOG);
        if (ptr != null)
            c_plug.*.host_log = @ptrCast(@alignCast(ptr));
    }
    {
        var ptr = c_plug.*.host.*.get_extension.?(c_plug.*.host, &clap.CLAP_EXT_THREAD_CHECK);
        if (ptr != null)
            c_plug.*.host_thread_check = @ptrCast(@alignCast(ptr));
    }
    {
        var ptr = c_plug.*.host.*.get_extension.?(c_plug.*.host, &clap.CLAP_EXT_LATENCY);
        if (ptr != null)
            c_plug.*.host_latency = @ptrCast(@alignCast(ptr));
    }
    {
        var ptr = c_plug.*.host.*.get_extension.?(c_plug.*.host, &clap.CLAP_EXT_STATE);
        if (ptr != null)
            c_plug.*.host_state = @ptrCast(@alignCast(ptr));
    }
    {
        var ptr = c_plug.*.host.*.get_extension.?(c_plug.*.host, &clap.CLAP_EXT_PARAMS);
        if (ptr != null) {
            c_plug.*.host_params = @ptrCast(@alignCast(ptr));
        }
    }
    {
        var ptr = c_plug.*.host.*.get_extension.?(c_plug.*.host, &clap.CLAP_EXT_TIMER_SUPPORT);
        if (ptr != null) {
            c_plug.*.host_timer_support = @ptrCast(@alignCast(ptr));
            if (c_plug.*.host_timer_support.*.unregister_timer != null)
                _ = c_plug.*.host_timer_support.*.register_timer.?(c_plug.*.host, 16, &c_plug.*.timer_id);
        }
    }
    return true;
}

pub fn destroy(plugin: [*c]const clap.clap_plugin) callconv(.C) void {
    var self = plug_cast(plugin.*.plugin_data);
    if (self.*.host_timer_support != null and self.*.host_timer_support.*.unregister_timer != null)
        _ = self.*.host_timer_support.*.unregister_timer.?(self.*.host, self.*.timer_id);
    self.plugin.deinit(allocator);
    allocator.destroy(self);
}

pub fn activate(
    plugin: [*c]const clap.clap_plugin,
    sample_rate: f64,
    min_frames_count: u32,
    max_frames_count: u32,
) callconv(.C) bool {
    var plug = plug_cast(plugin.*.plugin_data).plugin;
    plug.prepare(allocator, sample_rate, max_frames_count) catch unreachable;
    _ = min_frames_count;
    return true;
}

pub fn deactivate(plugin: [*c]const clap.clap_plugin) callconv(.C) void {
    _ = plugin;
}
pub fn startProcessing(plugin: [*c]const clap.clap_plugin) callconv(.C) bool {
    _ = plugin;
    return true;
}
pub fn stopProcessing(plugin: [*c]const clap.clap_plugin) callconv(.C) void {
    _ = plugin;
}
pub fn reset(plugin: [*c]const clap.clap_plugin) callconv(.C) void {
    _ = plugin;
}

pub fn processEvent(self: *Self, event: [*c]const clap.clap_event_header_t) callconv(.C) void {
    _ = event;
    _ = self;
    // if (event.*.space_id == clap.CLAP_CORE_EVENT_SPACE_ID) {
    //     if (event.*.type == clap.CLAP_EVENT_PARAM_VALUE) {
    //         const valueEvent = @as([*c]const clap.clap_event_param_value_t, @ptrCast(@alignCast(event)));
    //         self.plugin.params.setValue(valueEvent.*.param_id, valueEvent.*.value);
    //         Plugin.parameter_changed[valueEvent.*.param_id] = true;
    //         self.plugin.onParamChange(valueEvent.*.param_id);
    //         self.need_repaint = true;
    //     }
    // }
}

pub fn process(
    plugin: [*c]const clap.clap_plugin,
    process_info: ?*const clap.clap_process_t,
) callconv(.C) clap.clap_process_status {
    var self = plug_cast(plugin.*.plugin_data);
    var plug = self.plugin;
    const num_frames = process_info.?.frames_count;
    const num_events = process_info.?.in_events.*.size.?(process_info.?.in_events);
    var event_index: u32 = 0;
    var next_event_frame: u32 = if (num_events > 0) 0 else num_frames;

    var i: u32 = 0;
    for (0..num_frames) |_| {
        // handle all events at frame i
        while (event_index < num_events and next_event_frame == i) {
            const header = process_info.?.in_events.*.get.?(process_info.?.in_events, event_index);
            if (header.*.time != i) {
                next_event_frame = header.*.time;
                break;
            }

            self.processEvent(header);
            event_index += 1;

            if (event_index == num_events) {
                // end of event list
                next_event_frame = num_frames;
            }
        }

        // TODO: Instead of an array, just copy the pointers to a double multi-ptr
        var in = [_][*]f32{
            process_info.?.audio_inputs[0].data32[0],
            process_info.?.audio_inputs[0].data32[1],
        };
        var out = [_][*]f32{
            process_info.?.audio_outputs[0].data32[0],
            process_info.?.audio_outputs[0].data32[1],
        };
        // process audio in frame
        for (i..next_event_frame) |_| {
            const frames_to_process = next_event_frame - i;
            plug.processAudio(&in, &out, frames_to_process);
            i += frames_to_process;
        }
    }
    return clap.CLAP_PROCESS_CONTINUE;
}

pub fn getExtension(plugin: [*c]const clap.clap_plugin, id: [*c]const u8) callconv(.C) ?*const anyopaque {
    _ = plugin;
    if (std.mem.orderZ(u8, id, &clap.CLAP_EXT_LATENCY).compare(.eq))
        return &Latency.Data;
    if (std.mem.orderZ(u8, id, &clap.CLAP_EXT_AUDIO_PORTS).compare(.eq))
        return &AudioPorts.Data;
    if (std.mem.orderZ(u8, id, &clap.CLAP_EXT_NOTE_PORTS).compare(.eq))
        return &NotePorts.Data;
    if (std.mem.orderZ(u8, id, &clap.CLAP_EXT_STATE).compare(.eq))
        return &State.Data;
    if (std.mem.orderZ(u8, id, &clap.CLAP_EXT_PARAMS).compare(.eq))
        return &Params.Data;
    if (std.mem.orderZ(u8, id, &clap.CLAP_EXT_GUI).compare(.eq))
        return &ClapGui.Data;
    if (std.mem.orderZ(u8, id, &clap.CLAP_EXT_TIMER_SUPPORT).compare(.eq))
        return &Timer.Data;
    // if (std.cstr.cmp(id, &clap.CLAP_EXT_POSIX_FD_SUPPORT) == 0)
    //     return &Gui.PosixFDSupport.Data;
    return null;
}

pub fn onMainThread(plugin: [*c]const clap.clap_plugin) callconv(.C) void {
    _ = plugin;
}

// Factory
const Factory = struct {
    fn getPluginCount(factory: [*c]const clap.clap_plugin_factory) callconv(.C) u32 {
        _ = factory;
        return 1;
    }

    fn getPluginDescriptor(
        factory: [*c]const clap.clap_plugin_factory,
        index: u32,
    ) callconv(.C) [*c]const clap.clap_plugin_descriptor_t {
        _ = factory;
        return if (index == 0) &PluginDesc else null;
    }

    fn createPlugin(
        factory: [*c]const clap.clap_plugin_factory,
        host: [*c]const clap.clap_host_t,
        plugin_id: [*c]const u8,
    ) callconv(.C) [*c]const clap.clap_plugin_t {
        _ = factory;
        if (host.*.clap_version.major < 1)
            return null;
        if (std.mem.orderZ(u8, plugin_id, PluginDesc.id).compare(.eq)) {
            var c_plugin = allocator.create(Self) catch |e| {
                std.log.err("{}\n", .{e});
                std.process.exit(1);
            };
            c_plugin.* = .{
                .plugin = Plugin.init(allocator),
                .clap_plugin = .{
                    .desc = &PluginDesc,
                    .plugin_data = c_plugin,
                    .init = init,
                    .destroy = destroy,
                    .activate = activate,
                    .deactivate = deactivate,
                    .start_processing = startProcessing,
                    .stop_processing = stopProcessing,
                    .reset = reset,
                    .process = process,
                    .get_extension = getExtension,
                    .on_main_thread = onMainThread,
                },
                .host = host,
                .host_params = null,
                .host_state = null,
                .host_latency = null,
                .host_log = null,
                .host_thread_check = null,
                .host_timer_support = null,
                .timer_id = undefined,
            };
            return &c_plugin.clap_plugin;
        }
        return null;
    }

    const Data = clap.clap_plugin_factory_t{
        .get_plugin_count = Factory.getPluginCount,
        .get_plugin_descriptor = Factory.getPluginDescriptor,
        .create_plugin = Factory.createPlugin,
    };
};

// Entry
const Entry = struct {
    fn init(plugin_path: [*c]const u8) callconv(.C) bool {
        _ = plugin_path;

        return true;
    }

    fn deinit() callconv(.C) void {}

    fn get_factory(factory_id: [*c]const u8) callconv(.C) ?*const anyopaque {
        if (std.mem.orderZ(u8, factory_id, &clap.CLAP_PLUGIN_FACTORY_ID).compare(.eq)) {
            return &Factory.Data;
        }
        return null;
    }
};

export const clap_entry = clap.clap_plugin_entry_t{
    .clap_version = clap.clap_version_t{
        .major = clap.CLAP_VERSION_MAJOR,
        .minor = clap.CLAP_VERSION_MINOR,
        .revision = clap.CLAP_VERSION_REVISION,
    },
    .init = &Entry.init,
    .deinit = &Entry.deinit,
    .get_factory = &Entry.get_factory,
};
