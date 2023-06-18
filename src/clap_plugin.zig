//! clap_plugin.zig
//! definitions for CLAP plugin

const std = @import("std");
const Plugin = @import("Plugin.zig");
const Params = @import("Params.zig");
const Mutex = std.Thread.Mutex;
const Reverb = @import("zig-dsp/Reverb.zig");
const Gui = @import("gui/Gui.zig");
const ClapGui = @import("gui/clap_gui.zig");
const rl = ClapGui.rl;

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
pub var allocator: std.mem.Allocator = gpa.allocator();

pub const clap = @cImport({
    @cInclude("clap/clap.h");
});

const c_cast = std.zig.c_translation.cast;

pub const PluginDesc = clap.clap_plugin_descriptor_t{
    .clap_version = clap.clap_version_t{
        .major = clap.CLAP_VERSION_MAJOR,
        .minor = clap.CLAP_VERSION_MINOR,
        .revision = clap.CLAP_VERSION_REVISION,
    },
    .id = "com.ArborealAudio.clap",
    .name = Plugin.Description.plugin_name,
    .vendor = Plugin.Description.vendor_name,
    .url = Plugin.Description.url,
    .manual_url = "",
    .support_url = "",
    .version = Plugin.Description.version,
    .description = "Vintage analog warmth",
    .features = &[_][*c]const u8{ "stereo", "audio-effect", null },
};

const ClapPlugin = @This();
var plug = Plugin{};

plugin: clap.clap_plugin_t,

host: [*c]const clap.clap_host_t,
host_latency: [*c]const clap.clap_host_latency_t,
host_log: ?*const clap.clap_host_log_t,
host_thread_check: [*c]const clap.clap_host_thread_check_t,
host_state: [*c]const clap.clap_host_state_t,
host_params: [*c]const clap.clap_host_params_t,
host_timer_support: [*c]const clap.clap_host_timer_support_t,
timerID: clap.clap_id,

const AudioPorts = struct {
    fn count(plugin: [*c]const clap.clap_plugin_t, is_input: bool) callconv(.C) u32 {
        _ = is_input;
        _ = plugin;
        return 1;
    }

    fn get(plugin: [*c]const clap.clap_plugin_t, index: u32, is_input: bool, info: [*c]clap.clap_audio_port_info_t) callconv(.C) bool {
        _ = plugin;
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
        std.log.defaultLog(.info, .default, "Port name: {s}", .{info.*.name});
        // var plug = c_cast(*ClapPlugin, plugin.*.plugin_data);
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

    fn get(plugin: [*c]const clap.clap_plugin_t, index: u32, is_input: bool, info: [*c]clap.clap_note_port_info_t) callconv(.C) bool {
        _ = is_input;
        _ = plugin;
        if (index > 0)
            return false;
        info.*.id = 0;
        std.log.defaultLog(.info, .default, "Port name: {s}", .{info.*.name});
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
        _ = plugin;
        // const plug = c_cast(*ClapPlugin, plugin.*.plugin_data);
        return plug.latency;
    }
    const Data = clap.clap_plugin_latency_t{
        .get = getLatency,
    };
};

// state
const State = struct {
    pub fn save(plugin: [*c]const clap.clap_plugin_t, stream: [*c]const clap.clap_ostream_t) callconv(.C) bool {
        _ = plugin;
        _ = stream;
        // const plug = c_cast(*ClapPlugin, plugin.*.plugin_data);
        const numParams = plug.params.numParams;
        _ = numParams;
        // PROBLEM: This crashes the plugin!
        // return @sizeOf(f32) * numParams == stream.*.write.?(stream, c_cast([*c]const f32, &plug.*.params), @sizeOf(f32) * numParams);
        return true;
    }

    pub fn load(plugin: [*c]const clap.clap_plugin_t, stream: [*c]const clap.clap_istream_t) callconv(.C) bool {
        _ = plugin;
        // const plug = c_cast(*ClapPlugin, plugin.*.plugin_data);
        var mutex = Mutex{};
        mutex.lock();
        defer mutex.unlock();
        const numParams = plug.params.numParams;
        return @sizeOf(f32) * numParams == stream.*.read.?(stream, c_cast([*c]f32, &plug.params), @sizeOf(f32) * numParams);
    }

    const Data = clap.clap_plugin_state_t{
        .save = save,
        .load = load,
    };
};

// Timer
const Timer = struct {
    fn onTimer(plugin: [*c]const clap.clap_plugin_t, timerID: clap.clap_id) callconv(.C) void {
        _ = plugin;
        _ = timerID;
        // var plug = c_cast(*ClapPlugin, plugin.*.plugin_data);

        if (rl.IsGestureDetected(rl.GESTURE_DRAG)) {
            const vec = rl.GetMouseDelta();
            const p_val = plug.params.values.mix;
            const n_val = @min(1.0, @max(0.0, p_val + @floatCast(f64, -vec.y * 0.01)));
            plug.params.setValue(0, n_val);
        }

        // currently just infinitely repainting...
        // MAYBE: we should check if a repaint is needed
        if (!rl.WindowShouldClose())
            Gui.render(&plug);
    }

    pub const Data = clap.clap_plugin_timer_support_t{
        .on_timer = onTimer,
    };
};

pub fn init(plugin: [*c]const clap.clap_plugin) callconv(.C) bool {
    var c_plug = c_cast(*ClapPlugin, plugin.*.plugin_data);

    {
        var ptr = c_plug.*.host.*.get_extension.?(c_plug.*.host, &clap.CLAP_EXT_LOG);
        if (ptr != null)
            c_plug.*.host_log = c_cast(*const clap.clap_host_log_t, ptr);
    }
    {
        var ptr = c_plug.*.host.*.get_extension.?(c_plug.*.host, &clap.CLAP_EXT_THREAD_CHECK);
        if (ptr != null)
            c_plug.*.host_thread_check = c_cast(*const clap.clap_host_thread_check_t, ptr);
    }
    {
        var ptr = c_plug.*.host.*.get_extension.?(c_plug.*.host, &clap.CLAP_EXT_LATENCY);
        if (ptr != null)
            c_plug.*.host_latency = c_cast(*const clap.clap_host_latency_t, ptr);
    }
    {
        var ptr = c_plug.*.host.*.get_extension.?(c_plug.*.host, &clap.CLAP_EXT_STATE);
        if (ptr != null)
            c_plug.*.host_state = c_cast(*const clap.clap_host_state_t, ptr);
    }
    {
        var ptr = c_plug.*.host.*.get_extension.?(c_plug.*.host, &clap.CLAP_EXT_PARAMS);
        if (ptr != null) {
            c_plug.*.host_params = c_cast(*const clap.clap_host_params_t, ptr);
        }
    }
    {
        var ptr = c_plug.*.host.*.get_extension.?(c_plug.*.host, &clap.CLAP_EXT_TIMER_SUPPORT);
        if (ptr != null) {
            c_plug.*.host_timer_support = c_cast(*const clap.clap_host_timer_support_t, ptr);
            _ = c_plug.*.host_timer_support.*.register_timer.?(c_plug.*.host, 16, &c_plug.*.timerID);
        }
    }
    return true;
}

pub fn destroy(plugin: [*c]const clap.clap_plugin) callconv(.C) void {
    defer _ = gpa.deinit();
    var c_plug = c_cast(*ClapPlugin, plugin.*.plugin_data);
    // if (plug.*.host_timer_support != null and plug.*.host_timer_support.*.unregister_timer != null)
    _ = c_plug.*.host_timer_support.*.unregister_timer.?(c_plug.*.host, c_plug.*.timerID);
    allocator.destroy(c_plug);
}

pub fn activate(plugin: [*c]const clap.clap_plugin, sample_rate: f64, min_frames_count: u32, max_frames_count: u32) callconv(.C) bool {
    _ = plugin;
    plug.init(allocator, sample_rate, max_frames_count) catch unreachable;
    // var plug = c_cast(*ClapPlugin, plugin.*.plugin_data);
    // plug.sampleRate = sample_rate;
    // plug.maxNumSamples = max_frames_count;
    // plug.reverb.init(allocator, plug.sampleRate, 0.125 * @floatCast(f32, plug.sampleRate)) catch unreachable;
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

pub fn processEvent(plugin: *ClapPlugin, event: [*c]const clap.clap_event_header_t) callconv(.C) void {
    _ = plugin;
    if (event.*.space_id == clap.CLAP_CORE_EVENT_SPACE_ID) {
        if (event.*.type == clap.CLAP_EVENT_PARAM_VALUE) {
            const valueEvent = c_cast([*c]const clap.clap_event_param_value_t, event);
            plug.params.setValue(valueEvent.*.param_id, valueEvent.*.value);
        }
    }
}

pub fn process(plugin: [*c]const clap.clap_plugin, processInfo: [*c]const clap.clap_process_t) callconv(.C) clap.clap_process_status {
    var c_plug = c_cast(*ClapPlugin, plugin.*.plugin_data);
    const numFrames = processInfo.*.frames_count;
    const numEvents = processInfo.*.in_events.*.size.?(processInfo.*.in_events);
    var eventIndex: u32 = 0;
    var nextEventFrame: u32 = if (numEvents > 0) 0 else numFrames;

    var i: u32 = 0;
    while (i < numFrames) {
        // handle all events at frame i
        while (eventIndex < numEvents and nextEventFrame == i) {
            const header = processInfo.*.in_events.*.get.?(processInfo.*.in_events, eventIndex);
            if (header.*.time != i) {
                nextEventFrame = header.*.time;
                break;
            }

            processEvent(c_plug, header);
            eventIndex += 1;

            if (eventIndex == numEvents) {
                // end of event list
                nextEventFrame = numFrames;
            }
        }

        const in = [_][*]f32{ processInfo.*.audio_inputs[0].data32[0], processInfo.*.audio_inputs[0].data32[1] };
        const out = [_][*]f32{ processInfo.*.audio_outputs[0].data32[0], processInfo.*.audio_outputs[0].data32[1] };
        // process audio in frame
        while (i < nextEventFrame) {
            const frames_to_process = nextEventFrame - i;
            plug.processAudio(in, out, frames_to_process);
            i += frames_to_process;
        }
    }
    return clap.CLAP_PROCESS_CONTINUE;
}

pub fn getExtension(plugin: [*c]const clap.clap_plugin, id: [*c]const u8) callconv(.C) ?*const anyopaque {
    _ = plugin;
    if (std.cstr.cmp(id, &clap.CLAP_EXT_LATENCY) == 0)
        return &Latency.Data;
    if (std.cstr.cmp(id, &clap.CLAP_EXT_AUDIO_PORTS) == 0)
        return &AudioPorts.Data;
    if (std.cstr.cmp(id, &clap.CLAP_EXT_NOTE_PORTS) == 0)
        return &NotePorts.Data;
    if (std.cstr.cmp(id, &clap.CLAP_EXT_STATE) == 0)
        return &State.Data;
    if (std.cstr.cmp(id, &clap.CLAP_EXT_PARAMS) == 0)
        return &Params.Data;
    if (std.cstr.cmp(id, &clap.CLAP_EXT_GUI) == 0)
        return &ClapGui.Data;
    if (std.cstr.cmp(id, &clap.CLAP_EXT_TIMER_SUPPORT) == 0)
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

    fn getPluginDescriptor(factory: [*c]const clap.clap_plugin_factory, index: u32) callconv(.C) [*c]const clap.clap_plugin_descriptor_t {
        _ = factory;
        return if (index == 0) &PluginDesc else null;
    }

    fn createPlugin(factory: [*c]const clap.clap_plugin_factory, host: [*c]const clap.clap_host_t, plugin_id: [*c]const u8) callconv(.C) [*c]const clap.clap_plugin_t {
        _ = factory;
        if (host.*.clap_version.major < 1)
            return null;
        if (std.cstr.cmp(plugin_id, PluginDesc.id) == 0) {
            var c_plugin = allocator.create(ClapPlugin) catch unreachable;
            c_plugin.* = .{
                .plugin = .{
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
                .timerID = undefined,
            };
            return &c_plugin.plugin;
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
        if (std.cstr.cmp(factory_id, &clap.CLAP_PLUGIN_FACTORY_ID) == 0) {
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
