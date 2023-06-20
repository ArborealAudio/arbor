//! vst3_plugin.zig
//! Definition of VST3 implementation

const std = @import("std");
const sb = @import("vst3_api.zig");
const Plugin = @import("Plugin.zig");

const gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

// Entry point
export fn GetPluginFactory() *sb.IPluginFactory {
    if (!sb.gPluginFactory) {
        const factoryInfo: sb.PFactoryInfo = .{
            .vendor = "Arboreal Audio",
            .url = "https://arborealaudio.com",
            .email = "contact@arborealaudio.com",
            .flags = 0,
        };
        sb.gPluginFactory = allocator.create(sb.)
    }
}