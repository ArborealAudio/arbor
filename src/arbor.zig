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
const assert = std.debug.assert;

const plugin_description = @import("plugin_description.zig");
const Description = plugin_description.Description;
const PluginConfig = plugin_description.PluginConfig;
const PluginFeatures = plugin_description.PluginFeatures;
const Format = plugin_description.Format;
pub const config: PluginConfig = @import("config");
pub const format = @import("build_options").format;

const Allocator = std.mem.Allocator;

pub const param = @import("params.zig");
pub const Parameter = param.Parameter;

pub const Gui = @import("gui/Gui.zig");

pub const dsp = @import("dsp/dsp.zig");

pub const clap = @import("clap_api.zig");
pub const vst2 = @import("vst2_api.zig");
pub const vst3 = @import("vst3_api.zig");

/// User-defined plugin description, converted to format type
pub const plugin_desc = config.description;
pub const plugin_name = plugin_desc.name;

pub const Plugin = struct {
    pub const Interface = struct {
        deinit: *const fn (*Plugin) void,
        prepare: *const fn (*Plugin, f32, u32) void,
        process: *const fn (*Plugin, AudioBuffer(f32)) void,
        createGui: ?*const fn (*Plugin) void = null,
        // TODO: processDouble: *const fn (*Plugin, AudioBuffer(f64)) void,
    };

    /// User-provided initialization function
    pub extern fn init() *Plugin;

    /// Deinit a Plugin using the allocator passed to it in init().
    pub fn deinit(plugin: *Plugin) void {
        plugin.allocator.free(plugin.params);
        plugin.allocator.destroy(plugin);
    }

    interface: Interface,

    num_channels: u32,
    sample_rate: f32 = undefined,
    max_frames: u32 = undefined,

    param_info: []const Parameter,
    params: []f32,
    user: ?*anyopaque = null,
    gui: ?*Gui = null,

    mutex: std.Thread.Mutex = .{},

    allocator: Allocator,

    // functions for dealing with a plugin's parameters

    pub fn getParamValue(plugin: Plugin, comptime BaseType: type, name: [:0]const u8) BaseType {
        for (plugin.param_info, 0..) |p, i| {
            if (std.mem.orderZ(u8, p.name, name).compare(.eq)) {
                const val = plugin.params[i];
                switch (@typeInfo(BaseType)) {
                    .float => return val,
                    .int => return @intFromFloat(val),
                    .bool => return @as(BaseType, @as(u1, @intFromFloat(val)) != 0),
                    .@"enum" => return @as(
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
    /// TODO rename this function to be clearer as to its purpose
    pub fn getUser(plugin: *Plugin, comptime UserType: type) *UserType {
        if (plugin.user) |ptr| return cast(*UserType, ptr) else {
            log.fatal("User pointer is null\n", .{}, @src());
        }
    }
};

pub const InitOptions = struct {
    allocator: ?Allocator = null,
    num_inputs: u32,
    num_outputs: u32,
    params: []const Parameter,
    interface: Plugin.Interface,
    user_data: ?*anyopaque = null,
};

/// Initialize a Plugin. Caller owns the returned pointer and must free it by
/// calling `deinit`.
pub fn createPlugin(options: InitOptions) *Plugin {
    const allocator = options.allocator orelse std.heap.c_allocator;
    const plug = allocator.create(Plugin) catch |e|
        log.fatal("Plugin create failed: {}\n", .{e}, @src());
    plug.* = .{
        .interface = options.interface,
        .num_channels = @max(options.num_inputs, options.num_outputs),
        .param_info = options.params,
        .params = param.createSlice(allocator, options.params),
        .allocator = allocator,
        .user = options.user_data,
    };
    return plug;
}

const DescType = switch (format) {
    .CLAP => clap.PluginDescriptor,
    .VST2 => Description,
};

/// Create a description that satisfies the requirements of the format being compiled for.
pub fn createFormatDescription() DescType {
    const desc = config.description;
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
                .features = parseClapFeatures(config.features).ptr,
            };
        },
        Description => return desc,
        else => @compileError("Unimplemented format"),
    }
}

const num_features = std.meta.fields(PluginFeatures).len;

pub fn parseClapFeatures(comptime feat: PluginFeatures) []const ?[*:0]const u8 {
    const F = clap.PluginFeatures;
    const Array = struct {
        var idx: usize = 0;
        var buf: [num_features]?[*:0]const u8 = undefined;
        pub fn append(comptime opt: ?[*:0]const u8) void {
            buf[idx] = opt;
            idx += 1;
        }
        pub fn appendSlice(comptime slice: []const [:0]const u8) void {
            for (slice) |s| {
                append(s);
            }
        }
    };

    if (!feat.instrument and !feat.effect and !feat.analyzer)
        @compileError("Must have one main CLAP feature: 'instrument', 'audio-effect', 'note-effect', or 'analyzer' ");

    if (feat.mono) Array.append(F.MONO);
    if (feat.stereo) Array.append(F.STEREO);
    if (feat.surround) Array.append(F.SURROUND);
    if (feat.ambisonic) Array.append(F.AMBISONIC);
    if (feat.effect) Array.append(F.AUDIO_EFFECT);
    if (feat.distortion) Array.append(F.DISTORTION);
    if (feat.dynamics) Array.appendSlice(&.{ F.COMPRESSOR, F.GATE, F.EXPANDER });
    if (feat.eq) Array.append(F.EQUALIZER);
    if (feat.reverb) Array.append(F.REVERB);
    if (feat.pitch_shift) Array.append(F.PITCH_SHIFTER);
    if (feat.mastering) Array.append(F.MASTERING);
    if (feat.analyzer) Array.append(F.ANALYZER);
    if (feat.restoration) Array.append(F.RESTORATION);
    if (feat.instrument) Array.append(F.INSTRUMENT);
    if (feat.synth) Array.append(F.SYNTHESIZER);
    if (feat.sampler) Array.append(F.SAMPLER);
    if (feat.drum) Array.appendSlice(&.{ F.DRUM, F.DRUM_MACHINE });

    Array.append(null);

    return &Array.buf;
}

pub fn parseVst2Features(comptime feat: PluginFeatures) vst2.Category {
    if (feat.effect) return .kPlugCategEffect;
    if (feat.synth) return .kPlugCategSynth;
    if (feat.analyzer) return .kPlugCategAnalysis;
    if (feat.mastering) return .kPlugCategMastering;
    if (feat.reverb) return .kPlugCategRoomFx;
    if (feat.restoration) return .kPlugCategRestoration;

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
    const QueueArray = std.ArrayList(Event);
    events: QueueArray,
    mutex: std.Thread.Mutex = .{},
    allocator: Allocator,

    pub fn init(allocator: Allocator) !*Queue {
        const self = try allocator.create(Queue);
        self.* = .{
            .events = try QueueArray.initCapacity(allocator, queue_size),
            .allocator = allocator,
        };
        return self;
    }

    pub fn deinit(self: *Queue) void {
        self.events.deinit(self.allocator);
        self.allocator.destroy(self);
    }

    pub fn push_try(self: *Queue, event: Event) !void {
        if (self.mutex.tryLock()) {
            defer self.mutex.unlock();
            try self.events.appendBounded(event);
        }
    }

    pub fn push_wait(self: *Queue, event: Event) !void {
        self.mutex.lock();
        defer self.mutex.unlock();
        try self.events.appendBounded(event);
    }

    pub fn push_no_lock(self: *Queue, event: Event) !void {
        try self.events.appendBounded(event);
    }

    pub fn next_try(self: *Queue) ?Event {
        if (self.mutex.tryLock()) {
            defer self.mutex.unlock();
            return self.events.pop();
        } else return null;
    }

    pub fn next_wait(self: *Queue) ?Event {
        self.mutex.lock();
        defer self.mutex.unlock();
        return self.events.pop();
    }

    pub fn next_no_lock(self: *Queue) ?Event {
        return self.events.pop();
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
        if (@import("builtin").mode != .Debug) return;
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
    return @ptrCast(@alignCast(ptr));
}

pub fn Vst2VersionInt(comptime version: []const u8) !i32 {
    var v: [version.len]u8 = undefined;
    @memcpy(&v, version);
    std.mem.replaceScalar(u8, &v, '.', '_');
    // gotta multiply by 10 since 4 digits are expected (who uses 4 digits in versioning??)
    return 10 * try std.fmt.parseInt(i32, &v, 0);
}
