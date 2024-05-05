const std = @import("std");
const builtin = @import("builtin");
const Allocator = std.mem.Allocator;

const arbor = @import("../arbor.zig");
const log = arbor.log;

const Plugin = arbor.Plugin;
pub const draw = @import("draw.zig");
pub const Platform = @import("platform.zig");
pub const GuiImpl = Platform.GuiImpl;
pub const GuiState = Platform.GuiState;

const AtomicBool = std.atomic.Value(bool);

const Gui = @This();

/// User gui init
pub extern fn gui_init(*Plugin) void;

pub const GuiConfig = struct {
    plugin: *Plugin,
    width: u32,
    height: u32,
    interface: Interface,
};

pub const Interface = struct {
    render: *const fn (*Gui) void,
    deinit: *const fn (*Gui) void,
};

bits: []u32,
impl: *GuiImpl,
canvas: draw.Canvas,

interface: Interface,

components: std.ArrayList(Component),

in_events: *Queue,
out_events: *Queue,

allocator: Allocator,

state: struct {
    type: GuiState = .Idle,

    mouse_pos: draw.Vec2 = .{ .x = 0, .y = 0 },
    comp_id: ?usize = null,
} = .{},

wants_repaint: AtomicBool = AtomicBool.init(true),

/// Call this from within your gui_init function to init the GUI backend
pub fn init(allocator: Allocator, config: GuiConfig) *Gui {
    const ptr = allocator.create(Gui) catch |e| log.fatal("{!}\n", .{e});
    const bits = allocator.alloc(u32, config.width * config.height) catch |e|
        log.fatal("{!}\n", .{e});
    ptr.* = .{
        .allocator = allocator,
        .bits = bits,
        .impl = Platform.guiCreate(ptr, bits.ptr, config.width, config.height),
        .interface = config.interface,
        .components = std.ArrayList(Component).init(allocator),
        .in_events = Queue.init(allocator) catch |e| log.fatal("{!}\n", .{e}),
        .out_events = Queue.init(allocator) catch |e| log.fatal("{!}\n", .{e}),
        .canvas = draw.olivec_canvas(bits.ptr, config.width, config.height, config.width),
    };

    return ptr;
}

pub fn deinit(self: *Gui) void {
    self.interface.deinit(self);
    Platform.guiDestroy(self.impl);
    self.allocator.free(self.bits);
    self.components.deinit();
    self.in_events.deinit();
    self.out_events.deinit();
    self.allocator.destroy(self);
}

pub fn guiRender(self: *Gui) callconv(.C) void {
    // unload event queue
    self.pollInEvents();

    self.interface.render(self);

    if (debug_mouse_pos) {
        draw.olivec_circle(
            self.canvas,
            @intFromFloat(self.state.mouse_pos.x),
            @intFromFloat(self.state.mouse_pos.y),
            3,
            debug_mouse_color.toBits(),
        );
    }

    // check for component param change flags & push to plugin
    for (self.components.items, 0..) |*c, i| {
        if (c.param_changed) {
            self.out_events.push_wait(.{
                .param_change = .{ .id = i, .value = c.value },
            }) catch |e| {
                log.err("out_events push failed: {!}\n", .{e});
                return;
            };
            c.param_changed = false;
        }
    }
}

// wraps all event handling under one lock
fn pollInEvents(self: *Gui) void {
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

fn sysInputEvent(self: *Gui, cursorX: i32, cursorY: i32, state: GuiState) callconv(.C) void {
    if (self.state.type != state)
        self.state.type = state;
    self.processGesture(
        .{ .x = @floatFromInt(cursorX), .y = @floatFromInt(cursorY) },
    ) catch |e| {
        log.err("{!}\n", .{e});
        return;
    };
    self.wants_repaint.store(true, .release);
    // Platform.guiRender(self.impl, true);
}

pub fn getSize(self: Gui) draw.Vec2 {
    return .{ .x = @floatFromInt(self.canvas.width), .y = @floatFromInt(self.canvas.height) };
}

// NOTE: We do expect pointers for now, would prefer not to rely on heap
// allocation but our "inheritance" model kind of forces that.
pub fn addComponent(self: *Gui, component: Component) void {
    self.components.append(component) catch |e|
        log.err("Component append failed: {!}\n", .{e});
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

pub const Event = union(enum) {
    param_change: struct {
        id: usize,
        value: f32,
    },
};

pub const queue_size = 512;
pub const Queue = struct {
    const QueueType = std.BoundedArray(Event, queue_size);
    events: QueueType,
    mutex: std.Thread.Mutex = .{},
    allocator: Allocator,

    pub fn init(allocator: Allocator) !*Queue {
        const self = try allocator.create(Queue);
        self.* = .{
            .events = try QueueType.init(0),
            .allocator = allocator,
        };
        return self;
    }

    pub fn deinit(self: *Queue) void {
        self.allocator.destroy(self);
    }

    pub fn push(self: *Queue, event: Event) !void {
        if (self.mutex.tryLock()) {
            defer self.mutex.unlock();
            try self.events.append(event);
        }
    }

    pub fn push_wait(self: *Queue, event: Event) !void {
        self.mutex.lock();
        defer self.mutex.unlock();
        try self.events.append(event);
    }

    pub fn push_no_lock(self: *Queue, event: Event) !void {
        try self.events.append(event);
    }

    pub fn next(self: *Queue) ?Event {
        if (self.mutex.tryLock()) {
            defer self.mutex.unlock();
            return self.events.popOrNull();
        } else return null;
    }

    pub fn next_wait(self: *Queue) ?Event {
        self.mutex.lock();
        defer self.mutex.unlock();
        return self.events.popOrNull();
    }

    pub fn next_no_lock(self: *Queue) ?Event {
        return self.events.popOrNull();
    }
};

fn processGesture(
    self: *Gui,
    mouse_pos: draw.Vec2,
) !void {
    switch (self.state.type) {
        .MouseDrag => {
            const mouse_delta: draw.Vec2 = .{
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
                    func(comp);
            } else {
                if (self.getComponentUnderMouse(mouse_pos)) |c| {
                    if (c[0].interface.on_mouse_click) |func|
                        func(c[0]);
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

const Vec2 = draw.Vec2;
const Color = draw.Color;

/// Struct for organizing text attached to a component
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
        draw_proc: *const fn (self: *Component) void,
        on_mouse_over: ?*const fn (self: *Component, Vec2) void,
        on_mouse_exit: ?*const fn (self: *Component) void,
        on_mouse_click: ?*const fn (self: *Component) void,
        on_mouse_drag: ?*const fn (self: *Component, Vec2) void,
    };

    // TODO: Move canvas to a graphics context which each component will be pased in their draw_proc()
    canvas: draw.Canvas,
    pos: Vec2,
    width: f32,
    height: f32,
    background_color: Color,

    sub_type: ?*anyopaque = null,

    value: f32,

    /// every component may have a label, and it's up to the drawing procedure
    /// to determine how it is displayed.
    label: ?Label,

    interface: Component.Interface,

    /// flag to let the GUI know a parameter needs to be updated
    param_changed: bool = false,

    pub fn hitTest(self: Component, pt: Vec2) bool {
        return (pt.x >= self.pos.x and
            pt.y >= self.pos.y and
            pt.x <= self.pos.x + self.width and
            pt.y <= self.pos.y + self.height);
    }

    pub fn setValue(self: *Component, val: f32) void {
        self.value = val;
    }
};

pub const Slider = struct {
    // base: Component,

    pub fn init(allocator: Allocator) *Slider {
        return allocator.create(Slider) catch |e|
            log.fatal("Slider alloc failed: {!}\n", .{e});
    }

    fn draw_proc(self: *Component) void {
        const height = if (self.label) |label|
            self.height - @as(f32, @floatFromInt(label.height))
        else
            self.height;
        const val_height = height * self.value;
        const top = self.pos.y + (height - val_height);
        const fill = Color{ .a = 0xff, .r = 0xcc, .g = 0xcc, .b = 0xcc };
        // draw borders
        draw.olivec_rect(
            self.canvas,
            @intFromFloat(self.pos.x),
            @intFromFloat(self.pos.y),
            @intFromFloat(self.width),
            @intFromFloat(height),
            self.background_color.toBits(),
        );

        draw.olivec_rect(
            self.canvas,
            @intFromFloat(self.pos.x),
            @intFromFloat(top),
            @intFromFloat(self.width),
            @intFromFloat(val_height),
            fill.toBits(),
        );

        if (self.label) |l| {
            const text_y = self.pos.y + height;
            const text_x = self.pos.x;
            draw.drawText(self.canvas, l, .{
                .x = @intFromFloat(text_x),
                .y = @intFromFloat(text_y),
                .width = @intFromFloat(self.width),
                .height = l.height,
            });
        }
    }

    fn on_mouse_drag(self: *Component, mouse_delta: Vec2) void {
        var val = self.value;
        val += -mouse_delta.y * 0.025;
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

    highlight_color: Color = Color{ .r = 0xff, .g = 0xff, .b = 0, .a = 0x90 },

    is_mouse_over: bool = false,
    mouse_choice: ?usize = null,
    open: bool = false,

    // ISSUE: If we heap alloc we have to pair it with a destroy. How do we call this sub-type's destroy method?
    pub fn init(
        allocator: Allocator,
        choices: []const []const u8,
        border_color: Color,
        border_thickness: u32,
    ) *Menu {
        const self = allocator.create(Menu) catch |e| log.fatal("Menu init failed: {!}\n", .{e});
        self.* = .{
            .choices = choices,
            .border_color = border_color,
            .border_thickness = border_thickness,
        };
        return self;
    }

    pub fn draw_proc(self: *Component) void {
        const menu = arbor.cast(*Menu, self.sub_type);
        const border = if (menu.is_mouse_over)
            Color{ .r = 0xff, .g = 0xff, .b = 0, .a = 0xff }
        else
            menu.border_color;

        const label_height = self.height / 2;

        const flen: f32 = @floatFromInt(menu.choices.len);
        if (menu.open and menu.is_mouse_over) {
            draw.olivec_rect(
                self.canvas,
                @intFromFloat(self.pos.x),
                @intFromFloat(self.pos.y),
                @intFromFloat(self.width),
                @intFromFloat(self.height),
                self.background_color.toBits(),
            );
            const choice_h = self.height / flen;
            for (menu.choices, 0..) |choice, i| {
                if (menu.mouse_choice) |mc| {
                    if (i == mc) {
                        draw.olivec_rect(
                            self.canvas,
                            @intFromFloat(self.pos.x),
                            @intFromFloat(self.pos.y + (choice_h * @as(f32, @floatFromInt(i)))),
                            @intFromFloat(self.width),
                            @intFromFloat(choice_h),
                            menu.highlight_color.toBits(),
                        );
                    }
                }
                draw.drawText(self.canvas, .{
                    .text = choice,
                    .height = @intFromFloat(choice_h),
                    .color = Color.WHITE,
                }, .{
                    .x = @intFromFloat(self.pos.x),
                    .y = @intFromFloat(self.pos.y + (choice_h * @as(f32, @floatFromInt(i)))),
                    .width = @intFromFloat(self.width),
                    .height = @intFromFloat(choice_h),
                });
            }
            return;
        }

        if (self.label) |label| {
            draw.drawText(self.canvas, label, .{
                .x = @intFromFloat(self.pos.x),
                .y = @intFromFloat(self.pos.y - 1),
                .width = @intFromFloat(self.width),
                .height = @intFromFloat(label_height),
            });
        }

        const menu_y = self.pos.y + label_height;

        draw.olivec_rect(
            self.canvas,
            @intFromFloat(self.pos.x),
            @intFromFloat(menu_y),
            @intFromFloat(self.width),
            @intFromFloat(label_height),
            self.background_color.toBits(),
        );
        draw.olivec_frame(
            self.canvas,
            @intFromFloat(self.pos.x),
            @intFromFloat(menu_y),
            @intFromFloat(self.width),
            @intFromFloat(label_height),
            menu.border_thickness,
            border.toBits(),
        );

        const current = menu.choices[@intFromFloat(self.value * (flen - 1))];
        const mod = 0.5;
        draw.drawText(
            self.canvas,
            .{
                .text = current,
                .height = @intFromFloat(label_height * mod),
                .color = Color.WHITE,
            },
            .{
                .x = @intFromFloat(self.pos.x),
                .y = @intFromFloat(menu_y),
                .width = @intFromFloat(self.width),
                .height = @intFromFloat(label_height),
            },
        );
    }

    fn on_mouse_click(self: *Component) void {
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
        const norm = (mouse.y - self.pos.y) / self.height;
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

    pub fn draw_proc(self: Component) void {
        const radius: f32 = self.width / 2.0;
        const centerX = self.pos.x + radius;
        const centerY = self.pos.y + radius;
        // if (self.flags.filled)
        //     rl.DrawCircle(self.centerX, self.centerY, radius, self.color)
        // else
        //     rl.DrawCircleLines(self.centerX, self.centerY, radius, self.color);
        // Gui.drawCircle(bits, .{
        //     .pos = .{ .x = centerX, .y = centerY },
        //     .radius = self.width,
        // }, self.fill_color, self.border_color, self.border_size);
        draw.olivec_circle(self.canvas.*, centerX, centerY, @intFromFloat(radius), self.fill_color);

        const min_knob_pos: f32 = std.math.pi * 0.25;
        const max_knob_pos: f32 = std.math.pi * 1.75;
        // point along circumference to draw pointer
        const pointer_angle = min_knob_pos + self.value * (max_knob_pos - min_knob_pos);
        const cos = @cos(pointer_angle);
        const sin = @sin(pointer_angle);
        const x1 = centerX + (cos * radius);
        const y1 = centerY + (sin * radius);

        draw.olivec_circle(self.canvas.*, x1, y1, @intFromFloat(10), self.border_color);

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

const debug_mouse_pos = false;
const debug_mouse_color = Color{ .r = 0xff, .g = 0, .b = 0, .a = 0xff };

comptime {
    @export(guiRender, .{ .name = "gui_render", .linkage = .weak });
    @export(sysInputEvent, .{ .name = "sysInputEvent", .linkage = .weak });
    @export(Platform.guiTimerCallback, .{ .name = "guiTimerCallback", .linkage = .weak });
}
