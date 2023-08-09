//! Definition of a specific VST2 plugin implementation

const std = @import("std");
const c_cast = std.zig.c_translation.cast;
const vst2 = @import("vst2_api.zig");
const Plugin = @import("Plugin.zig");
const Gui = @import("Gui.zig");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

const Self = @This();

plugin: *Plugin,
effect: *vst2.AEffect,

edit_rect: vst2.Rect,

fn fromEffectPtr(effect: *vst2.AEffect) *const Self {
    return @fieldParentPtr(Self, "effect", &effect);
}

fn dispatch(
    effect: *vst2.AEffect,
    opcode: i32,
    index: i32,
    value: isize,
    ptr: ?*anyopaque,
    opt: f32,
) callconv(.C) isize {
    _ = opt;
    _ = value;
    _ = index;
    const self = fromEffectPtr(effect);
    // const code: vst2.Opcode = @enumFromInt(opcode);
    const code = std.meta.intToEnum(vst2.Opcode, opcode) catch return -1;
    switch (code) {
        .Open => {},
        .Close => {
            // defer _ = gpa.deinit();
            // self.plugin.deinit(allocator); // BUG: This is crashing. Invalid free of internal data, which doesn't exist yet
            // allocator.destroy(self.plugin);
            // allocator.destroy(self.effect);
            // allocator.destroy(self);
        },
        .GetVendorString => {
            if (ptr) |p| {
                var buf: [*]u8 = @ptrCast(p);
                const vendor = "Arboreal Audio";
                @memcpy(buf[0..vendor.len], vendor);
                return 1;
            }
            return 0;
        },
        .GetVendorVersion => {
            return 0x001;
        },
        .GetEffectName => {},
        .GetProductString => {},
        .GetInputProperties => {},
        .GetOutputProperties => {},
        .GetPlugCategory => {
            return @intFromEnum(vst2.Category.kPlugCategEffect);
        },
        .EditGetRect => {
            // set rect size & copy to ptr
            if (ptr) |p| {
                var out = c_cast(**vst2.Rect, p);
                out.* = @constCast(&self.edit_rect);
                return 1;
            }
        },
        .EditOpen => {
            // ptr = native parent window (HWND, NSView/NSWindow?)
            @breakpoint();
        },
        .EditClose => {},
        else => {},
    }
    return 0;
}

fn processReplacing(effect: *vst2.AEffect, inputs: [*][*]f32, outputs: [*][*]f32, frames: i32) callconv(.C) void {
    _ = effect;
    var i: u32 = 0;
    while (i < frames) : (i += 1) {
        outputs[0][i] = std.math.tanh(inputs[0][i]);
        outputs[1][i] = std.math.tanh(inputs[1][i]);
    }
}
fn processDoubleReplacing(effect: *vst2.AEffect, inputs: [*][*]f64, outputs: [*][*]f64, frames: i32) callconv(.C) void {
    _ = effect;
    _ = frames;
    _ = outputs;
    _ = inputs;
}

fn setParameter(effect: *vst2.AEffect, index: i32, value: f32) callconv(.C) void {
    _ = effect;
    _ = value;
    _ = index;
}
fn getParameter(effect: *vst2.AEffect, index: i32) callconv(.C) f32 {
    _ = effect;
    _ = index;
    return 0;
}

fn init(alloc: std.mem.Allocator) !*vst2.AEffect {
    var self = try alloc.create(Self);
    self.* = .{
        .effect = try alloc.create(vst2.AEffect),
        .plugin = try alloc.create(Plugin),
        .edit_rect = .{
            .left = 0,
            .top = 0,
            .bottom = Gui.GUI_HEIGHT,
            .right = Gui.GUI_WIDTH,
        },
    };
    self.effect.* = .{
        .dispatcher = dispatch,
        .processReplacing = processReplacing,
        .processDoubleReplacing = processDoubleReplacing,
        .setParameter = setParameter,
        .getParameter = getParameter,
        .num_programs = 0,
        .num_params = 0,
        .num_inputs = 2, // TODO: Get num channels (and other stuff below) from Config
        .num_outputs = 2,
        .flags = vst2.Flags.toInt(&[_]vst2.Flags{ vst2.Flags.CanReplacing, vst2.Flags.HasEditor }),
        .initial_delay = 0,
        .uniqueID = 0x666,
        .version = 0x001,
    };
    self.plugin.* = .{ .reverb = .{ .plugin = self.plugin } };
    return self.effect;
}

fn deinit(self: *Self, alloc: std.mem.Allocator) void {
    alloc.destroy(self);
}

export fn VSTPluginMain(callback: vst2.HostCallback) callconv(.C) ?*vst2.AEffect {
    _ = callback;
    return init(allocator) catch return null;
}
