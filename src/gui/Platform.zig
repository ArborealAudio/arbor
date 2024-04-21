//! Zig API over platform-specific implementation

const windows = @import("std").os.windows;
const builtin = @import("builtin");

pub const Window = switch (builtin.os.tag) {
    .windows => ?*anyopaque,
    .macos => ?*anyopaque,
    .linux => c_ulong,
    else => @panic("Unsupported OS\n"),
};

pub const GuiImpl = switch (builtin.os.tag) {
    .windows => struct {
        window: windows.HWND,
        bits: [*]u32,
        width: u32,
        height: u32,
        user: ?*anyopaque,
    },
    .linux => struct {
        display: ?*anyopaque,
        window: Window,
        image: ?*anyopaque,
        bits: [*]u32,
        width: u32,
        height: u32,
        user: ?*anyopaque,
    },
    .macos => struct {
        user: ?*anyopaque,
        bits: [*]u32,
        width: u32,
        height: u32,
        has_super_view: bool,
    },
    else => @panic("Unsupported OS\n"),
};

pub extern fn guiCreate(user: ?*anyopaque, bits: [*]u32, w: u32, h: u32) *GuiImpl;
pub extern fn guiDestroy(gui: *GuiImpl) void;
pub extern fn guiOnPosixFd(gui: *GuiImpl) void;
pub extern fn guiSetParent(gui: *GuiImpl, window: Window) void;
pub extern fn guiSetVisible(gui: *GuiImpl, visible: bool) void;
pub extern fn guiRender(gui: *GuiImpl, internal: bool) void;
