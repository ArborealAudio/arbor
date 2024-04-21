//! Gui.zig
//! Where you layout GUI properties & behavior

const std = @import("std");
const stderr = std.log.err;
const builtin = @import("builtin");
const build_options = @import("build_options");
const c_cast = std.zig.c_translation.cast;
const Plugin = @import("Plugin.zig");
const Params = @import("Params.zig");
const Component = @import("Component.zig");
const o = @cImport({
    @cDefine("OLIVEC_IMPLEMENTATION", "");
    @cInclude("olive.c");
});
const Gui = @This();
const Platform = @import("platform");
const GuiImpl = Platform.GuiImpl;

pub const GUI_WIDTH = 400;
pub const GUI_HEIGHT = 500;
const centerX: f32 = @as(f32, GUI_WIDTH) / 2.0;
const centerY: f32 = @as(f32, GUI_HEIGHT) / 2.0;

pub const Vec2 = extern struct {
    x: f32,
    y: f32,
};

pub const Vec2i = extern struct {
    x: i32,
    y: i32,
};

pub const Rect = extern struct {
    x: f32,
    y: f32,
    width: f32,
    height: f32,

    pub fn intersection(a: Rect, b: Rect) Rect {
        var rect = Rect{ .x = 0, .y = 0, .width = 0, .height = 0 };
        rect.x = @max(b.x, a.x);
        rect.y = @max(b.y, a.y);
        rect.width = @min(a.width, b.width);
        rect.height = @min(a.height, b.height);
        return rect;
    }
};

pub const Recti = extern struct {
    x: u32,
    y: u32,
    width: u32,
    height: u32,

    pub fn intersection(a: Recti, b: Recti) Recti {
        var rect = Recti{ .x = 0, .y = 0, .width = 0, .height = 0 };
        rect.x = @max(b.x, a.x);
        rect.y = @max(b.y, a.y);
        rect.width = @min(a.width, b.width);
        rect.height = @min(a.height, b.height);
        return rect;
    }
};

pub const Circle = struct {
    pos: Vec2, // center pos
    radius: f32,
};

bits: []u32,
impl: *GuiImpl,
canvas: o.Olivec_Canvas,
plugin: *Plugin,

// slice representing all parameter controllers. Access via ID
components: []*Component,
last_component: ?*Component = null,
last_mouse_pos: Vec2 = undefined,

const BACKGROUND_COLOR = 0xff_80_80_00;
const BORDER_COLOR = 0xff_c0_f0_c0;

pub fn init(allocator: std.mem.Allocator, plugin: *Plugin) !*Gui {
    const ptr = try allocator.create(Gui);
    const bits = try allocator.alloc(u32, GUI_WIDTH * GUI_HEIGHT);
    ptr.* = .{
        .bits = bits,
        .impl = Platform.guiCreate(ptr, bits.ptr, GUI_WIDTH, GUI_HEIGHT),
        .plugin = plugin,
        .components = try allocator.alloc(*Component, Params.num_params),
        .canvas = o.olivec_canvas(bits.ptr, GUI_WIDTH, GUI_HEIGHT, GUI_WIDTH),
    };

    // create pointers, assign IDs and values
    // this is how the components get "attached" to parameters
    // setup unique properties here
    const knob_width = GUI_WIDTH / Params.num_params;
    for (ptr.components, 0..) |_, i| {
        ptr.components[i] = try allocator.create(Component);
        ptr.components[i].* = .{
            .canvas = &ptr.canvas,
            .id = @intCast(i),
            .type = .{ .slider = .{} },
            .draw = Component.Slider.draw,
            .value = @as(f32, @floatCast(try plugin.params.idToValue(@intCast(i)))),
            .pos = .{
                .x = @floatFromInt(i * knob_width + 50),
                .y = GUI_HEIGHT / 2 - 100,
            },
            .width = @as(f32, @floatFromInt(knob_width)) * 0.3,
            .height = 200,
            .fill_color = 0xff_cc_cc_cc,
            .border_color = 0xff_70_70_00,
            .border_size = 2,
            .label = .{
                .text = Params.idToName(@intCast(i)) catch @panic("Can't find param\n"),
                .height = 25,
            },
        };
    }

    return ptr;
}

pub fn deinit(self: *Gui, allocator: std.mem.Allocator) void {
    // free individual components
    for (self.components) |c|
        allocator.destroy(c);
    // free component slice
    allocator.free(self.components);
    Platform.guiDestroy(self.impl);
    allocator.free(self.bits);
    allocator.destroy(self);
}

pub export fn render(self: *const Gui) void {
    o.olivec_fill(self.canvas, BACKGROUND_COLOR);

    self.components[0].draw(self.components[0].*);
    // for (self.components) |c| {
    //     c.draw(c.*);
    // }
}

fn processGesture(
    self: *Gui,
    mouse_button: i8,
    mouse_pos: Vec2,
) !void {
    var comp: ?*Component = null;
    var mouse_delta: Vec2 = .{ .x = 0, .y = 0 };
    switch (mouse_button) {
        -1 => {
            // Mouse up
            self.last_component = null;
            std.debug.print("Mouse up\n", .{});
            return;
        },
        0 => {
            // Mouse dragging
            if (self.last_component) |_| {
                comp = self.last_component;
                mouse_delta.x = mouse_pos.x - self.last_mouse_pos.x;
                mouse_delta.y = mouse_pos.y - self.last_mouse_pos.y;
                self.last_mouse_pos = mouse_pos;
            }
        },
        1 => {
            self.last_mouse_pos = mouse_pos;
            // Mouse down
            for (self.components) |c| {
                if (c.hit_test(mouse_pos)) {
                    comp = c;
                    self.last_component = comp;
                    std.debug.print("Mouse on: {d}\n", .{comp.?.id});
                    break;
                }
            }
        },
        else => @panic("Invalid mouse button\n"),
    }

    if (comp == null) return;

    const id = comp.?.id;

    // get parameter value of component under mouse
    var p_val = try self.plugin.params.idToValue(id);
    const p_min = Params.list[id].minValue;
    const p_max = Params.list[id].maxValue;
    p_val += @as(f64, @floatCast(mouse_delta.y * 0.01));
    p_val = @min(p_max, @max(p_min, p_val));

    // change parameter
    self.plugin.params.setValue(id, p_val);
    const norm_value: f32 = @floatCast(try self.plugin.params.getNormalizedValue(id));
    comp.?.value = norm_value;
    self.plugin.onParamChange(id);

    // self.last_component = comp.?.id;
    // std.debug.assert(self.last_component.? < self.components.len);
}

export fn inputEvent(self: *Gui, cursorX: i32, cursorY: i32, button: i8) void {
    self.processGesture(
        button,
        .{ .x = @floatFromInt(cursorX), .y = @floatFromInt(cursorY) },
    ) catch |e| {
        stderr("{}\n", .{e});
    };
    Platform.guiRender(self.impl, true);
}
