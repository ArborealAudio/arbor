//! Gui.zig
//! Where you layout GUI properties & behavior

const std = @import("std");
const builtin = @import("builtin");
const build_options = @import("build_options");
const c_cast = std.zig.c_translation.cast;
const Plugin = @import("Plugin.zig");
const Params = @import("Params.zig");
const Components = @import("gui/Components.zig");
const Gui = @This();

pub const GUI_WIDTH = 400;
pub const GUI_HEIGHT = 500;
const centerX: f32 = @as(f32, GUI_WIDTH) / 2.0;
const centerY: f32 = @as(f32, GUI_HEIGHT) / 2.0;

window: *anyopaque = undefined, // ISSUE: I hate undefined fields! Figure out a better way to organize this
bits: []u32,

plugin: *Plugin,

// slice representing all parameter knobs. Access via ID
components: []*Components.Knob,

state: State = .Idle,

// index to last component adjusted
last_component: ?u32 = null,

const State = enum {
    // TODO: Improve state system to manage updates in a cleaner way
    GestureDetected,
    GestureContinue,
    GestureProcessed,
    Idle,
};

const BACKGROUND_COLOR = 0x18_2b_33_ff;

pub fn init(allocator: std.mem.Allocator, plugin: *Plugin) !*Gui {
    const ptr = try allocator.create(Gui);
    ptr.* = .{
        .plugin = plugin,
        .components = try allocator.alloc(*Components.Knob, Params.numParams),
        // This gets the UI into proper event state
        .state = .Idle,
        .bits = try allocator.alloc(u32, GUI_WIDTH * GUI_HEIGHT * 4),
    };
    // create pointers, assign IDs and values
    // this is how the components get "attached" to parameters
    for (ptr.components, 0..) |_, i| {
        ptr.components[i] = try allocator.create(Components.Knob);
        ptr.components[i].id = @intCast(i);
        ptr.components[i].value = try plugin.params.getNormalizedValue(@intCast(i));
    }

    // setup unique properties here
    ptr.components[Components.getComponentID("mix")].* = .{
        .label = .{
            .text = "Mix",
            .size = 25.0,
            .spacing = 7,
        },
        .centerX = centerX - 75.0,
        .centerY = centerY,
        .width = 100.0,
        .color = 0xff_ff_ff_ff,
        .flags = .{
            .filled = true,
            .draw_label = true,
        },
    };
    ptr.components[Components.getComponentID("feedback")].* = .{
        .label = .{
            .text = "Delay",
            .size = 25.0,
            .spacing = 7,
        },
        .centerX = centerX + 75.0,
        .centerY = centerY,
        .width = 100.0,
        .color = 0xff_ff_ff_ff,
        .flags = .{
            .filled = true,
            .draw_label = true,
        },
    };

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
}

pub fn render(self: *Gui) void {
    // IDEA: What if we handle GUI events here, i.e. mouse clicks, and passing parameter changes to UI
    // can still happen in the plugin's timer?
    // UPDATE: Mostly did that, except parameter changes from host are processed in plugin wrapper, not timer
    // _ = self.update() catch @panic("GUI update error");

    self.drawRect(.{
        .x = 0,
        .y = 0,
        .width = GUI_WIDTH,
        .height = GUI_HEIGHT,
    }, 0x80_80_00, 0xc0_f0_c0, 5);

    // self.drawCircle(.{ .x = centerX, .y = centerY }, 100, 0x0000ff, 0, 0);
    self.drawCircleCustom(.{ .x = centerX, .y = centerY }, 100, 0x0000ff, 0, 2.5);

    // for (self.components) |c| {
    //     c.draw();
    // }

    // const ver_text_size = rl.MeasureTextEx(font, Plugin.Description.version, 13.0, 1.0);
    // rl.DrawTextEx(font, Plugin.Description.version, .{ .x = @as(f32, @floatFromInt(GUI_WIDTH)) - ver_text_size.x - 5, .y = 10 }, 13.0, 1.0, rl.WHITE);
    // const format_text_size = rl.MeasureTextEx(font, @tagName(build_options.format), 13.0, 1.0);
    // rl.DrawTextEx(font, @tagName(build_options.format), .{ .x = @as(f32, @floatFromInt(GUI_WIDTH)) - format_text_size.x - 5, .y = 10 + ver_text_size.y }, 13.0, 1.0, rl.WHITE);

    // if (builtin.mode == .Debug)
    //     rl.DrawFPS(5, 5);

    // rl.EndDrawing();
}

/// function for getting mouse events, checking parameters
pub fn update(self: *Gui) !bool {
    // TODO: replace with proper events query

    var may_repaint = false;
    var exit = false;

    while (!exit) {
        switch (self.state) {
            .Idle => {
                // check param changes
                for (&Plugin.parameter_changed, 0..) |*p, i| {
                    // set the associated component value based off the current param value
                    if (p.*) {
                        self.components[i].value = try self.plugin.params.getNormalizedValue(@as(u32, @intCast(i)));
                        p.* = false;
                        may_repaint = true;
                    }
                }
                // check for gestures
                // if (rl.IsGestureDetected(rl.GESTURE_DRAG)) {
                //     self.state = .GestureDetected;
                //     break;
                // } else exit = true;
                // TODO: Check for mouse clicks and plain ol mouse over
            },
            .GestureDetected => {
                exit = try self.processGesture(false);
            },
            .GestureContinue => {
                exit = try self.processGesture(true);
            },
            .GestureProcessed => {
                // if (rl.IsGestureDetected(rl.GESTURE_DRAG)) {
                //     self.state = .GestureContinue;
                //     break;
                // }
                self.state = .Idle;
                if (self.last_component != null)
                    self.components[self.last_component.?].is_mouse_over = false;
                exit = true;
            },
        }
    }

    return may_repaint;
}

const Vec2 = struct {
    x: f32,
    y: f32,
};

const Rect = struct {
    x: f32,
    y: f32,
    width: f32,
    height: f32,
};

fn drawRect(self: *Gui, rect: Rect, fill: u32, border: u32, border_thickness: f32) void {
    var y = rect.y;
    const bot = rect.y + rect.height;
    const right = rect.x + rect.width;
    while (y < bot) : (y += 1) {
        var x = rect.x;
        while (x < right) : (x += 1) {
            self.bits[@intFromFloat(y * GUI_WIDTH + x)] = if (y <= rect.y + border_thickness or
                y >= bot - border_thickness - 1 or
                x <= rect.x + border_thickness or
                x >= right - border_thickness - 1) border else fill;
        }
    }
}

fn drawCircleCustom(self: *Gui, pos: Vec2, radius: f32, fill: u32, border: u32, border_thickness: f32) void {
    const cx = pos.x;
    const cy = pos.y;
    const left = cx - radius;

    var y = cy - radius;
    var right = cx + radius;
    var bot = cy + radius;
    while (y < bot) : (y += 1) {
        var x = left;
        while (x < right) : (x += 1) {
            const adj = cx - x;
            const opp = cy - y;
            const hyp = @sqrt(adj * adj + opp * opp);
            const abs = @fabs(hyp);
            if (abs <= radius - border_thickness) {
                self.bits[@intFromFloat(y * GUI_WIDTH + x)] = fill;
            } else if (abs <= radius and abs >= radius - border_thickness)
                self.bits[@intFromFloat(y * GUI_WIDTH + x)] = border;
        }
    }
}

// Midpoint algo
// ISSUE: How do we fill the circle?
fn drawCircle(self: *Gui, pos: Vec2, radius: f32, fill: u32, border: u32, border_thickness: f32) void {
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

        if (d <= 0)
            d += 2 * y + 1
        else {
            x -= 1;
            d += 2 * y - 2 * x + 1;
        }

        if (x < y) break;

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

fn processGesture(self: *Gui, gesture_rendered: bool) !bool {
    // const vec = rl.GetMouseDelta();
    // const pos = rl.GetMousePosition();
    // check if still processing gesture on last component
    var comp: ?*Components.Knob = null;
    if (gesture_rendered)
        comp = self.components[self.last_component.?] // is_mouse_over should still be true
    else {
        // if not, get pointer to component which mouse is over
        // outer: for (self.components) |c| {
        //     if (rl.CheckCollisionPointCircle(pos, .{
        //         .x = @as(f32, @floatFromInt(c.centerX)),
        //         .y = @as(f32, @floatFromInt(c.centerY)),
        //     }, c.width / 2.0)) {
        //         comp = c;
        //         comp.?.is_mouse_over = true;
        //         break :outer;
        //     }
        // }
    }
    // otherwise, mouse event not on a component
    if (comp == null)
        return true;

    const id = comp.?.id;

    // get parameter value of component under mouse
    var p_val = try self.plugin.params.idToValue(id);
    const p_min = Params.list[id].minValue;
    const p_max = Params.list[id].maxValue;
    // p_val += @as(f64, @floatCast(-vec.y * 0.01));
    p_val = @min(p_max, @max(p_min, p_val));

    // change parameter
    self.plugin.params.setValue(id, p_val);
    comp.?.value = try self.plugin.params.getNormalizedValue(id);

    self.last_component = comp.?.id;
    std.debug.assert(self.last_component.? < self.components.len);
    self.state = .GestureProcessed;
    return true;
}
