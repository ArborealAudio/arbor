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
pub const Gui = @import("Gui.zig");

pub const clap = @import("clap_api.zig");

pub const AudioBuffer = extern struct {
    input: extern struct { ptr: [*]const [*]const f32 },
    output: extern struct { ptr: [*][*]f32 },
    num_ch: usize,
    num_samples: usize,
};

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

    params: []f32,
    user: ?*anyopaque = null,
    // TODO: don't anyopaque. It has a memory layout dammit!
    gui: ?*anyopaque = null,

    allocator: std.mem.Allocator = std.heap.c_allocator,

    pub extern fn init() *Plugin;
    pub extern fn deinit(*Plugin) void;
    pub extern fn prepare(*Plugin, f32, u32) void;
    pub extern fn process(*Plugin, AudioBuffer) void;
};

pub extern const plugin_desc: DescType;
// NOTE: THIs sucks, do something else!!
pub extern const plugin_params: [1]Parameter;

pub fn configure(
    allocator: std.mem.Allocator,
    params: []const Parameter,
) *Plugin {
    const plug = allocator.create(Plugin) catch |e| log.fatal("Plugin create failed: {}\n", .{e});
    plug.* = .{
        .params = param.createSlice(allocator, params),
        .allocator = allocator,
    };
    return plug;
}

const DescType = switch (format) {
    .CLAP => clap.PluginDescriptor,
    else => @panic("Unimplemented format\n"),
};

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

pub const String = extern struct {
    ptr: [*]const u8,
    len: usize,
};

// /// get a compile-time struct with information about the plugin
// pub fn Config(comptime UserPlugin: type) type {
//     return struct {
//         /// format-specific description
//         plugin_description: DescType = getFormatDescription(UserPlugin, DescType),
//         /// all plugin parameter values
//         plugin_params: []f32 = undefined,

//         allocator: std.mem.Allocator = if (@hasDecl(UserPlugin, "allocator"))
//             UserPlugin.allocator
//         else
//             std.heap.c_allocator,

//         pub fn init(self: *@This()) void {
//             self.plugin_params = param.createSlice(
//                 self.allocator,
//             ) catch |e|
//                 log.fatal("Failed to create params slice: {}\n", .{e});
//         }

//         pub fn deinit(self: *@This()) void {
//             self.allocator.free(self.plugin_params);
//         }
//     };
// }

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

// test "Init" {
//     const Plugin = struct {
//         var arena = std.heap.ArenaAllocator.init(std.heap.c_allocator);
//         // if not pub, results in invalid free
//         pub const allocator = arena.allocator();
//         pub const Desc = PluginDescription{
//             .id = "com.ArborealAudio.ZigVerb",
//             .name = "Example Distortion",
//             .company = "Arboreal Audio",
//             .version = "0.1",
//             .url = "https://arborealaudio.com",
//             .contact = "contact@arborealaudio.com",
//             .manual = "www.website.com/manual",
//             .description = "Basic distortion plugin",
//         };

//         pub const Mode = enum {
//             Vintage,
//             Modern,
//         };

//         pub const params = [_]param.Parameter{
//             param.create("Gain", .{ 1.0, 12.0, 1.0 }),
//             param.create("Mode", .{Mode.Vintage}),
//         };
//     };
//     defer Plugin.arena.deinit();

//     var config: Config(Plugin) = .{};
//     config.init();
//     defer config.deinit();
//     try std.testing.expectEqual(Plugin.Desc.name.ptr, config.plugin_description.name);
//     const gain_ptr = config.plugin_params[0];
//     gain_ptr.* = 6;
//     try std.testing.expectEqual(6, config.plugin_params[0].*);
// }
