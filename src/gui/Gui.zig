//! Gui.zig
//! Where you layout GUI properties & behavior

const std = @import("std");
const builtin = @import("builtin");
const build_options = @import("build_options");
const c_cast = std.zig.c_translation.cast;
const rl = @cImport({
    @cInclude("raylib.h");
});
pub const glfw = @cImport({
    @cInclude("GLFW/glfw3.h");
    switch (builtin.os.tag) {
        .linux => @cDefine("GLFW_EXPOSE_NATIVE_X11", {}),
        .macos => @cDefine("GLFW_EXPOSE_NATIVE_COCOA", {}),
        .windows => @cDefine("GLFW_EXPOSE_NATIVE_WIN32", {}),
        else => @panic("Unsupported OS"),
    }
    @cInclude("GLFW/glfw3native.h");
});
pub const Window = glfw.GLFWwindow;
const Plugin = @import("../Plugin.zig");
const Params = @import("../Params.zig");
const Components = @import("Components.zig");
const Gui = @This();

pub const GUI_WIDTH: c_uint = 400;
pub const GUI_HEIGHT: c_uint = 500;
const centerX: f32 = @as(f32, GUI_WIDTH) / 2.0;
const centerY: f32 = @as(f32, GUI_HEIGHT) / 2.0;

pub var font: rl.Font = undefined;

const State = enum {
    // TODO: Implement a state system to manage updates in a cleaner way
    GestureDetected,
    GestureContinue,
    GestureProcessed,
    Idle,
};

state: State = .Idle,

plugin: *Plugin,

window: *Window,

// slice representing all parameter knobs. Access via ID
components: []*Components.Knob,

// index to last component adjusted
last_component: ?u32 = null,

const BACKGROUND_COLOR = rl.Color{
    .r = 24,
    .g = 43,
    .b = 51,
    .a = 255,
};

pub fn init(allocator: std.mem.Allocator, plugin: *Plugin) !*Gui {
    rl.SetConfigFlags(rl.FLAG_WINDOW_RESIZABLE | rl.FLAG_WINDOW_UNDECORATED | rl.FLAG_VSYNC_HINT | rl.FLAG_MSAA_4X_HINT);
    rl.InitWindow(GUI_WIDTH, GUI_HEIGHT, Plugin.Description.plugin_name);
    rl.SetGesturesEnabled(rl.GESTURE_DRAG);
    const ptr = try allocator.create(Gui);
    ptr.* = .{
        .plugin = plugin,
        .components = try allocator.alloc(*Components.Knob, Params.numParams),
        // This gets the UI into proper event state
        .state = .Idle,
        .window = c_cast(*Window, rl.GetWindowHandle().?),
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
        .color = rl.RAYWHITE,
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
        .color = rl.RAYWHITE,
        .flags = .{
            .filled = true,
            .draw_label = true,
        },
    };

    // set default font
    const font_file = @embedFile("res/Sora-Regular.ttf");
    font = rl.LoadFontFromMemory(".ttf", font_file, font_file.len, 32, null, 0);

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
    _ = self.update() catch @panic("GUI update error");
    rl.BeginDrawing();

    rl.ClearBackground(BACKGROUND_COLOR);

    for (self.components) |c| {
        c.draw();
    }

    const ver_text_size = rl.MeasureTextEx(font, Plugin.Description.version, 13.0, 1.0);
    rl.DrawTextEx(font, Plugin.Description.version, .{ .x = @as(f32, @floatFromInt(GUI_WIDTH)) - ver_text_size.x - 5, .y = 10 }, 13.0, 1.0, rl.WHITE);
    const format_text_size = rl.MeasureTextEx(font, @tagName(build_options.format), 13.0, 1.0);
    rl.DrawTextEx(font, @tagName(build_options.format), .{ .x = @as(f32, @floatFromInt(GUI_WIDTH)) - format_text_size.x - 5, .y = 10 + ver_text_size.y }, 13.0, 1.0, rl.WHITE);

    if (builtin.mode == .Debug)
        rl.DrawFPS(5, 5);

    rl.EndDrawing();
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
                if (rl.IsGestureDetected(rl.GESTURE_DRAG)) {
                    self.state = .GestureDetected;
                    break;
                } else exit = true;
                // TODO: Check for mouse clicks and plain ol mouse over
            },
            .GestureDetected => {
                exit = try self.processGesture(false);
            },
            .GestureContinue => {
                exit = try self.processGesture(true);
            },
            .GestureProcessed => {
                if (rl.IsGestureDetected(rl.GESTURE_DRAG)) {
                    self.state = .GestureContinue;
                    break;
                }
                self.state = .Idle;
                if (self.last_component != null)
                    self.components[self.last_component.?].is_mouse_over = false;
                exit = true;
            },
        }
    }

    return may_repaint;
}

fn processGesture(self: *Gui, gesture_rendered: bool) !bool {
    const vec = rl.GetMouseDelta();
    const pos = rl.GetMousePosition();
    // check if still processing gesture on last component
    var comp: ?*Components.Knob = null;
    if (gesture_rendered)
        comp = self.components[self.last_component.?] // is_mouse_over should still be true
    else {
        // if not, get pointer to component which mouse is over
        outer: for (self.components) |c| {
            if (rl.CheckCollisionPointCircle(pos, .{
                .x = @as(f32, @floatFromInt(c.centerX)),
                .y = @as(f32, @floatFromInt(c.centerY)),
            }, c.width / 2.0)) {
                comp = c;
                comp.?.is_mouse_over = true;
                break :outer;
            }
        }
    }
    // otherwise, mouse event not on a component
    if (comp == null)
        return true;

    const id = comp.?.id;

    // get parameter value of component under mouse
    var p_val = try self.plugin.params.idToValue(id);
    const p_min = Params.list[id].minValue;
    const p_max = Params.list[id].maxValue;
    p_val += @as(f64, @floatCast(-vec.y * 0.01));
    p_val = @min(p_max, @max(p_min, p_val));

    // change parameter
    self.plugin.params.setValue(id, p_val);
    comp.?.value = try self.plugin.params.getNormalizedValue(id);

    self.last_component = comp.?.id;
    std.debug.assert(self.last_component.? < self.components.len);
    self.state = .GestureProcessed;
    return true;
}
