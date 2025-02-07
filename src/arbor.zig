// Copyright (c) 2024 Arboreal Audio, LLC
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

//! Main source file for framework, collecting everything in one place
const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
pub const config = @import("config");
const Allocator = std.mem.Allocator;

pub const param = @import("params.zig");
pub const Parameter = param.Parameter;

pub const Format = enum {
    CLAP,
    VST2,
    // Big 'ol TODO: VST3,
};
const format = config.format;

pub const Gui = @import("gui/Gui.zig");

pub const dsp = @import("dsp/dsp.zig");

pub const clap = @import("clap_api.zig");
pub const vst2 = @import("vst2_api.zig");

/// User-defined plugin description, converted to format type
pub const plugin_desc: DescType = createFormatDescription();
pub const plugin_name = config.plugin_desc.name;

pub const Plugin = struct {
    pub const Description = struct {
        /// plugin name
        name: [:0]const u8,
        /// unique id for plugin, i.e. com.Company.Plugin
        id: [:0]const u8,
        /// company name
        company: [:0]const u8,
        /// version string
        version: [:0]const u8,
        /// copyright string
        copyright: [:0]const u8,
        /// url of your website, not that you need one. It's nice to have!
        url: [:0]const u8,
        /// contact url
        contact: [:0]const u8,
        /// link to user manual
        manual: [:0]const u8,
        /// short description of plugin
        description: [:0]const u8,
        // NOTE: Removed features from this struct until bugs w/ Zig build options are fixed
        // format-agnostic list of plugin features
        // features: []const PluginFeatures,
    };

    pub const Interface = struct {
        deinit: *const fn (*Plugin) void,
        prepare: *const fn (*Plugin, f32, u32) void,
        process: *const fn (*Plugin, AudioBuffer(f32)) void,
        // TODO: processDouble: *const fn (*Plugin, AudioBuffer(f64)) void,
        gui_init: ?*const fn (*Plugin) void = null,
    };

    /// User-provided initialization function
    pub extern fn init() *Plugin;

    /// Deinit a Plugin using the allocator passed to it in init().
    pub fn deinit(plugin: *Plugin) void {
        plugin.allocator.free(plugin.params);
        plugin.allocator.destroy(plugin);
    }

    interface: Interface,

    num_channels: u32 = undefined,
    sample_rate: f32 = undefined,
    max_frames: u32 = undefined,

    param_info: []const Parameter,
    params: []f32,
    user: ?*anyopaque = null,
    gui: ?*Gui = null,

    mutex: std.Thread.Mutex = .{},

    allocator: Allocator = std.heap.c_allocator,

    // functions for dealing with a plugin's parameters

    pub fn getParamValue(plugin: Plugin, comptime BaseType: type, name: [:0]const u8) BaseType {
        for (plugin.param_info, 0..) |p, i| {
            if (std.mem.orderZ(u8, p.name, name).compare(.eq)) {
                const val = plugin.params[i];
                switch (@typeInfo(BaseType)) {
                    .Float => return val,
                    .Int => return @intFromFloat(val),
                    .Bool => return @as(BaseType, @as(u1, @intFromFloat(val)) != 0),
                    .Enum => return @as(
                        BaseType,
                        @enumFromInt(@as(i32, @intFromFloat(val))),
                    ),
                    else => log.fatal("Invalid param type: {s}\n", .{@typeName(BaseType)}, @src()),
                }
            }
        }
        log.fatal("Param not found\n", .{}, @src());
    }

    pub fn getParamWithId(plugin: Plugin, id: u32) !*const Parameter {
        if (id >= plugin.params.len) return error.ParamNotFound;
        return &plugin.param_info[id];
    }

    pub fn getParamName(plugin: Plugin, id: u32) ![:0]const u8 {
        if (id >= plugin.params.len) return error.ParamNotFound;
        return plugin.param_info[id].name;
    }

    /// Get a pointer to the user's data, if they provided one
    pub fn getUser(plugin: *Plugin, comptime UserType: type) *UserType {
        if (plugin.user) |ptr| return cast(*UserType, ptr) else {
            log.fatal("User pointer is null\n", .{}, @src());
        }
    }
};

/// Initialize a Plugin. Caller owns the returned pointer and must free it by
/// calling "deinit".
pub fn init(
    allocator: Allocator,
    params: []const Parameter,
    interface: Plugin.Interface,
) *Plugin {
    const plug = allocator.create(Plugin) catch |e| log.fatal("Plugin create failed: {}\n", .{e}, @src());
    plug.* = .{
        .interface = interface,
        .param_info = params,
        .params = param.createSlice(allocator, params),
        .allocator = allocator,
    };
    return plug;
}

const DescType = switch (format) {
    .CLAP => clap.PluginDescriptor,
    .VST2 => Plugin.Description,
};

/// Create a description that satisfies the requirements of the format being
/// compiled for.
pub fn createFormatDescription() DescType {
    const desc = config.plugin_desc;
    switch (DescType) {
        clap.PluginDescriptor => {
            return .{
                .clap_version = clap.Version.init(),
                .id = desc.id.ptr,
                .name = desc.name.ptr,
                .vendor = desc.company.ptr,
                .version = desc.version.ptr,
                .url = desc.url.ptr,
                .support_url = desc.contact.ptr,
                .manual_url = desc.manual.ptr,
                .description = desc.description.ptr,
                .features = (parseClapFeatures(config.plugin_features) catch |e| {
                    log.fatal("Parse CLAP features failed: {!}\n", .{e}, @src());
                }).constSlice().ptr,
            };
        },
        Plugin.Description => return Plugin.Description{
            .name = desc.name,
            .id = desc.id,
            .company = desc.company,
            .version = desc.version,
            .url = desc.url,
            .contact = desc.contact,
            .manual = desc.manual,
            .description = desc.description,
            .copyright = desc.copyright,
        },
        else => @compileError("Unimplemented format"),
    }
}

// NOTE: Had to convert from an enum to C-style bit flags, since Zig build options
// generation seems bugged
/// Bit-packed list of supported plugin features, which will be converted to format-specific feature list
pub const PluginFeatures = u32;
pub const features = struct {
    pub const MONO = 1 << 0;
    pub const STEREO = 1 << 1;
    pub const SURROUND = 1 << 2;
    pub const AMBISONIC = 1 << 3;
    pub const EFFECT = 1 << 4;
    pub const DISTORTION = 1 << 5;
    pub const DYNAMICS = 1 << 6;
    pub const EQ = 1 << 7;
    pub const REVERB = 1 << 8;
    pub const PITCH_SHIFT = 1 << 9;
    pub const MASTERING = 1 << 10;
    pub const ANALYZER = 1 << 11;
    pub const RESTORATION = 1 << 12;
    pub const INSTRUMENT = 1 << 13;
    pub const SYNTH = 1 << 14;
    pub const SAMPLER = 1 << 15;
    pub const DRUM = 1 << 16;
    pub const GUI = 1 << 17;
};

// TODO: Improve this. Couldn't think of a better way to compare features.
// There's gotta be a simple data structure which can aid converting between
// our enum and a format's string representation.
pub const FeaturesArray = std.BoundedArray(?[*:0]const u8, 18); // < Imagine hard-coding the number of flags

pub fn parseClapFeatures(comptime feat: PluginFeatures) !FeaturesArray {
    const F = clap.PluginFeatures;
    var out = try FeaturesArray.init(0);

    if (feat & features.INSTRUMENT == 0 and feat & features.EFFECT == 0 and
        feat & features.ANALYZER == 0)
        @compileError("Must have one main CLAP feature: 'instrument', 'audio-effect', 'note-effect', or 'analyzer' ");

    if (feat & features.MONO > 0) try out.append(F.MONO);
    if (feat & features.STEREO > 0) try out.append(F.STEREO);
    if (feat & features.SURROUND > 0) try out.append(F.SURROUND);
    if (feat & features.AMBISONIC > 0) try out.append(F.AMBISONIC);
    if (feat & features.EFFECT > 0) try out.append(F.AUDIO_EFFECT);
    if (feat & features.DISTORTION > 0) try out.append(F.DISTORTION);
    if (feat & features.DYNAMICS > 0) try out.appendSlice(&.{ F.COMPRESSOR, F.GATE, F.EXPANDER });
    if (feat & features.EQ > 0) try out.append(F.EQUALIZER);
    if (feat & features.REVERB > 0) try out.append(F.REVERB);
    if (feat & features.PITCH_SHIFT > 0) try out.append(F.PITCH_SHIFTER);
    if (feat & features.MASTERING > 0) try out.append(F.MASTERING);
    if (feat & features.ANALYZER > 0) try out.append(F.ANALYZER);
    if (feat & features.RESTORATION > 0) try out.append(F.RESTORATION);
    if (feat & features.INSTRUMENT > 0) try out.append(F.INSTRUMENT);
    if (feat & features.SYNTH > 0) try out.append(F.SYNTHESIZER);
    if (feat & features.SAMPLER > 0) try out.append(F.SAMPLER);
    if (feat & features.DRUM > 0) try out.appendSlice(&.{ F.DRUM, F.DRUM_MACHINE });

    try out.append(null);

    return out;
}

pub fn parseVst2Features(comptime feat: PluginFeatures) vst2.Category {
    if (feat & features.EFFECT > 0) return .kPlugCategEffect;
    if (feat & features.SYNTH > 0) return .kPlugCategSynth;
    if (feat & features.ANALYZER > 0) return .kPlugCategAnalysis;
    if (feat & features.MASTERING > 0) return .kPlugCategMastering;
    if (feat & features.REVERB > 0) return .kPlugCategRoomFx;
    if (feat & features.RESTORATION > 0) return .kPlugCategRestoration;

    return .kPlugCategUnknown;
}

pub const Event = union(enum) {
    param_change: struct {
        id: usize,
        /// normalized value
        value: f32,
    },
};

pub const queue_size = 512;
pub const Queue = struct {
    const QueueArray = std.BoundedArray(Event, queue_size);
    events: QueueArray,
    mutex: std.Thread.Mutex = .{},
    allocator: Allocator,

    pub fn init(allocator: Allocator) !*Queue {
        const self = try allocator.create(Queue);
        self.* = .{
            .events = try QueueArray.init(0),
            .allocator = allocator,
        };
        return self;
    }

    pub fn deinit(self: *Queue) void {
        self.allocator.destroy(self);
    }

    pub fn push_try(self: *Queue, event: Event) !void {
        if (self.mutex.tryLock()) {
            defer self.mutex.unlock();
            try self.events.append(event);
        }
    }

    pub fn push_wait(self: *Queue, event: Event) !void {
        self.mutex.lock();
        defer self.mutex.unlock();
        try self.events.append(event);
    }

    pub fn push_no_lock(self: *Queue, event: Event) !void {
        try self.events.append(event);
    }

    pub fn next_try(self: *Queue) ?Event {
        if (self.mutex.tryLock()) {
            defer self.mutex.unlock();
            return self.events.popOrNull();
        } else return null;
    }

    pub fn next_wait(self: *Queue) ?Event {
        self.mutex.lock();
        defer self.mutex.unlock();
        return self.events.popOrNull();
    }

    pub fn next_no_lock(self: *Queue) ?Event {
        return self.events.popOrNull();
    }
};

/// Generic audio buffer
pub fn AudioBuffer(comptime FloatType: type) type {
    return struct {
        input: []const []const FloatType,
        output: []const []FloatType,
        num_ch: usize,
        frames: usize,
    };
}

// Specifically implementing this to replace CLAP timer right now, could be
// made more generic in the future
pub const Timer = struct {
    const time = std.time;
    const Thread = std.Thread;

    time_ms: u32,
    should_run: bool = true,
    thread_handle: Thread = undefined,
    allocator: Allocator,

    cb: *const fn (*Plugin) void,
    plugin: *Plugin,

    pub fn init(
        allocator: Allocator,
        time_ms: u32,
        cb: *const fn (*Plugin) void,
        plugin: *Plugin,
    ) !*Timer {
        const self = try allocator.create(Timer);
        self.* = .{
            .cb = cb,
            .plugin = plugin,
            .time_ms = time_ms,
            .allocator = allocator,
            .thread_handle = try Thread.spawn(.{}, timer_loop, .{self}),
        };
        return self;
    }

    pub fn deinit(self: *Timer) void {
        self.should_run = false;
        self.thread_handle.join();
        self.allocator.destroy(self);
    }

    pub fn timer_loop(self: *Timer) void {
        while (self.should_run) {
            self.cb(self.plugin);
            time.sleep(self.time_ms * time.ns_per_ms);
        }
    }
};

// UTILS //

/// Extern-compatible slice
pub fn Slice(comptime T: type) type {
    return extern struct {
        ptr: [*]T,
        len: usize,

        pub fn make(ptr: [*]T, len: usize) Slice(T) {
            return Slice(T){
                .ptr = ptr,
                .len = len,
            };
        }

        pub fn slice(self: Slice(T)) []T {
            return self.ptr[0..self.len];
        }
    };
}

pub const log = struct {
    const format_str = @tagName(format);
    const pre = plugin_name ++ " " ++ format_str ++ ": " ++
        "{s}:{s}:{d}: ";
    /// debug logger which gets compiled out in release modes
    pub fn debug(
        comptime fmt: []const u8,
        args: anytype,
        comptime src: std.builtin.SourceLocation,
    ) void {
        if (builtin.mode == .Debug)
            std.debug.print(pre ++ fmt, .{ src.file, src.fn_name, src.line } ++ args);
    }

    /// default info
    pub fn info(
        comptime fmt: []const u8,
        args: anytype,
        comptime src: std.builtin.SourceLocation,
    ) void {
        std.log.info(pre ++ fmt, .{ src.file, src.fn_name, src.line } ++ args);
    }

    /// default nonfatal error
    pub fn err(
        comptime fmt: []const u8,
        args: anytype,
        comptime src: std.builtin.SourceLocation,
    ) void {
        std.log.err(pre ++ fmt, .{ src.file, src.fn_name, src.line } ++ args);
    }

    /// default fatal error
    pub fn fatal(
        comptime fmt: []const u8,
        args: anytype,
        comptime src: std.builtin.SourceLocation,
    ) noreturn {
        std.log.err(pre ++ fmt, .{ src.file, src.fn_name, src.line } ++ args);
        std.process.exit(1);
    }
};

pub fn cast(comptime DestType: type, ptr: anytype) DestType {
    return @alignCast(@ptrCast(ptr));
}

pub fn Vst2VersionInt(comptime version: []const u8) !i32 {
    var v: [version.len]u8 = undefined;
    @memcpy(&v, version);
    std.mem.replaceScalar(u8, &v, '.', '_');
    // gotta multiply by 10 since 4 digits are expected (who uses 4 digits in versioning??)
    return 10 * try std.fmt.parseInt(i32, &v, 0);
}
