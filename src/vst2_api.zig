//! vst2_api.zig

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

pub const AEffect = extern struct {
    magic: i32 = ('V' << 24) | ('s' << 16) | ('t' << 8) | 'P',

    dispatcher: Dispatch,

    processReplacing: Process,
    processDoubleReplacing: ProcessDouble,

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

    object: ?*anyopaque = null,
    user: ?*anyopaque = null,

    uniqueID: i32,
    version: i32,

    future: [56]u8 = [_]u8{0} ** 56,
};

pub const Opcode = enum(i32) {
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

    NumOpcode,
};

pub const Flags = enum(i32) {
    HasEditor = 1 << 0,
    CanReplacing = 1 << 4,
    ProgramChunks = 1 << 5,
    IsSynth = 1 << 8,
    NoSoundInStop = 1 << 9,
    CanDoubleReplacing = 1 << 12,
};

pub const Category = enum(i32) {
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
