// For the time being, this is for the sake of getting a desktop application
// up and running where we can just copy the olivec frame buffer used in the
// plugin drawing code and render it using sokol.

// The reason we're using sokol is so we can have a starting point for a new
// hardware renderer that can be used in standalone or plugin UIs.

const std = @import("std");
const builtin = @import("builtin");
const arbor = @import("arbor.zig");
const log = arbor.log;
const draw = arbor.Gui.draw;

const sokol = @import("sokol");
const sapp = sokol.app;
const sg = sokol.gfx;
const sglue = sokol.glue;
const slog = sokol.log;

const shd = @import("quad");

const allocator = std.heap.c_allocator;

const Vertex = extern struct {
    x: f32,
    y: f32,

    u: f32,
    v: f32,
};

const quad = [4]Vertex{
    .{ .x = -1, .y = -1, .u = 0, .v = 1 },
    .{ .x = 1, .y = -1, .u = 1, .v = 1 },
    .{ .x = 1, .y = 1, .u = 1, .v = 0 },
    .{ .x = -1, .y = 1, .u = 0, .v = 0 },
};

var state: struct {
    clear_action: sg.PassAction = .{},
    pip: sg.Pipeline = .{},
    bind: sg.Bindings = .{},

    mouse_down: bool = false,

    plugin: *arbor.Plugin = undefined,
} = .{};

const GUI_W = 800;
const GUI_H = 600;

fn init() callconv(.C) void {
    state.plugin = arbor.Plugin.init();
    arbor.Gui.gui_init(state.plugin);

    sg.setup(.{
        .environment = sglue.environment(),
        .logger = .{ .func = slog.func },
    });

    state.clear_action.colors[0] = .{
        .load_action = .CLEAR,
        .clear_value = .{ .r = 0, .g = 0, .b = 0, .a = 1 },
    };

    state.bind.vertex_buffers[0] = sg.makeBuffer(.{
        .size = @sizeOf(Vertex) * quad.len,
        .data = sg.asRange(&quad),
    });

    const indices = [_]u16{ 0, 1, 2, 0, 2, 3 };
    state.bind.index_buffer = sg.makeBuffer(.{
        .type = .INDEXBUFFER,
        .size = @sizeOf(u16) * indices.len,
        .data = sg.asRange(&indices),
    });

    const img_desc = sg.ImageDesc{
        .width = GUI_W,
        .height = GUI_H,
        .pixel_format = .BGRA8,
        .usage = .STREAM,
    };

    state.bind.fs.samplers[shd.SLOT_smp] = sg.makeSampler(.{});
    state.bind.fs.images[0] = sg.makeImage(img_desc);

    var pipeline_desc = sg.PipelineDesc{
        .shader = sg.makeShader(shd.quadShaderDesc(sg.queryBackend())),
        .index_type = .UINT16,
    };
    pipeline_desc.layout.attrs[shd.ATTR_vs_pos].format = .FLOAT2;
    pipeline_desc.layout.attrs[shd.ATTR_vs_uv].format = .FLOAT2;
    state.pip = sg.makePipeline(pipeline_desc);
}

fn frame() callconv(.C) void {
    sg.beginPass(.{
        .action = state.clear_action,
        .swapchain = sglue.swapchain(),
    });

    if (state.plugin.gui) |gui| {
        gui.render();
        var img_data: sg.ImageData = std.mem.zeroes(sg.ImageData);
        img_data.subimage[0][0] = sg.asRange(gui.bits);
        sg.updateImage(state.bind.fs.images[0], img_data);
    }

    sg.applyPipeline(state.pip);
    sg.applyBindings(state.bind);

    sg.draw(0, 6, 1);
    sg.endPass();
    sg.commit();
}

fn handle_event(e: ?*const sapp.Event) callconv(.C) void {
    const event = e orelse {
        log.err("Event is null\n", .{}, @src());
        return;
    };
    const gui = state.plugin.gui orelse {
        log.err("Plugin GUI is null\n", .{}, @src());
        return;
    };
    const mouse_x: i32 = @intFromFloat(@max(0, event.mouse_x));
    const mouse_y: i32 = @intFromFloat(@max(0, event.mouse_y));
    switch (event.type) {
        .MOUSE_MOVE => {
            gui.sysInputEvent(mouse_x, mouse_y, if (state.mouse_down)
                .MouseDrag
            else
                .MouseOver);
        },
        .MOUSE_DOWN => {
            state.mouse_down = true;
            gui.sysInputEvent(mouse_x, mouse_y, .MouseDown);
        },
        .MOUSE_UP => {
            state.mouse_down = false;
            gui.sysInputEvent(mouse_x, mouse_y, .MouseUp);
        },
        else => {},
    }
}

fn deinit() callconv(.C) void {
    sg.shutdown();

    if (state.plugin.gui) |gui| {
        gui.deinit();
    }
    state.plugin.deinit();
}

pub fn main() !void {
    sapp.run(.{
        .window_title = arbor.plugin_name,
        .width = GUI_W,
        .height = GUI_H,
        .init_cb = init,
        .frame_cb = frame,
        .event_cb = handle_event,
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
