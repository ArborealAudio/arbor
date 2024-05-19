const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;

const cc: std.builtin.CallingConvention = if (builtin.os.tag == .windows and
    builtin.cpu.arch == .x86) .Stdcall else .C;

// definitions & helpers

pub const uid_len = 16;
pub const Uid = [uid_len]u8;

pub fn uidCreate(l1: u32, l2: u32, l3: u32, l4: u32) Uid {
    if (builtin.os.tag == .windows) {
        return .{
            @as(u8, @truncate(l1 & 0x000000FF)),         @as(u8, @truncate((l1 & 0x0000FF00) >> 8)),
            @as(u8, @truncate((l1 & 0x00FF0000) >> 16)), @as(u8, @truncate((l1 & 0xFF000000) >> 24)),
            @as(u8, @truncate((l2 & 0x00FF0000) >> 16)), @as(u8, @truncate((l2 & 0xFF000000) >> 24)),
            @as(u8, @truncate(l2 & 0x000000FF)),         @as(u8, @truncate((l2 & 0x0000FF00) >> 8)),
            @as(u8, @truncate((l3 & 0xFF000000) >> 24)), @as(u8, @truncate((l3 & 0x00FF0000) >> 16)),
            @as(u8, @truncate((l3 & 0x0000FF00) >> 8)),  @as(u8, @truncate(l3 & 0x000000FF)),
            @as(u8, @truncate((l4 & 0xFF000000) >> 24)), @as(u8, @truncate((l4 & 0x00FF0000) >> 16)),
            @as(u8, @truncate((l4 & 0x0000FF00) >> 8)),  @as(u8, @truncate(l4 & 0x000000FF)),
        };
    } else {
        return .{
            @as(u8, @truncate((l1 & 0xFF000000) >> 24)), @as(u8, @truncate((l1 & 0x00FF0000) >> 16)),
            @as(u8, @truncate((l1 & 0x0000FF00) >> 8)),  @as(u8, @truncate(l1 & 0x000000FF)),
            @as(u8, @truncate((l2 & 0xFF000000) >> 24)), @as(u8, @truncate((l2 & 0x00FF0000) >> 16)),
            @as(u8, @truncate((l2 & 0x0000FF00) >> 8)),  @as(u8, @truncate(l2 & 0x000000FF)),
            @as(u8, @truncate((l3 & 0xFF000000) >> 24)), @as(u8, @truncate((l3 & 0x00FF0000) >> 16)),
            @as(u8, @truncate((l3 & 0x0000FF00) >> 8)),  @as(u8, @truncate(l3 & 0x000000FF)),
            @as(u8, @truncate((l4 & 0xFF000000) >> 24)), @as(u8, @truncate((l4 & 0x00FF0000) >> 16)),
            @as(u8, @truncate((l4 & 0x0000FF00) >> 8)),  @as(u8, @truncate(l4 & 0x000000FF)),
        };
    }
}

pub fn uidCmp(a: *const Uid, b: *const Uid) bool {
    assert(a.len == uid_len and b.len == uid_len and a.len == b.len);
    return std.mem.eql(u8, a, b);
}

const uid_table = std.ComptimeStringMap(Uid, genInterfaceMap());

fn genInterfaceMap() []struct { []const u8, Uid } {
    const decls = @typeInfo(Interface).Struct.decls;
    // len + 2 for extra factory UIDs
    var table: [decls.len + 2]struct { []const u8, Uid } = undefined;
    for (decls, table[0..decls.len]) |iface, *t| {
        t.* = .{ iface.name, @field(Interface, iface.name).UID };
    }
    table[table.len - 2] = .{ "Factory2", Interface.Factory.UID2 };
    table[table.len - 1] = .{ "Factory3", Interface.Factory.UID3 };
    return &table;
}

/// Query a UID against known interface IDs
pub fn uidToStr(uid: *const Uid) []const u8 {
    inline for (uid_table.kvs) |iface| {
        if (uidCmp(uid, &iface.value)) {
            return iface.key;
        }
    }
    return "UnknownInterface";
}

pub const Result = if (builtin.os.tag != .windows) enum(i32) {
    NoInterface = -1,
    Ok = 0,
    NotOk = 1,
    InvalidArgument = 2,
    NotImplemented = 3,
    InternalError = 4,
    NotInitialized = 5,
    OutOfMemory = 6,
} else enum(i32) {
    // elegant...immaculate...
    NoInterface = -0x7fffbffe,
    Ok = 0,
    NotOk = 1,
    InvalidArgument = -0x7ff8ffa9,
    NotImplemented = -0x7fffbfff,
    InternalError = -0x7fffbffb,
    NotInitialized = -0x7fff0001,
    OutOfMemory = -0x7ff8fff2,
};

pub const CardinalityManyInstances = 0x7fffffff;

pub const wstr = [128]u16;

// structs

pub const ClassInfo = extern struct {
    cid: Uid,
    /// just set to `CardinalityManyInstances`...it's the only option
    cardinality: i32,
    category: [32]u8,
    name: [64]u8,
};

pub const ClassInfo2 = extern struct {
    base: ClassInfo,
    class_flags: u32,
    sub_categories: [128]u8,
    vendor: [64]u8,
    version: [64]u8,
    sdk_version: [64]u8,
};

pub const ClassInfoW = extern struct {
    cid: Uid,
    /// just set to `CardinalityManyInstances`...it's the only option
    cardinality: i32,
    category: [32]u8,
    name: [64]u16,
    class_flags: u32,
    sub_categories: [128]u8,
    vendor: [64]u16,
    version: [64]u16,
    sdk_version: [64]u16,
};

pub const BusInfo = extern struct {
    media_type: MediaType,
    direction: BusDirection,
    channel_count: i32,
    name: [128]u16,
    bus_type: BusType,
    flags: Flags,

    pub const Flags = packed struct(u32) {
        DefaultActive: bool = false,
        IsControlVoltage: bool = false,
        _: u30 = 0,
    };
};

pub const RoutingInfo = extern struct {
    media_type: MediaType,
    bus_index: i32,
    channel: i32,
};

pub const ProcessSetup = extern struct {
    process_mode: ProcessMode,
    sample_size: SampleSize,
    max_samples: i32,
    sample_rate: f64,
};

pub const ProcessContext = extern struct {
    state: Flags,
    sample_rate: f64,
    project_time_samples: i64,
    system_time: i64,
    continuous_time_samples: i64,
    project_time: f64,
    bar_position: f64,
    cycle_start: f64,
    cycle_end: f64,
    tempo: f64,
    time_sig_numerator: i32,
    time_sig_denom: i32,
    chord: Chord,
    smpte_offset_subframes: i32,
    frame_rate: FrameRate,
    samples_to_next_clock: i32,

    pub const Flags = packed struct(u32) {
        _: u1 = 0,
        Playing: bool = false,
        CycleActive: bool = false,
        Recording: bool = false,
        SystemTimeValid: bool = false,
        ContTimeValid: bool = false,
        ProjectTimeMusicValid: bool = false,
        BarPositionValid: bool = false,
        CycleValid: bool = false,
        TempoValid: bool = false,
        TimeSigValid: bool = false,
        ChordValid: bool = false,
        SmpteValid: bool = false,
        ClockValid: bool = false,
        _pad: u18 = 0,
    };

    pub const Requirements = packed struct(u32) {
        NeedSystemTime: bool = false,
        NeedContinousTimeSamples: bool = false,
        NeedProjectTimeMusic: bool = false,
        NeedBarPositionMusic: bool = false,
        NeedCycleMusic: bool = false,
        NeedSamplesToNextClock: bool = false,
        NeedTempo: bool = false,
        NeedTimeSignature: bool = false,
        NeedChord: bool = false,
        NeedFrameRate: bool = false,
        NeedTransportState: bool = false,
        _: u21 = 0,
    };
};

pub const ProcessData = extern struct {
    process_mode: ProcessMode,
    sample_size: SampleSize,
    num_samples: i32,
    num_inputs: i32,
    num_outputs: i32,
    inputs: ?*AudioBuffer,
    outputs: ?*AudioBuffer,
    in_param_changes: ?*Interface.ParameterChange,
    out_param_changes: ?*Interface.ParameterChange,
    in_events: ?*Interface.EventList,
    out_events: ?*Interface.EventList,
    process_context: ?*ProcessContext,
};

pub const AudioBuffer = extern struct {
    num_channels: i32,
    silence_flags: u64,
    data: extern union {
        buffer32: [*][*]f32,
        buffer64: [*][*]f64,
    },
};

pub const ParameterInfo = extern struct {
    id: u32,
    title: [128]u16,
    /// lmao
    short_title: [128]u16,
    units: [128]u16,
    step_count: i32,
    default_normalized: f64,
    unit_id: i32,
    flags: Flags,

    pub const Flags = packed struct(u32) {
        CanAutomate: bool = false,
        IsReadOnly: bool = false,
        IsWrapAround: bool = false,
        IsList: bool = false,
        IsHidden: bool = false,
        _pad1: u10 = 0,
        IsProgramChange: bool = false,
        IsBypass: bool = false,
        _pad2: u15 = 0,
    };
};

pub const Chord = extern struct {
    key_note: u8,
    root_note: u8,
    chord_mask: Mask,

    pub const Mask = enum(u16) { ChordMask = 0x0fff, Reserved = 0xf000 };
};

pub const Event = extern struct {
    bus_index: i32,
    sample_offset: i32,
    ppq_position: f64,
    flags: Flags,
    type: u16,
    event: extern union {
        note_on: NoteOnEvent,
        note_off: NoteOffEvent,
        data: DataEvent,
        poly_pressure: PolyPressureEvent,
        note_expression_value: NoteExpressionValueEvent,
        note_expression_text: NoteExpressionTextEvent,
        chord: ChordEvent,
        scale: ScaleEvent,
        midi_cc_out: MidiCCOutEvent,
    },

    pub const Flags = packed struct(u16) {
        IsLive: bool = false,
        _: u13 = 0,
        UserReserved1: bool = false,
        UserReserved2: bool = false,
    };
};

pub const NoteOnEvent = extern struct {
    channel: i16,
    pitch: i16,
    tuning: f32,
    velocity: f32,
    length: i32,
    note_id: i32,
};

pub const NoteOffEvent = extern struct {
    channel: i16,
    pitch: i16,
    velocity: f32,
    note_id: i32,
    tuning: f32,
};

pub const DataEvent = extern struct {
    size: u32,
    type: u32,
    bytes: [*]const u8,
};

pub const PolyPressureEvent = extern struct {
    channel: i16,
    pitch: i16,
    pressure: f32,
    note_id: i32,
};

pub const ChordEvent = extern struct {
    root: i16,
    bass_note: i16,
    mask: i16,
    text_len: u16,
    text: [*]const u16,
};

pub const ScaleEvent = extern struct {
    root: i16,
    mask: i16,
    text_len: u16,
    text: [*]const u16,
};

pub const MidiCCOutEvent = extern struct {
    control_number: u8,
    channel: u8,
    value: u8,
    value2: u8,
};

pub const NoteExpressionValueEvent = extern struct {
    type_id: u32,
    note_id: i32,
    value: f64,
};

pub const NoteExpressionTextEvent = extern struct {
    type_id: u32,
    note_id: i32,
    text_len: u32,
    text: [*]const u16,
};

pub const FrameRate = extern struct {
    fps: u32,
    flags: Flags,

    pub const Flags = packed struct(u32) {
        PullDownRate: bool = false,
        DropRate: bool = false,
        _: u30 = 0,
    };
};

pub const Rect = extern struct {
    left: i32,
    top: i32,
    right: i32,
    bottom: i32,
};

// enums

pub const MediaType = enum(i32) {
    Audio = 0,
    Event = 1,
};

pub const BusDirection = enum(i32) {
    Input = 0,
    Output = 1,
};

pub const BusType = enum(i32) {
    Main = 0,
    Aux = 1,
};

pub const IoMode = enum(i32) {
    Simple = 0,
    Advanced,
    OfflineProcessing,
};

pub const SpeakerArrangement = packed struct(u64) {
    L: bool = false,
    R: bool = false,
    C: bool = false,
    LFE: bool = false,
    LS: bool = false,
    RS: bool = false,
    LC: bool = false,
    RC: bool = false,
    S: bool = false,
    SL: bool = false,
    SR: bool = false,
    TC: bool = false,
    TFL: bool = false,
    TFC: bool = false,
    TFR: bool = false,
    TRL: bool = false,
    TRC: bool = false,
    TRR: bool = false,
    LFE2: bool = false,
    M: bool = false,
    _: u44 = 0,
};

pub const ProcessMode = enum(i32) {
    Realtime,
    Prefetch,
    Offline,
};

pub const SampleSize = enum(i32) {
    Sample32,
    Sample64,
};

pub const ComponentRestartFlags = packed struct(i32) {
    ReloadComponent: bool = false,
    IoChanged: bool = false,
    ParamValuesChanged: bool = false,
    LatencyChanged: bool = false,
    ParamTitlesChanged: bool = false,
    MidiCCAssignmentChanged: bool = false,
    NoteExpressionChanged: bool = false,
    IoTitlesChanged: bool = false,
    PrefetchableSupportChanged: bool = false,
    RoutingInfoChanged: bool = false,
    KeyswitchChanged: bool = false,
    _: u21 = 0,
};

pub const Interface = struct {
    pub const Base = extern struct {
        queryInterface: ?*const fn (this: ?*anyopaque, iid: *const Uid, obj: ?*?*anyopaque) callconv(cc) Result,
        addRef: ?*const fn (this: ?*anyopaque) callconv(cc) u32,
        release: ?*const fn (this: ?*anyopaque) callconv(cc) u32,

        pub const UID = uidCreate(0x00000000, 0x00000000, 0xC0000000, 0x00000046);
    };

    pub const HostApplication = extern struct {
        base: Base,
        getName: ?*const fn (this: ?*anyopaque, name: [128]u16) callconv(cc) Result,
        createInstance: ?*const fn (this: ?*anyopaque, cid: [*:0]const u8, iid: [*:0]const u8, obj: ?*?*anyopaque) callconv(cc) Result,

        pub const UID = uidCreate(0x58E595CC, 0xDB2D4969, 0x8B6AAF8C, 0x36A664E5);
    };

    pub const PluginBase = extern struct {
        base: Base,
        initialize: ?*const fn (this: ?*anyopaque, context: ?*Base) callconv(cc) Result,
        terminate: ?*const fn (this: ?*anyopaque) callconv(cc) Result,

        pub const UID = uidCreate(0x22888DDB, 0x156E45AE, 0x8358B348, 0x08190625);
    };

    /// extends `PluginBase`
    pub const Component = extern struct {
        base: PluginBase,
        getControllerClass: ?*const fn (this: ?*anyopaque, cid: *Uid) callconv(cc) Result,
        setIoMode: ?*const fn (this: ?*anyopaque, mode: IoMode) callconv(cc) Result,
        getBusCount: ?*const fn (this: ?*anyopaque, type: MediaType, dir: BusDirection) callconv(cc) i32,
        getBusInfo: ?*const fn (
            this: ?*anyopaque,
            type: MediaType,
            dir: BusDirection,
            index: i32,
            bus: ?*BusInfo,
        ) callconv(cc) Result,
        getRoutingInfo: ?*const fn (this: ?*anyopaque, in_info: ?*RoutingInfo, out_info: ?*RoutingInfo) callconv(cc) Result,
        activateBus: ?*const fn (this: ?*anyopaque, type: MediaType, dir: BusDirection, index: i32, state: bool) callconv(cc) Result,
        setActive: ?*const fn (this: ?*anyopaque, state: bool) callconv(cc) Result,
        setState: ?*const fn (this: ?*anyopaque, state: ?*Stream) callconv(cc) Result,
        getState: ?*const fn (this: ?*anyopaque, state: ?*Stream) callconv(cc) Result,

        pub const Flags = packed struct(u32) {
            Distributable: bool = false,
            SimpleModeSupported: bool = false,
            _pad2: u30 = 0,
        };

        pub const UID = uidCreate(0xE831FF31, 0xF2D54301, 0x928EBBEE, 0x25697802);
    };

    /// An interface that works in tandem with `Component` to form a plugin
    pub const AudioProcessor = extern struct {
        base: Base,
        setBusArrangements: ?*const fn (
            this: ?*anyopaque,
            inputs: ?*SpeakerArrangement,
            num_in: i32,
            outputs: ?*SpeakerArrangement,
            num_out: i32,
        ) callconv(cc) Result,
        getBusArrangement: ?*const fn (this: ?*anyopaque, dir: BusDirection, index: i32, arr: ?*SpeakerArrangement) callconv(cc) Result,
        canProcessSampleSize: ?*const fn (this: ?*anyopaque, size: SampleSize) callconv(cc) Result,
        getLatencySamples: ?*const fn (this: ?*anyopaque) callconv(cc) u32,
        setupProcessing: ?*const fn (this: ?*anyopaque, setup: ?*ProcessSetup) callconv(cc) Result,
        setProcessing: ?*const fn (this: ?*anyopaque, state: bool) callconv(cc) Result,
        process: ?*const fn (this: ?*anyopaque, data: ?*ProcessData) callconv(cc) Result,
        getTailSamples: ?*const fn (this: ?*anyopaque) callconv(cc) u32,

        pub const UID = uidCreate(0x42043F99, 0xB7DA453C, 0xA569E79D, 0x9AAEC33D);
    };

    pub const ProcessContextRequirements = extern struct {
        base: Base,
        getProcessContextRequirements: ?*const fn (this: ?*anyopaque) ProcessContext.Requirements,

        pub const UID = uidCreate(0x2A654303, 0xEF764E3D, 0x95B5FE83, 0x730EF6D0);
    };

    pub const EditController = extern struct {
        base: PluginBase,
        setComponentState: ?*const fn (this: ?*anyopaque, state: ?*Stream) callconv(cc) Result,
        setState: ?*const fn (this: ?*anyopaque, state: ?*Stream) callconv(cc) Result,
        getState: ?*const fn (this: ?*anyopaque, state: ?*Stream) callconv(cc) Result,
        getParameterCount: ?*const fn (this: ?*anyopaque) callconv(cc) i32,
        getParameterInfo: ?*const fn (this: ?*anyopaque, param_index: i32, info: ?*ParameterInfo) callconv(cc) Result,
        getParamStringByValue: ?*const fn (this: ?*anyopaque, id: u32, value_normalized: f64, string: *wstr) callconv(cc) Result,
        getParamValueByString: ?*const fn (this: ?*anyopaque, id: u32, string: [*:0]u16, value_normalized: ?*f64) callconv(cc) Result,
        normalizedParamToPlain: ?*const fn (this: ?*anyopaque, id: u32, value_normalized: f64) callconv(cc) f64,
        plainParamToNormalized: ?*const fn (this: ?*anyopaque, id: u32, plain_value: f64) callconv(cc) f64,
        getParamNormalized: ?*const fn (this: ?*anyopaque, id: u32) callconv(cc) f64,
        setParamNormalized: ?*const fn (this: ?*anyopaque, id: u32, value: f64) callconv(cc) Result,
        setComponentHandler: ?*const fn (this: ?*anyopaque, handler: ?*?*ComponentHandler) callconv(cc) Result,
        createView: ?*const fn (this: ?*anyopaque, name: [*:0]const u8) callconv(cc) ?*View,

        pub const UID = uidCreate(0xDCD7BBE3, 0x7742448D, 0xA874AACC, 0x979C759E);
    };

    pub const ComponentHandler = extern struct {
        base: Base,
        beginEdit: ?*const fn (this: ?*anyopaque, id: u32) callconv(cc) Result,
        performEdit: ?*const fn (this: ?*anyopaque, id: u32, value_normalized: f64) callconv(cc) Result,
        endEdit: ?*const fn (this: ?*anyopaque, id: u32) callconv(cc) Result,
        restartComponent: ?*const fn (this: ?*anyopaque, flags: ComponentRestartFlags) callconv(cc) Result,

        pub const UID = uidCreate(0x93A0BEA3, 0x0BD045DB, 0x8E890B0C, 0xC1E46AC6);
    };

    pub const View = extern struct {
        base: Base,
        isPlatformTypeSupported: ?*const fn (this: ?*anyopaque, type: [*:0]const u8) callconv(cc) Result,
        attached: ?*const fn (this: ?*anyopaque, parent: ?*anyopaque, type: [*:0]const u8) callconv(cc) Result,
        removed: ?*const fn (this: ?*anyopaque) callconv(cc) Result,
        onWheel: ?*const fn (this: ?*anyopaque, distance: f32) callconv(cc) Result,
        onKeyDown: ?*const fn (this: ?*anyopaque, key: u16, key_code: i16, modifiers: i16) callconv(cc) Result,
        onKeyUp: ?*const fn (this: ?*anyopaque, key: u16, key_code: i16, modifiers: i16) callconv(cc) Result,
        getSize: ?*const fn (this: ?*anyopaque, size: ?*Rect) callconv(cc) Result,
        onSize: ?*const fn (this: ?*anyopaque, new_size: ?*Rect) callconv(cc) Result,
        onFocus: ?*const fn (this: ?*anyopaque, state: bool) callconv(cc) Result,
        setFrame: ?*const fn (this: ?*anyopaque, frame: ?*Frame) callconv(cc) Result,
        canResize: ?*const fn (this: ?*anyopaque) callconv(cc) Result,
        checkSizeConstraint: ?*const fn (this: ?*anyopaque, rect: ?*Rect) callconv(cc) Result,

        pub const UID = uidCreate(0x5BC32507, 0xD06049EA, 0xA6151B52, 0x2B755B29);
    };

    pub const Frame = extern struct {
        base: Base,
        resizeView: ?*const fn (this: ?*anyopaque, view: ?*View, new_size: ?*Rect) callconv(cc) Result,

        pub const UID = uidCreate(0x367FAF01, 0xAFA94693, 0x8D4DA2A0, 0xED0882A3);
    };

    pub const Factory = extern struct {
        base: Base,
        getFactoryInfo: ?*const fn (this: ?*anyopaque, info: ?*Info) callconv(cc) Result,
        countClasses: ?*const fn (this: ?*anyopaque) callconv(cc) i32,
        getClassInfo: ?*const fn (this: ?*anyopaque, index: i32, info: ?*ClassInfo) callconv(cc) Result,
        createInstance: ?*const fn (
            this: ?*anyopaque,
            cid: [*:0]const u8,
            iid: [*:0]const u8,
            obj: ?*?*anyopaque,
        ) callconv(cc) Result,
        // what will happen if we just...put the other functions in here?
        getClassInfo2: ?*const fn (this: ?*anyopaque, index: i32, info: ?*ClassInfo2) callconv(cc) Result,
        getClassInfoUnicode: ?*const fn (
            this: ?*anyopaque,
            index: i32,
            info: ?*ClassInfoW,
        ) callconv(cc) Result,
        setHostContext: ?*const fn (this: ?*anyopaque, context: ?*Base) callconv(cc) Result,

        pub const Info = extern struct {
            vendor: [64]u8,
            url: [256]u8,
            email: [128]u8,
            flags: Flags,

            pub const Flags = packed struct(i32) {
                none: bool = false,
                classes_discardable: bool = false,
                license_check: bool = false,
                _pad: u1 = 0,
                component_non_discardable: bool = false,
                unicode: bool = false,
                _: u26 = 0,
            };
        };

        pub const UID = uidCreate(0x7A4D811C, 0x52114A1F, 0xAED9D2EE, 0x0B43BF9F);
        pub const UID2 = uidCreate(0x0007B650, 0xF24B4C0B, 0xA464EDB9, 0xF00B2ABB);
        pub const UID3 = uidCreate(0x4555A2AB, 0xC1234E57, 0x9B122910, 0x36878931);
    };

    pub const Stream = extern struct {
        base: Base,
        read: ?*const fn (this: ?*anyopaque, buffer: ?*anyopaque, num_bytes: i32, bytes_read: ?*i32) callconv(cc) Result,
        write: ?*const fn (this: ?*anyopaque, buffer: ?*anyopaque, num_bytes: i32, bytes_written: ?*i32) callconv(cc) Result,
        seek: ?*const fn (this: ?*anyopaque, pos: i64, mode: i32, result: ?*i64) callconv(cc) Result,
        tell: ?*const fn (this: ?*anyopaque, pos: ?*i64) callconv(cc) Result,

        pub const UID = uidCreate(0xC3BF6EA2, 0x30994752, 0x9B6BF990, 0x1EE33E9B);
    };

    pub const EventList = extern struct {
        base: Base,
        getEventCount: ?*const fn (this: ?*anyopaque) callconv(cc) i32,
        getEvent: ?*const fn (this: ?*anyopaque, index: i32, event: ?*Event) callconv(cc) Result,
        addEvent: ?*const fn (this: ?*anyopaque, event: ?*Event) callconv(cc) Result,

        pub const UID = uidCreate(0x3A2C4214, 0x346349FE, 0xB2C4F397, 0xB9695A44);
    };

    pub const ParamValueQueue = extern struct {
        base: Base,
        getParameterId: ?*const fn (this: ?*anyopaque) callconv(cc) u32,
        getPointCount: ?*const fn (this: ?*anyopaque) callconv(cc) i32,
        getPoint: ?*const fn (this: ?*anyopaque, index: i32, sample_offset: ?*i32, value: ?*f64) callconv(cc) Result,
        addPoint: ?*const fn (this: ?*anyopaque, sample_offset: i32, value: f64, index: ?*i32) callconv(cc) Result,

        pub const UID = uidCreate(0x01263A18, 0xED074F6F, 0x98C9D356, 0x4686F9BA);
    };

    pub const ParameterChange = extern struct {
        base: Base,
        getParameterCount: ?*const fn (this: ?*anyopaque) callconv(cc) i32,
        getParameterData: ?*const fn (this: ?*anyopaque, index: i32) callconv(cc) ?*ParamValueQueue,
        addParameterData: ?*const fn (this: ?*anyopaque, id: ?*const u32, index: ?*i32) callconv(cc) ?*ParamValueQueue,

        pub const UID = uidCreate(0xA4779663, 0x0BB64A56, 0xB44384A8, 0x466FEB9D);
    };
};
