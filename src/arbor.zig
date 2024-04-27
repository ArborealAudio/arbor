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
        // TODO: Plugin features
    };

    num_channels: u32 = undefined,

    param_info: []const Parameter,
    params: []f32,
    user: ?*anyopaque = null,
    gui: ?*Gui = null,

    allocator: std.mem.Allocator = std.heap.c_allocator,

    pub extern fn init() *Plugin;
    pub extern fn deinit(*Plugin) void;
    pub extern fn prepare(*Plugin, f32, u32) void;
    pub extern fn process(*Plugin, AudioBuffer(f32)) void;
    pub extern fn processDouble(*Plugin, AudioBuffer(f64)) void;

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
};

/// User-defined plugin description, converted to format type
pub extern const plugin_desc: DescType;

/// Initialize a Plugin. Caller owns the returned pointer and must free it by
/// calling "deinit".
pub fn init(
    allocator: std.mem.Allocator,
    params: []const Parameter,
) *Plugin {
    const plug = allocator.create(Plugin) catch |e| log.fatal("Plugin create failed: {}\n", .{e});
    plug.* = .{
        .param_info = params,
        .params = param.createSlice(allocator, params),
        .allocator = allocator,
    };
    return plug;
}

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
pub fn createFormatDescription(desc: Plugin.Description) DescType {
    switch (DescType) {
        clap.PluginDescriptor => {
            return .{
                .clap_version = clap.Version.fromString(desc.version) catch {
                    log.fatal("Failed to create CLAP version", .{});
                },
                .id = desc.id.ptr,
                .name = desc.name.ptr,
                .vendor = desc.company.ptr,
                .version = desc.version.ptr,
                .url = desc.url.ptr,
                .support_url = desc.contact.ptr,
                .manual_url = desc.manual.ptr,
                .description = desc.description.ptr,
                .features = null, // TODO: PLugin features
            };
        },
        else => @compileError("Unimplemented format"),
    }
}

/// Generic audio buffer
pub fn AudioBuffer(comptime FloatType: type) type {
    return extern struct {
        input: [*]const [*]const FloatType,
        output: [*][*]FloatType,
        num_ch: usize,
        num_samples: usize,
    };
}

// UTILS //

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
