const std = @import("std");
const builtin = @import("builtin");
const Allocator = std.mem.Allocator;

const arbor = @import("../arbor.zig");
const log = arbor.log;

const Plugin = arbor.Plugin;

const Event = arbor.Event;
const Queue = arbor.Queue;

pub const renderpkg = @import("render/render.zig");
pub const Graphics = renderpkg.Graphics;
pub const Vec2 = renderpkg.Vec2i;
pub const Vec2u = renderpkg.Vec2u;
pub const Rect = renderpkg.Rect;
pub const Color = renderpkg.Color;

const AtomicBool = std.atomic.Value(bool);

const Gui = @This();

pub const GuiConfig = struct {
    width: u32,
    height: u32,
    interface: Interface,
    timer_ms: u32,
};

pub const Interface = struct {
    render: *const fn (*Gui) void,
    deinit: *const fn (*Gui) void,
};

g: *Graphics,
interface: Interface,
plugin: *const Plugin,

components: std.ArrayList(Component),

width: u32,
height: u32,

in_events: *Queue,
out_events: *Queue,

allocator: Allocator,

state: struct {
    // type: GuiState = .Idle,

    mouse_pos: Vec2 = .{ .x = 0, .y = 0 },
    comp_id: ?usize = null,
} = .{},

wants_repaint: AtomicBool = AtomicBool.init(true),

var arena_impl = std.heap.ArenaAllocator.init(std.heap.c_allocator);
const arena = arena_impl.allocator();

/// Call this from within your gui_init function to init the GUI backend
pub fn init(plugin: *Plugin, config: GuiConfig) *Gui {
    const ptr = arena.create(Gui) catch |e| log.fatal("{!}\n", .{e}, @src());
    // const bits = arena.alloc(u32, config.width * config.height) catch |e|
    //     log.fatal("{!}\n", .{e}, @src());
    ptr.* = .{
        .allocator = arena,
        .g = renderpkg.init(
            @intCast(config.width),
            @intCast(config.height),
            arbor.plugin_name,
            .{ .child = .{ .user = ptr } },
        ) catch |e| log.fatal("{!}\n", .{e}, @src()),
        .interface = config.interface,
        .plugin = plugin,
        .width = config.width,
        .height = config.height,
        .components = std.ArrayList(Component).init(arena),
        .in_events = Queue.init(arena) catch |e| log.fatal("{!}\n", .{e}, @src()),
        .out_events = Queue.init(arena) catch |e| log.fatal("{!}\n", .{e}, @src()),
    };

    plugin.gui = ptr;

    return ptr;
}

pub fn deinit(self: *Gui) void {
    self.interface.deinit(self);
    self.g.deinit();
    arena_impl.deinit();
}

pub fn requestDraw(self: *Gui) void {
    self.wants_repaint.store(true, .release);
}

fn render(self: *Gui) callconv(.C) void {
    // unload event queue
    self.processInEvents();

    self.g.beginDrawing();
    self.g.clear(.{ .r = 0, .g = 0, .b = 0 });
    self.g.fillRect(
        .{ .left = 100, .top = 100, .right = @floatFromInt(self.width - 100), .bottom = @floatFromInt(self.height - 100) },
        .{ .r = 0, .g = 1, .b = 0, .a = 0.25 },
    );
    self.g.endDrawing();

    self.interface.render(self);

    // check for component param change flags & push to plugin
    for (self.components.items, 0..) |*c, i| {
        if (c.param_changed) {
            self.out_events.push_wait(.{
                .param_change = .{ .id = i, .value = c.value },
            }) catch |e| {
                log.err("out_events push failed: {!}\n", .{e}, @src());
                return;
            };
            c.param_changed = false;
        }
    }
}

// wraps all event handling under one lock
fn processInEvents(self: *Gui) void {
    self.in_events.mutex.lock();
    defer self.in_events.mutex.unlock();
    while (self.in_events.next_no_lock()) |event| {
        switch (event) {
            .param_change => |change| {
                const comp = self.getComponent(change.id);
                comp.value = change.value;
            },
        }
    }
}

// fn sysInputEvent(self: *Gui, cursor_x: i32, cursor_y: i32, state: GuiState) callconv(.C) void {
//     if (self.state.type != state)
//         self.state.type = state;
//     self.processGesture(
//         .{ .x = cursor_x, .y = cursor_y },
//     ) catch |e| {
//         log.err("{!}\n", .{e}, @src());
//         return;
//     };
//     self.requestDraw();
// }

pub fn getSize(self: Gui) Vec2 {
    const size = self.g.getRenderSize();
    return .{ .x = @intFromFloat(size.width), .y = @intFromFloat(size.height) };
}

// NOTE: We do expect pointers for now, would prefer not to rely on heap
// allocation but our "inheritance" model kind of forces that.
pub fn addComponent(self: *Gui, component: Component) void {
    self.components.append(component) catch |e|
        log.err("Component append failed: {!}\n", .{e}, @src());
}

pub fn getComponent(self: *Gui, id: usize) *Component {
    return &self.components.items[id];
}

pub fn getComponentUnderMouse(self: *Gui, mouse: Vec2) ?struct {
    *Component,
    usize,
} {
    for (self.components.items, 0..) |*c, i| {
        if (c.hitTest(mouse)) return .{ c, i };
    }
    return null;
}

fn processGesture(
    self: *Gui,
    mouse_pos: Vec2,
) !void {
    switch (self.state.type) {
        .MouseDrag => {
            const mouse_delta: Vec2 = .{
                .x = mouse_pos.x - self.state.mouse_pos.x,
                .y = mouse_pos.y - self.state.mouse_pos.y,
            };
            if (self.state.comp_id) |id| {
                const comp = self.getComponent(id);
                if (comp.interface.on_mouse_drag) |func|
                    func(comp, mouse_delta);
            } else {
                if (self.getComponentUnderMouse(mouse_pos)) |c| {
                    if (c[0].interface.on_mouse_drag) |func|
                        func(c[0], mouse_delta);
                    self.state.comp_id = c[1];
                }
            }
            self.state.mouse_pos = mouse_pos;
        },
        .MouseDown => {
            if (self.state.comp_id) |id| {
                const comp = self.getComponent(id);
                if (comp.interface.on_mouse_click) |func|
                    func(comp, mouse_pos);
            } else {
                if (self.getComponentUnderMouse(mouse_pos)) |c| {
                    if (c[0].interface.on_mouse_click) |func|
                        func(c[0], mouse_pos);
                    self.state.comp_id = c[1];
                }
            }
            self.state.mouse_pos = mouse_pos;
        },
        .MouseOver => {
            if (self.getComponentUnderMouse(mouse_pos)) |c| {
                if (self.state.comp_id) |id| {
                    if (c[1] != id) {
                        // mouse moved to new component
                        const last_c = self.getComponent(id);
                        if (last_c.interface.on_mouse_exit) |func|
                            func(last_c);
                    }
                }
                if (c[0].interface.on_mouse_over) |func|
                    func(c[0], mouse_pos);
                self.state.comp_id = c[1];
            } else {
                // mouse left last component, over nothing
                if (self.state.comp_id) |id| {
                    // mouse left last comp
                    const comp = self.getComponent(id);
                    if (comp.interface.on_mouse_exit) |func|
                        func(comp);
                    self.state.type = .Idle;
                    self.state.comp_id = null;
                }
            }
            self.state.mouse_pos = mouse_pos;
        },
        .MouseUp => {
            self.state.comp_id = null; // easiest just to null it. If we get another
            // click or drag we hit test again anyway
            self.state.mouse_pos = mouse_pos;
            self.state.type = .MouseOver;
        },
        .Idle => {}, // will this ever be called when state is idle?
    }
}

const LayoutType = union(enum) {
    default: void,
    grid: struct {
        rows: u32,
        cols: u32,
    },
    binary,
};

// pub fn performLayout(self: *Gui) void {
//     const gui_size = self.getSize();
//     switch (self.layout) {
//         .default => {
//             for (self.components.items) |*c| {
//                 const pad = draw.Vec2u.fromVec2i(c.padding);
//                 c.bounds.x += pad.x;
//                 c.bounds.y += pad.y;
//                 c.bounds.width -= @intCast(pad.x * 2);
//                 c.bounds.height -= @intCast(pad.y * 2);
//             }
//         },
//         .grid => |grid| {
//             var row: u32 = 0;
//             var col: u32 = 0;
//             for (self.components.items) |*c| {
//                 const pad = draw.Vec2u.fromVec2i(c.padding);
//                 const unit_width = @as(u32, @intCast(gui_size.x)) / grid.cols -
//                     @as(u32, @intCast(pad.x)) * 2;
//                 const unit_height = @as(u32, @intCast(gui_size.y)) / grid.rows -
//                     @as(u32, @intCast(pad.y)) * 2;
//                 c.bounds.x = @intCast(unit_width * col);
//                 c.bounds.x += pad.x;
//                 c.bounds.y = @intCast(unit_height * row);
//                 c.bounds.y += pad.y;
//                 c.bounds.width = unit_width;
//                 c.bounds.height = unit_height;

//                 col += 1;
//                 if (col > grid.cols - 1) {
//                     col = 0;
//                     row += 1;
//                 }
//             }
//         },
//         .binary => {},
//     }
// }

/// Struct for organizing text attached to a component, or for creating a quick
/// text layout for passing into a text drawing function.
pub const Label = struct {
    pub const Flags = packed struct {
        center_x: bool = true,
        center_y: bool = true,
        background: bool = false,
        border: bool = false,
    };

    text: []const u8,
    height: u32,
    flags: Flags = .{},
    color: Color,
    background: Color = std.mem.zeroes(Color),
    border: Color = std.mem.zeroes(Color),
    // TODO: Kerning
};

pub const Component = struct {
    pub const Interface = struct {
        draw_proc: *const fn (self: *Component, gi: *Graphics) void,
        on_mouse_over: ?*const fn (self: *Component, Vec2) void,
        on_mouse_exit: ?*const fn (self: *Component) void,
        on_mouse_click: ?*const fn (self: *Component, Vec2) void,
        on_mouse_drag: ?*const fn (self: *Component, Vec2) void,
    };

    bounds: Rect = Rect.zero,
    padding: Vec2 = .{ .x = 0, .y = 0 },
    background_color: Color,

    sub_type: ?*anyopaque = null,

    value: f32,

    value_to_text: ?*const fn (value: f32, buf: []u8) usize = null,

    /// every component may have a label, and it's up to the drawing procedure
    /// to determine how it is displayed.
    label: ?Label,

    interface: Component.Interface,

    /// flag to let the GUI know a parameter needs to be updated
    // NOTE: Would all components need this?
    param_changed: bool = false,

    pub fn hitTest(self: Component, pt: Vec2) bool {
        const pu = Vec2u.fromVec2i(pt);
        return (pu.x >= self.bounds.x and
            pu.y >= self.bounds.y and
            pu.x <= self.bounds.x + self.bounds.width and
            pu.y <= self.bounds.y + self.bounds.height);
    }

    pub fn setValue(self: *Component, val: f32) void {
        self.value = val;
    }
};

pub const Slider = struct {
    // reference to associated parameter
    param: *const arbor.Parameter,

    // main color of the slider
    color: Color,

    flags: packed struct {
        draw_value: bool = true,
    },

    pub fn init(allocator: Allocator, param: *const arbor.Parameter, color: Color) *Slider {
        const self = allocator.create(Slider) catch |e|
            log.fatal("Slider alloc failed: {!}\n", .{e}, @src());
        self.* = .{ .param = param, .color = color, .flags = .{} };
        return self;
    }

    fn draw_proc(self: *Component, g: *Graphics) void {
        const slider = arbor.cast(*Slider, self.sub_type);
        const height = if (self.label) |label|
            self.bounds.height - @as(f32, @floatFromInt(label.height))
        else
            self.bounds.height;
        const val_height: u32 = @intFromFloat(@as(f32, @floatFromInt(height)) *
            self.value);
        const top = self.bounds.y + (height - val_height);

        // draw borders
        g.fillRect(self.bounds.toPlatform(), self.background_color.toPlatform());

        g.fillRect(.{
            .left = self.bounds.x,
            .top = top,
            .right = self.bounds.x + self.bounds.width,
            .bottom = top + val_height,
        }, slider.color.toPlatform());

        if (self.label) |l| {
            const text_y: u32 = self.bounds.y + height;
            const text_x: u32 = self.bounds.x;
            g.drawText(l, .{
                .left = text_x,
                .top = text_y,
                .right = text_x + self.bounds.width,
                .bottom = text_y + l.height,
            }, Color.White.toPlatform());
        }

        if (slider.flags.draw_value) {
            var buf: [10]u8 = undefined;
            if (slider.param.value_to_text) |func| {
                const denorm = slider.param.valueFromNormalized(self.value);
                const len = func(denorm, &buf);
                g.drawText(buf[0..len], .{
                    .left = self.bounds.x,
                    .top = self.bounds.y,
                    .right = self.bounds.x + self.bounds.width,
                    .bottom = self.bounds.y + 25,
                });
            }
        }
    }

    fn on_mouse_drag(self: *Component, mouse_delta: Vec2) void {
        var val = self.value;
        val += -@as(f32, @floatFromInt(mouse_delta.y)) * 0.025;
        val = @min(1, @max(0, val));
        self.value = val;
        self.param_changed = true;
    }

    pub const interface = Component.Interface{
        .draw_proc = draw_proc,
        .on_mouse_drag = on_mouse_drag,
        .on_mouse_exit = null,
        .on_mouse_over = null,
        .on_mouse_click = null,
    };
};

pub const Menu = struct {
    choices: []const []const u8,

    border_color: Color,
    border_thickness: u32,

    highlight_color: Color,

    is_mouse_over: bool = false,
    mouse_choice: ?usize = null,
    open: bool = false,

    // ISSUE: If we heap alloc we have to pair it with a destroy. How do we call this sub-type's destroy method?
    pub fn init(
        allocator: Allocator,
        choices: []const []const u8,
        border_color: Color,
        border_thickness: u32,
        highlight_color: Color,
    ) *Menu {
        const self = allocator.create(Menu) catch |e| log.fatal("Menu init failed: {!}\n", .{e}, @src());
        self.* = .{
            .choices = choices,
            .border_color = border_color,
            .border_thickness = border_thickness,
            .highlight_color = highlight_color,
        };
        return self;
    }

    pub fn draw_proc(self: *Component, g: *Graphics) void {
        const menu = arbor.cast(*Menu, self.sub_type);
        // const border = if (menu.is_mouse_over)
        //     menu.highlight_color
        // else
        //     menu.border_color;

        // const label_height = self.bounds.height / 2;

        if (menu.open and menu.is_mouse_over) {
            g.fillRect(
                self.bounds.toPlatform(),
                self.background_color.toBits(),
            );
            const choice_h: f32 = self.bounds.height / @as(f32, @floatFromInt(menu.choices.len));
            for (menu.choices, 0..) |choice, i| {
                if (menu.mouse_choice) |mc| {
                    if (i == mc) {
                        g.fillRect(
                            .{
                                .left = self.bounds.x,
                                .top = self.bounds.y + (choice_h * @as(f32, @floatFromInt(i))),
                                .right = self.bounds.x + self.bounds.width,
                                .bottom = self.bounds.y + choice_h,
                            },
                            menu.highlight_color.toPlatform(),
                        );
                    }
                }
                g.drawText(choice, .{
                    .x = self.bounds.x,
                    .y = self.bounds.y + (choice_h * @as(f32, @floatFromInt(i))),
                    .width = self.bounds.x + self.bounds.width,
                    .height = self.bounds.y + choice_h,
                }, Color.White.toPlatform());
            }
            return;
        }

        // if (self.label) |label| {
        //     draw.drawText(canvas, label, .{
        //         .x = self.bounds.x,
        //         .y = self.bounds.y,
        //         .width = self.bounds.width,
        //         .height = label_height,
        //     });
        // }

        // const menu_y = self.bounds.y + label_height;

        // draw.olivec_rect(
        //     canvas,
        //     @intCast(self.bounds.x),
        //     @intCast(menu_y),
        //     @intCast(self.bounds.width),
        //     @intCast(label_height),
        //     self.background_color.toBits(),
        // );
        // draw.olivec_frame(
        //     canvas,
        //     @intCast(self.bounds.x),
        //     @intCast(menu_y),
        //     @intCast(self.bounds.width),
        //     @intCast(label_height),
        //     menu.border_thickness,
        //     border.toBits(),
        // );

        // const current = menu.choices[
        //     @intFromFloat(self.value *
        //         (@as(f32, @floatFromInt(menu.choices.len)) - 1))
        // ];
        // draw.drawText(canvas, .{
        //     .text = current,
        //     .height = label_height / 2,
        //     .color = Color.WHITE,
        // }, .{
        //     .x = self.bounds.x,
        //     .y = menu_y,
        //     .width = self.bounds.width,
        //     .height = label_height,
        // });
    }

    fn on_mouse_click(self: *Component, mouse: Vec2) void {
        _ = mouse;
        const menu = arbor.cast(*Menu, self.sub_type);
        if (menu.mouse_choice) |choice| {
            self.value = @as(f32, @floatFromInt(choice)) /
                @as(f32, @floatFromInt(menu.choices.len - 1));
            menu.mouse_choice = null;
            menu.is_mouse_over = false;
            menu.open = false;
            self.param_changed = true;
        } else menu.open = !menu.open;
    }

    fn on_mouse_over(self: *Component, mouse: Vec2) void {
        const menu = arbor.cast(*Menu, self.sub_type);
        menu.is_mouse_over = true;
        const norm: f32 = @as(f32, @floatFromInt(@as(u32, @intCast(mouse.y)) -
            self.bounds.y)) / @as(f32, @floatFromInt(self.bounds.height));
        if (menu.open)
            menu.mouse_choice = @intFromFloat(@round(norm *
                @as(f32, @floatFromInt(menu.choices.len - 1))));
    }

    fn on_mouse_exit(self: *Component) void {
        const menu = arbor.cast(*Menu, self.sub_type);
        menu.is_mouse_over = false;
        menu.open = false;
        menu.mouse_choice = null;
    }

    pub const interface = Component.Interface{
        .draw_proc = draw_proc,
        .on_mouse_over = on_mouse_over,
        .on_mouse_exit = on_mouse_exit,
        .on_mouse_click = on_mouse_click,
        .on_mouse_drag = null,
    };
};

pub const Knob = struct {
    base: *Component,

    // pointer length as a fraction of radius
    pointer_length: f32 = 0.5,
    // pointer thickness in pixels
    pointer_thickness: f32 = 5.0,

    flags: Flags = .{},

    const Flags = packed struct {
        drop_shadow: bool = false,
    };

    pub fn draw_proc(self: *Component, g: *Graphics) void {
        const radius: f32 = self.width / 2.0;
        const centerX: f32 = self.pos.x + radius;
        const centerY: f32 = self.pos.y + radius;
        // if (self.flags.filled)
        //     rl.DrawCircle(self.centerX, self.centerY, radius, self.color)
        // else
        //     rl.DrawCircleLines(self.centerX, self.centerY, radius, self.color);
        // Gui.drawCircle(bits, .{
        //     .pos = .{ .x = centerX, .y = centerY },
        //     .radius = self.width,
        // }, self.fill_color, self.border_color, self.border_size);
        g.fillEllipse(.{ centerX, centerY }, radius, radius, self.fill_color.toPlatform());

        const min_knob_pos: f32 = std.math.pi * 0.25;
        const max_knob_pos: f32 = std.math.pi * 1.75;
        // point along circumference to draw pointer
        const pointer_angle = min_knob_pos + self.value * (max_knob_pos - min_knob_pos);
        const cos = @cos(pointer_angle);
        const sin = @sin(pointer_angle);
        const x1 = centerX + (cos * radius);
        const y1 = centerY + (sin * radius);

        g.fillEllipse(.{ x1, y1 }, 10, 10, self.border_color.toPlatform());

        // Gui.drawCircle(
        //     bits,
        //     .{ .pos = .{ .x = x1, .y = y1 }, .radius = 10 },
        //     0xffff0000,
        //     0,
        //     0,
        // );

        // if (self.flags.draw_label) {
        //     var label = self.label.text;
        //     const max_chars = 4;
        //     if (self.is_mouse_over) {
        //         var buf: [max_chars + 1]u8 = undefined;
        //         label = std.fmt.bufPrintZ(&buf, "{d:.2}", .{self.value}) catch @panic("Buffer write error");
        //     }
        //     const text_width = rl.MeasureTextEx(Gui.font, label, self.label.size, 1.5);
        //     const half_text = text_width.x / 2.0;
        //     rl.DrawTextEx(Gui.font, label, .{ .x = @as(f32, @floatFromInt(self.centerX)) - half_text, .y = @as(f32, @floatFromInt(self.centerY + self.label.spacing)) + radius }, self.label.size, 1.5, rl.RAYWHITE);
        // }
    }
};

comptime {
    @export(render, .{ .name = "arbor_gui_render", .linkage = .weak });
    // @export(sysInputEvent, .{ .name = "sysInputEvent", .linkage = .weak });
    // @export(Platform.guiTimerCallback, .{ .name = "guiTimerCallback", .linkage = .weak });
}
