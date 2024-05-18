const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;

const arbor = @import("arbor.zig");
const log = arbor.log;

const allocator = std.heap.c_allocator;

const utf8To16 = std.unicode.utf8ToUtf16Le;

const vst3 = @import("vst3_api.zig");

const cc: std.builtin.CallingConvention = if (builtin.os.tag == .windows and
    builtin.cpu.arch == .x86) .Stdcall else .C;

const Result = vst3.Result;

const RefCounter = std.atomic.Value(u32);

pub const class_id: vst3.Uid = vst3.uidCreate('A', 'N', 'V', '3');
pub const comp_id: vst3.Uid = vst3.uidCreate('C', 'o', 'm', 'p');
pub const controller_id: vst3.Uid = vst3.uidCreate('C', 't', 'r', 'l');
const uidCmp = vst3.uidCmp;

const Vst3Plugin = extern struct {
    const AudioProcessor = vst3.Interface.AudioProcessor;
    const Component = vst3.Interface.Component;
    component: *const Component,
    // processor: *const AudioProcessor,
    ref_counter: RefCounter,

    fn queryInterface(this: ?*anyopaque, iid: *const vst3.Uid, obj: ?*?*anyopaque) callconv(cc) Result {
        if (uidCmp(iid, &vst3.Interface.Base.UID) or
            uidCmp(iid, &vst3.Interface.PluginBase.UID) or
            uidCmp(iid, &vst3.Interface.Component.UID))
        {
            if (obj) |o| {
                const self = arbor.cast(*Vst3Plugin, this);
                log.debug("Query: {s}\n", .{vst3.uidToStr(iid)}, @src());
                _ = self.ref_counter.fetchAdd(1, .release);
                o.* = this;
                return .Ok;
            }
        }
        log.debug("Unsupported: {s}\n", .{vst3.uidToStr(iid)}, @src());
        return .NoInterface;
    }

    fn addRef(this: ?*anyopaque) callconv(cc) u32 {
        const self = arbor.cast(*Vst3Plugin, this);
        return self.ref_counter.fetchAdd(1, .release) + 1;
    }

    fn release(this: ?*anyopaque) callconv(cc) u32 {
        const self = arbor.cast(*Vst3Plugin, this);
        const ref_count = self.ref_counter.fetchSub(1, .release) - 1;
        if (ref_count > 0) {
            return ref_count;
        } else {
            allocator.destroy(self);
        }
        return 0;
    }

    fn initialize(this: ?*anyopaque, context: ?*vst3.Interface.Base) callconv(cc) Result {
        _ = this;
        _ = context;
        // this is where we'd get a pointer to the host
        // query its interface for host context and save a pointer to it in our plugin
        return .Ok;
    }

    fn terminate(this: ?*anyopaque) callconv(cc) Result {
        _ = this;
        // kill
        return .Ok;
    }

    fn getControllerClass(_: ?*anyopaque, cid: *vst3.Uid) callconv(cc) Result {
        @memcpy(cid, &comp_id);
        return .Ok;
    }

    fn setIoMode(this: ?*anyopaque, mode: vst3.IoMode) callconv(cc) Result {
        _ = this;
        _ = mode;
        return .Ok;
    }

    fn getBusCount(this: ?*anyopaque, media_type: vst3.MediaType, dir: vst3.BusDirection) callconv(cc) i32 {
        _ = this;
        _ = dir;
        if (media_type == .Audio)
            return 1
        else
            return 0;
    }

    fn getBusInfo(
        this: ?*anyopaque,
        media_type: vst3.MediaType,
        dir: vst3.BusDirection,
        index: i32,
        bus_ptr: ?*vst3.BusInfo,
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

    fn getRoutingInfo(this: ?*anyopaque, in_info: ?*vst3.RoutingInfo, out_info: ?*vst3.RoutingInfo) callconv(cc) Result {
        _ = this;
        _ = in_info;
        _ = out_info;
        return .NotImplemented;
    }

    fn activateBus(
        this: ?*anyopaque,
        media_type: vst3.MediaType,
        dir: vst3.BusDirection,
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

    fn setBusArrangements(
        this: ?*anyopaque,
        inputs: ?*vst3.SpeakerArrangement,
        num_in: i32,
        outputs: ?*vst3.SpeakerArrangement,
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
        dir: vst3.BusDirection,
        index: i32,
        arr_ptr: ?*vst3.SpeakerArrangement,
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

    fn setActive(this: ?*anyopaque, state: bool) callconv(cc) Result {
        _ = this;
        _ = state;
        return .Ok;
    }

    fn canProcessSampleSize(this: ?*anyopaque, size: vst3.SampleSize) callconv(cc) Result {
        _ = this;
        // TODO: Check if double precision supported
        if (size == .Sample32) return .Ok else return .NotOk;
    }

    fn getLatencySamples(this: ?*anyopaque) callconv(cc) u32 {
        _ = this;
        return 0;
    }

    fn setupProcessing(this: ?*anyopaque, setup_ptr: ?*vst3.ProcessSetup) callconv(cc) Result {
        _ = this;
        if (setup_ptr) |_| {
            return .Ok;
        } else return .InvalidArgument;
    }

    fn setProcessing(this: ?*anyopaque, state: bool) callconv(cc) Result {
        _ = this;
        _ = state;
        return .Ok;
    }

    fn process(this: ?*anyopaque, data: ?*vst3.ProcessData) callconv(cc) Result {
        _ = this;
        _ = data;
        return .Ok;
    }

    fn getTailSamples(this: ?*anyopaque) callconv(cc) u32 {
        _ = this;
        return 0;
    }

    fn setState(this: ?*anyopaque, state: ?*vst3.Interface.Stream) callconv(cc) Result {
        // TODO
        _ = this;
        _ = state;
        return .Ok;
    }
    fn getState(this: ?*anyopaque, state: ?*vst3.Interface.Stream) callconv(cc) Result {
        _ = this;
        _ = state;
        return .Ok;
    }

    const component_vtable = Component{
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

    const processor_vtable = AudioProcessor{
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

const Factory = extern struct {
    vtable: *vst3.Interface.Factory,
    ref_counter: RefCounter,

    host_ctx: ?*vst3.Interface.Base = null,

    fn queryInterface(this: ?*anyopaque, iid: *const vst3.Uid, obj: ?*?*anyopaque) callconv(cc) Result {
        if (uidCmp(iid, &vst3.Interface.Factory.UID3) or
            uidCmp(iid, &vst3.Interface.Factory.UID2) or
            uidCmp(iid, &vst3.Interface.Factory.UID) or
            uidCmp(iid, &vst3.Interface.Base.UID))
        {
            if (obj) |o| {
                const self = arbor.cast(*Factory, this);
                log.debug("Query OK: {s}\n", .{vst3.uidToStr(iid)}, @src());
                _ = self.ref_counter.fetchAdd(1, .release);
                o.* = this;
                return .Ok;
            }
        }
        log.debug("Unsupported: {s}\n", .{vst3.uidToStr(iid)}, @src());
        if (obj) |o| o.* = null;
        return .NoInterface;
    }

    fn addRef(this: ?*anyopaque) callconv(cc) u32 {
        const self = arbor.cast(*Factory, this);
        const ref_count = self.ref_counter.fetchAdd(1, .release) + 1;
        return ref_count;
    }

    fn release(this: ?*anyopaque) callconv(cc) u32 {
        const self = arbor.cast(*Factory, this);
        const ref_count = self.ref_counter.fetchSub(1, .release) - 1;

        if (ref_count > 0) {
            return ref_count;
        } else {
            log.debug("All refs released, destroying\n", .{}, @src());
            allocator.destroy(self);
        }
        return 0;
    }

    fn getFactoryInfo(this: ?*anyopaque, info: ?*vst3.Interface.Factory.Info) callconv(cc) Result {
        _ = this;
        if (info) |i| {
            i.* = std.mem.zeroes(vst3.Interface.Factory.Info);

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

    fn getClassInfo(this: ?*anyopaque, index: i32, info: ?*vst3.ClassInfo) callconv(cc) Result {
        _ = this;
        _ = index;
        if (info) |i| {
            i.* = std.mem.zeroes(vst3.ClassInfo);
            @memcpy(&i.cid, &class_id);
            i.cardinality = vst3.CardinalityManyInstances;
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

        if (vst3.uidCmp(cid[0..vst3.uid_len], &class_id) and
            (vst3.uidCmp(iid[0..vst3.uid_len], &vst3.Interface.PluginBase.UID) or
            vst3.uidCmp(iid[0..vst3.uid_len], &vst3.Interface.Component.UID)))
        {
            if (obj) |o| {
                log.debug("Create: {s}\n", .{vst3.uidToStr(iid[0..vst3.uid_len])}, @src());
                const plugin = allocator.create(Vst3Plugin) catch |e|
                    log.fatal("{!}\n", .{e}, @src());
                plugin.* = Vst3Plugin{
                    .component = &Vst3Plugin.component_vtable,
                    // .processor = &Plugin.processor_vtable,
                    .ref_counter = RefCounter.init(1),
                };
                o.* = plugin;
                return .Ok;
            } else return .InvalidArgument;
        }
        log.debug("Unsupported: {s}\n", .{vst3.uidToStr(iid[0..vst3.uid_len])}, @src());
        return .InvalidArgument;
    }

    fn getClassInfo2(this: ?*anyopaque, index: i32, info: ?*vst3.ClassInfo2) callconv(cc) Result {
        _ = this;
        _ = index;
        if (info) |i| {
            i.* = std.mem.zeroes(vst3.ClassInfo2);
            @memcpy(&i.base.cid, &class_id);
            i.base.cardinality = vst3.CardinalityManyInstances;
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

    fn getClassInfoW(this: ?*anyopaque, index: i32, info: ?*vst3.ClassInfoW) callconv(cc) Result {
        _ = this;
        _ = index;
        if (info) |i| {
            i.* = std.mem.zeroes(vst3.ClassInfoW);

            @memcpy(&i.cid, &class_id);

            i.cardinality = vst3.CardinalityManyInstances;

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

    fn setHostContext(this: ?*anyopaque, context: ?*vst3.Interface.Base) callconv(cc) Result {
        const self = arbor.cast(*Factory, this);
        _ = if (self.host_ctx) |old_ctx| if (old_ctx.release) |rel| rel(old_ctx);
        if (context) |ctx| {
            self.host_ctx = ctx;
            if (ctx.addRef) |add| _ = add(ctx);
            return .Ok;
        }
        return .InvalidArgument;
    }

    var vtable = vst3.Interface.Factory{
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
