//! Definition of a specific VST2 plugin implementation

const std = @import("std");
const assert = std.debug.assert;
const arbor = @import("arbor.zig");
const log = arbor.log;
const cast = arbor.cast;
const builtin = @import("builtin");

const config = @import("config");

const vst2 = @import("vst2_api.zig");

const Plugin = arbor.Plugin;
const Parameter = arbor.Parameter;
const Gui = arbor.Gui;
const PlatformGui = Gui.Platform;

const allocator = std.heap.c_allocator;

const VstPlugin = @This();

var audio_thread: std.Thread.Id = undefined;
var main_thread: std.Thread.Id = undefined;

// vst2-specific data
effect: *vst2.AEffect,
host_callback: *const fn (
    effect: ?*vst2.AEffect,
    opcode: i32,
    index: i32,
    value: isize,
    ptr: ?*anyopaque,
    opt: f32,
) callconv(.C) isize,
plugin: *Plugin, // our specific plugin data

in_events: *arbor.Queue,

process_precision: vst2.ProcessPrecision = .ProcessPrecision32,

pub fn plugCast(effect: ?*const vst2.AEffect) *VstPlugin {
    if (effect) |ptr|
        return @ptrCast(@alignCast(ptr.object))
    else {
        log.fatal("Plugin ptr is null\n", .{}, @src());
    }
}

fn dispatch(
    effect: ?*vst2.AEffect,
    opcode: i32,
    index: i32,
    value: isize,
    ptr: ?*anyopaque,
    opt: f32,
) callconv(.C) isize {
    var plugin: *VstPlugin = plugCast(effect);
    const plug = plugin.plugin;
    const code = std.meta.intToEnum(vst2.Opcode, opcode) catch return -1;
    switch (code) {
        .Open => {
            const sample_rate = plugin.host_callback(
                plugin.effect,
                @intFromEnum(vst2.HostOpcodes.GetSampleRate),
                0,
                0,
                null,
                0,
            );
            const max_frames = plugin.host_callback(
                plugin.effect,
                @intFromEnum(vst2.HostOpcodes.GetNumFrames),
                0,
                0,
                null,
                0,
            );
            log.debug("Setting SR {d} and {d} frames from host\n", .{ sample_rate, max_frames }, @src());
            plug.interface.prepare(
                plug,
                @floatFromInt(sample_rate),
                @intCast(max_frames),
            );
            return 0;
        },
        // ISSUE: This is kinda bunk right? Since the outer AEffect will end up destroying itself?
        .Close => {
            plugin.deinit(allocator);
            return 0;
        },
        .GetVendorString => {
            if (ptr) |p| {
                var buf: [*]u8 = @ptrCast(p);
                const vendor = arbor.plugin_desc.company;
                @memset(buf[0..vst2.StringConstants.MaxVendorStrLen], 0);
                @memcpy(buf[0..vendor.len], vendor);
                return 0;
            }
        },
        .GetVendorVersion => {
            return arbor.Vst2VersionInt(arbor.plugin_desc.version) catch |e| {
                log.err("{s}: {!}\n", .{ @tagName(code), e }, @src());
                return 1;
            };
        },
        .GetProductString => {
            if (ptr) |p| {
                var buf: [*]u8 = @ptrCast(p);
                const name = arbor.plugin_desc.name;
                @memset(buf[0..vst2.StringConstants.MaxProductStrLen], 0);
                @memcpy(buf[0..name.len], name);
                return 0;
            }
        },
        .GetPlugCategory => {
            return @intFromEnum(arbor.parseVst2Features(config.plugin_features));
        },
        .GetParamName => {
            if (index >= 0 and index < plug.param_info.len) {
                if (ptr) |p| {
                    const name = plug.getParamName(@intCast(index)) catch |e| {
                        log.err("{s}: {!}\n", .{ @tagName(code), e }, @src());
                        return 1;
                    };
                    var buf: [*]u8 = @ptrCast(p);
                    const len = @min(vst2.StringConstants.MaxParamStrLen, name.len);
                    @memset(buf[0..vst2.StringConstants.MaxParamStrLen], 0);
                    @memcpy(buf[0..len], name[0..len]);
                    return 0;
                }
            }
            return 1;
        },
        .GetParamLabel => {},
        // Param value as text
        .ParamValueToText => {
            if (index >= 0 and index < plug.param_info.len) {
                const id: usize = @intCast(index);
                const val = plug.params[id];
                const param_info = plug.param_info[id];
                if (ptr) |p| {
                    const out: [*]u8 = @ptrCast(p);
                    // Doesn't seem to matter that we pass strings longer than the API's
                    // insane restriction of 8 chars. Either most hosts subvert this limitation
                    // or it's, like, more of a suggestion.
                    const max_len = vst2.StringConstants.MaxParamStrLen;
                    @memset(out[0..max_len], 0);
                    if (param_info.value_to_text) |func| {
                        var buf: [max_len]u8 = .{0} ** max_len;
                        const len = func(val, &buf);
                        @memcpy(out[0..len], buf[0..len]);
                        return 0;
                    } else if (param_info.flags.is_enum) {
                        if (param_info.enum_choices) |choices| {
                            const choice = choices[@intFromFloat(val)];
                            const clen = @min(max_len, choice.len);
                            @memcpy(out[0..clen], choice[0..clen]);
                            return 0;
                        }
                    } else { // no value-to-text fn, just format it
                        var buf: [max_len]u8 = .{0} ** max_len;
                        const print = std.fmt.bufPrintZ(&buf, "{d:.2}", .{val}) catch |e| {
                            log.err("{s}: {!}\n", .{ @tagName(code), e }, @src());
                            return 1;
                        };
                        @memcpy(out[0..print.len], print);
                        return 0;
                    }
                }
            }
            return 1;
        },
        .ParamTextToValue => {
            if (index >= 0 and index < plug.param_info.len) {
                const id: usize = @intCast(index);
                const text: []const u8 = std.mem.span(@as([*:0]u8, @ptrCast(ptr)));
                const val: f32 = std.fmt.parseFloat(f32, text) catch |e| {
                    log.err("{!}\n", .{e}, @src());
                    return 1;
                };
                plug.params[id] = val;
                return 0;
            }
        },
        .SetSampleRate => {
            // Do we need to wrap this in a mutex & re-init the plugin? Delay lines etc. will need resizing
            log.debug("Setting sample rate: {d}\n", .{opt}, @src());
            plug.interface.prepare(plug, opt, plug.max_frames);
            return 0;
        },
        .CanBeAutomated => return 1,
        .SetBlockSize => {
            // Do we need to wrap this in a mutex & re-init the plugin? Delay lines etc. will need resizing
            log.debug("Setting block size: {d}\n", .{value}, @src());
            plug.interface.prepare(plug, plug.sample_rate, @intCast(value));
            return 0;
        },
        .EditGetRect => {
            if (config.plugin_features & arbor.features.GUI == 0) return 0;
            // copy to ptr
            if (ptr) |p| {
                const dest = arbor.cast(**vst2.Rect, p);
                if (plug.gui) |gui| {
                    const width: i16 = @intCast(gui.getSize().x);
                    const height: i16 = @intCast(gui.getSize().y);
                    var rect = vst2.Rect{
                        .top = 0,
                        .left = 0,
                        .right = width,
                        .bottom = height,
                    };
                    dest.* = &rect;
                    return 1;
                } else {
                    log.err("{s}: Gui is null", .{@tagName(code)}, @src());
                    return 0;
                }
            }
            return 0;
        },
        .EditOpen => {
            if (config.plugin_features & arbor.features.GUI == 0) return 0;
            // Init GUI
            // ptr = native parent window (HWND, NSView/NSWindow?, X Window)
            assert(plug.gui == null);
            Gui.gui_init(plug);
            const gui = plug.gui orelse {
                log.err("{s}: Gui is null\n", .{@tagName(code)}, @src());
                return 0;
            };

            const width: i16 = @intCast(gui.getSize().x);
            const height: i16 = @intCast(gui.getSize().y);

            if (plugin.host_callback(
                effect,
                @intFromEnum(vst2.HostOpcodes.SizeWindow),
                width,
                height,
                null,
                0,
            ) != 1) {
                log.err("SizeWindow not supported by host\n", .{}, @src());
                return 0;
            }

            if (ptr) |p| {
                const window = if (builtin.os.tag != .linux)
                    arbor.cast(PlatformGui.Window, p)
                else
                    @intFromPtr(p);
                PlatformGui.guiSetParent(gui.impl, window);
            } else {
                log.err("Passed null parent window\n", .{}, @src());
                return 0;
            }
            PlatformGui.guiSetVisible(gui.impl, true);
            gui.requestDraw();
            return 1;
        },
        .EditRedraw => {
            return 1;
        },
        .EditClose => {
            if (config.plugin_features & arbor.features.GUI == 0) return 0;
            // Close GUI
            if (plug.gui) |gui| {
                gui.deinit();
                plug.gui = null;
            } else {
                log.err("{s}: GUI is null\n", .{@tagName(code)}, @src());
                assert(false);
                return 0;
            }
            return 1;
        },
        .GetVstVersion => return 2400,
        .CanDo => {
            if (ptr) |p| {
                const req: []const u8 = std.mem.span(@as([*:0]u8, (@ptrCast(p))));
                // TODO: Check if plugin is MIDI
                if (std.mem.eql(u8, req, "receiveVstMidiEvent")) return -1;
                log.debug("Requesting can do: {s}\n", .{req}, @src());
                return 0;
            }
        },
        .GetChunk => {
            if (ptr) |p| {
                var dest: [*]f32 = @ptrCast(@alignCast(p));
                dest = plug.params.ptr;
                return @intCast(@sizeOf(f32) * plug.params.len);
            }
            return 1;
        },
        .SetChunk => {
            if (ptr) |p| {
                const src: [*]f32 = @ptrCast(@alignCast(p));
                @memcpy(plug.params, src[0..plug.params.len]);
                return 0;
            }
            return 1;
        },
        .SetProgram, .GetProgram, .SetProgramName, .GetProgramName => {
            // Does anyone use this stuff?
            return -1;
        },
        .ProcessEvents => {},
        .GetInputProperties => {
            // TODO: Use `index` to support multiple pins
            const pin = allocator.create(vst2.PinProperties) catch |e| {
                log.err("{!}\n", .{e}, @src());
                return 1;
            };
            pin.* = std.mem.zeroes(vst2.PinProperties);
            const name = "Input";
            @memcpy(pin.label[0..name.len], name);
            pin.flags = .{ .IsActive = true, .IsStereo = plug.num_channels > 1 };
            @memcpy(pin.shortLabel[0..name.len], name);

            if (ptr) |p| {
                var dest: *vst2.PinProperties = @alignCast(@ptrCast(p));
                dest = pin;
                return 0;
            }
            return 1;
        },
        .GetOutputProperties => {
            // TODO: Use `index` to support multiple pins
            const pin = allocator.create(vst2.PinProperties) catch |e| {
                log.err("{!}\n", .{e}, @src());
                return 1;
            };
            pin.* = std.mem.zeroes(vst2.PinProperties);
            const name = "Output";
            @memcpy(pin.label[0..name.len], name);
            pin.flags = .{ .IsActive = true, .IsStereo = plug.num_channels > 1 };
            @memcpy(pin.shortLabel[0..name.len], name);

            if (ptr) |p| {
                var dest: *vst2.PinProperties = @alignCast(@ptrCast(p));
                dest = pin;
                return 0;
            }
            return 1;
        },
        .SetProcessPrecision => {
            plugin.process_precision = @enumFromInt(value);
            return 0;
        },
        .GetParameterProperties => {
            // TODO
            return -1;
        },
        .GetTailSize => return 0,
    }
    return -1;
}

fn processInEvents(vst: *VstPlugin) void {
    const plug = vst.plugin;
    // Don't want to lock on the audio thread
    while (vst.in_events.next_try()) |event| {
        switch (event) {
            .param_change => |change| {
                plug.params[change.id] = plug.param_info[change.id]
                    .valueFromNormalized(change.value);

                if (plug.gui) |gui| {
                    gui.in_events.push_try(event) catch |e| {
                        log.err("{!}\n", .{e}, @src());
                    };
                    gui.requestDraw();
                }
            },
        }
    }
}

fn processOutEvents(vst: *VstPlugin) void {
    const plugin = vst.plugin;
    const gui = plugin.gui orelse {
        log.err("Gui is null\n", .{}, @src());
        assert(false);
        return;
    };
    while (gui.out_events.next_try()) |event| {
        switch (event) {
            .param_change => |change| {
                const p = plugin.param_info[change.id];
                plugin.params[change.id] = p.valueFromNormalized(change.value);
                // push change to host
                _ = vst.host_callback(
                    vst.effect,
                    @intFromEnum(vst2.HostOpcodes.AutomateParam),
                    @intCast(change.id),
                    0,
                    null,
                    change.value,
                );
            },
        }
    }
}

fn processReplacing(
    effect: ?*vst2.AEffect,
    inputs: [*][*]f32,
    outputs: [*][*]f32,
    frames: i32,
) callconv(.C) void {
    audio_thread = std.Thread.getCurrentId();
    const vst = plugCast(effect);
    const plugin = vst.plugin;
    if (plugin.gui) |_| processOutEvents(vst);

    processInEvents(vst);

    const uframes: usize = @intCast(frames);
    const buffer: arbor.AudioBuffer(f32) = .{
        .input = &.{
            inputs[0][0..uframes],
            inputs[1][0..uframes],
        },
        .output = &.{
            outputs[0][0..uframes],
            outputs[1][0..uframes],
        },
        .frames = uframes,
        .num_ch = @intCast(@min(vst.effect.num_inputs, vst.effect.num_outputs)),
        // TODO: Handle unequal in/out pairs
    };
    plugin.interface.process(plugin, buffer);
}
fn processDoubleReplacing(
    effect: ?*vst2.AEffect,
    inputs: [*][*]f64,
    outputs: [*][*]f64,
    frames: i32,
) callconv(.C) void {
    _ = effect;
    _ = frames;
    _ = outputs;
    _ = inputs;
}

fn setParameter(effect: ?*vst2.AEffect, index: i32, value: f32) callconv(.C) void {
    main_thread = std.Thread.getCurrentId();
    const vst = plugCast(effect);
    const plugin = vst.plugin;
    if (index >= 0 and index < plugin.param_info.len) {
        const event = arbor.Event{
            .param_change = .{ .id = @intCast(index), .value = value },
        };
        // ISSUE: This just feels no good...
        // but, we don't know which thread this will be called from
        if (main_thread == audio_thread) {
            vst.in_events.push_no_lock(event) catch return; // Well, let's just not care if we overflow
            vst.processInEvents();
        } else {
            vst.in_events.push_wait(event) catch return;
        }
    }
}

fn getParameter(effect: ?*vst2.AEffect, index: i32) callconv(.C) f32 {
    const plugin = plugCast(effect).plugin;
    if (index >= 0 and index < plugin.param_info.len) {
        const id: usize = @intCast(index);
        return plugin.param_info[id].getNormalizedValue(plugin.params[id]);
    }
    return 0;
}

pub fn init(alloc: std.mem.Allocator, host_callback: vst2.HostCallback) !*vst2.AEffect {
    const self = try alloc.create(VstPlugin);
    self.* = .{
        .effect = try alloc.create(vst2.AEffect),
        .plugin = Plugin.init(),
        .in_events = try arbor.Queue.init(alloc),
        .host_callback = host_callback orelse {
            log.err("host_callback is null\n", .{}, @src());
            return error.InitFailed;
        },
    };
    self.plugin.num_channels = 2; // TODO: DOn't hardcode
    self.effect.* = .{
        .dispatcher = dispatch,
        .processReplacing = processReplacing,
        .processDoubleReplacing = processDoubleReplacing,
        .setParameter = setParameter,
        .getParameter = getParameter,
        .num_programs = 0,
        .num_params = @intCast(self.plugin.param_info.len),
        .num_inputs = 2,
        .num_outputs = 2,
        .flags = .{
            .HasStateChunk = true,
            .HasReplacing = true,
            .HasEditor = (config.plugin_features & arbor.features.GUI > 0),
        },
        .latency = 0,
        .uniqueID = std.mem.bytesToValue(i32, arbor.plugin_desc.id),
        .version = arbor.Vst2VersionInt(arbor.plugin_desc.version) catch |e| {
            log.fatal("{!}\n", .{e}, @src());
            return error.ParseVersionFailed;
        },
        .object = self,
    };
    return self.effect;
}

pub fn deinit(self: *VstPlugin, alloc: std.mem.Allocator) void {
    const plug = self.plugin;
    plug.interface.deinit(plug);
    plug.deinit();
    self.in_events.deinit();
    alloc.destroy(self.effect);
    alloc.destroy(self);
}

export fn VSTPluginMain(callback: vst2.HostCallback) callconv(.C) ?*anyopaque {
    return init(allocator, callback) catch return null;
}
