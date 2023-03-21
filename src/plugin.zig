//! plugin.zig
//! starting point for our plugin

const std = @import("std");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};

pub const clap = @cImport({
    @cInclude("clap/clap.h");
});

const c_cast = std.zig.c_translation.cast;

const PluginDesc = clap.clap_plugin_descriptor_t{
    .clap_version = clap.clap_version_t{ .major = clap.CLAP_VERSION_MAJOR, .minor = clap.CLAP_VERSION_MINOR, .revision = clap.CLAP_VERSION_REVISION },
    .id = "com.ArborealAudio.clap",
    .name = "CLAP-raw",
    .vendor = "Arboreal Audio",
    .url = "https://arborealaudio.com",
    .manual_url = "",
    .support_url = "",
    .version = "0.1",
    .description = "Vintage analog warmth",
    .features = &[_][*c]const u8{ "stereo", "instrument", null },
};

const Plugin = struct {
    plugin: clap.clap_plugin_t,

    host: [*c]const clap.clap_host_t,
    host_latency: [*c]const clap.clap_host_latency_t,
    host_log: ?*const clap.clap_host_log_t,
    host_thread_check: [*c]const clap.clap_host_thread_check_t,
    host_state: [*c]const clap.clap_host_state_t,

    latency: u32,
};

const AudioPorts = struct {
    fn count(plugin: [*c]const clap.clap_plugin_t, is_input: bool) callconv(.C) u32 {
        _ = is_input;
        _ = plugin;
        return 2;
    }

    fn get(plugin: [*c]const clap.clap_plugin_t, index: u32, is_input: bool, info: [*c]clap.clap_audio_port_info_t) callconv(.C) bool {
        _ = is_input;
        _ = plugin;
        if (index > 1)
            return false;
        info.*.id = 0;
        std.log.defaultLog(.info, .default, "Port name: {s}", .{info.*.name});
        info.*.channel_count = 2;
        info.*.flags = clap.CLAP_AUDIO_PORT_IS_MAIN;
        info.*.port_type = &clap.CLAP_PORT_STEREO;
        info.*.in_place_pair = clap.CLAP_INVALID_ID;
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
        const plug = plugin.*.plugin_data;
        _ = plug;
        return true;
    }

    pub fn load(plugin: [*c]const clap.clap_plugin_t, stream: [*c]const clap.clap_istream_t) callconv(.C) bool {
        _ = stream;
        const plug = plugin.*.plugin_data;
        _ = plug;
        return true;
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
    return true;
}

pub fn destroy(plugin: [*c]const clap.clap_plugin) callconv(.C) void {
    var plug = c_cast(*Plugin, plugin.*.plugin_data);
    gpa.allocator().destroy(plug);
}

pub fn activate(plugin: [*c]const clap.clap_plugin, sample_rate: f64, min_frames_count: u32, max_frames_count: u32) callconv(.C) bool {
    _ = max_frames_count;
    _ = min_frames_count;
    _ = sample_rate;
    _ = plugin;
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

pub fn processEvent(plugin: *Plugin, header: [*c]const clap.clap_event_header_t) callconv(.C) void {
    _ = header;
    _ = plugin;
}

pub fn process(plugin: [*c]const clap.clap_plugin, processInfo: [*c]const clap.clap_process_t) callconv(.C) clap.clap_process_status {
    var plug = c_cast(*Plugin, plugin.*.plugin_data);
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
            const inL = processInfo.*.audio_inputs[0].data32[0][i];
            const inR = processInfo.*.audio_inputs[0].data32[1][i];

            // ye olde tanh
            var outL = std.math.tanh(inL * 10.0) / 10.0;
            var outR = std.math.tanh(inR * 10.0) / 10.0;

            // write output
            processInfo.*.audio_outputs[0].data32[0][i] = outL;
            processInfo.*.audio_outputs[0].data32[1][i] = outR;
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
    .clap_version = clap.clap_version_t{ .major = clap.CLAP_VERSION_MAJOR, .minor = clap.CLAP_VERSION_MINOR, .revision = clap.CLAP_VERSION_REVISION },
    .init = &Entry.init,
    .deinit = &Entry.deinit,
    .get_factory = &Entry.get_factory,
};
