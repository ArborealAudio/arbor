//! ANV = ANV's Not VST3
//! Special thanks to Tremus' CPLUG (https://github.com/Tremus/CPLUG) for
//! providing a no-nonsense VST3 implementation

const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;

const arbor = @import("arbor.zig");
const log = arbor.log;

const allocator = std.heap.c_allocator;

const utf8To16 = std.unicode.utf8ToUtf16Le;

const anv = @import("anv_api.zig");

const cc: std.builtin.CallingConvention = if (builtin.os.tag == .windows and
    builtin.cpu.arch == .x86) .Stdcall else .C;

const Result = anv.Result;

const RefCounter = std.atomic.Value(u32);

pub const class_id: anv.Uid = anv.uidCreate('A', 'N', 'V', '3');
pub const controller_id: anv.Uid = anv.uidCreate('C', 't', 'r', 'l');
const uidCmp = anv.uidCmp;

/// Despite being sufficiently related to `Component`, this is a separate struct
/// which handles some audio-specific tasks, like getting info about audio busses
/// and processing audio.
const Processor = extern struct {
    vtable: *const anv.Interface.AudioProcessor,
    ref_counter: RefCounter,

    fn queryInterface(this: ?*anyopaque, iid: *const anv.Uid, obj: ?*?*anyopaque) callconv(cc) Result {
        if (uidCmp(iid, &anv.Interface.Base.UID) or
            uidCmp(iid, &anv.Interface.AudioProcessor.UID))
        {
            if (obj) |o| {
                log.debug("Query OK: {s}\n", .{anv.uidToStr(iid)}, @src());
                const self = arbor.cast(*Processor, this);
                _ = self.ref_counter.fetchAdd(1, .release);
                o.* = self;
                return .Ok;
            }
        } else if (uidCmp(iid, &anv.Interface.ProcessContextRequirements.UID)) {
            log.debug("Processor: {s}\n", .{anv.uidToStr(iid)}, @src());
            if (obj) |o| {
                o.* = @ptrCast(&global_pc_requirements.vtable);
                return .Ok;
            }
        }
        log.debug("Processor: Unsupported: {s}\n", .{anv.uidToStr(iid)}, @src());
        return .NoInterface;
    }

    fn addRef(this: ?*anyopaque) callconv(cc) u32 {
        const self = arbor.cast(*Processor, this);
        const ref_count = self.ref_counter.fetchAdd(1, .release) + 1;
        log.debug("Processor: Adding ref | Count: {d}\n", .{ref_count}, @src());
        return ref_count;
    }

    fn release(this: ?*anyopaque) callconv(cc) u32 {
        const self = arbor.cast(*Processor, this);
        const ref_count = self.ref_counter.fetchSub(1, .release) - 1;
        log.debug("Processor: Releasing ref | Count: {d}\n", .{ref_count}, @src());
        if (ref_count > 0) return ref_count;

        const plugin: *Vst3Plugin = @fieldParentPtr("processor", self);
        plugin.deinit();
        return 0;
    }

    fn setBusArrangements(
        this: ?*anyopaque,
        inputs: ?*anv.SpeakerArrangement,
        num_in: i32,
        outputs: ?*anv.SpeakerArrangement,
        num_out: i32,
    ) callconv(cc) Result {
        _ = this;
        _ = inputs;
        _ = num_in;
        _ = outputs;
        _ = num_out;
        return .Ok;
    }

    fn getBusArrangement(
        this: ?*anyopaque,
        dir: anv.BusDirection,
        index: i32,
        arr_ptr: ?*anv.SpeakerArrangement,
    ) callconv(cc) Result {
        _ = this;
        _ = dir;
        _ = index;
        if (arr_ptr) |arr| {
            arr.* = .{
                .L = true,
                .R = true,
            };
            return .Ok;
        }
        return .InvalidArgument;
    }

    fn canProcessSampleSize(this: ?*anyopaque, size: anv.SampleSize) callconv(cc) Result {
        _ = this;
        // TODO: Check if double precision supported
        if (size == .Sample32) return .Ok else return .NotOk;
    }

    fn getLatencySamples(this: ?*anyopaque) callconv(cc) u32 {
        _ = this;
        return 0;
    }

    fn setupProcessing(this: ?*anyopaque, setup_ptr: ?*anv.ProcessSetup) callconv(cc) Result {
        if (setup_ptr) |setup| {
            const plugin: *Vst3Plugin = @fieldParentPtr("processor", arbor.cast(*Processor, this));
            const plug = plugin.user;
            plug.interface.prepare(plug, @floatCast(setup.sample_rate), @intCast(setup.max_samples));
            return .Ok;
        } else return .InvalidArgument;
    }

    fn setProcessing(this: ?*anyopaque, state: bool) callconv(cc) Result {
        _ = this;
        _ = state;
        return .Ok;
    }

    fn process(this: ?*anyopaque, data_cptr: ?*anv.ProcessData) callconv(cc) Result {
        const plugin: *Vst3Plugin = @fieldParentPtr("processor", arbor.cast(*Processor, this));
        const plug = plugin.user;
        const data = data_cptr orelse {
            log.err("ProcessData is null\n", .{}, @src());
            return .InvalidArgument;
        };
        const out_changes = data.out_param_changes orelse {
            log.err("Out param changes is null\n", .{}, @src());
            return .InvalidArgument;
        };
        if (plug.gui) |_| plugin.processOutEvents(out_changes);
        plugin.processInEvents();

        const input = data.inputs orelse {
            log.err("Input data null\n", .{}, @src());
            return .InvalidArgument;
        };
        const output = data.outputs orelse {
            log.err("Output data null\n", .{}, @src());
            return .InvalidArgument;
        };
        const num_frames: u32 = @intCast(data.num_samples);
        assert(num_frames <= plug.max_frames);
        const num_ch: usize = @intCast(@min(input.num_channels, output.num_channels));
        assert(num_ch <= arbor.Plugin.num_channels);
        var frame: u32 = 0;
        // TODO: Figure out sample-accurate automation with this insane API
        // NOTE: You almost need to work with in inside-out to get an ordered list
        // of changes for *all* parameters
        while (frame < num_frames) {
            const buffer = arbor.AudioBuffer(f32){
                .input = make: {
                    var buf: [arbor.Plugin.num_channels][]f32 = undefined;
                    for (0..@intCast(input.num_channels)) |ch| {
                        buf[ch] = input.data.buffer32[ch][frame .. frame + num_frames];
                    }
                    break :make buf[0..num_ch];
                },
                .output = make: {
                    var buf: [arbor.Plugin.num_channels][]f32 = undefined;
                    for (0..@intCast(output.num_channels)) |ch| {
                        buf[ch] = output.data.buffer32[ch][frame .. frame + num_frames];
                    }
                    break :make buf[0..num_ch];
                },
                .num_ch = num_ch,
                .frames = @intCast(data.num_samples),
            };

            plug.interface.process(plug, buffer);
            frame += num_frames;
        }
        return .Ok;
    }

    fn getTailSamples(this: ?*anyopaque) callconv(cc) u32 {
        _ = this;
        return 0;
    }

    const vtable = anv.Interface.AudioProcessor{
        .base = .{
            .queryInterface = queryInterface,
            .addRef = addRef,
            .release = release,
        },
        .setBusArrangements = setBusArrangements,
        .getBusArrangement = getBusArrangement,
        .canProcessSampleSize = canProcessSampleSize,
        .getLatencySamples = getLatencySamples,
        .setupProcessing = setupProcessing,
        .setProcessing = setProcessing,
        .process = process,
        .getTailSamples = getTailSamples,
    };
};

const ProcessContextRequirements = extern struct {
    vtable: *const anv.Interface.ProcessContextRequirements,
    ref_counter: RefCounter,

    fn queryInterface(this: ?*anyopaque, iid: *const anv.Uid, obj: ?*?*anyopaque) callconv(cc) Result {
        if (uidCmp(iid, &anv.Interface.Base.UID) or
            uidCmp(iid, &anv.Interface.ProcessContextRequirements.UID))
        {
            const self = arbor.cast(*ProcessContextRequirements, this);
            if (obj) |o| {
                o.* = self;
                return .Ok;
            }
        }

        return .NoInterface;
    }

    fn addRef(_: ?*anyopaque) callconv(cc) u32 {
        return 1;
    }

    fn release(_: ?*anyopaque) callconv(cc) u32 {
        return 0;
    }

    fn getProcessContextRequirements(this: ?*anyopaque) callconv(cc) anv.ProcessContext.Requirements {
        _ = this;
        return anv.ProcessContext.Requirements{
            .NeedContinousTimeSamples = true,
            .NeedTempo = true,
            .NeedTransportState = true,
        };
    }

    pub const vtable = anv.Interface.ProcessContextRequirements{
        .base = .{
            .queryInterface = queryInterface,
            .addRef = addRef,
            .release = release,
        },
        .getProcessContextRequirements = getProcessContextRequirements,
    };
};

var global_pc_requirements: ProcessContextRequirements = .{
    .vtable = &ProcessContextRequirements.vtable,
    .ref_counter = RefCounter.init(1),
};

/// The basic struct comprising an audio plugin. Despite handling tasks related
/// to audio busses and the state of the plugin, this class is not responsible
/// for processing audio or handling parameters, for no particular reason.
const Component = extern struct {
    vtable: *const anv.Interface.Component,
    ref_counter: RefCounter,

    fn queryInterface(this: ?*anyopaque, iid: *const anv.Uid, obj: ?*?*anyopaque) callconv(cc) Result {
        if (uidCmp(iid, &anv.Interface.Base.UID) or
            uidCmp(iid, &anv.Interface.PluginBase.UID) or
            uidCmp(iid, &anv.Interface.Component.UID))
        {
            if (obj) |o| {
                const self = arbor.cast(*Vst3Plugin, this);
                log.debug("Component: Query OK: {s}\n", .{anv.uidToStr(iid)}, @src());
                _ = self.component.ref_counter.fetchAdd(1, .release);
                o.* = self;
                return .Ok;
            }
        } else if (uidCmp(iid, &anv.Interface.AudioProcessor.UID)) {
            if (obj) |o| {
                const self = arbor.cast(*Vst3Plugin, this);
                log.debug("Component: Query OK: {s}\n", .{anv.uidToStr(iid)}, @src());
                _ = self.processor.ref_counter.fetchAdd(1, .release);
                o.* = &self.processor;
                return .Ok;
            }
        } else if (uidCmp(iid, &anv.Interface.EditController.UID)) {
            if (obj) |o| {
                const self = arbor.cast(*Vst3Plugin, this);
                log.debug("Component: Query OK: {s}\n", .{anv.uidToStr(iid)}, @src());
                _ = self.controller.ref_counter.fetchAdd(1, .release);
                o.* = &self.controller;
                return .Ok;
            }
        }
        log.debug("Component: Unsupported: {s}\n", .{anv.uidToStr(iid)}, @src());
        return .NoInterface;
    }

    fn addRef(this: ?*anyopaque) callconv(cc) u32 {
        const self = arbor.cast(*Component, this);
        const ref_count = self.ref_counter.fetchAdd(1, .release) + 1;
        log.debug("Component: Adding ref | Count: {d}\n", .{ref_count}, @src());
        return ref_count;
    }

    fn release(this: ?*anyopaque) callconv(cc) u32 {
        const self = arbor.cast(*Component, this);
        const ref_count = self.ref_counter.fetchSub(1, .release) - 1;
        log.debug("Component: Releasing ref | Count: {d}\n", .{ref_count}, @src());
        if (ref_count > 0)
            return ref_count;
        const plugin: *Vst3Plugin = @fieldParentPtr("component", self);
        _ = Processor.release(&plugin.processor);
        _ = Controller.release(&plugin.controller);
        // plugin.deinit();
        return 0;
    }

    fn initialize(this: ?*anyopaque, context: ?*anv.Interface.Base) callconv(cc) Result {
        _ = context;
        log.debug("Component: Initialize\n", .{}, @src());
        // this is where we'd get a pointer to the host
        // query its interface for host context and save a pointer to it in our plugin
        const plugin: *Vst3Plugin = @fieldParentPtr("component", arbor.cast(*Component, this));
        // call user's init function
        plugin.user = arbor.Plugin.init();
        return .Ok;
    }

    fn terminate(this: ?*anyopaque) callconv(cc) Result {
        log.debug("Component: Terminate\n", .{}, @src());
        const plugin: *Vst3Plugin = @fieldParentPtr("component", arbor.cast(*Component, this));
        const plug = plugin.user;
        plug.deinit();
        // NOTE: Really should set user data to null here.
        return .Ok;
    }

    fn getControllerClass(_: ?*anyopaque, cid: *anv.Uid) callconv(cc) Result {
        @memcpy(cid, &controller_id);
        return .Ok;
    }

    fn setIoMode(this: ?*anyopaque, mode: anv.IoMode) callconv(cc) Result {
        _ = this;
        _ = mode;
        return .Ok;
    }

    fn getBusCount(this: ?*anyopaque, media_type: anv.MediaType, dir: anv.BusDirection) callconv(cc) i32 {
        _ = this;
        _ = dir;
        if (media_type == .Audio)
            return 1
        else
            return 0;
    }

    fn getBusInfo(
        this: ?*anyopaque,
        media_type: anv.MediaType,
        dir: anv.BusDirection,
        index: i32,
        bus_ptr: ?*anv.BusInfo,
    ) callconv(cc) Result {
        _ = this;
        _ = index;
        const bus = bus_ptr orelse {
            log.err("Bus is null\n", .{}, @src());
            return .InvalidArgument;
        };
        if (media_type == .Audio) {
            if (dir == .Input) {
                bus.media_type = .Audio;
                bus.direction = .Input;
                bus.channel_count = 2;
                bus.bus_type = .Main;
                bus.flags = .{ .DefaultActive = true };
            } else {
                bus.media_type = .Audio;
                bus.direction = .Output;
                bus.channel_count = 2;
                bus.bus_type = .Main;
                bus.flags = .{ .DefaultActive = true };
            }
            return .Ok;
        } else {
            return .NotImplemented;
        }
    }

    fn getRoutingInfo(this: ?*anyopaque, in_info: ?*anv.RoutingInfo, out_info: ?*anv.RoutingInfo) callconv(cc) Result {
        _ = this;
        _ = in_info;
        _ = out_info;
        return .NotImplemented;
    }

    fn activateBus(
        this: ?*anyopaque,
        media_type: anv.MediaType,
        dir: anv.BusDirection,
        index: i32,
        state: bool,
    ) callconv(cc) Result {
        _ = this;
        _ = dir;
        _ = index;
        _ = state;
        if (media_type == .Audio) {
            // TODO: Check if uhh we want to enable a bus? Who cares?
            return .Ok;
        } else return .NotImplemented;
    }

    fn setActive(this: ?*anyopaque, state: bool) callconv(cc) Result {
        _ = this;
        _ = state;
        return .Ok;
    }

    fn setState(this: ?*anyopaque, state: ?*?*anv.Interface.Stream) callconv(cc) Result {
        // TODO
        _ = this;
        _ = state;
        return .Ok;
    }
    fn getState(this: ?*anyopaque, state: ?*?*anv.Interface.Stream) callconv(cc) Result {
        _ = this;
        _ = state;
        return .Ok;
    }

    const vtable = anv.Interface.Component{
        .base = .{
            .base = .{
                .queryInterface = queryInterface,
                .addRef = addRef,
                .release = release,
            },
            .initialize = initialize,
            .terminate = terminate,
        },
        .getControllerClass = getControllerClass,
        .setIoMode = setIoMode,
        .getBusCount = getBusCount,
        .getBusInfo = getBusInfo,
        .getRoutingInfo = getRoutingInfo,
        .activateBus = activateBus,
        .setActive = setActive,
        .setState = setState,
        .getState = getState,
    };
};

/// A very special struct which manages plugin state (upstream from `Component`?) and contains
/// helper functions for converting parameter values. Also spawns UI for some reason.
/// This contains a reference to a `ComponentHandler` interface which manages the
/// apparently sufficiently-unique task of *performing* edits to the plugin's state.
const Controller = extern struct {
    vtable: *const anv.Interface.EditController,
    ref_counter: RefCounter,
    handler: ?*anv.Interface.ComponentHandler,

    fn queryInterface(this: ?*anyopaque, iid: *const anv.Uid, obj: ?*?*anyopaque) callconv(cc) Result {
        if (uidCmp(iid, &anv.Interface.Base.UID) or
            uidCmp(iid, &anv.Interface.EditController.UID))
        {
            if (obj) |o| {
                const self = arbor.cast(*Controller, this);
                _ = self.ref_counter.fetchAdd(1, .release);
                o.* = self;
                return .Ok;
            }
        }
        log.debug("Controller: Unsupported: {s}\n", .{anv.uidToStr(iid)}, @src());
        return .NoInterface;
    }

    fn addRef(this: ?*anyopaque) callconv(cc) u32 {
        const self = arbor.cast(*Controller, this);
        const ref_count = self.ref_counter.fetchAdd(1, .release) + 1;
        log.debug("Controller: Adding ref: {d}\n", .{ref_count}, @src());
        return ref_count;
    }

    fn release(this: ?*anyopaque) callconv(cc) u32 {
        const self = arbor.cast(*Controller, this);
        const ref_count = self.ref_counter.fetchSub(1, .release) - 1;
        log.debug("Controller: Releasing ref | Count: {d}\n", .{ref_count}, @src());

        if (ref_count > 0) return ref_count;

        _ = if (self.handler) |handler| handler.base.release(handler);

        const plugin: *Vst3Plugin = @fieldParentPtr("controller", self);
        plugin.deinit();
        return 0;
    }

    fn initialize(this: ?*anyopaque, context: ?*anv.Interface.Base) callconv(cc) Result {
        _ = this;
        _ = context;
        // whats the point of this
        return .Ok;
    }

    fn terminate(this: ?*anyopaque) callconv(cc) Result {
        _ = this;
        // Again...why
        return .Ok;
    }

    /// Propagate the Controller's state to its corresponding `Component`
    fn setComponentState(this: ?*anyopaque, state: ?*?*anv.Interface.Stream) callconv(cc) Result {
        _ = this;
        _ = state;
        return .NotImplemented;
    }

    /// Assuming this is getting state from the host which we will send to the `Component`
    fn setState(this: ?*anyopaque, state: ?*?*anv.Interface.Stream) callconv(cc) Result {
        // TODO
        _ = this;
        _ = state;
        return .NotImplemented;
    }

    /// Assuming this is sending state to the host
    fn getState(this: ?*anyopaque, state: ?*?*anv.Interface.Stream) callconv(cc) Result {
        // TODO
        _ = this;
        _ = state;
        return .NotImplemented;
    }

    fn getParameterCount(this: ?*anyopaque) callconv(cc) i32 {
        const self = arbor.cast(*Controller, this);
        const plugin: *Vst3Plugin = @fieldParentPtr("controller", self);
        const plug = plugin.user;
        return @intCast(plug.param_info.len);
    }

    fn getParameterInfo(this: ?*anyopaque, index: i32, info_cptr: ?*anv.ParameterInfo) callconv(cc) Result {
        const dest_info = info_cptr orelse {
            log.err("Info is null\n", .{}, @src());
            return .InvalidArgument;
        };
        dest_info.* = std.mem.zeroes(anv.ParameterInfo);

        const self = arbor.cast(*Controller, this);
        const plugin: *Vst3Plugin = @fieldParentPtr("controller", self);
        const plug = plugin.user;
        const param_info = if (index < 0 or index >= plug.param_info.len)
            return .InvalidArgument
        else
            plug.param_info[@intCast(index)];

        dest_info.id = @intCast(index);

        _ = utf8To16(&dest_info.title, param_info.name) catch |e| {
            log.err("{!}\n", .{e}, @src());
            return .InternalError;
        };
        _ = utf8To16(&dest_info.short_title, param_info.name) catch |e| {
            log.err("{!}\n", .{e}, @src());
            return .InternalError;
        };

        dest_info.default_normalized = @floatCast(param_info.getNormalizedValue(param_info.default_value));

        dest_info.flags = .{
            .CanAutomate = true,
        };

        return .Ok;
    }

    fn getParamStringByValue(this: ?*anyopaque, index: u32, value_normalized: f64, string: *anv.Wstr) callconv(cc) Result {
        const self = arbor.cast(*Controller, this);
        const plugin: *Vst3Plugin = @fieldParentPtr("controller", self);
        const plug = plugin.user;
        const param_info = if (index < 0 or index >= plug.param_info.len)
            return .InvalidArgument
        else
            plug.param_info[@intCast(index)];

        @memset(string, 0);

        const val_denorm = param_info.valueFromNormalized(@floatCast(value_normalized));
        var buf = [_]u8{0} ** 12;
        if (param_info.value_to_text) |func| {
            const len = func(val_denorm, &buf);
            _ = utf8To16(string[0..len], buf[0..len]) catch |e| {
                log.err("{!}\n", .{e}, @src());
                return .InternalError;
            };
        } else {
            // no user conversion, print raw
            if (param_info.flags.is_enum) {
                if (param_info.enum_choices) |choices| {
                    const choice_id: usize = @intFromFloat(value_normalized *
                        @as(f32, @floatFromInt(choices.len - 1)));
                    const choice = choices[choice_id];
                    _ = utf8To16(string[0..choice.len], choice) catch |e| {
                        log.err("{!}\n", .{e}, @src());
                        return .InternalError;
                    };
                }
            } else {
                const out = std.fmt.bufPrint(&buf, "{d:.2}", .{val_denorm}) catch |e| {
                    log.err("{!}\n", .{e}, @src());
                    return .InternalError;
                };
                _ = utf8To16(string[0..out.len], out) catch |e| {
                    log.err("{!}\n", .{e}, @src());
                    return .InternalError;
                };
            }
        }
        return .Ok;
    }

    fn getParamValueByString(this: ?*anyopaque, id: u32, string: [*:0]u16, value_normalized: ?*f64) callconv(cc) Result {
        _ = this;
        _ = id;
        _ = string;
        _ = value_normalized;
        return .NotImplemented;
    }

    /// Convert a normalized value to a regular value
    fn normalizedParamToPlain(this: ?*anyopaque, id: u32, value_normalized: f64) callconv(cc) f64 {
        const plugin: *Vst3Plugin = @fieldParentPtr("controller", arbor.cast(*Controller, this));
        const plug = plugin.user;

        if (id < 0 or id >= plug.param_info.len) {
            log.err("Invalid param ID\n", .{}, @src());
            return 0;
        }
        const param = plug.param_info[id];
        return @floatCast(param.valueFromNormalized(@floatCast(value_normalized)));
    }

    /// Convert a regular value to a normalized one
    fn plainParamToNormalized(this: ?*anyopaque, id: u32, plain_value: f64) callconv(cc) f64 {
        const plugin: *Vst3Plugin = @fieldParentPtr("controller", arbor.cast(*Controller, this));
        const plug = plugin.user;
        if (id < 0 or id >= plug.param_info.len) {
            log.err("Invalid param ID\n", .{}, @src());
            return 0;
        }
        const param = plug.param_info[id];
        return @floatCast(param.getNormalizedValue(@floatCast(plain_value)));
    }

    /// Get current normalized value
    fn getParamNormalized(this: ?*anyopaque, id: u32) callconv(cc) f64 {
        const plugin: *Vst3Plugin = @fieldParentPtr("controller", arbor.cast(*Controller, this));
        const plug = plugin.user;
        if (id < 0 or id >= plug.param_info.len) {
            log.err("Invalid param ID\n", .{}, @src());
            return 0;
        }
        const param = plug.param_info[id];
        const value = plug.params[id];
        return @floatCast(param.getNormalizedValue(value));
    }

    fn setParamNormalized(this: ?*anyopaque, id: u32, value: f64) callconv(cc) Result {
        const plugin: *Vst3Plugin = @fieldParentPtr("controller", arbor.cast(*Controller, this));
        const plug = plugin.user;
        if (id < 0 or id >= plug.param_info.len) {
            log.err("Invalid param ID\n", .{}, @src());
            return .InvalidArgument;
        }
        plugin.in_events.push_try(.{
            .param_change = .{ .id = id, .value = @floatCast(value) },
        }) catch |e| {
            log.err("in_events push failed: {!}\n", .{e}, @src());
            return .InternalError;
        };
        return .Ok;
    }

    fn setComponentHandler(this: ?*anyopaque, handler_cptr: ?*?*anv.Interface.ComponentHandler) callconv(cc) Result {
        const self = arbor.cast(*Controller, this);
        if (handler_cptr) |_| {
            log.debug("TODO, maybe\n", .{}, @src());
            _ = if (self.handler) |old| old.base.release(old);
            return .Ok;
        }
        log.err("Handler is null\n", .{}, @src());
        return .InvalidArgument;
    }

    fn createView(this: ?*anyopaque, _: [*:0]const u8) callconv(cc) ?**const anv.Interface.View {
        if (arbor.config.plugin_features & arbor.features.GUI > 0) {
            const view = allocator.create(View) catch |e| {
                log.err("{!}\n", .{e}, @src());
                return null;
            };
            view.* = .{
                .vtable = &View.vtable,
                .ref_count = RefCounter.init(1),
            };
            const plugin: *Vst3Plugin = @fieldParentPtr(
                "controller",
                arbor.cast(*Controller, this),
            );
            assert(plugin.user.gui == null);
            const gui = arbor.Gui.init(plugin.user);
            view.user_gui = gui;
            plugin.view = view;
            return &view.vtable;
        } else return null;
    }

    pub const vtable = anv.Interface.EditController{
        .base = .{
            .base = .{
                .queryInterface = queryInterface,
                .addRef = addRef,
                .release = release,
            },
            .initialize = initialize,
            .terminate = terminate,
        },
        .setComponentState = setComponentState,
        .setState = setState,
        .getState = getState,
        .getParameterCount = getParameterCount,
        .getParameterInfo = getParameterInfo,
        .getParamStringByValue = getParamStringByValue,
        .getParamValueByString = getParamValueByString,
        .normalizedParamToPlain = normalizedParamToPlain,
        .plainParamToNormalized = plainParamToNormalized,
        .getParamNormalized = getParamNormalized,
        .setParamNormalized = setParamNormalized,
        .setComponentHandler = setComponentHandler,
        .createView = createView,
    };
};

const View = extern struct {
    vtable: *const anv.Interface.View,
    ref_count: RefCounter,

    user_gui: ?*arbor.Gui = null,

    const PLATFORM_API = switch (builtin.os.tag) {
        .linux => "X11EmbedWindowID",
        .macos => "NSView",
        .windows => "HWND",
        else => @compileError("Unsupported OS"),
    };

    fn queryInterface(this: ?*anyopaque, iid: *const anv.Uid, obj: ?*?*anyopaque) callconv(cc) Result {
        const self = arbor.cast(*View, this);
        if (uidCmp(iid, &anv.Interface.Base.UID) or
            uidCmp(iid, &anv.Interface.View.UID))
        {
            if (obj) |o| {
                log.debug("Query OK: {s}", .{anv.uidToStr(iid)}, @src());
                _ = addRef(this);
                o.* = self;
            } else {
                log.err("Obj is null\n", .{}, @src());
                return .InvalidArgument;
            }
        }

        log.err("View: unsupported: {s}\n", .{anv.uidToStr(iid)}, @src());

        return .NoInterface;
    }

    fn addRef(this: ?*anyopaque) callconv(cc) u32 {
        const self = arbor.cast(*View, this);
        const ref_count = self.ref_count.fetchAdd(1, .release) + 1;
        log.debug("View: adding ref | Count {d}\n", .{ref_count}, @src());
        return ref_count;
    }

    // NOTE: This may be called without ever having called attached() or release()
    fn release(this: ?*anyopaque) callconv(cc) u32 {
        const self = arbor.cast(*View, this);
        const ref_count = self.ref_count.fetchSub(1, .release) - 1;
        if (ref_count > 0)
            return ref_count;

        log.debug("View: all refs released, destroying\n", .{}, @src());
        if (self.user_gui) |gui| {
            arbor.Gui.Platform.guiSetVisible(gui.impl, false);
            gui.deinit();
            self.user_gui = null;
        }
        allocator.destroy(self);
        // ISSUE: We can't seem to get a mutable ptr to plugin from our
        // optional view ptr...
        // plugin.view = null;
        return 0;
    }

    fn isPlatformTypeSupported(this: ?*anyopaque, win_type: [*:0]const u8) callconv(cc) Result {
        _ = this;
        log.debug("View: is platform {s} supported\n", .{win_type}, @src());
        const eql = std.mem.eql;
        const span = std.mem.span;
        if (eql(u8, span(win_type), PLATFORM_API)) return .Ok;
        return .NotImplemented;
    }

    fn attached(this: ?*anyopaque, parent: ?*anyopaque, win_type: [*:0]const u8) callconv(cc) Result {
        log.debug("View: attached\n", .{}, @src());
        const self = arbor.cast(*View, this);
        const win = if (builtin.os.tag == .linux) blk: {
            if (std.mem.eql(u8, std.mem.span(win_type), "X11EmbedWindowID"))
                break :blk @as(c_ulong, @intFromPtr(parent))
            else
                return .InvalidArgument;
        } else arbor.cast(arbor.Gui.Platform.Window, parent);

        const gui = self.user_gui orelse {
            log.err("User GUI is null\n", .{}, @src());
            return .InternalError;
        };
        arbor.Gui.Platform.guiSetParent(gui.impl, win);
        arbor.Gui.Platform.guiSetVisible(gui.impl, true);
        return .Ok;
    }

    fn removed(this: ?*anyopaque) callconv(cc) Result {
        log.debug("View: removed\n", .{}, @src());
        const self = arbor.cast(*View, this);
        if (self.user_gui) |gui| {
            arbor.Gui.Platform.guiSetVisible(gui.impl, false);
            gui.deinit();
            self.user_gui = null;
            return .Ok;
        } else log.err("Tried to remove null GUI\n", .{}, @src());
        return .NotOk;
    }

    fn onWheel(_: ?*anyopaque, _: f32) callconv(cc) Result {
        return .NotImplemented;
    }

    fn onKeyDown(_: ?*anyopaque, _: u16, _: i16, _: i16) callconv(cc) Result {
        return .NotImplemented;
    }

    fn onKeyUp(_: ?*anyopaque, _: u16, _: i16, _: i16) callconv(cc) Result {
        return .NotImplemented;
    }

    fn getSize(this: ?*anyopaque, rect_cptr: ?*anv.Rect) callconv(cc) Result {
        const self = arbor.cast(*View, this);
        const rect = rect_cptr orelse return .InvalidArgument;
        if (self.user_gui) |gui| {
            const size = gui.getSize();
            rect.* = .{
                .left = 0,
                .top = 0,
                .right = size.x,
                .bottom = size.y,
            };
            return .Ok;
        }

        return .InternalError;
    }

    fn onSize(this: ?*anyopaque, new_size: ?*anv.Rect) callconv(cc) Result {
        _ = this;
        _ = new_size;
        return .Ok;
    }

    fn onFocus(this: ?*anyopaque, state: bool) callconv(cc) Result {
        _ = this;
        _ = state;
        return .NotImplemented;
    }

    fn setFrame(this: ?*anyopaque, frame: ?*?*anv.Interface.Frame) callconv(cc) Result {
        _ = this;
        _ = frame;
        return .NotImplemented;
    }

    fn canResize(this: ?*anyopaque) callconv(cc) Result {
        _ = this;
        return .NotOk;
    }

    fn checkSizeConstraint(this: ?*anyopaque, rect_cptr: ?*anv.Rect) callconv(cc) Result {
        const self = arbor.cast(*View, this);
        const rect = rect_cptr orelse return .InvalidArgument;
        if (self.user_gui) |gui| {
            const size = gui.getSize();
            if (rect.left + rect.right != size.x)
                rect.right = rect.left + size.x;
            if (rect.top + rect.bottom != size.y)
                rect.bottom = rect.top + size.y;
        }
        return .Ok;
    }

    pub const vtable = anv.Interface.View{
        .base = .{
            .queryInterface = queryInterface,
            .addRef = addRef,
            .release = release,
        },
        .isPlatformTypeSupported = isPlatformTypeSupported,
        .attached = attached,
        .removed = removed,
        .onWheel = onWheel,
        .onKeyDown = onKeyDown,
        .onKeyUp = onKeyUp,
        .getSize = getSize,
        .onSize = onSize,
        .onFocus = onFocus,
        .setFrame = setFrame,
        .canResize = canResize,
        .checkSizeConstraint = checkSizeConstraint,
    };
};

const Vst3Plugin = extern struct {
    component: Component,
    processor: Processor,
    controller: Controller,
    view: ?*View = null,

    user: *arbor.Plugin,

    in_events: *arbor.Queue,

    pub fn init() !*Vst3Plugin {
        const plugin = try allocator.create(Vst3Plugin);
        plugin.* = Vst3Plugin{
            .component = .{
                .vtable = &Component.vtable,
                .ref_counter = RefCounter.init(1),
            },
            .processor = .{
                .vtable = &Processor.vtable,
                .ref_counter = RefCounter.init(1),
            },
            .controller = .{
                .vtable = &Controller.vtable,
                .ref_counter = RefCounter.init(1),
                .handler = null,
            },
            .user = undefined,
            .in_events = try arbor.Queue.init(allocator),
        };
        return plugin;
    }

    pub fn deinit(self: *Vst3Plugin) void {
        const total_refs = self.getTotalRefCount();
        if (total_refs == 0) {
            log.debug("All refs released, destroying plugin\n", .{}, @src());
            self.in_events.deinit();
            allocator.destroy(self);
        } else {
            log.err("Deinit called with non-zero refcount | Count: {d}\n", .{total_refs}, @src());
        }
    }

    pub fn getTotalRefCount(self: *Vst3Plugin) u32 {
        var total: u32 = 0;
        total += self.component.ref_counter.load(.acquire);
        total += self.processor.ref_counter.load(.acquire);
        total += self.controller.ref_counter.load(.acquire);
        return total;
    }

    /// Process events from automation & send to GUI if needed.
    pub fn processInEvents(self: *Vst3Plugin) void {
        if (self.in_events.mutex.tryLock()) {
            defer self.in_events.mutex.unlock();
            while (self.in_events.next_no_lock()) |event| {
                switch (event) {
                    .param_change => |change| {
                        const id = change.id;
                        const value = change.value;
                        self.user.params[id] = self.user.param_info[id]
                            .valueFromNormalized(value);

                        if (self.user.gui) |gui| {
                            gui.in_events.push_try(event) catch |e| {
                                log.err("{!}\n", .{e}, @src());
                            };

                            gui.requestDraw();
                        }
                    },
                }
            }
        }
    }

    /// Process events from GUI
    pub fn processOutEvents(
        self: *Vst3Plugin,
        out_changes: *?*anv.Interface.ParameterChange,
    ) void {
        const plug = self.user;
        const gui = plug.gui orelse {
            log.err("GUI is null\n", .{}, @src());
            assert(false);
            return;
        };
        while (gui.out_events.next_try()) |event| {
            switch (event) {
                .param_change => |change| {
                    const param = plug.param_info[change.id];
                    plug.params[change.id] = param.valueFromNormalized(change.value);

                    var out_id: i32 = 0;
                    const vtbl = anv.getInterface(anv.Interface.ParameterChange, out_changes) catch {
                        log.err("ParameterChange vtable is null\n", .{}, @src());
                        return;
                    };
                    const queue = vtbl.addParameterData(
                        @ptrCast(out_changes),
                        &@as(u32, @intCast(change.id)),
                        &out_id,
                    );
                    const q_vtbl = anv.getInterface(anv.Interface.ParamValueQueue, queue) catch {
                        log.err("addParameterData failed\n", .{}, @src());
                        return;
                    };
                    const result = q_vtbl.addPoint(@ptrCast(queue), 0, @floatCast(change.value), &out_id);
                    if (result != .Ok)
                        log.err("addPoint failed: {s}\n", .{@tagName(result)}, @src());
                },
            }
        }
    }
};

const Factory = extern struct {
    vtable: *const anv.Interface.Factory,
    ref_counter: RefCounter,

    host_ctx: ?*anv.Interface.Base = null,

    fn queryInterface(this: ?*anyopaque, iid: *const anv.Uid, obj: ?*?*anyopaque) callconv(cc) Result {
        if (uidCmp(iid, &anv.Interface.Factory.UID3) or
            uidCmp(iid, &anv.Interface.Factory.UID2) or
            uidCmp(iid, &anv.Interface.Factory.UID) or
            uidCmp(iid, &anv.Interface.Base.UID))
        {
            if (obj) |o| {
                const self = arbor.cast(*Factory, this);
                log.debug("Factory: Query OK: {s}\n", .{anv.uidToStr(iid)}, @src());
                _ = self.ref_counter.fetchAdd(1, .release);
                o.* = this;
                return .Ok;
            }
            log.err("obj is null\n", .{}, @src());
            return .InvalidArgument;
        }
        log.debug("Factory: Unsupported: {s}\n", .{anv.uidToStr(iid)}, @src());
        if (obj) |o| o.* = null;
        return .NoInterface;
    }

    fn addRef(this: ?*anyopaque) callconv(cc) u32 {
        const self = arbor.cast(*Factory, this);
        const ref_count = self.ref_counter.fetchAdd(1, .release) + 1;
        log.debug("Factory: Adding ref: {d}\n", .{ref_count}, @src());
        return ref_count;
    }

    fn release(this: ?*anyopaque) callconv(cc) u32 {
        const self = arbor.cast(*Factory, this);
        const ref_count = self.ref_counter.fetchSub(1, .release) - 1;
        log.debug("Factory: releasing | Count {d}\n", .{ref_count}, @src());

        if (ref_count > 0) {
            return ref_count;
        } else {
            log.debug("Factory: all refs released, destroying\n", .{}, @src());
            allocator.destroy(self);
        }
        return 0;
    }

    fn getFactoryInfo(this: ?*anyopaque, info: ?*anv.Interface.Factory.Info) callconv(cc) Result {
        _ = this;
        if (info) |i| {
            i.* = std.mem.zeroes(anv.Interface.Factory.Info);

            i.flags = .{ .unicode = true };

            const vendor = arbor.config.plugin_desc.company;
            @memcpy(i.vendor[0..vendor.len], vendor);

            const url = arbor.config.plugin_desc.url;
            @memcpy(i.vendor[0..url.len], url);

            const email = arbor.config.plugin_desc.contact;
            @memcpy(i.email[0..email.len], email);
            return .Ok;
        }
        return .NotOk;
    }

    fn countClasses(this: ?*anyopaque) callconv(cc) i32 {
        _ = this;
        // Not positive on what separates a "class" from an interface...are we
        // basically doing everything as 1 class?
        return 1;
    }

    fn getClassInfo(this: ?*anyopaque, index: i32, info: ?*anv.ClassInfo) callconv(cc) Result {
        _ = this;
        _ = index;
        if (info) |i| {
            i.* = std.mem.zeroes(anv.ClassInfo);
            @memcpy(&i.cid, &class_id);
            i.cardinality = anv.CardinalityManyInstances;
            const category = "Audio Module Class";
            @memcpy(i.category[0..category.len], category);
            const name = arbor.config.plugin_desc.name;
            @memcpy(i.name[0..name.len], name);
            return .Ok;
        }
        return .NotOk;
    }

    fn createInstance(this: ?*anyopaque, cid: [*:0]const u8, iid: [*:0]const u8, obj: ?*?*anyopaque) callconv(cc) Result {
        _ = this;

        if (anv.uidCmp(cid[0..anv.uid_len], &class_id) and
            (anv.uidCmp(iid[0..anv.uid_len], &anv.Interface.Base.UID) or
            anv.uidCmp(iid[0..anv.uid_len], &anv.Interface.PluginBase.UID) or
            anv.uidCmp(iid[0..anv.uid_len], &anv.Interface.Component.UID)))
        {
            if (obj) |o| {
                log.debug("Creating: {s}\n", .{anv.uidToStr(iid[0..anv.uid_len])}, @src());
                const plugin = Vst3Plugin.init() catch |e| {
                    log.err("{!}\n", .{e}, @src());
                    return .InternalError;
                };
                o.* = &plugin.component;
                return .Ok;
            }
            log.err("obj is null\n", .{}, @src());
            return .InvalidArgument;
        }
        log.debug("Unsupported: {s}\n", .{anv.uidToStr(iid[0..anv.uid_len])}, @src());
        return .NoInterface;
    }

    fn getClassInfo2(this: ?*anyopaque, index: i32, info: ?*anv.ClassInfo2) callconv(cc) Result {
        _ = this;
        _ = index;
        if (info) |i| {
            i.* = std.mem.zeroes(anv.ClassInfo2);
            @memcpy(&i.base.cid, &class_id);
            i.base.cardinality = anv.CardinalityManyInstances;
            const category = "Audio Module Class";
            @memcpy(i.base.category[0..category.len], category);

            const sub_categ = "Fx"; // TODO: Parse VST3 categories from user definitions
            @memcpy(i.sub_categories[0..sub_categ.len], sub_categ);
            const vendor = arbor.config.plugin_desc.company;
            @memcpy(i.vendor[0..vendor.len], vendor);
            const version = arbor.config.plugin_desc.version;
            @memcpy(i.version[0..version.len], version);
            const sdk_version = "VST 3.7.4";
            @memcpy(i.sdk_version[0..sdk_version.len], sdk_version);

            return .Ok;
        }
        return .NotOk;
    }

    fn getClassInfoW(this: ?*anyopaque, index: i32, info: ?*anv.ClassInfoW) callconv(cc) Result {
        _ = this;
        _ = index;
        if (info) |i| {
            i.* = std.mem.zeroes(anv.ClassInfoW);

            @memcpy(&i.cid, &class_id);

            i.cardinality = anv.CardinalityManyInstances;

            const category = "Audio Module Class";
            @memcpy(i.category[0..category.len], category);

            const sub_categ = "Fx";
            @memcpy(i.sub_categories[0..sub_categ.len], sub_categ);

            const name = arbor.config.plugin_desc.name;
            _ = utf8To16(&i.name, name) catch |e| {
                log.err("{!}\n", .{e}, @src());
                return .NotOk;
            };

            const vendor = arbor.config.plugin_desc.company;
            _ = utf8To16(&i.vendor, vendor) catch |e| {
                log.err("{!}\n", .{e}, @src());
                return .NotOk;
            };

            const version = arbor.config.plugin_desc.version;
            _ = utf8To16(&i.version, version) catch |e| {
                log.err("{!}\n", .{e}, @src());
                return .NotOk;
            };

            const sdk_version = std.unicode.utf8ToUtf16LeStringLiteral("VST 3.7.4");
            @memcpy(i.sdk_version[0..sdk_version.len], sdk_version);
            return .Ok;
        }
        return .NotOk;
    }

    fn setHostContext(this: ?*anyopaque, context: ?*?*anv.Interface.Base) callconv(cc) Result {
        const self = arbor.cast(*Factory, this);
        const host = anv.getInterface(anv.Interface.Base, context) catch
            return .InvalidArgument;
        if (host.queryInterface(
            @ptrCast(context),
            &anv.Interface.HostApplication.UID,
            @ptrCast(&self.host_ctx),
        ) != .Ok)
            return .InternalError;

        return .Ok;
    }

    const vtable = anv.Interface.Factory{
        .base = .{
            .queryInterface = queryInterface,
            .addRef = addRef,
            .release = release,
        },
        .getFactoryInfo = getFactoryInfo,
        .countClasses = countClasses,
        .getClassInfo = getClassInfo,
        .createInstance = createInstance,
        .getClassInfo2 = getClassInfo2,
        .getClassInfoUnicode = getClassInfoW,
        .setHostContext = setHostContext,
    };
};

export fn GetPluginFactory() ?*anyopaque {
    const factory = allocator.create(Factory) catch |e|
        log.fatal("{!}\n", .{e}, @src());
    factory.* = .{
        .vtable = &Factory.vtable,
        .ref_counter = RefCounter.init(1),
    };

    return factory;
}

export fn bundleEntry(_: ?*anyopaque) bool {
    log.debug("Bundle entry\n", .{}, @src());
    return true;
}

export fn bundleExit(_: ?*anyopaque) bool {
    log.debug("Bundle exit\n", .{}, @src());
    return true;
}

export fn ModuleEntry(_: ?*anyopaque) bool {
    log.debug("Module entry\n", .{}, @src());
    return true;
}

export fn ModuleExit(_: ?*anyopaque) bool {
    log.debug("Module exit\n", .{}, @src());
    return true;
}
