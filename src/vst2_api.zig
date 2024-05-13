//! vst2_api.zig

pub const MagicNumber: i32 = ('V' << 24) | ('s' << 16) | ('t' << 8) | 'P';

pub const AEffect = extern struct {
    magic: i32 = MagicNumber,

    dispatcher: Dispatch,

    deprecated_process: Process = null,

    setParameter: SetParameter,
    getParameter: GetParameter,

    num_programs: i32,
    num_params: i32,
    num_inputs: i32,
    num_outputs: i32,

    flags: PluginFlags,

    resvd1: isize = 0,
    resvd2: isize = 0,

    latency: i32,

    deprecated1: i32 = 0,
    deprecated2: i32 = 0,
    deprecated3: f32 = 0,

    object: ?*anyopaque = null,
    user: ?*anyopaque = null,

    uniqueID: i32,
    version: i32,

    processReplacing: Process,
    processDoubleReplacing: ProcessDouble,

    future: [56]i8 = [_]i8{0} ** 56,
};

pub const PluginFlags = packed struct(i32) {
    HasEditor: bool = false,
    pad1: u3 = 0,
    HasReplacing: bool = false,
    HasStateChunk: bool = false,
    pad2: u2 = 0,
    IsSynth: bool = false,
    NoSoundInStop: bool = false,
    pad3: u2 = 0,
    HasDoubleReplacing: bool = false,
    pad4: u19 = 0,
};

pub const StringConstants = struct {
    pub const MaxProgNameLen = 24;
    /// Param name & display len
    pub const MaxParamStrLen = 8;
    pub const MaxVendorStrLen = 64;
    pub const MaxProductStrLen = 64;
    pub const MaxEffectNameLen = 32;
    /// Used for Midi key names & PinProperties names
    pub const MaxNameLen = 64;
    /// ParameterProperties label
    pub const MaxLabelLen = 64;
    /// PinProperties & ParameterProperties short_label
    pub const MaxShortLabelLen = 8;
    /// ParameterProperties category
    pub const MaxCategLabelLen = 24;
    pub const MaxFileNameLen = 100;
};

const Event = extern struct {
    /// should always be 1 for MIDI
    type: i32,
    byte_size: i32,
    /// delta from current event block start
    delta_frames: i32,
    /// unused garbage
    flags: i32,

    data: [16]u8,
    const Type = enum(i32) {
        MidiType = 1,
        SysExType = 6,
    };
};

pub const EventsBlock = extern struct {
    num_events: i32,
    reserved: isize = 0,
    events: [2]*Event,
};

pub const MidiEvent = extern struct {
    type: i32,
    byte_size: i32,
    /// delta from event block start
    delta_frames: i32,
    flags: packed struct(i32) {
        is_realtime: bool = false,
        _: u31,
    },
    /// current note length in frames
    note_length: i32,
    /// delta from note start
    note_offset: i32,
    midi_data: [4]i8,
    /// -64 to 63 cents
    detune: i8,
    note_off_vel: i8,
    _: u16 = 0,
};

/// I think what this is for is so we can manually call the host
/// Gets passed in thru VSTPluginMain, hang onto it if you need it
pub const HostCallback = ?*const fn (
    effect: ?*AEffect,
    opcode: i32,
    index: i32,
    value: isize,
    ptr: ?*anyopaque,
    opt: f32,
) callconv(.C) isize;

/// Host->plugin communication. How the API wants to handle most things outside of major function ptrs
pub const Dispatch = ?*const fn (
    effect: ?*AEffect,
    opcode: i32,
    index: i32,
    value: isize,
    ptr: ?*anyopaque,
    opt: f32,
) callconv(.C) isize;

pub const Process = ?*const fn (
    effect: ?*AEffect,
    inputs: [*][*]f32,
    outputs: [*][*]f32,
    frames: i32,
) callconv(.C) void;
pub const ProcessDouble = ?*const fn (
    effect: ?*AEffect,
    inputs: [*][*]f64,
    outputs: [*][*]f64,
    frames: i32,
) callconv(.C) void;

pub const SetParameter = ?*const fn (
    effect: ?*AEffect,
    index: i32,
    parameter: f32,
) callconv(.C) void;
pub const GetParameter = ?*const fn (
    effect: ?*AEffect,
    index: i32,
) callconv(.C) f32;

/// Host-to-plugin instructions
pub const Opcode = enum(i32) {
    Open = 0,
    Close,
    SetProgram,
    GetProgram,
    SetProgramName,
    GetProgramName,

    /// This is a sort of post-value string you might want, like "dB" or "Hz".
    /// You can also just leave this blank and handle postfix labelling in a
    /// custom value-to-text function called in `ParamValueToText`
    GetParamLabel,
    ParamValueToText,
    GetParamName,

    SetSampleRate = 10,
    SetBlockSize,

    EditGetRect = 13,
    EditOpen,
    EditClose,
    EditRedraw = 19,

    GetChunk = 23,
    SetChunk,

    /// `ptr`: *VstEvents
    ProcessEvents,

    /// `index`: param index -- return true or false
    CanBeAutomated = 26,
    ParamTextToValue = 27,

    /// `index`: id `ptr`: *PinProperties -- return 1 if supported
    GetInputProperties = 33,
    /// `index`: id `ptr`: *PinProperties -- return 1 if supported
    GetOutputProperties = 34,

    GetPlugCategory = 35,
    GetVendorString = 47,
    GetProductString,
    GetVendorVersion,
    CanDo = 51,
    GetTailSize = 52,
    /// `index`: param id `ptr`: *ParamProperties -- return 1 if supported
    GetParameterProperties = 56,
    GetVstVersion = 58,
    /// `value`: process precision (enum)
    SetProcessPrecision = 77,
};

pub const HostOpcodes = enum(i32) {
    /// `index`: parameter index `opt`: parameter value
    AutomateParam = 0,
    /// Get Host VST version
    HostVersion,
    /// Get unique ID of plugin
    CurrentId,
    /// why
    Idle,
    /// Send `*VstEvents` to host via `ptr`
    ProcessEvents = 8,
    /// Tell Host new window size: `index`: width `value`: height -- Returns 1 if supported
    SizeWindow = 15,
    /// Tell host which param `index` is about to change
    BeginParamChange = 43,
    EndParamChange = 44,
};

pub const ProcessPrecision = enum(i32) {
    ProcessPrecision32 = 0,
    ProcessPrecision64,
};

pub const ParameterProperties = extern struct {
    pub const Flags = packed struct(i32) {
        IsSwitch: bool = false,
        UsesIntegerMax: bool = false,
        UseFloatStep: bool = false,
        UsesIntStep: bool = false,
        SupportsDisplayIndex: bool = false,
        SupportsDisplayCategory: bool = false,
        CanRamp: bool = false,
        _: u25,
    };
    stepFloat: f32,
    smallStepFloat: f32,
    largeStepFloat: f32,
    label: [StringConstants.MaxLabelLen]u8,
    flags: Flags,
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

    future: [16]u8 = [_]u8{0} ** 16,
};

pub const PinProperties = extern struct {
    pub const Flags = packed struct(i32) {
        /// pin active
        IsActive: bool = false,
        /// pin is a stereo pair
        IsStereo: bool = false,
        /// use `arrangement_type` (unsupported)
        UseSpeaker: bool = false,

        _: u29 = 0,
    };
    label: [StringConstants.MaxLabelLen]u8,
    flags: Flags,
    arrangement_type: i32 = -1,
    shortLabel: [StringConstants.MaxShortLabelLen]u8,
    future: [48]u8 = [_]u8{0} ** 48,
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

pub const Rect = extern struct {
    top: i16,
    left: i16,
    bottom: i16,
    right: i16,
};
