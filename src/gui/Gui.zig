//! Gui.zig
//! Where you layout GUI properties & behavior

const std = @import("std");
const rl = @cImport({
    @cInclude("raylib.h");
});
const Plugin = @import("../Plugin.zig");
const Params = @import("../Params.zig");
const Components = @import("Components.zig");

pub const GUI_WIDTH: c_uint = 400;
pub const GUI_HEIGHT: c_uint = 500;
const centerX: f32 = @as(f32, GUI_WIDTH) / 2.0;
const centerY: f32 = @as(f32, GUI_HEIGHT) / 2.0;

pub var font: rl.Font = undefined;

// slice representing all parameter knobs. Access via ID
var components: [Params.numParams]Components.Knob = undefined;

var gesture_rendered = false;

// last component adjusted
var last_component: ?*Components.Knob = null;

const BACKGROUND_COLOR = rl.Color{
    .r = 24,
    .g = 43,
    .b = 51,
    .a = 255,
};

pub fn init(plugin: *Plugin) !void {
    // set default font
    const font_file = @embedFile("res/Sora-Regular.ttf");
    font = rl.LoadFontFromMemory(".ttf", font_file, font_file.len, 32, null, 0);

    // setup unique properties here
    components[Components.getComponentID("mix")] = .{
        .label = .{
            .text = "Mix",
            .size = 25.0,
            .spacing = 7,
        },
        .centerX = centerX,
        .centerY = centerY,
        .width = 150.0,
        .color = rl.RAYWHITE,
        .flags = .{
            .filled = true,
            .draw_label = true,
        },
    };

    // assign IDs and values
    // this is how the components get "attached" to parameters
    for (&components, 0..) |*c, i| {
        c.id = @intCast(u32, i);
        c.value = try plugin.params.getNormalizedValue(@intCast(u32, i));
    }
}

pub fn render(plugin: *Plugin) void {
    // IDEA: What if we handle GUI events here, i.e. mouse clicks, and passing parameter changes to UI
    // can still happen in the plugin's timer?
    // UPDATE: Mostly did that, except parameter changes from host are processed in plugin wrapper, not timer
    update(plugin) catch @panic("GUI update error");
    rl.BeginDrawing();

    rl.ClearBackground(BACKGROUND_COLOR);

    for (&components) |*c| {
        c.draw();
    }

    rl.DrawFPS(5, 5);

    rl.EndDrawing();
}

/// function for getting mouse events, checking parameters
fn update(plugin: *Plugin) !void {
    // TODO: replace with proper events query

    // check param changes
    for (&Plugin.parameter_changed, 0..) |*p, i| {
        // set the associated component value based off the current param value
        if (p.*) {
            components[i].value = try plugin.params.getNormalizedValue(@intCast(u32, i));
            p.* = false;
        }
    }

    // check for mouse events
    if (rl.IsGestureDetected(rl.GESTURE_DRAG)) {
        const vec = rl.GetMouseDelta();
        const pos = rl.GetMousePosition();
        var comp: ?*Components.Knob = null;
        outer: for (&components) |*c| {
            if (rl.CheckCollisionPointCircle(pos, .{
                .x = @intToFloat(f32, c.centerX),
                .y = @intToFloat(f32, c.centerY),
            }, c.width / 2.0) or gesture_rendered) { // if gesture rendered last update, still processing gesture on the same comp
                comp = c;
                comp.?.is_mouse_over = true;
                break :outer;
            }
        }

        if (comp == null) return;

        const id = comp.?.id;

        // get parameter value of component under mouse
        var p_val = try plugin.params.idToValue(id);
        p_val += @floatCast(f64, -vec.y * 0.01);
        p_val = @min(1.0, @max(0.0, p_val));

        // change parameter
        plugin.params.setValue(id, p_val);
        comp.?.value = try plugin.params.getNormalizedValue(id);

        gesture_rendered = true;
        last_component = comp.?;
    } else {
        gesture_rendered = false;
        if (last_component != null) last_component.?.is_mouse_over = false;
    }
}
