//! vst2_api.zig

pub const AEffect = extern struct {
    magic: i32 = ('V' << 24) | ('s' << 16) | ('t' << 8) | 'P',

    dispatcher: Dispatch,

    deprecated_process: Process = deprecatedProcess,

    setParameter: SetParameter,
    getParameter: GetParameter,

    num_programs: i32,
    num_params: i32,
    num_inputs: i32,
    num_outputs: i32,

    flags: i32,

    resvd1: isize = 0,
    resvd2: isize = 0,

    initial_delay: i32,

    _real_qualities: i32 = 0,
    _off_qualities: i32 = 0,
    _io_ratio: i32 = 0,

    object: ?*anyopaque = null,
    user: ?*anyopaque = null,

    uniqueID: i32,
    version: i32,

    processReplacing: Process,
    processDoubleReplacing: ProcessDouble,

    future: [56]u8 = [_]u8{0} ** 56,

    fn deprecatedProcess(effect: *AEffect, inputs: [*][*]f32, outputs: [*][*]f32, frames: i32) callconv(.C) void {
        _ = frames;
        _ = outputs;
        _ = inputs;
        _ = effect;
    }
};

pub const StringConstants = struct {
    pub const MaxNameLen = 64;
    pub const MaxLabelLen = 64;
    pub const MaxShortLabelLen = 8;
    pub const MaxCategLabelLen = 24;
    pub const MaxFileNameLen = 100;
};

pub const VstEvents = struct {
    const Event = struct {
        type: i32,
        byte_size: i32,
        delta_frames: i32,
        flags: i32,

        data: [16]u8,
    };

    const Type = enum(i32) {
        MidiType = 1,
        SysExType = 6,
    };

    num_events: i32,
    reserved: isize,
    events: [2]*Event,
};

pub const HostCallback = *const fn (
    effect: *AEffect,
    opcode: i32,
    index: i32,
    value: isize,
    ptr: ?*anyopaque,
    opt: f32,
) callconv(.C) isize;

pub const Dispatch = *const fn (
    effect: *AEffect,
    opcode: i32,
    index: i32,
    value: isize,
    ptr: ?*anyopaque,
    opt: f32,
) callconv(.C) isize;

pub const Process = *const fn (
    effect: *AEffect,
    inputs: [*][*]f32,
    outputs: [*][*]f32,
    frames: i32,
) callconv(.C) void;
pub const ProcessDouble = *const fn (
    effect: *AEffect,
    inputs: [*][*]f64,
    outputs: [*][*]f64,
    frames: i32,
) callconv(.C) void;

pub const SetParameter = *const fn (
    effect: *AEffect,
    index: i32,
    parameter: f32,
) callconv(.C) void;
pub const GetParameter = *const fn (
    effect: *AEffect,
    index: i32,
) callconv(.C) f32;

pub const Opcode = enum(c_int) {
    Open = 0,
    Close,
    SetProgram,
    GetProgram,
    SetProgramName,
    GetProgramName,

    GetParamLabel,
    GetParamDisplay,
    GetParamName,

    SetSampleRate,
    SetBlockSize,
    MainsChanged,

    EditGetRect,
    EditOpen,
    EditClose,

    EditIdle,

    GetChunk,
    SetChunk,

    ProcessEvents, // MIDI events

    CanBeAutomated,
    String2Parameter,

    GetInputProperties = 33,
    GetOutputProperties,
    GetPlugCategory,
    SetBypass = 44,
    GetEffectName,
    GetVendorString = 47,
    GetProductString,
    GetVendorVersion,
    CanDo = 50,
    GetTailSize,
    GetParameterProperties = 56,
    GetVstVersion = 58,
    EditKeyDown,
    EditKeyUp,
    SetProcessPrecision = 77,
};

pub const ProcessPrecision = enum(c_int) {
    ProcessPrecision32 = 0,
    ProcessPrecision64,
};

pub const ParameterProperties = struct {
    stepFloat: f32,
    smallStepFloat: f32,
    largeStepFloat: f32,
    label: [StringConstants.MaxLabelLen]u8,
    flags: i32,
    minInteger: i32,
    maxInteger: i32,
    stepInteger: i32,
    largeStepInteger: i32,
    shortLabel: [StringConstants.MaxShortLabelLen]u8,

    displayIndex: i16,

    category: i16,
    numParametersInCategory: i16,
    reserved: i16,
    categoryLabel: [StringConstants.MaxCategLabelLen]u8,

    future: [16]u8,
};

pub const ParameterFlags = enum(c_int) {
    IsSwitch = 1 << 0,
    UsesIntegerMax = 1 << 1,
    UseFloatStep = 1 << 2,
    UsesIntStep = 1 << 3,
    SupportsDisplayIndex = 1 << 4,
    SupportsDisplayCategory = 1 << 5,
    CanRamp = 1 << 6,
};

pub const PinProperties = struct {
    label: [StringConstants.MaxLabelLen]u8,
    flags: i32,
    arrangement_type: i32,
    shortLabel: [StringConstants.MaxShortLabelLen]u8,
    future: [48]u8,
};

pub const PinPropertiesFlags = enum(c_int) {
    IsActive = 1 << 0,
    IsStereo = 1 << 1,
    UseSpeaker = 1 << 2,
};

pub const Flags = enum(c_int) {
    HasEditor = 1 << 0,
    CanReplacing = 1 << 4,
    ProgramChunks = 1 << 5,
    IsSynth = 1 << 8,
    NoSoundInStop = 1 << 9,
    CanDoubleReplacing = 1 << 12,

    pub fn toInt(flags: []const Flags) i32 {
        var i: i32 = 0;
        for (flags) |f| {
            i |= @intFromEnum(f);
        }
        return i;
    }
};

pub const Category = enum(c_int) {
    kPlugCategUnknown = 0,
    kPlugCategEffect,
    kPlugCategSynth,
    kPlugCategAnalysis,
    kPlugCategMastering,
    kPlugCategSpacializer,
    kPlugCategRoomFx,
    kPlugSurroundFx,
    kPlugCategRestoration,
    kPlugCategOfflineProcess,
    kPlugCategShell,
    kPlugCategGenerator,
    kPlugCategMaxCount,
};

pub const Rect = struct {
    top: i16,
    left: i16,
    bottom: i16,
    right: i16,
};
