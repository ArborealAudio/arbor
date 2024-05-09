//! clap_plugin.zig
//! definitions for CLAP plugin

const std = @import("std");
const builtin = @import("builtin");
const arbor = @import("arbor.zig");
const config = @import("config");
const log = arbor.log;
const cast = arbor.cast;
const Slice = arbor.Slice;
const clap = arbor.clap;

// TODO: Can we inherit the allocator decalred in user plugin somehow?
const allocator = std.heap.c_allocator;

/// Explicitly make a ClapPlugin from a CLAP API plugin pointer
fn plug_cast(ptr: ?*const clap.Plugin) *ClapPlugin {
    if (ptr) |p|
        return @ptrCast(@alignCast(p.plugin_data))
    else
        log.fatal("Plugin ptr is null\n", .{}, @src());
}

const ClapPlugin = @This();

const timer_ms = 16;

/// user plugin
plugin: ?*arbor.Plugin = null,

/// need a sub-struct to hold clap-specific data
/// this owns a pointer to this outer struct in the form of plugin_data
clap_plugin: clap.Plugin,
host: ?*const clap.Host,
host_latency: ?*const clap.HostLatency = null,
host_log: ?*const clap.HostLog = null,
host_thread_check: ?*const clap.HostThreadCheck = null,
host_state: ?*const clap.HostState = null,
host_params: ?*const clap.params.HostParams = null,
host_fd_support: ?*const clap.posix_fd.HostSupport = null,
timer_id: clap.Id,

need_repaint: bool = false,

const AudioPorts = struct {
    fn count(plugin: ?*const clap.Plugin, is_input: bool) callconv(.C) u32 {
        _ = is_input;
        _ = plugin;
        return 1;
    }

    fn get(
        plugin: ?*const clap.Plugin,
        index: u32,
        is_input: bool,
        info: ?*clap.AudioPorts.Info,
    ) callconv(.C) bool {
        _ = is_input;
        if (index > 1)
            return false;
        if (info) |ptr| {
            ptr.* = .{
                .id = 0,
                .name = undefined,
                .channel_count = 2,
                .flags = clap.AudioPorts.Flags{ .IS_MAIN = true },
                .port_type = clap.AudioPorts.STEREO,
                .in_place_pair = clap.INVALID_ID,
            };
            if (plug_cast(plugin).plugin) |plug|
                plug.num_channels = ptr.channel_count;
            return true;
        } else return false;
    }

    const Data = clap.AudioPorts{
        .count = count,
        .get = get,
    };
};

// TODO: Implement plugin note ports
// const NotePorts = struct {
//     fn count(plugin: ?*const clap.Plugin, is_input: bool) callconv(.C) u32 {
//         _ = is_input;
//         _ = plugin;
//         // TODO: Query whether there are note ports
//         return 0;
//     }

//     fn get(
//         plugin: ?*const clap.Plugin,
//         index: u32,
//         is_input: bool,
//         info: ?*clap.clap_note_port_info_t,
//     ) callconv(.C) bool {
//         _ = is_input;
//         _ = plugin;
//         if (index > 0)
//             return false;
//         info.*.id = 0;
//         std.log.defaultLog(.info, .default, "Note port: {s}", .{info.*.name});
//         info.*.supported_dialects = clap.CLAP_NOTE_DIALECT_MIDI;
//         info.*.preferred_dialect = clap.CLAP_NOTE_DIALECT_CLAP;
//         return true;
//     }

//     const Data = clap.NotePorts{
//         .count = count,
//         .get = get,
//     };
// };

// Latency
pub const Latency = struct {
    fn getLatency(plugin: ?*const clap.Plugin) callconv(.C) u32 {
        if (plug_cast(plugin).plugin) |plug| {
            if (@hasField(@TypeOf(plug.*), "latency"))
                return plug.latency
            else
                return 0;
        }
        return 0;
    }
    const Data = clap.Latency{
        .get = getLatency,
    };
};

// state
const State = struct {
    pub fn save(
        plugin: ?*const clap.Plugin,
        stream: ?*const clap.OutStream,
    ) callconv(.C) bool {
        if (plug_cast(plugin).plugin) |plug| {
            const num_params = plug.params.len;
            // PROBLEM: This crashes the plugin!
            if (stream) |str|
                return @sizeOf(f32) * num_params == str.write(
                    stream,
                    plug.params.ptr,
                    @sizeOf(f32) * num_params,
                );
        }
        return false;
    }

    pub fn load(
        plugin: ?*const clap.Plugin,
        stream: ?*const clap.InStream,
    ) callconv(.C) bool {
        if (plug_cast(plugin).plugin) |plug| {
            const num_params = plug.params.len;
            if (stream) |str|
                return @sizeOf(f32) * num_params == str.read(
                    stream,
                    plug.params.ptr,
                    @sizeOf(f32) * num_params,
                );
        }
        return false;
    }

    const Data = clap.PluginState{
        .save = save,
        .load = load,
    };
};

// Params
const Params = struct {
    pub fn count(plugin: ?*const clap.Plugin) callconv(.C) u32 {
        if (plug_cast(plugin).plugin) |plug|
            return @intCast(plug.params.len)
        else
            return 0;
    }

    fn getInfo(plugin: ?*const clap.Plugin, index: u32, info: ?*clap.params.Info) callconv(.C) bool {
        const plug = plug_cast(plugin).plugin orelse {
            log.err("Plugin is null\n", .{}, @src());
            return false;
        };
        if (index >= plug.params.len) return false;
        const param = plug.param_info[index];
        if (info) |ptr| {
            ptr.* = .{
                .name = .{0} ** clap.NAME_SIZE,
                .module = .{0} ** clap.PATH_SIZE,
                .id = index,
                .flags = .{
                    .IS_AUTOMATABLE = param.flags.automatable,
                    .IS_MODULATABLE = param.flags.modulatable,
                    .IS_STEPPED = param.flags.stepped,
                    .IS_ENUM = param.flags.is_enum,
                },
                .min_value = param.min_value,
                .max_value = param.max_value,
                .default_value = param.default_value,
                .cookie = null,
            };
            const name_len = param.name.len;
            if (name_len > 0) {
                @memcpy(ptr.name[0..name_len], param.name);
            }
            return true;
        }
        return false;
    }

    pub fn getValue(plugin: ?*const clap.Plugin, id: clap.Id, value: ?*f64) callconv(.C) bool {
        if (plug_cast(plugin).plugin) |plug| {
            if (id >= plug.params.len) return false;
            const val = if (plug.param_info[id].flags.stepped)
                @round(plug.params[id])
            else
                plug.params[id];
            if (value) |out_val| {
                out_val.* = val;
                return true;
            }
        }
        return false;
    }

    fn valueToText(
        plugin: ?*const clap.Plugin,
        id: clap.Id,
        value: f64,
        display: [*:0]u8,
        size: u32,
    ) callconv(.C) bool {
        if (plug_cast(plugin).plugin) |plug| {
            if (id >= plug.params.len) return false;
            const param = plug.param_info[id];
            if (param.flags.stepped) {
                const ival: u32 = @intFromFloat(@round(value));
                if (param.flags.is_enum) {
                    if (param.enum_choices) |choices| {
                        const choice = choices[ival];
                        // ISSUE: This bugs out with certain arrangements of strings
                        @memcpy(display[0..choice.len], choice);
                    }
                } else {
                    _ = std.fmt.bufPrintZ(display[0..size], "{d}", .{ival}) catch |e| {
                        log.err("{}\n", .{e}, @src());
                        return false;
                    };
                }
            } else {
                _ = std.fmt.bufPrintZ(display[0..size], "{d:.2}", .{value}) catch |e| {
                    log.err("{}\n", .{e}, @src());
                    return false;
                };
            }
            return true;
        } else return false;
    }

    // TODO: This
    fn textToValue(
        plugin: ?*const clap.Plugin,
        param_id: clap.Id,
        value_text: [*:0]const u8,
        out_value: ?*f64,
    ) callconv(.C) bool {
        _ = out_value;
        _ = value_text;
        _ = param_id;
        _ = plugin;
        return false;
    }

    fn flush(plugin: ?*const clap.Plugin, in: ?*const clap.InputEvents, out: ?*const clap.OutputEvents) callconv(.C) void {
        // TODO: Handle output events
        _ = out;
        const plug = plug_cast(plugin);
        if (in) |in_events| {
            for (0..in_events.size(in_events)) |i| {
                plug.processInEvent(in_events.get(in_events, @intCast(i)));
            }
        }
    }

    pub const Data = clap.params.PluginParams{
        .count = count,
        .get_info = getInfo,
        .get_value = getValue,
        .value_to_text = valueToText,
        .text_to_value = textToValue,
        .flush = flush,
    };
};

// GUI //
const GuiPlatform = arbor.Gui.Platform;
const GuiImpl = arbor.Gui.GuiImpl;
const Gui = struct {
    pub const GUI_API = switch (builtin.os.tag) {
        .linux => clap.gui.Window.API_X11,
        .macos => clap.gui.Window.API_COCOA,
        .windows => clap.gui.Window.API_WIN32,
        else => @panic("Unsupported OS"),
    };

    fn isAPISupported(
        plugin: ?*const clap.Plugin,
        api: [*:0]const u8,
        is_floating: bool,
    ) callconv(.C) bool {
        _ = plugin;
        return std.mem.orderZ(u8, api, GUI_API).compare(.eq) and !is_floating;
    }

    fn getPreferredAPI(
        plugin: ?*const clap.Plugin,
        api: ?*[*:0]const u8,
        is_floating: ?*bool,
    ) callconv(.C) bool {
        _ = plugin;
        if (api) |ptr| ptr.* = GUI_API;
        if (is_floating) |ptr| ptr.* = false;
        return true;
    }

    fn createGui(
        plugin: ?*const clap.Plugin,
        api: [*:0]const u8,
        is_floating: bool,
    ) callconv(.C) bool {
        if (!isAPISupported(plugin, api, is_floating))
            return false;
        if (plug_cast(plugin).plugin) |plug| {
            std.debug.assert(plug.gui == null);
            arbor.Gui.gui_init(plug);
            if (plug.gui) |gui| {
                const clap_plug = plug_cast(plugin);
                if (builtin.os.tag == .linux) {
                    if (clap_plug.host_fd_support) |host_fd| {
                        _ = host_fd.register_fd(clap_plug.host, gui.impl.fd, .{ .FD_READ = true });
                    }
                }
                return true;
            } else return false; // No GUI supplied
        }
        return false;
    }

    fn destroyGui(plugin: ?*const clap.Plugin) callconv(.C) void {
        const clap_plug = plug_cast(plugin);
        if (clap_plug.plugin) |plug| {
            std.debug.assert(plug.gui != null);
            if (builtin.os.tag == .linux) {
                if (clap_plug.host_fd_support) |host_fd| {
                    _ = host_fd.unregister_fd(clap_plug.host, plug.gui.?.impl.fd);
                }
            }
            plug.gui.?.deinit();
            plug.gui = null;
        }
    }

    fn setScale(plugin: ?*const clap.Plugin, scale: f64) callconv(.C) bool {
        _ = scale;
        _ = plugin;
        return false;
    }

    fn getSize(plugin: ?*const clap.Plugin, width: ?*u32, height: ?*u32) callconv(.C) bool {
        if (plug_cast(plugin).plugin) |plug| {
            if (plug.gui) |gui| {
                const size = gui.getSize();
                if (width) |ptr| ptr.* = @intCast(size.x);
                if (height) |ptr| ptr.* = @intCast(size.y);
            }
        }
        return true;
    }

    fn canResize(plugin: ?*const clap.Plugin) callconv(.C) bool {
        _ = plugin;
        return false;
    }

    fn getResizeHints(plugin: ?*const clap.Plugin, hints: ?*clap.gui.ResizeHints) callconv(.C) bool {
        _ = hints;
        _ = plugin;
        return false;
    }

    fn adjustSize(plugin: ?*const clap.Plugin, width: ?*u32, height: ?*u32) callconv(.C) bool {
        return getSize(plugin, width, height);
    }

    // TODO: Handle this
    fn setSize(plugin: ?*const clap.Plugin, width: u32, height: u32) callconv(.C) bool {
        _ = height;
        _ = width;
        _ = plugin;
        return true;
    }

    fn setParent(plugin: ?*const clap.Plugin, clap_window: ?*const clap.gui.Window) callconv(.C) bool {
        if (plug_cast(plugin).plugin) |plug| {
            const window = clap_window orelse {
                log.err("Window is null\n", .{}, @src());
                return false;
            };
            if (!std.mem.orderZ(u8, window.api, GUI_API).compare(.eq)) {
                log.err("Incompatible API: {s}\n", .{window.api}, @src());
                return false;
            }
            if (plug.gui) |gui| {
                const win_data = switch (builtin.os.tag) {
                    .macos => window.window.cocoa,
                    .linux => window.window.x11,
                    .windows => window.window.win32,
                    else => log.fatal("Unsupported OS\n", .{}, @src()),
                };
                GuiPlatform.guiSetParent(gui.impl, win_data);
                return true;
            }
        }
        return false;
    }

    fn setTransient(plugin: ?*const clap.Plugin, clap_window: ?*const clap.gui.Window) callconv(.C) bool {
        _ = clap_window;
        _ = plugin;
        return false;
    }

    fn suggestTitle(plugin: ?*const clap.Plugin, title: [*:0]const u8) callconv(.C) void {
        _ = title;
        _ = plugin;
    }

    fn show(plugin: ?*const clap.Plugin) callconv(.C) bool {
        if (plug_cast(plugin).plugin) |plug| {
            if (plug.gui) |gui| GuiPlatform.guiSetVisible(gui.impl, true);
            return true;
        }
        return false;
    }

    fn hide(plugin: ?*const clap.Plugin) callconv(.C) bool {
        if (plug_cast(plugin).plugin) |plug| {
            if (plug.gui) |gui| GuiPlatform.guiSetVisible(gui.impl, false);
            return true;
        }
        return false;
    }

    pub const Data = clap.gui.PluginGui{
        .is_api_supported = isAPISupported,
        .get_preferred_api = getPreferredAPI,
        .create = createGui,
        .destroy = destroyGui,
        .set_scale = setScale,
        .get_size = getSize,
        .can_resize = canResize,
        .get_resize_hints = getResizeHints,
        .adjust_size = adjustSize,
        .set_size = setSize,
        .set_parent = setParent,
        .set_transient = setTransient,
        .suggest_title = suggestTitle,
        .show = show,
        .hide = hide,
    };
};

pub const PosixFDSupport = struct {
    fn on_fd(
        plugin: ?*const clap.Plugin,
        fd: i32,
        flags: clap.posix_fd.Flags,
    ) callconv(.C) void {
        _ = fd;
        _ = flags;
        if (plug_cast(plugin).plugin) |plug| {
            if (plug.gui) |gui| GuiPlatform.guiOnPosixFd(gui.impl);
        }
    }

    pub const Data = clap.posix_fd.PluginSupport{
        .on_fd = on_fd,
    };
};

pub fn init(plugin: ?*const clap.Plugin) callconv(.C) bool {
    const clap_plug = plug_cast(plugin);

    // create user plugin
    clap_plug.plugin = arbor.Plugin.init();

    const host = clap_plug.host orelse {
        log.err("Clap host is null\n", .{}, @src());
        return false;
    };
    const get_ext = host.get_extension;

    if (get_ext(host, clap.EXT_LOG)) |ptr|
        clap_plug.host_log = @ptrCast(@alignCast(ptr));

    if (get_ext(host, clap.EXT_THREAD_CHECK)) |ptr|
        clap_plug.host_thread_check = @ptrCast(@alignCast(ptr));

    if (get_ext(host, clap.EXT_LATENCY)) |ptr|
        clap_plug.host_latency = @ptrCast(@alignCast(ptr));

    if (get_ext(host, clap.EXT_STATE)) |ptr|
        clap_plug.host_state = @ptrCast(@alignCast(ptr));

    if (get_ext(host, clap.EXT_PARAMS)) |ptr|
        clap_plug.host_params = @ptrCast(@alignCast(ptr));

    // if (get_ext(host, clap.EXT_TIMER_SUPPORT)) |ptr| {
    //     clap_plug.host_timer_support = @ptrCast(@alignCast(ptr));
    //     if (clap_plug.host_timer_support) |timer| {
    //         if (!timer.register_timer(host, timer_ms, &clap_plug.timer_id)) {
    //             log.err("Host timer register failed\n", .{});
    //         }
    //     }
    // }

    if (get_ext(host, clap.EXT_POSIX_FD_SUPPORT)) |ptr|
        clap_plug.host_fd_support = @ptrCast(@alignCast(ptr));

    return true;
}

pub fn destroy(plugin: ?*const clap.Plugin) callconv(.C) void {
    const clap_plug = plug_cast(plugin);
    // const host = clap_plug.host orelse log.fatal("Clap host is null\n", .{});
    // if (clap_plug.host_timer_support) |timer| {
    //     _ = timer.unregister_timer(host, clap_plug.timer_id);
    // }
    if (clap_plug.plugin) |plug|
        plug.interface.deinit(plug);
    allocator.destroy(clap_plug);
}

pub fn activate(
    plugin: ?*const clap.Plugin,
    sample_rate: f64,
    min_frames_count: u32,
    max_frames_count: u32,
) callconv(.C) bool {
    if (plug_cast(plugin).plugin) |plug| {
        plug.interface.prepare(plug, @floatCast(sample_rate), max_frames_count);
        _ = min_frames_count;
        return true;
    } else return false;
}

pub fn deactivate(plugin: ?*const clap.Plugin) callconv(.C) void {
    _ = plugin;
}
pub fn startProcessing(plugin: ?*const clap.Plugin) callconv(.C) bool {
    if (plugin) |_| return true else return false;
}
pub fn stopProcessing(plugin: ?*const clap.Plugin) callconv(.C) void {
    _ = plugin;
}
pub fn reset(plugin: ?*const clap.Plugin) callconv(.C) void {
    _ = plugin;
}

/// Take a CLAP event (just param changes for now), change the corresponding
/// parameter, and forward a param change event to the GUI
pub fn processInEvent(plugin: *ClapPlugin, event: ?*const clap.EventHeader) void {
    const plug = plugin.plugin orelse {
        log.err("Plugin is null\n", .{}, @src());
        return;
    };
    if (event) |e| {
        if (e.space_id == clap.CLAP_CORE_EVENT_SPACE_ID) {
            switch (e.type) {
                .PARAM_VALUE => {
                    const param_event = cast(*const clap.EventParamValue, e);
                    plug.params[param_event.param_id] = @floatCast(param_event.value);
                    if (plug.gui) |gui| {
                        gui.in_events.push_try(.{ .param_change = .{
                            .id = param_event.param_id,
                            .value = plug.param_info[param_event.param_id]
                                .getNormalizedValue(@floatCast(param_event.value)),
                        } }) catch |err| {
                            log.err("in_events push failed: {!}\n", .{err}, @src());
                            return;
                        };
                        gui.wants_repaint.store(true, .release);
                    }
                },
                // TODO: Separate functions for audio & MIDI events
                else => log.err("Unhandled event: {s}\n", .{@tagName(e.type)}, @src()),
            }
        }
    } else {
        log.err("Event header is null\n", .{}, @src());
        return;
    }
}

/// Read events from GUI and forward them to CLAP host
pub fn processOutEvent(plugin: *ClapPlugin, clap_events: *const clap.OutputEvents) void {
    const plug = plugin.plugin orelse {
        log.err("User plugin is null\n", .{}, @src());
        return;
    };
    const gui = plug.gui orelse {
        log.err("Gui is null\n", .{}, @src());
        return;
    };
    while (gui.out_events.next_try()) |event| {
        switch (event) {
            .param_change => |change| {
                const p = plug.param_info[change.id];
                plug.params[change.id] = p.valueFromNormalized(change.value);

                const out_event = clap.EventParamValue{
                    .header = .{
                        .size = @sizeOf(clap.EventParamValue),
                        .time = 0,
                        .space_id = clap.CLAP_CORE_EVENT_SPACE_ID,
                        .flags = .{},
                        .type = .PARAM_VALUE,
                    },
                    .cookie = null,
                    .param_id = @intCast(change.id),
                    .note_id = -1,
                    .port_index = -1,
                    .channel = -1,
                    .key = -1,
                    .value = @floatCast(plug.params[change.id]),
                };
                _ = clap_events.try_push(clap_events, &out_event.header);
            },
        }
    }
}

pub fn process(
    plugin: ?*const clap.Plugin,
    process_info: ?*const clap.Process,
) callconv(.C) clap.ProcessStatus {
    var clap_plug = plug_cast(plugin);
    const plug = clap_plug.plugin orelse {
        log.err("User plugin is null\n", .{}, @src());
        return .PROCESS_ERROR;
    };
    const p_info = process_info orelse {
        log.err("Process info is null\n", .{}, @src());
        return .PROCESS_ERROR;
    };
    const num_frames = p_info.frames_count;
    const num_events: u32 = if (p_info.in_events) |in_events|
        in_events.size(in_events)
    else
        0;
    var event_index: u32 = 0;
    var next_event_frame: u32 = if (num_events > 0) 0 else num_frames;

    if (plug.gui) |_| if (p_info.out_events) |out_ev| {
        clap_plug.processOutEvent(out_ev);
    };

    var i: u32 = 0;
    while (i < num_frames) {
        // handle all events at frame i
        while (event_index < num_events and next_event_frame == i) {
            if (p_info.in_events) |in_events| {
                if (in_events.get(in_events, event_index)) |header| {
                    if (header.time != i) {
                        next_event_frame = header.time;
                        break;
                    }
                    clap_plug.processInEvent(header);
                    event_index += 1;
                    if (event_index == num_events) {
                        // end of event list
                        next_event_frame = num_frames;
                        break;
                    }
                }
            }
        }

        // process audio in frame
        const audio_in = p_info.audio_inputs orelse {
            log.err("Audio inputs null\n", .{}, @src());
            return .PROCESS_ERROR;
        };
        const audio_out = p_info.audio_outputs orelse {
            log.err("Audio outputs null\n", .{}, @src());
            return .PROCESS_ERROR;
        };
        std.debug.assert(audio_in[0].channel_count == audio_out[0].channel_count);

        while (i < next_event_frame) {
            const frames_to_process = next_event_frame - i;
            // // TODO: Determine whether f64 is wanted
            const num_ch = @min(audio_in[0].channel_count, audio_out[0].channel_count);
            if (frames_to_process == 0) break;
            plug.interface.process(plug, .{
                .input = &.{
                    audio_in[0].data32[0][i..next_event_frame],
                    audio_in[0].data32[1][i..next_event_frame],
                },
                .output = &.{
                    audio_out[0].data32[0][i..next_event_frame],
                    audio_out[0].data32[1][i..next_event_frame],
                },
                .num_ch = num_ch,
                .frames = frames_to_process,
            });
            i += frames_to_process;
        }
    }
    return .PROCESS_CONTINUE;
}

// TODO: Figure out how to do this properly and pass proper slices to the user's process()
fn slicePtr(in: [*][*]f32, num_ch: usize, offset: usize, end: usize) [*]Slice(f32) {
    var out = Slice([*]f32){ .ptr = in, .len = num_ch };
    for (out.slice(), 0..) |_, ch_idx| {
        out.slice()[ch_idx] = in[ch_idx][offset..end];
    }
}

pub fn getExtension(plugin: ?*const clap.Plugin, id: [*:0]const u8) callconv(.C) ?*const anyopaque {
    _ = plugin;
    if (std.mem.orderZ(u8, id, clap.EXT_LATENCY).compare(.eq))
        return &Latency.Data;
    if (std.mem.orderZ(u8, id, clap.EXT_AUDIO_PORTS).compare(.eq))
        return &AudioPorts.Data;
    // TODO: NotePorts
    // if (std.mem.orderZ(u8, id, clap.EXT_NOTE_PORTS).compare(.eq))
    //     return &NotePorts.Data;
    if (std.mem.orderZ(u8, id, clap.EXT_STATE).compare(.eq))
        return &State.Data;
    if (std.mem.orderZ(u8, id, clap.EXT_PARAMS).compare(.eq))
        return &Params.Data;
    if (std.mem.orderZ(u8, id, clap.EXT_GUI).compare(.eq))
        return &Gui.Data;
    // if (std.mem.orderZ(u8, id, clap.EXT_TIMER_SUPPORT).compare(.eq))
    //     return &Timer.Data;
    if (std.mem.orderZ(u8, id, clap.EXT_POSIX_FD_SUPPORT).compare(.eq))
        return &PosixFDSupport.Data;
    return null;
}

pub fn onMainThread(plugin: ?*const clap.Plugin) callconv(.C) void {
    _ = plugin;
}

// Factory
const Factory = struct {
    fn getPluginCount(factory: ?*const clap.PluginFactory) callconv(.C) u32 {
        _ = factory;
        return 1;
    }

    fn getPluginDescriptor(
        factory: ?*const clap.PluginFactory,
        index: u32,
    ) callconv(.C) ?*const clap.PluginDescriptor {
        _ = factory;
        return if (index == 0) &arbor.plugin_desc else null;
    }

    fn createPlugin(
        factory: ?*const clap.PluginFactory,
        host: ?*const clap.Host,
        plugin_id: [*:0]const u8,
    ) callconv(.C) ?*const clap.Plugin {
        _ = factory;
        const h = host orelse {
            log.err("Host is null\n", .{}, @src());
            return null;
        };

        if (!clap.clap_version_is_compatible(h.clap_version)) return null;

        if (std.mem.orderZ(u8, plugin_id, arbor.plugin_desc.id).compare(.eq)) {
            var clap_plug = allocator.create(ClapPlugin) catch |e| {
                log.err("Failed to create CLAP plugin: {}\n", .{e}, @src());
                return null;
            };
            clap_plug.* = .{
                .clap_plugin = .{
                    .desc = &arbor.plugin_desc,
                    .plugin_data = clap_plug,
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
                .host = h,
                .timer_id = undefined,
            };
            return &clap_plug.clap_plugin;
        } else return null;
    }

    pub const Data = clap.PluginFactory{
        .get_plugin_count = getPluginCount,
        .get_plugin_descriptor = getPluginDescriptor,
        .create_plugin = createPlugin,
    };
};

// Entry
const Entry = struct {
    fn init(plugin_path: [*:0]const u8) callconv(.C) bool {
        _ = plugin_path;

        return true;
    }

    fn deinit() callconv(.C) void {}

    fn get_factory(factory_id: [*:0]const u8) callconv(.C) ?*const anyopaque {
        if (std.mem.orderZ(u8, factory_id, clap.PLUGIN_FACTORY_ID).compare(.eq)) {
            return &Factory.Data;
        } else return null;
    }
};

export const clap_entry = clap.PluginEntry{
    .clap_version = clap.Version.init(),
    .init = &Entry.init,
    .deinit = &Entry.deinit,
    .get_factory = &Entry.get_factory,
};
