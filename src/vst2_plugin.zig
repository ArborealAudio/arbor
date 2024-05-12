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
plugin: ?*Plugin = null, // our specific plugin data
rect: vst2.Rect,

in_events: *arbor.Queue,

process_precision: vst2.ProcessPrecision = .ProcessPrecision32,

fn plugCast(effect: ?*const vst2.AEffect) *VstPlugin {
    if (effect) |ptr|
        return @ptrCast(@alignCast(ptr.object))
    else {
        log.fatal("Plugin ptr is null\n", .{}, @src());
    }
}

// TODO: Handle extende set of opcodes
fn dispatch(
    effect: ?*vst2.AEffect,
    opcode: i32,
    index: i32,
    value: isize,
    ptr: ?*anyopaque,
    opt: f32,
) callconv(.C) isize {
    var plugin: *VstPlugin = plugCast(effect);
    const plug = plugin.plugin orelse {
        log.err("Plugin is null\n", .{}, @src());
        return 0;
    };
    const code = std.meta.intToEnum(vst2.Opcode, opcode) catch return -1;
    switch (code) {
        .Open => {
            // TODO: Implement calling the host for SR, max frames, num ch
            plug.interface.prepare(
                plug,
                plug.sample_rate,
                plug.max_frames,
            );
            return 0;
        },
        .Close => {
            plugin.deinit(allocator);
            return 0;
        },
        .GetVendorString => {
            if (ptr) |p| {
                var buf: [*]u8 = @ptrCast(p);
                const vendor = arbor.plugin_desc.company;
                @memset(buf[0..vst2.StringConstants.MaxNameLen], 0);
                @memcpy(buf[0..vendor.len], vendor);
                return 0;
            }
        },
        .GetVendorVersion => {
            return arbor.Vst2VersionInt(arbor.plugin_desc.version) catch |e|
                {
                log.err("{s}: {!}\n", .{ @tagName(code), e }, @src());
                return 1;
            };
        },
        .GetProductString => {
            if (ptr) |p| {
                var buf: [*]u8 = @ptrCast(p);
                const name = arbor.plugin_desc.name;
                @memset(buf[0..vst2.StringConstants.MaxNameLen], 0);
                @memcpy(buf[0..name.len], name);
                return 1;
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
                    @memset(buf[0..vst2.StringConstants.MaxNameLen], 0);
                    @memcpy(buf[0..name.len], name);
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
                    @memset(out[0..vst2.StringConstants.MaxNameLen], 0);
                    if (param_info.value_to_text) |func| {
                        var buf: [10]u8 = undefined;
                        const len = func(val, &buf);
                        @memcpy(out[0..len], buf[0..len]);
                        return 0;
                    } else if (param_info.flags.is_enum) {
                        if (param_info.enum_choices) |choices| {
                            const choice = choices[@intFromFloat(val)];
                            @memcpy(out[0..choice.len], choice);
                            return 1;
                        }
                    } else { // no value-to-text fn, just format it
                        var buf: [10]u8 = undefined;
                        const print = std.fmt.bufPrintZ(&buf, "{d:.2}", .{val}) catch |e| {
                            log.err("{s}: {!}\n", .{ @tagName(code), e }, @src());
                            return 1;
                        };
                        @memcpy(out[0..print.len], print);
                        return 0;
                    }
                }
            }
            return 0;
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
            return 1;
        },
        .CanBeAutomated => return 1,
        .SetBlockSize => {
            // Do we need to wrap this in a mutex & re-init the plugin? Delay lines etc. will need resizing
            log.debug("Setting block size: {d}\n", .{value}, @src());
            plug.interface.prepare(plug, plug.sample_rate, @intCast(value));
            return 1;
        },
        .EditGetRect => {
            if (config.plugin_features & arbor.features.GUI == 0) return 0;
            // copy to ptr
            if (ptr) |p| {
                const dest = arbor.cast(**vst2.Rect, p);
                dest.* = &plugin.rect;
                return 1;
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
            plugin.rect = vst2.Rect{
                .top = 0,
                .left = 0,
                .right = width,
                .bottom = height,
            };

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
                    @compileError("VST2 Window unimplemented on Linux");
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
            if (config.plugin_features & arbor.features.GUI == 0) return 0;
            // NOTE: Does this collide with our timer callback?
        },
        .EditClose => {
            if (config.plugin_features & arbor.features.GUI == 0) return 0;
            // Close GUI
            if (plug.gui) |gui| {
                gui.deinit();
                plug.gui = null;
                // plugin.rect = null;
            } else {
                log.err("{s}: GUI is null\n", .{@tagName(code)}, @src());
                assert(false);
                return 0;
            }
            return 0;
        },
        .GetVstVersion => return 2400,
        .CanDo => {
            if (ptr) |p| {
                const req: []const u8 = std.mem.span(@as([*:0]u8, (@ptrCast(p))));
                if (std.mem.eql(u8, req, "receiveVstMidiEvent")) return -1;
                log.debug("Requesting can do: {s}\n", .{req}, @src());
                return 0;
            }
        },
        .GetChunk => {
            if (ptr) |p| {
                var dest = p;
                dest = @alignCast(@ptrCast(plug.params.ptr));
                return 0;
            }
            return 1;
        },
        .SetChunk => {
            if (ptr) |p| {
                @memcpy(
                    plug.params,
                    @as([*]f32, @alignCast(@ptrCast(p))),
                );
                return 0;
            }
            return 1;
        },
        .SetProgram, .GetProgram, .SetProgramName, .GetProgramName => {},
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
        .GetParameterProperties => {},
        .GetTailSize => return 0,
    }
    return -1;
}

fn processInEvent(vst: *VstPlugin) void {
    const plug = vst.plugin orelse {
        log.err("Plugin is null\n", .{}, @src());
        assert(false);
        return;
    };
    // locking here makes sure we drain it before releasing
    vst.in_events.mutex.lock();
    defer vst.in_events.mutex.unlock();
    while (vst.in_events.next_no_lock()) |event| {
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

fn processOutEvent(vst: *VstPlugin) void {
    const plugin = vst.plugin orelse {
        log.err("Plugin is null\n", .{}, @src());
        assert(false);
        return;
    };
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
    if (vst.plugin) |plugin| {
        if (plugin.gui) |_| processOutEvent(vst);

        processInEvent(vst);

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
    if (vst.plugin) |plugin| {
        if (index >= 0 and index < plugin.param_info.len) {
            const event = arbor.Event{
                .param_change = .{ .id = @intCast(index), .value = value },
            };
            if (main_thread == audio_thread) {
                vst.in_events.push_no_lock(event) catch |e| {
                    log.err("{!}\n", .{e}, @src());
                    return;
                };
                vst.processInEvent();
            } else {
                vst.in_events.push_wait(event) catch |e| {
                    log.err("{!}\n", .{e}, @src());
                    return;
                };
            }
        }
    }
}

fn getParameter(effect: ?*vst2.AEffect, index: i32) callconv(.C) f32 {
    if (plugCast(effect).plugin) |plugin| {
        if (index >= 0 and index < plugin.param_info.len) {
            const id: usize = @intCast(index);
            return plugin.param_info[id].getNormalizedValue(plugin.params[id]);
        }
    }
    return 0;
}

fn init(alloc: std.mem.Allocator, host_callback: vst2.HostCallback) !*vst2.AEffect {
    const self = try alloc.create(VstPlugin);
    self.* = .{
        .effect = try alloc.create(vst2.AEffect),
        .plugin = Plugin.init(),
        .in_events = try arbor.Queue.init(alloc),
        .host_callback = host_callback orelse {
            log.err("host_callback is null\n", .{}, @src());
            return error.InitFailed;
        },
        .rect = .{ .top = 0, .left = 0, .bottom = 600, .right = 500 },
    };
    self.plugin.?.num_channels = 2; // TODO: DOn't hardcode
    self.effect.* = .{
        .dispatcher = dispatch,
        .processReplacing = processReplacing,
        .processDoubleReplacing = processDoubleReplacing,
        .setParameter = setParameter,
        .getParameter = getParameter,
        .num_programs = 0,
        .num_params = @intCast(self.plugin.?.param_info.len),
        .num_inputs = 2,
        .num_outputs = 2,
        .flags = .{
            .HasStateChunk = true,
            .HasReplacing = true,
            .HasEditor = (config.plugin_features & arbor.features.GUI > 0),
        },
        .latency = 0,
        .uniqueID = std.mem.bytesToValue(i32, "TODO"),
        .version = arbor.Vst2VersionInt(arbor.plugin_desc.version) catch |e| {
            log.fatal("{!}\n", .{e}, @src());
            return error.ParseVersionFailed;
        },
        .object = self,
    };
    return self.effect;
}

fn deinit(self: *VstPlugin, alloc: std.mem.Allocator) void {
    if (self.plugin) |plug| plug.interface.deinit(plug);
    alloc.destroy(self.effect);
    alloc.destroy(self);
}

export fn VSTPluginMain(callback: vst2.HostCallback) callconv(.C) ?*anyopaque {
    return init(allocator, callback) catch return null;
}
