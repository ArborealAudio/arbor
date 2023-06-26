//! clap_gui.zig
//! GUI module for plugin

const std = @import("std");
const builtin = @import("builtin");
const ClapPlugin = @import("../clap_plugin.zig");
const Plugin = @import("../Plugin.zig");
const Gui = @import("Gui.zig");
const glfw = Gui.glfw;
const GUI_WIDTH = Gui.GUI_WIDTH;
const GUI_HEIGHT = Gui.GUI_HEIGHT;
const clap = @cImport({
    @cInclude("clap/clap.h");
});
pub const GUI_API = switch (builtin.os.tag) {
    .linux => clap.CLAP_WINDOW_API_X11,
    .macos => clap.CLAP_WINDOW_API_COCOA,
    .windows => clap.CLAP_WINDOW_API_WIN32,
    else => @panic("Unsupported OS"),
};

/// only used for X11
var display: ?*anyopaque = null;

pub const rl = @cImport({
    @cInclude("raylib.h");
});

extern fn implGuiCreateDisplay() callconv(.C) ?*anyopaque;
extern fn implGuiSetParent(display: ?*anyopaque, main: ?*anyopaque, window: ?*anyopaque) callconv(.C) void;
extern fn implGuiSetVisible(display: ?*anyopaque, main: ?*anyopaque, visible: bool) callconv(.C) void;

const c_cast = std.zig.c_translation.cast;

fn isAPISupported(plugin: [*c]const clap.clap_plugin_t, api: [*c]const u8, is_floating: bool) callconv(.C) bool {
    _ = plugin;
    return 0 == std.cstr.cmp(api, &GUI_API) and !is_floating;
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
    display = implGuiCreateDisplay().?;
    var c_plug = c_cast(*ClapPlugin, plugin.*.plugin_data);
    var plug = c_plug.plugin;
    if (glfw.glfwInit() != glfw.GLFW_TRUE) {
        // std.log.err("Failed to initialize GLFW: {?s}", .{glfw.getErrorString()});
        std.process.exit(1);
    }
    std.debug.assert(plug.gui == null);
    plug.gui = Gui.init(ClapPlugin.allocator, plug) catch unreachable;
    glfw.glfwWindowHint(glfw.GLFW_DECORATED, glfw.GLFW_FALSE);
    glfw.glfwWindowHint(glfw.GLFW_VISIBLE, glfw.GLFW_FALSE);
    plug.gui.?.window = glfw.glfwCreateWindow(GUI_WIDTH, GUI_HEIGHT, Plugin.Description.plugin_name, null, null);
    if (plug.gui.?.window == null)
        std.process.exit(1);
    // glfw.glfwSetWindowPos(plug.gui.?.window, 0, 0);
    // plug.gui.?.render();
    return true;
}

fn destroyGUI(plugin: [*c]const clap.clap_plugin_t) callconv(.C) void {
    // Impl.GUIDestroy(plug);
    var c_plug = c_cast(*ClapPlugin, plugin.*.plugin_data);
    var plug = c_plug.plugin;
    std.debug.print("Destroying GUI...\n", .{});
    glfw.glfwTerminate();
    std.debug.assert(plug.gui != null);
    glfw.glfwDestroyWindow(plug.gui.?.window);
    plug.gui.?.deinit(ClapPlugin.allocator);
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
    return rl.IsWindowState(rl.FLAG_WINDOW_RESIZABLE);
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
    // rl.SetWindowSize(c_cast(c_int, width), c_cast(c_int, height));
    return true;
}

fn setParent(plugin: [*c]const clap.clap_plugin_t, clap_window: [*c]const clap.clap_window_t) callconv(.C) bool {
    var plug = c_cast(*ClapPlugin, plugin.*.plugin_data).plugin;
    std.debug.assert(std.cstr.cmp(clap_window.*.api, &GUI_API) == 0);
    const parent_window = switch (builtin.os.tag) {
        .macos => clap_window.*.unnamed_0.cocoa,
        .windows => clap_window.*.unnamed_0.win32,
        .linux => clap_window.*.unnamed_0.x11,
        else => @panic("Unsupported OS"),
    };
    std.debug.assert(plug.gui.?.window != null);
    const main_window = switch (builtin.os.tag) {
        .macos => glfw.glfwGetCocoaWindow(plug.gui.?.window.?),
        .windows => rl.GetWindowHandle(),
        .linux => glfw.glfwGetX11Window(c_cast(*glfw.GLFWwindow, rl.GetWindowHandle())),
        else => @panic("Unsupported OS"),
    };
    const disp = if (builtin.os.tag == .linux) glfw.glfwGetX11Display() else null;
    implGuiSetParent(disp, main_window, parent_window);
    glfw.glfwShowWindow(plug.gui.?.window);
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
    const main_window = switch (builtin.os.tag) {
        .macos => glfw.glfwGetCocoaWindow(plug.gui.?.window.?),
        .windows => glfw.glfwGetWin32Window(c_cast(*glfw.GLFWwindow, rl.GetWindowHandle())),
        .linux => rl.GetWindowHandle(),
        else => @panic("Unsupported OS"),
    };
    const disp = if (builtin.os.tag == .linux) glfw.glfwGetX11Display() else null;
    implGuiSetVisible(disp, main_window, true);
    glfw.glfwShowWindow(plug.gui.?.window);
    return true;
}

fn hide(plugin: [*c]const clap.clap_plugin_t) callconv(.C) bool {
    var plug = c_cast(*ClapPlugin, plugin.*.plugin_data).plugin;
    const main_window = switch (builtin.os.tag) {
        .macos => glfw.glfwGetCocoaWindow(plug.gui.?.window.?),
        .windows => glfw.glfwGetWin32Window(c_cast(*glfw.GLFWwindow, rl.GetWindowHandle())),
        .linux => rl.GetWindowHandle(),
        else => @panic("Unsupported OS"),
    };
    const disp = if (builtin.os.tag == .linux) glfw.glfwGetX11Display() else null;
    implGuiSetVisible(disp, main_window, false);
    glfw.glfwHideWindow(plug.gui.?.window);
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
