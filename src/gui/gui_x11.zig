//! gui_x11.zig
//! Module for interfacing with X11

const std = @import("std");
const clap = @cImport({
    @cInclude("clap/clap.h");
});
const c_cast = std.zig.c_translation.cast;
const Plugin = @import("../Plugin.zig");
const allocator = &Plugin.allocator;
pub const GUI_API = clap.CLAP_WINDOW_API_X11;
const Parent = @import("Gui.zig");
const GUI_WIDTH = Parent.GUI_WIDTH;
const GUI_HEIGHT = Parent.GUI_HEIGHT;
const pluginPaint = Parent.pluginPaint;

pub const x11 = @cImport({
    @cInclude("X11/Xlib.h");
    @cInclude("X11/Xutil.h");
    @cInclude("X11/Xatom.h");
});

pub const Display = struct {
    display: *x11.Display,
    window: x11.Window,
    image: *x11.XImage,
    bits: []u32,
};

pub fn GUICreate(plugin: *Plugin) !void {
    std.debug.assert(plugin.gui == null);
    plugin.gui = try allocator.create(Display);

    if (plugin.gui == null) return;

    plugin.gui.?.display = x11.XOpenDisplay(null).?;
    var attributes: x11.XSetWindowAttributes = undefined;
    plugin.gui.?.window = x11.XCreateWindow(plugin.gui.?.display, x11.DefaultRootWindow(plugin.gui.?.display), 0, 0, GUI_WIDTH, GUI_HEIGHT, 0, 0, x11.InputOutput, x11.CopyFromParent, x11.CWOverrideRedirect, &attributes);

    _ = x11.XStoreName(plugin.gui.?.display, plugin.gui.?.window, Plugin.PluginDesc.name);

    const embedInfoAtom = x11.XInternAtom(plugin.gui.?.display, "_XEMBED_INFO", 0);
    const embedInfoData = [2]u32{ 0, 0 };
    _ = x11.XChangeProperty(plugin.gui.?.display, plugin.gui.?.window, embedInfoAtom, embedInfoAtom, 32, x11.PropModeReplace, c_cast([*c]const u8, &embedInfoData), 2);

    var sizeHints: x11.XSizeHints = .{
        .flags = x11.PMinSize | x11.PMaxSize,
        .min_width = GUI_WIDTH,
        .max_width = GUI_WIDTH,
        .min_height = GUI_HEIGHT,
        .max_height = GUI_HEIGHT,
        .x = undefined,
        .y = undefined,
        .width = GUI_WIDTH,
        .height = GUI_HEIGHT,
        .width_inc = undefined,
        .height_inc = undefined,
        .min_aspect = undefined,
        .max_aspect = undefined,
        .base_width = undefined,
        .base_height = undefined,
        .win_gravity = undefined,
    };
    x11.XSetWMNormalHints(plugin.gui.?.display, plugin.gui.?.window, &sizeHints);

    _ = x11.XSelectInput(plugin.gui.?.display, plugin.gui.?.window, x11.SubstructureNotifyMask | x11.ExposureMask | x11.PointerMotionMask | x11.ButtonPressMask | x11.ButtonReleaseMask | x11.KeyPressMask | x11.KeyReleaseMask | x11.StructureNotifyMask | x11.EnterWindowMask | x11.LeaveWindowMask | x11.ButtonMotionMask | x11.KeymapStateMask | x11.FocusChangeMask | x11.PropertyChangeMask);

    plugin.gui.?.image = x11.XCreateImage(plugin.gui.?.display, x11.DefaultVisual(plugin.gui.?.display, 0), 24, x11.ZPixmap, 0, null, 10, 10, 32, 0);
    plugin.gui.?.bits = try allocator.alloc(u32, GUI_WIDTH * GUI_HEIGHT * 4);
    plugin.gui.?.image.width = GUI_WIDTH;
    plugin.gui.?.image.height = GUI_HEIGHT;
    plugin.gui.?.image.bytes_per_line = GUI_WIDTH * 4;
    plugin.gui.?.image.data = c_cast(*u8, plugin.gui.?.bits);

    if (plugin.host_posix_fd_support != null and plugin.host_posix_fd_support.*.register_fd != null) {
        _ = plugin.host_posix_fd_support.*.register_fd.?(plugin.host, x11.ConnectionNumber(plugin.gui.?.display), clap.CLAP_POSIX_FD_READ);
    }
}

pub fn GUIPaint(plugin: *Plugin, internal: bool) void {
    if (internal) pluginPaint(plugin.gui.?.bits.ptr);
    _ = x11.XPutImage(plugin.gui.?.display, plugin.gui.?.window, x11.DefaultGC(plugin.gui.?.display, 0), plugin.gui.?.image, 0, 0, 0, 0, GUI_WIDTH, GUI_HEIGHT);
}

fn GUIProcessX11Event(plugin: *Plugin, event: *x11.XEvent) void {
    if (event.type == x11.Expose) {
        if (event.xexpose.window == plugin.gui.?.window)
            GUIPaint(plugin, false);
    }
}

pub fn GUIOnPOSIXFD(plugin: *Plugin) void {
    _ = x11.XFlush(plugin.gui.?.display);

    const pending = x11.XPending(plugin.gui.?.display);
    std.debug.print("Pending: {d}\n", .{pending});

    if (pending > 0) {
        var event: x11.XEvent = undefined;
        _ = x11.XNextEvent(plugin.gui.?.display, &event);

        while (c_cast(bool, x11.XPending(plugin.gui.?.display))) {
            var event0: x11.XEvent = undefined;
            _ = x11.XNextEvent(plugin.gui.?.display, &event0);

            if (event.type == x11.MotionNotify and event0.type == x11.MotionNotify) {
                // merge adjacent mouse motion events
            } else {
                GUIProcessX11Event(plugin, &event);
                _ = x11.XFlush(plugin.gui.?.display);
            }

            event = event0;
        }

        GUIProcessX11Event(plugin, &event);
        _ = x11.XFlush(plugin.gui.?.display);
        GUIPaint(plugin, true);
    } else std.debug.print("No events!\n", .{});

    _ = x11.XFlush(plugin.gui.?.display);
}

pub fn GUIDestroy(plugin: *Plugin) void {
    std.debug.assert(plugin.gui != null);

    if (plugin.host_posix_fd_support != null and plugin.host_posix_fd_support.*.unregister_fd != null) {
        _ = plugin.host_posix_fd_support.*.unregister_fd.?(plugin.host, x11.ConnectionNumber(plugin.gui.?.display));
    }

    allocator.free(plugin.gui.?.bits);
    plugin.gui.?.image.data = null;
    _ = x11.XDestroyImage(plugin.gui.?.image);
    _ = x11.XDestroyWindow(plugin.gui.?.display, plugin.gui.?.window);
    _ = x11.XCloseDisplay(plugin.gui.?.display);

    allocator.destroy(plugin.gui.?);
    plugin.gui = null;
}

pub fn GUISetParent(plugin: *Plugin, clap_window: [*c]const clap.clap_window_t) void {
    _ = x11.XReparentWindow(plugin.gui.?.display, plugin.gui.?.window, c_cast(x11.Window, clap_window.*.unnamed_0.x11), 0, 0);
    _ = x11.XFlush(plugin.gui.?.display);
}

pub fn GUISetVisible(plugin: *Plugin, visible: bool) void {
    if (visible)
        _ = x11.XMapRaised(plugin.gui.?.display, plugin.gui.?.window)
    else
        _ = x11.XUnmapWindow(plugin.gui.?.display, plugin.gui.?.window);

    _ = x11.XFlush(plugin.gui.?.display);
}
