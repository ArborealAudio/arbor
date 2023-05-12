//! Plugin.zig
//! starting point for our plugin

const std = @import("std");
const Params = @import("Params.zig");
const Mutex = std.Thread.Mutex;
const Reverb = @import("zig-dsp/Reverb.zig");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};

pub const clap = @cImport({
    @cInclude("clap/clap.h");
});

const c_cast = std.zig.c_translation.cast;

const PluginDesc = clap.clap_plugin_descriptor_t{
    .clap_version = clap.clap_version_t{
        .major = clap.CLAP_VERSION_MAJOR,
        .minor = clap.CLAP_VERSION_MINOR,
        .revision = clap.CLAP_VERSION_REVISION,
    },
    .id = "com.ArborealAudio.clap",
    .name = "CLAP-raw",
    .vendor = "Arboreal Audio",
    .url = "https://arborealaudio.com",
    .manual_url = "",
    .support_url = "",
    .version = "0.1",
    .description = "Vintage analog warmth",
    .features = &[_][*c]const u8{ "stereo", "audio-effect", null },
};

const Plugin = @This();

plugin: clap.clap_plugin_t,

host: [*c]const clap.clap_host_t,
host_latency: [*c]const clap.clap_host_latency_t,
host_log: ?*const clap.clap_host_log_t,
host_thread_check: [*c]const clap.clap_host_thread_check_t,
host_state: [*c]const clap.clap_host_state_t,
host_params: [*c]const clap.clap_host_params_t,

params: Params = Params{},

reverb: Reverb,

sampleRate: f64,
numChannels: u32,
maxNumSamples: u32,

latency: u32,

// pub fn syncMainToAudio(plugin: *Plugin, out: [*c]const clap.clap_output_events_t) void {
//     var mutex = Mutex{};
//     mutex.lock();
//     defer mutex.unlock();

//     var i: u32 = 0;
//     while (i < P_COUNT) : (i += 1) {
//         if (plugin.gestureStart[i]) {
//             plugin.gestureStart[i] = false;
//             var event: clap.clap_event_param_gesture_t = undefined;
//             event.header.size = @sizeOf(clap.clap_event_param_gesture_t);
//             event.header.time = 0;
//             event.header.space_id = clap.CLAP_CORE_EVENT_SPACE_ID;
//             event.header.type = clap.CLAP_EVENT_PARAM_GESTURE_BEGIN;
//             event.header.flags = 0;
//             event.param_id = i;
//             _ = out.*.try_push.?(out, &event.header);
//         }
//         if (plugin.mainChanged[i]) {
//             plugin.parameters[i] = plugin.mainParameters[i];
//             plugin.mainChanged[i] = false;

//             var event: clap.clap_event_param_value_t = undefined;
//             event.header.size = @sizeOf(clap.clap_event_param_value_t);
//             event.header.time = 0;
//             event.header.space_id = clap.CLAP_CORE_EVENT_SPACE_ID;
//             event.header.type = clap.CLAP_EVENT_PARAM_VALUE;
//             event.header.flags = 0;
//             event.param_id = i;
//             event.cookie = null;
//             event.note_id = -1;
//             event.port_index = -1;
//             event.channel = -1;
//             event.key = -1;
//             event.value = plugin.parameters[i];
//             _ = out.*.try_push.?(out, &event.header);
//         }
//         if (plugin.gestureEnd[i]) {
//             plugin.gestureEnd[i] = false;
//             var event: clap.clap_event_param_gesture_t = undefined;
//             event.header.size = @sizeOf(clap.clap_event_param_gesture_t);
//             event.header.time = 0;
//             event.header.space_id = clap.CLAP_CORE_EVENT_SPACE_ID;
//             event.header.type = clap.CLAP_EVENT_PARAM_GESTURE_END;
//             event.header.flags = 0;
//             event.param_id = i;
//             _ = out.*.try_push.?(out, &event.header);
//         }
//     }
// }

// pub fn syncAudioToMain(plugin: *Plugin) bool {
//     var anyChanged = false;
//     var mutex = Mutex{};
//     mutex.lock();
//     defer mutex.unlock();
//     var i: u32 = 0;
//     while (i < P_COUNT) : (i += 1) {
//         if (plugin.changed[i]) {
//             plugin.mainParameters[i] = plugin.parameters[i];
//             plugin.changed[i] = false;
//             anyChanged = true;
//         }
//     }
//     return anyChanged;
// }

const AudioPorts = struct {
    fn count(plugin: [*c]const clap.clap_plugin_t, is_input: bool) callconv(.C) u32 {
        _ = is_input;
        _ = plugin;
        return 1;
    }

    fn get(plugin: [*c]const clap.clap_plugin_t, index: u32, is_input: bool, info: [*c]clap.clap_audio_port_info_t) callconv(.C) bool {
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
        var plug = c_cast(*Plugin, plugin.*.plugin_data);
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
        const plug = c_cast(*Plugin, plugin.*.plugin_data);
        return plug.latency;
    }
    const Data = clap.clap_plugin_latency_t{
        .get = getLatency,
    };
};

// state
const State = struct {
    pub fn save(plugin: [*c]const clap.clap_plugin_t, stream: [*c]const clap.clap_ostream_t) callconv(.C) bool {
        _ = stream;
        const plug = c_cast(*Plugin, plugin.*.plugin_data);
        const numParams = plug.params.numParams;
        _ = numParams;
        // PROBLEM: This crashes the plugin!
        // return @sizeOf(f32) * numParams == stream.*.write.?(stream, c_cast([*c]const f32, &plug.*.params), @sizeOf(f32) * numParams);
        return true;
    }

    pub fn load(plugin: [*c]const clap.clap_plugin_t, stream: [*c]const clap.clap_istream_t) callconv(.C) bool {
        const plug = c_cast(*Plugin, plugin.*.plugin_data);
        var mutex = Mutex{};
        mutex.lock();
        defer mutex.unlock();
        const numParams = plug.params.numParams;
        return @sizeOf(f32) * numParams == stream.*.read.?(stream, c_cast([*c]f32, &plug.*.params), @sizeOf(f32) * numParams);
    }

    const Data = clap.clap_plugin_state_t{
        .save = save,
        .load = load,
    };
};

pub fn init(plugin: [*c]const clap.clap_plugin) callconv(.C) bool {
    var plug = c_cast(*Plugin, plugin.*.plugin_data);

    {
        var ptr = plug.*.host.*.get_extension.?(plug.*.host, &clap.CLAP_EXT_LOG);
        if (ptr != null)
            plug.*.host_log = c_cast(*const clap.clap_host_log_t, ptr);
    }
    {
        var ptr = plug.*.host.*.get_extension.?(plug.*.host, &clap.CLAP_EXT_THREAD_CHECK);
        if (ptr != null)
            plug.*.host_thread_check = c_cast(*const clap.clap_host_thread_check_t, ptr);
    }
    {
        var ptr = plug.*.host.*.get_extension.?(plug.*.host, &clap.CLAP_EXT_LATENCY);
        if (ptr != null)
            plug.*.host_latency = c_cast(*const clap.clap_host_latency_t, ptr);
    }
    {
        var ptr = plug.*.host.*.get_extension.?(plug.*.host, &clap.CLAP_EXT_STATE);
        if (ptr != null)
            plug.*.host_state = c_cast(*const clap.clap_host_state_t, ptr);
    }
    {
        var ptr = plug.*.host.*.get_extension.?(plug.*.host, &clap.CLAP_EXT_PARAMS);
        if (ptr != null) {
            plug.*.host_params = c_cast(*const clap.clap_host_params_t, ptr);
            // var i: u32 = 0;
            // while (i < P_COUNT) : (i += 1) {
            //     var information: clap.clap_param_info_t = undefined;
            //     _ = Params.getInfo(plugin, i, &information);
            //     plug.*.mainParameters[i] = @floatCast(f32, information.default_value);
            //     plug.*.parameters[i] = @floatCast(f32, information.default_value);
            // }
        }
    }
    return true;
}

pub fn destroy(plugin: [*c]const clap.clap_plugin) callconv(.C) void {
    std.log.debug("Destroying plugin", .{});
    var plug = c_cast(*Plugin, plugin.*.plugin_data);
    plug.reverb.deinit(gpa.allocator());
    gpa.allocator().destroy(plug);
    const leaked = gpa.deinit();
    if (leaked)
        std.log.err("Leak detected!", .{});
}

pub fn activate(plugin: [*c]const clap.clap_plugin, sample_rate: f64, min_frames_count: u32, max_frames_count: u32) callconv(.C) bool {
    var plug = c_cast(*Plugin, plugin.*.plugin_data);
    plug.sampleRate = sample_rate;
    plug.maxNumSamples = max_frames_count;
    plug.reverb.init(gpa.allocator(), 0.3 * @floatCast(f32, plug.sampleRate)) catch unreachable;
    // plug.delay.max_delay = @floatToInt(u32, plug.sampleRate * 2.0) + 1;
    // plug.delay.init(gpa.allocator(), plug.numChannels) catch unreachable;
    // plug.delay.delay_time = @floatCast(f32, (plug.params.values.delay / 1000.0) * plug.sampleRate);
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

pub fn processEvent(plugin: *Plugin, event: [*c]const clap.clap_event_header_t) callconv(.C) void {
    if (event.*.space_id == clap.CLAP_CORE_EVENT_SPACE_ID) {
        if (event.*.type == clap.CLAP_EVENT_PARAM_VALUE) {
            const valueEvent = c_cast([*c]const clap.clap_event_param_value_t, event);
            plugin.params.setValue(valueEvent.*.param_id, valueEvent.*.value);
        }
    }
}

pub fn process(plugin: [*c]const clap.clap_plugin, processInfo: [*c]const clap.clap_process_t) callconv(.C) clap.clap_process_status {
    var plug = c_cast(*Plugin, plugin.*.plugin_data);
    const numFrames = processInfo.*.frames_count;
    const numEvents = processInfo.*.in_events.*.size.?(processInfo.*.in_events);
    var eventIndex: u32 = 0;
    var nextEventFrame: u32 = if (numEvents > 0) 0 else numFrames;

    // const mix = @floatCast(f32, plug.params.values.mix);
    // _ = mix;

    var i: u32 = 0;
    while (i < numFrames) {
        // handle all events at frame i
        while (eventIndex < numEvents and nextEventFrame == i) {
            const header = processInfo.*.in_events.*.get.?(processInfo.*.in_events, eventIndex);
            if (header.*.time != i) {
                nextEventFrame = header.*.time;
                break;
            }

            processEvent(plug, header);
            eventIndex += 1;

            if (eventIndex == numEvents) {
                // end of event list
                nextEventFrame = numFrames;
            }
        }

        // process audio in frame
        while (i < nextEventFrame) : (i += 1) {
            // get input samples
            var inL = processInfo.*.audio_inputs[0].data32[0][i];
            var inR = processInfo.*.audio_inputs[0].data32[1][i];

            // plug.reverb.processSample(&inL, &inR);

            // write output
            processInfo.*.audio_outputs[0].data32[0][i] = inL;
            processInfo.*.audio_outputs[0].data32[1][i] = inR;
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
            var plugin = gpa.allocator().create(Plugin) catch unreachable;
            plugin.*.host = host;
            plugin.*.plugin.desc = &PluginDesc;
            plugin.*.plugin.plugin_data = plugin;
            plugin.*.plugin.init = init;
            plugin.*.plugin.destroy = destroy;
            plugin.*.plugin.activate = activate;
            plugin.*.plugin.start_processing = startProcessing;
            plugin.*.plugin.stop_processing = stopProcessing;
            plugin.*.plugin.reset = reset;
            plugin.*.plugin.process = process;
            plugin.*.plugin.get_extension = getExtension;
            plugin.*.plugin.on_main_thread = onMainThread;
            plugin.*.latency = 0;
            return &plugin.*.plugin;
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
