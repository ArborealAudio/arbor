//! Definition of a specific VST2 plugin implementation

const std = @import("std");
const arbor = @import("arbor.zig");
const log = arbor.log;
const builtin = @import("builtin");
const vst2 = @import("vst2_api.zig");
const Plugin = arbor.Plugin;
const param = arbor.param;
// const Gui = @import("Gui.zig");
// const PlatformGui = @import("platform");

const allocator = std.heap.c_allocator;

const Self = @This();

// vst2-specific data
effect: *vst2.AEffect,
host_callback: *const fn (
    effect: *vst2.AEffect,
    opcode: i32,
    index: i32,
    value: isize,
    ptr: ?*anyopaque,
    opt: f32,
) callconv(.C) isize,
plugin: ?*Plugin = null, // our specific plugin data
state: vst2.PluginState = undefined,
rect: vst2.Rect,

fn plugCast(effect: ?*const vst2.AEffect) *Self {
    return @ptrCast(@alignCast(effect.object));
}

fn dispatch(
    effect: *vst2.AEffect,
    opcode: i32,
    index: i32,
    value: isize,
    ptr: ?*anyopaque,
    opt: f32,
) callconv(.C) isize {
    var self = plugCast(effect);
    const code = std.meta.intToEnum(vst2.Opcode, opcode) catch return -1;
    switch (code) {
        .Open => {
            // ISSUE: Hardcoding srate and block size
            // trying instead to use plugin's own values. Do they get set before Open is called?
            // Or should we actually allocate teh user plugin here, and then call prepare right
            // after?
            self.plugin.prepare(
                allocator,
                self.plugin.sample_rate,
                self.plugin.maxNumSamples,
            ) catch |e| {
                std.log.err("Plugin init error {}\n", .{e});
                std.process.exit(1);
            };
            return 1;
        },
        .Close => {
            self.deinit(allocator);
            // _ = gpa.deinit();
            return 1;
        },
        .GetVendorString => {
            if (ptr) |p| {
                var buf: [*]u8 = @ptrCast(p);
                const vendor = Plugin.Description.vendor_name;
                _ = std.fmt.bufPrintZ(buf[0..vendor.len :0], "{s}", .{vendor}) catch |e| {
                    std.log.err("{}\n", .{e});
                    return -1;
                };
                return 1;
            }
        },
        .GetVendorVersion => {
            return arbor.plugin_desc.version_int;
        },
        .GetProductString => {
            if (ptr) |p| {
                var buf: [*]u8 = @ptrCast(p);
                const name = arbor.plugin_desc.name;
                _ = std.fmt.bufPrintZ(buf[0..name.len :0], "{s}", .{name}) catch |e| {
                    std.log.err("{}\n", .{e});
                    return -1;
                };
                return 1;
            }
        },
        .GetPlugCategory => {
            return @intFromEnum(vst2.Category.kPlugCategEffect);
        },
        .GetParamName => {
            if (index >= 0 and index < Params.num_params) {
                if (ptr) |p| {
                    const name = Params.idToName(@intCast(index)) catch {
                        std.log.err("Can't find param\n", .{});
                        return -1;
                    };
                    var buf: [*]u8 = @ptrCast(p);
                    // name length + 1 for null terminator--using :0 doesn't work for some reason
                    _ = std.fmt.bufPrintZ(buf[0 .. name.len + 1], "{s}", .{name}) catch |e| {
                        std.log.err("{}\n", .{e});
                        return -1;
                    };
                }
                return 1;
            }
            return 0;
        },
        // Param value as text
        .GetParamText => {
            if (index >= 0 and index < Params.num_params) {
                const val = self.plugin.params.idToValue(@intCast(index)) catch {
                    std.log.err("Can't find param\n", .{});
                    return -1;
                };
                if (ptr) |p| {
                    var buf: [*]u8 = @ptrCast(p);
                    _ = std.fmt.bufPrintZ(buf[0..5], "{d:.2}", .{val}) catch |e| {
                        std.log.err("{}\n", .{e});
                        return -1;
                    };
                    return 1;
                }
            }
            return 0;
        },
        .SetSampleRate => {
            // Do we need to wrap this in a mutex & re-init the plugin? Delay lines etc. will need resizing
            self.plugin.sample_rate = @floatCast(opt);
            self.plugin.prepare(allocator, self.plugin.sample_rate, self.plugin.maxNumSamples) catch |e| {
                std.log.err("Plugin init error: {}\n", .{e});
                return -1;
            };
            return 1;
        },
        .CanBeAutomated => return 1,
        .SetBlockSize => {
            // Do we need to wrap this in a mutex & re-init the plugin? Delay lines etc. will need resizing
            self.plugin.maxNumSamples = @intCast(value);
            return 1;
        },
        .EditGetRect => {
            // copy to ptr
            if (ptr) |*p| {
                var dest = p;
                dest = @alignCast(@ptrCast(&self.rect));
                return 1;
            }
        },
        .EditOpen => {
            // Init GUI
            // ptr = native parent window (HWND, NSView/NSWindow?, X Window)
            std.debug.assert(self.plugin.gui == null);
            self.plugin.gui = Gui.init(allocator, self.plugin) catch |e| {
                std.log.err("GUI init failed: {}\n", .{e});
                return -1;
            };

            if (ptr) |p|
                PlatformGui.guiSetParent(self.plugin.gui.?.impl, if (builtin.os.tag == .linux)
                    @intFromPtr(p)
                else
                    p)
            else
                return 0;
            PlatformGui.guiRender(self.plugin.gui.?.impl, true);
            return 1;
        },
        .EditRedraw => {
            // Update & Draw GUI
            // Probably need to check whether redraw is needed
            std.debug.assert(self.plugin.gui != null);
            PlatformGui.guiRender(self.plugin.gui.?.impl, true);
        },
        .EditClose => {
            // Close GUI
            std.debug.assert(self.plugin.gui != null);
            std.debug.print("Closing GUI\n", .{});
            self.plugin.gui.?.deinit(allocator);
            self.plugin.gui = null;
            return 1;
        },
        .GetVstVersion => return 2400,
        .CanDo => return -1,
        .GetChunk => {
            if (ptr) |p| {
                var dest = &p;
                dest = @alignCast(@ptrCast(&self.state));
            }
        },
        .SetChunk => {
            self.state = @as(*vst2.PluginState, @alignCast(@ptrCast(ptr))).*;
            return 1;
        },
        else => {},
    }
    return 0;
}

fn processReplacing(
    effect: *vst2.AEffect,
    inputs: [*][*]f32,
    outputs: [*][*]f32,
    frames: i32,
) callconv(.C) void {
    if (plugCast(effect).plugin) |plugin| {
        const buffer: arbor.AudioBuffer = .{
            .input = inputs,
            .output = outputs,
            .num_samples = frames,
            .num_ch = plugin.num_channels,
        };
        plugin.process(buffer);
    }
}
fn processDoubleReplacing(
    effect: *vst2.AEffect,
    inputs: [*][*]f64,
    outputs: [*][*]f64,
    frames: i32,
) callconv(.C) void {
    _ = effect;
    _ = frames;
    _ = outputs;
    _ = inputs;
}

fn setParameter(effect: *vst2.AEffect, index: i32, value: f32) callconv(.C) void {
    if (plugCast(effect).plugin) |plugin| {
        if (index >= 0 and index < plugin.param_info.len) {
            // TODO: Wrap in mutex
            // self.plugin.params.setValue(@intCast(index), @floatCast(value));
            // if (self.plugin.gui) |gui| {
            //     gui.components[@intCast(index)].value =
            //         self.plugin.params.getNormalizedValue(@intCast(index)) catch {
            //         @panic("Couldn't find param\n");
            //     };
            // }
            plugin.processEvent(@intCast(index));
        }
    }
}
fn getParameter(effect: *vst2.AEffect, index: i32) callconv(.C) f32 {
    if (plugCast(effect).plugin) |plugin| {
        if (index >= 0 and index < plugin.param_info.len) {
            // TODO: Wrap in mutex
            const val = plugin.params[index];
            return @floatCast(val);
        }
    }
    return 0;
}

fn init(alloc: std.mem.Allocator, host_callback: vst2.HostCallback) !*vst2.AEffect {
    const self = try alloc.create(Self);
    self.* = .{
        .effect = try alloc.create(vst2.AEffect),
        .plugin = Plugin.init(alloc),
        .host_callback = host_callback,
        // .rect = .{ .top = 0, .left = 0, .bottom = Gui.GUI_HEIGHT, .right = Gui.GUI_WIDTH },
    };
    self.effect.* = .{
        .dispatcher = dispatch,
        .deprecated_process = null,
        .processReplacing = processReplacing,
        .processDoubleReplacing = processDoubleReplacing,
        .setParameter = setParameter,
        .getParameter = getParameter,
        .num_programs = 0,
        // .num_params = arbor.,
        .num_inputs = 2, // TODO: Get num channels (and other stuff below) from Config
        .num_outputs = 2,
        .flags = vst2.Flags.toInt(&[_]vst2.Flags{ .HasReplacing, .HasEditor }),
        .latency = 0,
        .uniqueID = 0x666,
        .version = Plugin.Description.version_int,
        .object = self,
    };
    return self.effect;
}

fn deinit(self: *Self, alloc: std.mem.Allocator) void {
    self.plugin.deinit(alloc);
    alloc.destroy(self.effect);
    alloc.destroy(self);
}

export fn VSTPluginMain(callback: vst2.HostCallback) callconv(.C) ?*anyopaque {
    return init(allocator, callback) catch return null;
}
