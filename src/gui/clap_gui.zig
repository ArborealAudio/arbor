//! clap_gui.zig
//! GUI module for plugin

const std = @import("std");
const builtin = @import("builtin");
const ClapPlugin = @import("../clap_plugin.zig");
const alloc = ClapPlugin.allocator;
const clap = ClapPlugin.clap;
const Plugin = @import("../Plugin.zig");
const Gui = @import("../Gui.zig");
const GUI_WIDTH = Gui.GUI_WIDTH;
const GUI_HEIGHT = Gui.GUI_HEIGHT;

pub const GUI_API = switch (builtin.os.tag) {
    .linux => clap.CLAP_WINDOW_API_X11,
    .macos => clap.CLAP_WINDOW_API_COCOA,
    .windows => clap.CLAP_WINDOW_API_WIN32,
    else => @panic("Unsupported OS"),
};

const c_cast = std.zig.c_translation.cast;

fn isAPISupported(plugin: [*c]const clap.clap_plugin_t, api: [*c]const u8, is_floating: bool) callconv(.C) bool {
    _ = plugin;
    return std.mem.orderZ(u8, api, &GUI_API).compare(.eq) and !is_floating;
}

fn getPreferredAPI(plugin: [*c]const clap.clap_plugin_t, api: [*c][*c]const u8, is_floating: [*c]bool) callconv(.C) bool {
    _ = plugin;
    api.* = &GUI_API;
    is_floating.* = false;
    return true;
}

fn createGUI(plugin: [*c]const clap.clap_plugin_t, api: [*c]const u8, is_floating: bool) callconv(.C) bool {
    if (!isAPISupported(plugin, api, is_floating))
        return false;
    var c_plug = c_cast(*ClapPlugin, plugin.*.plugin_data);
    var plug = c_plug.plugin;
    std.debug.assert(plug.gui == null);
    plug.gui = Gui.init(alloc, plug) catch unreachable;
    // plug.gui.?.bits = alloc.alloc(u32, GUI_WIDTH * GUI_HEIGHT * 4);
    if (Gui.implGuiCreate(plug, plug.gui.?.bits.ptr, GUI_WIDTH, GUI_HEIGHT)) |disp|
        plug.gui.?.window = disp;
    plug.gui.?.render();
    return true;
}

fn destroyGUI(plugin: [*c]const clap.clap_plugin_t) callconv(.C) void {
    // Impl.GUIDestroy(plug);
    var c_plug = c_cast(*ClapPlugin, plugin.*.plugin_data);
    var plug = c_plug.plugin;
    std.debug.print("Destroying GUI...\n", .{});
    std.debug.assert(plug.gui != null);
    plug.gui.?.deinit(ClapPlugin.allocator);
    Gui.implGuiDestroy(plug.gui.?.window);
    alloc.free(plug.gui.?.bits);
    ClapPlugin.allocator.destroy(plug.gui.?);
    plug.gui = null;
}

fn setScale(plugin: [*c]const clap.clap_plugin_t, scale: f64) callconv(.C) bool {
    _ = scale;
    _ = plugin;
    return false;
}

fn getSize(plugin: [*c]const clap.clap_plugin_t, width: [*c]u32, height: [*c]u32) callconv(.C) bool {
    _ = plugin;
    width.* = GUI_WIDTH;
    height.* = GUI_HEIGHT;
    return true;
}

fn canResize(plugin: [*c]const clap.clap_plugin_t) callconv(.C) bool {
    _ = plugin;
    return false;
}

fn getResizeHints(plugin: [*c]const clap.clap_plugin_t, hints: [*c]clap.clap_gui_resize_hints_t) callconv(.C) bool {
    _ = hints;
    _ = plugin;
    return false;
}

fn adjustSize(plugin: [*c]const clap.clap_plugin_t, width: [*c]u32, height: [*c]u32) callconv(.C) bool {
    return getSize(plugin, width, height);
}

fn setSize(plugin: [*c]const clap.clap_plugin_t, width: u32, height: u32) callconv(.C) bool {
    _ = height;
    _ = width;
    _ = plugin;
    return true;
}

fn setParent(plugin: [*c]const clap.clap_plugin_t, clap_window: [*c]const clap.clap_window_t) callconv(.C) bool {
    var plug = c_cast(*ClapPlugin, plugin.*.plugin_data).plugin;
    std.debug.assert(std.mem.orderZ(u8, clap_window.*.api, &GUI_API).compare(.eq));
    const parent_window = switch (builtin.os.tag) {
        .macos => clap_window.*.unnamed_0.cocoa,
        .windows => clap_window.*.unnamed_0.win32,
        .linux => clap_window.*.unnamed_0.x11,
        else => @panic("Unsupported OS"),
    };
    Gui.implGuiSetParent(null, plug.gui.?.window, parent_window);
    return true;
}

fn setTransient(plugin: [*c]const clap.clap_plugin_t, clap_window: [*c]const clap.clap_window_t) callconv(.C) bool {
    _ = clap_window;
    _ = plugin;
    return false;
}

fn suggestTitle(plugin: [*c]const clap.clap_plugin_t, title: [*c]const u8) callconv(.C) void {
    _ = title;
    _ = plugin;
}

fn show(plugin: [*c]const clap.clap_plugin_t) callconv(.C) bool {
    var plug = c_cast(*ClapPlugin, plugin.*.plugin_data).plugin;
    Gui.implGuiSetVisible(null, plug.gui.?.window, true);
    return true;
}

fn hide(plugin: [*c]const clap.clap_plugin_t) callconv(.C) bool {
    var plug = c_cast(*ClapPlugin, plugin.*.plugin_data).plugin;
    Gui.implGuiSetVisible(null, plug.gui.?.window, false);
    return true;
}

pub const Data = clap.clap_plugin_gui_t{
    .is_api_supported = isAPISupported,
    .get_preferred_api = getPreferredAPI,
    .create = createGUI,
    .destroy = destroyGUI,
    .set_scale = setScale,
    .get_size = getSize,
    .can_resize = canResize,
    .get_resize_hints = getResizeHints,
    .adjust_size = adjustSize,
    .set_size = setSize,
    .set_parent = setParent,
    .set_transient = setTransient,
    .suggest_title = suggestTitle,
    .show = show,
    .hide = hide,
};
