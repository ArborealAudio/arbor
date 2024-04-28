const std = @import("std");
const builtin = @import("builtin");
const arbor = @import("../arbor.zig");
const log = arbor.log;
const Plugin = arbor.Plugin;
pub const Component = @import("Component.zig");
pub const Label = Component.Label;
pub const Text = @import("Text.zig");
pub const olivec = @import("olivec.zig");
pub const Color = @import("Color.zig");
pub const Platform = @import("platform.zig");
pub const GuiImpl = Platform.GuiImpl;

const Gui = @This();

pub const WIDTH = 500;
pub const HEIGHT = 600;
const centerX: f32 = @as(f32, WIDTH) / 2.0;
const centerY: f32 = @as(f32, HEIGHT) / 2.0;

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
canvas: olivec.Canvas,
plugin: *const Plugin,

// slice representing all parameter controllers. Access via ID
components: []Component,

state: struct {
    type: enum {
        Idle,
        MouseDown,
        MouseDragging,
    } = .Idle,

    mouse_pos: Vec2 = .{ .x = 0, .y = 0 },
    comp_id: ?usize = null,
} = .{},

const BACKGROUND_COLOR = Color{ .r = 0, .g = 0x80, .b = 0x80, .a = 0xff };
const BORDER_COLOR = Color{ .r = 0xc0, .g = 0xf0, .b = 0xc0, .a = 0xff };

pub fn init(allocator: std.mem.Allocator, plugin: *const Plugin) !*Gui {
    const ptr = try allocator.create(Gui);
    const bits = try allocator.alloc(u32, WIDTH * HEIGHT);
    ptr.* = .{
        .bits = bits,
        .impl = Platform.guiCreate(ptr, bits.ptr, WIDTH, HEIGHT),
        .plugin = plugin,
        .components = try allocator.alloc(Component, plugin.params.len),
        .canvas = olivec.olivec_canvas(bits.ptr, WIDTH, HEIGHT, WIDTH),
    };

    // create pointers, assign IDs and values
    // this is how the components get "attached" to parameters
    // setup unique properties here
    const knob_width = (WIDTH / plugin.params.len) / 2;
    const gap = WIDTH / 8;
    for (ptr.components, 0..) |*c, i| {
        const param_info = try plugin.getParamId(@intCast(i));
        c.* = .{
            .canvas = ptr.canvas,
            .id = @intCast(i),
            .type = .{ .slider = .{} },
            .draw = Component.Slider.draw,
            .value = param_info.getNormalizedValue(param_info.default_value),
            .pos = .{
                .x = @floatFromInt(i * knob_width + gap * (i + 1)),
                .y = HEIGHT / 2 - 100,
            },
            .width = @as(f32, @floatFromInt(knob_width)),
            .height = 200,
            .fill_color = (Color{ .a = 0xff, .r = 0xcc, .g = 0xcc, .b = 0xcc }).bits(),
            .border_color = (Color{ .a = 0xff, .g = 0x70, .r = 0, .b = 0x70 }).bits(),
            .label = .{
                .text = param_info.name,
                .height = 18,
                .color = 0xffffffff,
                .border = (Color{ .a = 0xff, .r = 0xcc, .g = 0xcc, .b = 0xcc }).bits(),
                .flags = .{
                    .border = true,
                    .center_x = true,
                    .center_y = false,
                },
            },
        };
    }

    return ptr;
}

pub fn deinit(self: *Gui, allocator: std.mem.Allocator) void {
    // free individual components
    // for (self.components) |c|
    //     allocator.destroy(c);
    // free component slice
    allocator.free(self.components);
    Platform.guiDestroy(self.impl);
    allocator.free(self.bits);
    allocator.destroy(self);
}

// TODO: This really only needs to be user code
// export so platform lib can call this
fn render(self: *const Gui) callconv(.C) void {
    olivec.olivec_fill(self.canvas, BACKGROUND_COLOR.bits());
    olivec.olivec_frame(self.canvas, 2, 2, WIDTH - 4, HEIGHT - 4, 4, BORDER_COLOR.bits());

    for (self.components) |c| {
        c.draw(c);
    }
}

fn processGesture(
    self: *Gui,
    mouse_pos: Vec2,
) !void {
    const plugin = self.plugin;
    switch (self.state.type) {
        .MouseDragging => {
            const mouse_delta: Vec2 = .{
                .x = mouse_pos.x - self.state.mouse_pos.x,
                .y = mouse_pos.y - self.state.mouse_pos.y,
            };
            self.state.mouse_pos = mouse_pos;
            if (self.state.comp_id) |id| {
                // get parameter value of component under mouse
                const param_info = try plugin.getParamId(@intCast(id));
                var p_val = param_info.getNormalizedValue(plugin.params[id]);
                p_val += mouse_delta.y * 0.025;
                p_val = @min(1, @max(0, p_val));
                // change parameter
                // TODO: Figure out a better way to sync GUI values & param values
                plugin.params[id] = param_info.valueFromNormalized(p_val);
                self.components[id].value = p_val;
                // plugin.onParamChange(id);
            }
        },
        .MouseDown => {
            // Mouse down
            for (self.components, 0..) |c, i| {
                if (c.hit_test(mouse_pos)) {
                    self.state.comp_id = i;
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

fn inputEvent(self: *Gui, cursorX: i32, cursorY: i32, button: i8) callconv(.C) void {
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
    @export(render, .{ .name = "render", .linkage = .weak });
}
