//! Gui.zig
//! GUI module for plugin

const std = @import("std");
const builtin = @import("builtin");
const Plugin = @import("../Plugin.zig");
export const GUI_WIDTH: c_uint = 800;
export const GUI_HEIGHT: c_uint = 600;
const Gui = if (builtin.os.tag == .windows) @cImport({
    @cInclude("gui_w32.c");
}) else if (builtin.os.tag == .macos) @cImport({
    @cInclude("gui_mac.c");
}) else if (builtin.os.tag == .linux) @cImport({
    @cInclude("gui_x11.c");
});
pub const clap = @cImport({
    @cInclude("clap/clap.h");
});
const c_cast = std.zig.c_translation.cast;

const Rectangle = struct {
    x: u32,
    y: u32,
    width: u32,
    height: u32,
};

const PosixFDSupport = struct {
    fn onFD(plugin: [*c]const clap.clap_plugin_t, fd: u32, flags: [*c]const clap.clap_posix_fd_flags_t) void {
        _ = flags;
        _ = fd;
        var plug = c_cast(*Plugin, plugin.*.plugin_data);
        Gui.onPOSIXFD(plug);
    }
};

fn isAPISupported(plugin: [*c]const clap.clap_plugin_t, api: [*c]const u8, is_floating: bool) callconv(.C) bool {
    _ = plugin;
    return 0 == std.cstr.cmp(api, &Gui.GUI_API) and !is_floating;
}

fn getPreferredAPI(plugin: [*c]const clap.clap_plugin_t, api: [*c][*c]const u8, is_floating: [*c]bool) callconv(.C) bool {
    _ = plugin;
    api.* = &Gui.GUI_API;
    is_floating.* = false;
    return true;
}

fn createGUI(plugin: [*c]const clap.clap_plugin_t, api: [*c]const u8, is_floating: bool) callconv(.C) bool {
    if (!isAPISupported(plugin, api, is_floating))
        return false;
    var plug = c_cast(*Plugin, plugin.*.plugin_data);
    Gui.GUIcreate(plug);
    return true;
}

fn destroyGUI(plugin: [*c]const clap.clap_plugin_t) callconv(.C) void {
    var plug = c_cast(*Plugin, plugin.*.plugin_data);
    Gui.GUIcreate(plug);
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
    return false;
}

fn setParent(plugin: [*c]const clap.clap_plugin_t, window: [*c]const clap.clap_window_t) callconv(.C) bool {
    std.debug.assert(std.cstr.cmp(window.*.api, &Gui.GUI_API) == 0);
    var plug = c_cast(*Plugin, plugin.*.plugin_data);
    Gui.setParent(plug, window);
    return true;
}

fn setTransient(plugin: [*c]const clap.clap_plugin_t, window: [*c]const clap.clap_window_t) callconv(.C) bool {
    _ = window;
    _ = plugin;
    return false;
}

fn suggestTitle(plugin: [*c]const clap.clap_plugin_t, title: [*c]const u8) callconv(.C) void {
    _ = title;
    _ = plugin;
}

fn show(plugin: [*c]const clap.clap_plugin_t) callconv(.C) bool {
    var plug = c_cast(*Plugin, plugin.*.plugin_data);
    Gui.setVisible(plug, true);
    return true;
}

fn hide(plugin: [*c]const clap.clap_plugin_t) callconv(.C) bool {
    var plug = c_cast(*Plugin, plugin.*.plugin_data);
    Gui.setVisible(plug, false);
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

fn paintRectangle(bits: [*]u32, rect: Rectangle, border: u32, fill: u32) void {
    const r = rect.x + rect.width;
    const b = rect.y + rect.height;
    var y: u32 = 0;
    while (y < b) : (y += 1) {
        var x: u32 = 0;
        while (x < r) : (x += 1) {
            bits[y * GUI_WIDTH + x] = if (y == rect.y or y == b - 1 or x == rect.x or x == r - 1) border else fill;
        }
    }
}

export fn pluginPaint(bits: [*]u32) void {
    // draw background
    paintRectangle(bits, Rectangle{
        .x = 0,
        .y = 0,
        .width = GUI_WIDTH,
        .height = GUI_HEIGHT,
    }, 0xC0C0C0, 0xC0C0C0);

    const centerX: u32 = GUI_WIDTH / 2;
    const centerY: u32 = GUI_HEIGHT / 2;
    var width: u32 = GUI_WIDTH / 3;
    var height: u32 = @intToFloat(f32, GUI_HEIGHT) * 0.75;
    var x = centerX - (width / 2);
    var y = centerY - (height / 2);

    const bounds = Rectangle{
        .x = x,
        .y = y,
        .width = width,
        .height = height,
    };
    paintRectangle(bits, bounds, 0x000000, 0xC0C0C0);
    // const paramVal = 1.0 - self.params.values.mix;
    // const paramY = y + (height - y) * paramVal;
    // paintRectangle(bits, Rectangle{ x, paramY, width, height }, 0x000000, 0x000000);
}
