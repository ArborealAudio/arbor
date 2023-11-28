//! Gui.zig
//! Where you layout GUI properties & behavior

const std = @import("std");
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

pub const GUI_WIDTH = 400;
pub const GUI_HEIGHT = 500;
const centerX: f32 = @as(f32, GUI_WIDTH) / 2.0;
const centerY: f32 = @as(f32, GUI_HEIGHT) / 2.0;

pub const Vec2 = struct {
    x: f32,
    y: f32,
};

pub const Rect = struct {
    x: f32,
    y: f32,
    width: f32,
    height: f32,
};

pub const Circle = struct {
    pos: Vec2, // center pos
    radius: f32,
};

window: *anyopaque = undefined,
canvas: o.Olivec_Canvas,
bits: []u32,

plugin: *Plugin,

// slice representing all parameter controllers. Access via ID
components: []*Component,
last_component: ?*Component = null,
last_mouse_pos: Vec2 = undefined,

const BACKGROUND_COLOR = 0xff_80_80_00;
const BORDER_COLOR = 0xff_c0_f0_c0;

pub fn init(allocator: std.mem.Allocator, plugin: *Plugin) !*Gui {
    const ptr = try allocator.create(Gui);
    ptr.* = .{
        .plugin = plugin,
        .components = try allocator.alloc(*Component, Params.num_params),
        // This gets the UI into proper event state
        .bits = try allocator.alloc(u32, GUI_WIDTH * GUI_HEIGHT * 4),
        .canvas = o.olivec_canvas(ptr.bits.ptr, GUI_WIDTH, GUI_HEIGHT, GUI_WIDTH),
    };
    // define window separately bc it relies on `bits`
    if (implGuiCreate(plugin, ptr.bits.ptr, GUI_WIDTH, GUI_HEIGHT)) |disp|
        ptr.window = disp;

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
        };
    }

    // std.debug.print("{d}: Mix\n", .{ptr.components[Component.getComponentID("mix")].id});
    // std.debug.print("{d}: Feedback\n", .{ptr.components[Component.getComponentID("feedback")].id});

    // set default font
    // const font_file = @embedFile("res/Sora-Regular.ttf");
    // font = rl.LoadFontFromMemory(".ttf", font_file, font_file.len, 32, null, 0);

    return ptr;
}

pub fn deinit(self: *Gui, allocator: std.mem.Allocator) void {
    // free individual components
    for (self.components) |c|
        allocator.destroy(c);
    // free component slice
    allocator.free(self.components);
    Gui.implGuiDestroy(self.window);
    allocator.free(self.bits);
    allocator.destroy(self);
}

pub fn render(self: *Gui) void {
    o.olivec_fill(self.canvas, BACKGROUND_COLOR);

    for (self.components) |c| {
        c.draw(c.*, self.bits);
    }

    // const ver_text_size = rl.MeasureTextEx(font, Plugin.Description.version, 13.0, 1.0);
    // rl.DrawTextEx(font, Plugin.Description.version, .{ .x = @as(f32, @floatFromInt(GUI_WIDTH)) - ver_text_size.x - 5, .y = 10 }, 13.0, 1.0, rl.WHITE);
    // const format_text_size = rl.MeasureTextEx(font, @tagName(build_options.format), 13.0, 1.0);
    // rl.DrawTextEx(font, @tagName(build_options.format), .{ .x = @as(f32, @floatFromInt(GUI_WIDTH)) - format_text_size.x - 5, .y = 10 + ver_text_size.y }, 13.0, 1.0, rl.WHITE);

    // if (builtin.mode == .Debug)
    //     rl.DrawFPS(5, 5);

    // rl.EndDrawing();
}

pub fn drawRect(bits: []u32, rect: Rect, fill: u32, border: u32, border_thickness: f32) void {
    var y = rect.y;
    const bot = rect.y + rect.height;
    const right = rect.x + rect.width;
    while (y < bot) : (y += 1) {
        var x = rect.x;
        while (x < right) : (x += 1) {
            var pix = &bits[@intFromFloat(y * GUI_WIDTH + x)];
            pix.* = if (y <= rect.y + border_thickness or
                y >= bot - border_thickness - 1 or
                x <= rect.x + border_thickness or
                x >= right - border_thickness - 1) border else fill;
        }
    }
}

pub fn drawLine(bits: []u32, p1: Vec2, p2: Vec2, color: u32, thickness: f32) void {
    _ = thickness;
    // Bresenham's line algorithm
    const dx = p2.x - p1.x;
    const dy = p2.y - p1.y;
    var d = 2 * dy - dx;
    var y: u32 = @intFromFloat(p1.y);
    var x: u32 = @intFromFloat(p1.x);
    while (x < @as(u32, @intFromFloat(p2.x))) : (x += 1) {
        bits[y * GUI_WIDTH + x] = color;
        if (d > 0) {
            y += 1;
            d -= 2 * dx;
        }
        d += 2 * dy;
    }
}

pub fn drawCircle(bits: []u32, circle: Circle, fill: u32, border: u32, border_thickness: f32) void {
    const cx = circle.pos.x;
    const cy = circle.pos.y;
    const left = cx - circle.radius;

    var y = cy - circle.radius;
    var right = cx + circle.radius;
    var bot = cy + circle.radius;
    while (y < bot) : (y += 1) {
        var x = left;
        while (x < right) : (x += 1) {
            const adj = cx - x;
            const opp = cy - y;
            const hyp = @sqrt(adj * adj + opp * opp);
            const abs = @fabs(hyp);
            if (abs <= circle.radius - border_thickness) {
                bits[@intFromFloat(y * GUI_WIDTH + x)] = fill;
            } else if (abs <= circle.radius and abs >= circle.radius - border_thickness) {
                bits[@intFromFloat(y * GUI_WIDTH + x)] = border;
            }
        }
    }
}

// Midpoint algo
// ISSUE: How do we fill the circle?
fn drawCircleMidpoint(self: *Gui, pos: Vec2, radius: f32, fill: u32, border: u32, border_thickness: f32) void {
    _ = fill;
    _ = border_thickness;
    const cx: i32 = @intFromFloat(pos.x);
    const cy: i32 = @intFromFloat(pos.y);
    var x: i32 = @intFromFloat(radius);
    var y: i32 = 0;

    if (radius > 0) {
        self.bits[@intCast((cy - y) * GUI_WIDTH + x + cx)] = border;
        self.bits[@intCast((cx + y) * GUI_WIDTH + x + cy)] = border;
        self.bits[@intCast((cx - y) * GUI_WIDTH + x + cy)] = border;
    }

    var d: i32 = 1 - @as(i32, @intFromFloat(radius));

    while (x > y) {
        y += 1;

        // midpoint is inside or on the perimeter
        if (d <= 0) {
            d += 2 * y + 1;
        } else { // midoint is outside the perimeter
            x -= 1;
            d += 2 * y - 2 * x + 1;
        }

        if (x < y) break; // all border points have been drawn

        self.bits[@intCast((cy + y) * GUI_WIDTH + cx + x)] = border;
        self.bits[@intCast((cy + y) * GUI_WIDTH + cx - x)] = border;
        self.bits[@intCast((cy - y) * GUI_WIDTH + cx + x)] = border;
        self.bits[@intCast((cy - y) * GUI_WIDTH + cx - x)] = border;

        if (x != y) {
            self.bits[@intCast((cy + x) * GUI_WIDTH + cx + y)] = border;
            self.bits[@intCast((cy + x) * GUI_WIDTH + cx - y)] = border;
            self.bits[@intCast((cy - x) * GUI_WIDTH + cx + y)] = border;
            self.bits[@intCast((cy - x) * GUI_WIDTH + cx - y)] = border;
        }
    }
}

fn processGesture(self: *Gui, mouse_button: i8, mouse_pos: Vec2) !bool {
    var comp: ?*Component = null;
    var mouse_delta: Vec2 = .{ .x = 0, .y = 0 };
    switch (mouse_button) {
        -1 => {
            // Mouse up
            self.last_component = null;
            std.debug.print("Mouse up\n", .{});
            return false;
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

    if (comp == null) return false;

    const id = comp.?.id;

    // get parameter value of component under mouse
    var p_val = try self.plugin.params.idToValue(id);
    const p_min = Params.list[id].minValue;
    const p_max = Params.list[id].maxValue;
    p_val += @as(f64, @floatCast(mouse_delta.y * 0.01));
    p_val = @min(p_max, @max(p_min, p_val));

    // change parameter
    self.plugin.params.setValue(id, p_val);
    comp.?.value = @as(f32, @floatCast(try self.plugin.params.getNormalizedValue(id)));

    // self.last_component = comp.?.id;
    // std.debug.assert(self.last_component.? < self.components.len);
    return true;
}

// OS-specific UI handling functions
pub extern fn implGuiCreate(plugin: *Plugin, bits: [*]u32, w: u32, h: u32) callconv(.C) ?*anyopaque;
pub extern fn implGuiDestroy(main: *anyopaque) callconv(.C) void;
pub extern fn implGuiSetParent(display: ?*anyopaque, main: *anyopaque, window: ?*anyopaque) callconv(.C) void;
pub extern fn implGuiSetVisible(display: ?*anyopaque, main: *anyopaque, visible: bool) callconv(.C) void;
pub extern fn implGuiRender(main: *anyopaque) callconv(.C) void;
export fn implInputEvent(plugin: *Plugin, cursorX: i32, cursorY: i32, button: i8) callconv(.C) void {
    std.debug.assert(plugin.gui != null);
    _ = plugin.gui.?.processGesture(
        button,
        .{ .x = @floatFromInt(cursorX), .y = @floatFromInt(cursorY) },
    ) catch |e| {
        std.log.err("{}\n", .{e});
    };
    plugin.gui.?.render();
    implGuiRender(plugin.gui.?.window);
}
