//! Main source file for framework, collecting everything in one place

const std = @import("std");
const assert = std.debug.assert;
// ISSUE: Build options appears to be bugged, it won't allow import
// const build_options = @import("build_options");

pub const param = @import("params.zig");
pub const Parameter = param.Parameter;
pub const Format = enum { CLAP, VST3, VST2 };
// const format = build_options.format;
const format = Format.CLAP;
pub const Gui = @import("gui/Gui.zig");

pub const clap = @import("clap_api.zig");

/// User-defined plugin description, converted to format type
pub extern const plugin_desc: DescType;

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
        /// url of your website
        url: [:0]const u8,
        /// contact url
        contact: [:0]const u8,
        /// link to user manual
        manual: [:0]const u8,
        /// short description of plugin
        description: [:0]const u8,
        /// format-agnostic list of plugin features
        features: []const PluginFeatures,
    };

    pub extern fn init() *Plugin;

    pub const Interface = struct {
        deinit: *const fn (*Plugin) void,
        prepare: *const fn (*Plugin, f32, u32) void,
        process: *const fn (*Plugin, AudioBuffer(f32)) void,
        // processDouble: *const fn (*Plugin, AudioBuffer(f64)) void,
    };

    interface: Interface,

    num_channels: u32 = undefined,

    param_info: []const Parameter,
    params: []f32,
    user: ?*anyopaque = null,
    gui: ?*Gui = null,

    mutex: std.Thread.Mutex = .{},

    allocator: std.mem.Allocator = std.heap.c_allocator,

    pub fn getParamValue(plugin: Plugin, comptime BaseType: type, name: [:0]const u8) BaseType {
        for (plugin.param_info, 0..) |p, i| {
            if (std.mem.orderZ(u8, p.name, name).compare(.eq)) {
                const val = plugin.params[i];
                switch (@typeInfo(BaseType)) {
                    .Float => return val,
                    .Int => return @intFromFloat(val),
                    .Bool => return @as(bool, @intFromFloat(val)),
                    .Enum => return @as(
                        BaseType,
                        @enumFromInt(@as(i32, @intFromFloat(val))),
                    ),
                    else => log.fatal("Invalid param type: {s}\n", .{@typeName(BaseType)}),
                }
            }
        }
        log.fatal("Param not found\n", .{});
    }

    pub fn getParamId(plugin: Plugin, id: u32) !*const Parameter {
        if (id >= plugin.params.len) return error.ParamNotFound;
        return &plugin.param_info[id];
    }

    pub fn getParamName(plugin: Plugin, id: u32) ![:0]const u8 {
        if (id >= plugin.params.len) return error.ParamNotFound;
        return plugin.param_info[id].name;
    }

    pub fn pollGuiEvents(plugin: *Plugin) void {
        const gui = plugin.gui orelse {
            log.err("How did this get called if GUI is null?\n", .{});
            return;
        };
        while (gui.nextOutEvent()) |event| {
            switch (event) {
                // NOTE: We should decide on a convention for whether or not
                // the param values from the GUI are expected to be normalized
                // or not.
                .param_change => |change| {
                    plugin.mutex.lock();
                    defer plugin.mutex.unlock();
                    const p = plugin.param_info[change.id];
                    plugin.params[change.id] = p.valueFromNormalized(change.value);
                },
            }
        }
    }
};

/// Initialize a Plugin. Caller owns the returned pointer and must free it by
/// calling "deinit".
pub fn init(
    allocator: std.mem.Allocator,
    params: []const Parameter,
    interface: Plugin.Interface,
) *Plugin {
    const plug = allocator.create(Plugin) catch |e| log.fatal("Plugin create failed: {}\n", .{e});
    plug.* = .{
        .interface = interface,
        .param_info = params,
        .params = param.createSlice(allocator, params),
        .allocator = allocator,
    };
    return plug;
}

// NOTE: SHould we call the user's deinit fn here rather than expect them to call this?
/// Deinit a Plugin using the allocator passed to it in init().
pub fn deinit(plugin: *Plugin) void {
    plugin.allocator.free(plugin.params);
    plugin.allocator.destroy(plugin);
}

const DescType = switch (format) {
    .CLAP => clap.PluginDescriptor,
    else => @panic("Unimplemented format\n"),
};

/// Create a description that satisfies the requirements of the format being
/// compiled for.
pub fn createFormatDescription(comptime desc: Plugin.Description) DescType {
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
                .features = (parseClapFeatures(desc.features) catch |e| {
                    log.fatal("Parse CLAP features failed: {!}\n", .{e});
                }).constSlice().ptr,
            };
        },
        else => @compileError("Unimplemented format"),
    }
}

/// Generic audio buffer
pub fn AudioBuffer(comptime FloatType: type) type {
    return struct {
        input: [*]const [*]const FloatType,
        output: [*]const [*]FloatType,
        num_ch: usize,
        frames: usize,
        /// For now, this is necessary w/ sample-accurate automation
        offset: usize,
    };
}

/// List of supported plugin features, which will be converted to format-specific feature list
pub const PluginFeatures = enum {
    mono,
    stereo,
    surround,
    ambisonic,
    effect,
    distortion,
    dynamics,
    eq,
    reverb,
    pitch_shift,
    mastering,
    analyzer,
    restoration,
    instrument,
    synth,
    sampler,
    drum,
    count,
};

// TODO: Improve this. Couldn't think of a better way to compare features.
// There's gotta be a simple data structure which can aid converting between
// our enum and a format's string representation.
pub const FeaturesArray = std.BoundedArray(?[*:0]const u8, @intFromEnum(PluginFeatures.count));

pub fn parseClapFeatures(feat: []const PluginFeatures) !FeaturesArray {
    const F = clap.PluginFeatures;
    var out = try FeaturesArray.init(0);
    for (feat) |f| {
        switch (f) {
            .mono => try out.append(F.MONO),
            .stereo => try out.append(F.STEREO),
            .surround => try out.append(F.SURROUND),
            .ambisonic => try out.append(F.AMBISONIC),
            .effect => try out.append(F.AUDIO_EFFECT),
            .distortion => try out.append(F.DISTORTION),
            .dynamics => try out.appendSlice(&.{ F.COMPRESSOR, F.GATE, F.EXPANDER }),
            .eq => try out.append(F.EQUALIZER),
            .reverb => try out.append(F.REVERB),
            .pitch_shift => try out.append(F.PITCH_SHIFTER),
            .mastering => try out.append(F.MASTERING),
            .analyzer => try out.append(F.ANALYZER),
            .restoration => try out.append(F.RESTORATION),
            .instrument => try out.append(F.INSTRUMENT),
            .synth => try out.append(F.SYNTHESIZER),
            .sampler => try out.append(F.SAMPLER),
            .drum => try out.appendSlice(&.{ F.DRUM, F.DRUM_MACHINE }),
            .count => {
                log.err("Don't actually pass `.count`. That's for internal use\n", .{});
                return error.UserPassedEnumCount;
            },
        }
    }

    try out.append(null);

    return out;
}

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
    /// default info
    pub fn info(comptime fmt: []const u8, args: anytype) void {
        std.log.info(fmt, args);
    }

    /// default nonfatal error
    pub fn err(comptime fmt: []const u8, args: anytype) void {
        std.log.err(fmt, args);
    }

    /// default fatal error
    pub fn fatal(comptime fmt: []const u8, args: anytype) noreturn {
        std.log.err(fmt, args);
        std.process.exit(1);
    }
};

pub fn cast(comptime DestType: type, ptr: anytype) DestType {
    return @alignCast(@ptrCast(ptr));
}
