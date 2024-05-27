const std = @import("std");
const builtin = @import("builtin");
const arbor = @import("arbor");
const draw = arbor.Gui.draw;

const sokol = @import("sokol");
const sapp = sokol.app;
const sg = sokol.gfx;
const sglue = sokol.glue;
const slog = sokol.log;

const allocator = std.heap.c_allocator;

var state: struct {
    pixels: []u32 = undefined,
    canvas: arbor.Gui.draw.Canvas = undefined,

    clear_action: sg.PassAction = .{},
    pip: sg.Pipeline = .{},
    bind: sg.Bindings = .{},
} = .{};

const GUI_W = 800;
const GUI_H = 600;

fn init() callconv(.C) void {
    sg.setup(.{
        .environment = sglue.environment(),
        .logger = .{ .func = slog.func },
    });

    state.pixels = allocator.alloc(u32, GUI_W * GUI_H) catch @panic("OOM");

    state.canvas = draw.olivec_canvas(state.pixels.ptr, GUI_W, GUI_H, GUI_W);
}

fn frame() callconv(.C) void {}

fn deinit() callconv(.C) void {
    sg.shutdown();

    allocator.free(state.pixels);
}

pub fn main() !void {
    sapp.run(.{
        .window_title = arbor.plugin_name,
        .width = GUI_W,
        .height = GUI_H,
        .init_cb = init,
        .frame_cb = frame,
        .cleanup_cb = deinit,
        .logger = .{ .func = slog.func },
    });
}

const GuiImpl = arbor.Gui.GuiImpl;

export fn guiCreate(
    _: ?*arbor.Gui,
    _: [*]u32,
    _: u32,
    _: u32,
    _: u32,
    _: [*:0]const u8,
) *GuiImpl {
    if (builtin.os.tag == .macos)
        return @constCast(@alignCast(@ptrCast(sapp.macosGetWindow())));
    if (builtin.os.tag == .windows)
        return @constCast(@alignCast(@ptrCast(sapp.win32GetHwnd())));
}

export fn guiDestroy(_: *GuiImpl) void {}
export fn guiOnPosixFd(_: *GuiImpl) void {}
export fn guiSetParent(_: *GuiImpl, _: arbor.Gui.Platform.Window) void {}
export fn guiSetVisible(_: *GuiImpl, _: bool) void {}
export fn guiRender(_: *GuiImpl, _: bool) void {}
