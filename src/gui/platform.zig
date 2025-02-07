//! Zig API over platform-specific implementation

const std = @import("std");
const windows = std.os.windows;
const builtin = @import("builtin");
const Gui = @import("Gui.zig");

pub const Window = switch (builtin.os.tag) {
    .windows => windows.HWND,
    .macos => ?*anyopaque,
    .linux => c_ulong,
    else => @panic("Unsupported OS\n"),
};

/// Opaque type over MacOS CFRunLoopTimerRef
pub const NSTimerRef = *opaque {};

pub const d2dl = @import("d2dl/d2dl.zig");

pub const GuiImpl = switch (builtin.os.tag) {
    .windows => d2dl.Direct2D,
    .linux => extern struct {
        display: ?*anyopaque,
        fd: c_int,
        window: Window,
        image: ?*anyopaque,
        bits: [*]u32,
        width: u32,
        height: u32,
        user: ?*anyopaque,
    },
    .macos => extern struct {
        user: ?*anyopaque,
        bits: [*]u32,
        width: u32,
        height: u32,
        has_super_view: bool,
        timer: NSTimerRef,
    },
    else => @panic("Unsupported OS\n"),
};

pub extern fn guiCreate(
    user: ?*Gui,
    w: u32,
    h: u32,
    timer_ms: u32,
    id: [*:0]const u8,
) *GuiImpl;
pub extern fn guiDestroy(gui: GuiImpl) void;
pub extern fn guiOnPosixFd(gui: GuiImpl) void;
pub extern fn guiSetParent(gui: GuiImpl, window: Window) void;
pub extern fn guiSetVisible(gui: GuiImpl, visible: bool) void;
// pub extern fn guiRender(gui: *GuiImpl, internal: bool) void;

// pub fn guiTimerCallback(timer: NSTimerRef, gui: *Gui) callconv(.C) void {
//     _ = timer;
//     if (gui.wants_repaint.load(.acquire)) {
//         guiRender(gui.impl, true);
//         gui.wants_repaint.store(false, .release);
//     }
// }
