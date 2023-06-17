//! Gui.zig
//! GUI module for plugin

const std = @import("std");
const builtin = @import("builtin");
const Plugin = @import("../Plugin.zig");
const clap = @cImport({
    @cInclude("clap/clap.h");
});
pub const GUI_API = switch (builtin.os.tag) {
    .linux => clap.CLAP_WINDOW_API_X11,
    .macos => clap.CLAP_WINDOW_API_COCOA,
    .windows => clap.CLAP_WINDOW_API_WIN32,
    else => @panic("Unsupported OS"),
};
pub const GUI_WIDTH: c_uint = 800;
pub const GUI_HEIGHT: c_uint = 600;

pub const rl = @cImport({
    @cInclude("raylib.h");
});

const Impl = @cImport({
    switch (builtin.os.tag) {
        .windows => {
            @cInclude("windows.h");
            @cInclude("windowsx.h");
            @cInclude("winuser.h");
        },
        .linux => {},
        .macos => {},
        else => @panic("Unsupported OS"),
    }
});

extern fn implGuiSetParent(main: ?*anyopaque, window: [*c]const clap.clap_window_t) callconv(.C) void;
extern fn implGuiSetVisible(main: ?*anyopaque, visible: bool) callconv(.C) void;

const c_cast = std.zig.c_translation.cast;

const centerX: f32 = @as(f32, GUI_WIDTH) / 2.0;
const centerY: f32 = @as(f32, GUI_HEIGHT) / 2.0;
pub const mix_slider = rl.Rectangle{
    .x = centerX - 25.0,
    .y = centerY - 50.0,
    .width = 50.0,
    .height = 100.0,
};

pub fn render(plugin: *Plugin) void {
    while (!rl.WindowShouldClose()) {
        rl.BeginDrawing();

        rl.ClearBackground(rl.RAYWHITE);

        const reverb_amount = @floatCast(f32, plugin.params.values.mix);

        var d_mix_slider = mix_slider;
        d_mix_slider.height = mix_slider.height * reverb_amount;
        d_mix_slider.y = mix_slider.y - (mix_slider.height - d_mix_slider.height);

        rl.DrawRectangleRec(d_mix_slider, rl.RED);

        rl.DrawFPS(5, 5);

        rl.EndDrawing();
    }
}

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
    var plug = c_cast(*Plugin, plugin.*.plugin_data);
    // Impl.GUICreate(plug) catch unreachable;
    rl.SetConfigFlags(rl.FLAG_WINDOW_RESIZABLE);
    rl.InitWindow(GUI_WIDTH, GUI_HEIGHT, "clap-raw");
    rl.SetTargetFPS(60);
    rl.SetGesturesEnabled(rl.GESTURE_DRAG);
    render(plug);
    return true;
}

fn destroyGUI(plugin: [*c]const clap.clap_plugin_t) callconv(.C) void {
    _ = plugin;
    // Impl.GUIDestroy(plug);
    rl.CloseWindow();
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
    _ = plugin;
    rl.SetWindowSize(c_cast(c_int, width), c_cast(c_int, height));
    return true;
}

fn setParent(plugin: [*c]const clap.clap_plugin_t, clap_window: [*c]const clap.clap_window_t) callconv(.C) bool {
    _ = plugin;
    std.debug.assert(std.cstr.cmp(clap_window.*.api, &GUI_API) == 0);
    // var plug = c_cast(*Plugin, plugin.*.plugin_data);
    // _ = plug;
    // implGuiSetParent(rl.GetWindowHandle(), clap_window);
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
    _ = plugin;
    // Impl.GUISetVisible(plug, true);
    // switch (builtin.os.tag) {
    //     .windows => {
    //         _ = Impl.ShowWindow(c_cast(Impl.HWND, rl.GetWindowHandle().?), Impl.SW_SHOW);
    //     },
    //     .linux => {},
    //     .macos => {},
    //     else => @panic("Unsupported OS"),
    // }
    // implGuiSetVisible(rl.GetWindowHandle(), true);
    return true;
}

fn hide(plugin: [*c]const clap.clap_plugin_t) callconv(.C) bool {
    _ = plugin;
    // switch (builtin.os.tag) {
    //     .windows => {
    //         _ = Impl.ShowWindow(c_cast(Impl.HWND, rl.GetWindowHandle().?), Impl.SW_HIDE);
    //     },
    //     .linux => {},
    //     .macos => {},
    //     else => @panic("Unsupported OS"),
    // }
    // implGuiSetVisible(rl.GetWindowHandle(), false);
    rl.CloseWindow();
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
