const std = @import("std");
const builtin = @import("builtin");
const arbor = @import("../arbor.zig");
const log = arbor.log;
const Plugin = arbor.Plugin;
pub const Component = @import("Component.zig");
pub const draw = @import("draw.zig");
pub const Platform = @import("platform.zig");
pub const GuiImpl = Platform.GuiImpl;

const Gui = @This();

bits: []u32,
impl: *GuiImpl,
canvas: draw.Canvas,

components: std.ArrayList(Component),

events: std.ArrayList(Event),

allocator: std.mem.Allocator,

state: struct {
    type: enum {
        Idle,
        MouseDown,
        MouseDragging,
    } = .Idle,

    mouse_pos: draw.Vec2 = .{ .x = 0, .y = 0 },
    comp_id: ?usize = null,
} = .{},

/// User gui init
pub extern fn gui_init(*Plugin) void;
pub extern fn gui_render(*Plugin) void;
pub extern fn gui_event(*Gui) void;
pub extern fn gui_deinit(*Plugin) void;

/// Call this from within your gui_init function to init the GUI backend
pub fn init(plugin: *Plugin, allocator: std.mem.Allocator, width: u32, height: u32) *Gui {
    const ptr = allocator.create(Gui) catch |e| log.fatal("{}\n", .{e});
    const bits = allocator.alloc(u32, width * height) catch |e| log.fatal("{}\n", .{e});
    ptr.* = .{
        .bits = bits,
        .impl = Platform.guiCreate(plugin, bits.ptr, width, height),
        .allocator = allocator,
        .components = std.ArrayList(Component).init(allocator),
        .events = std.ArrayList(Event).init(allocator),
        .canvas = draw.olivec_canvas(bits.ptr, width, height, width),
    };

    return ptr;
}

/// Call this from gui_deinit after all your own deinit logic
pub fn deinit(self: *Gui) void {
    Platform.guiDestroy(self.impl);
    self.allocator.free(self.bits);
    self.components.deinit();
    self.events.deinit();
    self.allocator.destroy(self);
}

pub fn getSize(self: Gui) draw.Vec2 {
    return .{ .x = @floatFromInt(self.canvas.width), .y = @floatFromInt(self.canvas.height) };
}

pub fn addComponent(self: *Gui, component: Component) void {
    self.components.append(component) catch |e|
        log.err("Component append failed: {!}\n", .{e});
}

pub fn getComponent(self: *Gui, id: usize) *Component {
    return &self.components.items[id];
}

pub const Event = union(enum) {
    click: struct {
        mouse_pos: draw.Vec2,
        id: usize,
    },
    drag: struct {
        mouse_delta: draw.Vec2,
        id: usize,
    },
};

fn pushEvent(self: *Gui, event: Event) !void {
    try self.events.append(event);
}

pub fn nextEvent(self: *Gui) ?Event {
    return self.events.popOrNull();
}

fn processGesture(
    self: *Gui,
    mouse_pos: draw.Vec2,
) !void {
    switch (self.state.type) {
        .MouseDragging => {
            const mouse_delta: draw.Vec2 = .{
                .x = mouse_pos.x - self.state.mouse_pos.x,
                .y = mouse_pos.y - self.state.mouse_pos.y,
            };
            if (self.state.comp_id) |id| {
                try self.pushEvent(.{ .drag = .{
                    .mouse_delta = mouse_delta,
                    .id = id,
                } });
            }
            self.state.mouse_pos = mouse_pos;
        },
        .MouseDown => {
            // Mouse down
            for (self.components.items, 0..) |c, i| {
                if (c.hit_test(mouse_pos)) {
                    self.state.comp_id = i;
                    try self.pushEvent(.{ .click = .{
                        .mouse_pos = mouse_pos,
                        .id = i,
                    } });
                    break;
                }
            }
            self.state.mouse_pos = mouse_pos;
        },
        .Idle => {
            self.state.comp_id = null;
        },
    }
}

fn inputEvent(plugin: *const Plugin, cursorX: i32, cursorY: i32, button: i8) callconv(.C) void {
    const self = plugin.gui orelse log.fatal("GUI is null\n", .{});
    switch (self.state.type) {
        .Idle => {
            switch (button) {
                -1 => log.info("Weird...mouse up after no mouse down\n", .{}),
                0 => self.state.type = .MouseDragging,
                1 => self.state.type = .MouseDown,
                else => {},
            }
        },
        .MouseDown => {
            switch (button) {
                -1 => self.state.type = .Idle,
                0 => self.state.type = .MouseDragging,
                1 => {},
                else => {},
            }
        },
        .MouseDragging => {
            switch (button) {
                -1 => self.state.type = .Idle,
                0 => {},
                1 => self.state.type = .MouseDown,
                else => {},
            }
        },
    }
    self.processGesture(
        .{ .x = @floatFromInt(cursorX), .y = @floatFromInt(cursorY) },
    ) catch |e| {
        log.err("{}\n", .{e});
        return;
    };

    Platform.guiRender(self.impl, true);
}

comptime {
    @export(inputEvent, .{ .name = "inputEvent", .linkage = .weak });
}
