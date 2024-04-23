const std = @import("std");

pub const Version = struct {
    major: u32,
    minor: u32,
    revision: u32,
};

pub const CLAP_VERSION_MAJOR = 1;
pub const CLAP_VERSION_MINOR = 2;
pub const CLAP_VERSION_REVISION = 0;

pub fn clap_version_is_compatible(v: Version) bool {
    return v.major >= 1;
}

pub const Id = u32;

pub const PluginEntry = struct {
    clap_version: Version,
    init: ?*const fn (plugin_path: [*]const u8) bool,
    deinit: ?*const fn () void,
    get_factory: ?*const fn (factory_id: [*]const u8) ?*anyopaque,
};

pub const PLUGIN_FACTORY_ID = "clap.plugin-factory";

pub const PluginFactory = struct {
    get_plugin_count: ?*const fn (factory: ?*const PluginFactory) u32,
    get_plugin_descriptor: ?*const fn (factory: ?*const PluginFactory, index: u32) ?*const PluginDescriptor,
    create_plugin: ?*const fn (
        factory: ?*const PluginFactory,
        host: ?*const Host,
        plugin_id: [*]const u8,
    ) ?*const Plugin,
};

pub const PluginDescriptor = struct {
    clap_version: Version,
    id: [*]const u8,
    name: [*]const u8,
    vendor: [*]const u8,
    url: [*]const u8,
    manual_url: [*]const u8,
    support_url: [*]const u8,
    version: [*]const u8,
    description: [*]const u8,

    features: [*][*]const u8,
};

pub const Plugin = struct {
    desc: PluginDescriptor,
    plugin_data: ?*anyopaque,
    init: ?*const fn (plugin: ?*const Plugin) bool,
    destroy: ?*const fn (plugin: ?*const Plugin) void,
    activate: ?*const fn (
        plugin: ?*Plugin,
        sample_rate: f64,
        min_frames: u32,
        max_frames: u32,
    ) bool,
    deactivate: ?*const fn (plugin: ?*const Plugin) void,
    start_processing: ?*const fn (plugin: ?*const Plugin) bool,
    stop_processing: ?*const fn (plugin: ?*const Plugin) void,
    reset: ?*const fn (plugin: ?*const Plugin) void,
    process: ?*const fn (plugin: ?*const Plugin, process: Process) ProcessStatus,
    get_extension: ?*const fn (plugin: ?*const Plugin, id: [*]const u8) ?*anyopaque,
    on_main_thread: ?*const fn (plugin: ?*const Plugin) void,
};

pub const Process = struct {
    steady_time: i64,
    frames_count: u32,
    transport: ?*EventTransport,
    audio_inputs: ?*const AudioBuffer,
    audio_outputs: ?*AudioBuffer,
    audio_inputs_count: u32,
    audio_outputs_count: u32,
    in_events: ?*InputEvents,
    out_events: ?*OutputEvents,
};

pub const ProcessStatus = enum(i32) {
    // Processing failed. The output buffer must be discarded.
    CLAP_PROCESS_ERROR = 0,

    // Processing succeeded, keep processing.
    CLAP_PROCESS_CONTINUE = 1,

    // Processing succeeded, keep processing if the output is not quiet.
    CLAP_PROCESS_CONTINUE_IF_NOT_QUIET = 2,

    // Rely upon the plugin's tail to determine if the plugin should continue to process.
    // see clap_plugin_tail
    CLAP_PROCESS_TAIL = 3,

    // Processing succeeded, but no more processing is required,
    // until the next event or variation in audio input.
    CLAP_PROCESS_SLEEP = 4,
};

pub const EventHeader = struct {
    size: u32,
    time: u32,
    space_id: u16,
    type: u16,
    flags: u32,
};

pub const CLAP_CORE_EVENT_SPACE_ID = 0;

pub const ClapEventFlags = enum(u32) {
    CLAP_EVENT_IS_LIVE = 1 << 0,
    CLAP_EVENT_DONT_RECORD = 1 << 1,
    CLAP_EVENT_NOTE_ON = 0,
    CLAP_EVENT_NOTE_OFF = 1,
    CLAP_EVENT_NOTE_CHOKE = 2,
    CLAP_EVENT_NOTE_END = 3,
    CLAP_EVENT_NOTE_EXPRESSION = 4,
    CLAP_EVENT_PARAM_VALUE = 5,
    CLAP_EVENT_PARAM_MOD = 6,
    CLAP_EVENT_PARAM_GESTURE_BEGIN = 7,
    CLAP_EVENT_PARAM_GESTURE_END = 8,
    CLAP_EVENT_TRANSPORT = 9, // update the transport info; clap_event_transport
    CLAP_EVENT_MIDI = 10, // raw midi event; clap_event_midi
    CLAP_EVENT_MIDI_SYSEX = 11, // raw midi sysex event; clap_event_midi_sysex
    CLAP_EVENT_MIDI2 = 12, // raw midi 2 event; clap_event_midi2
};

pub const NoteEvent = struct {
    header: EventHeader,
    note_id: i32,
    port_index: i16,
    channel: i16,
    key: i16,
    velocity: f64,
};

pub const NoteExpression = enum(i32) {
    // with 0 < x <= 4, plain = 20 * log(x)
    CLAP_NOTE_EXPRESSION_VOLUME = 0,

    // pan, 0 left, 0.5 center, 1 right
    CLAP_NOTE_EXPRESSION_PAN = 1,

    // Relative tuning in semitones, from -120 to +120. Semitones are in
    // equal temperament and are doubles; the resulting note would be
    // retuned by `100 * evt->value` cents.
    CLAP_NOTE_EXPRESSION_TUNING = 2,

    // 0..1
    CLAP_NOTE_EXPRESSION_VIBRATO = 3,
    CLAP_NOTE_EXPRESSION_EXPRESSION = 4,
    CLAP_NOTE_EXPRESSION_BRIGHTNESS = 5,
    CLAP_NOTE_EXPRESSION_PRESSURE = 6,
};

pub const EventNoteExpression = struct {
    header: EventHeader,
    expression_id: NoteExpression,
    note_id: i32,
    port_index: i16,
    channel: i16,
    key: i16,
    value: f64,
};

pub const EventParamValue = struct {
    header: EventHeader,
    param_id: Id,
    cookie: ?*anyopaque,
    note_id: i32,
    port_index: i16,
    channel: i16,
    key: i16,
    value: f64,
};

pub const EventParamMod = struct {
    header: EventHeader,
    param_id: Id,
    cookie: ?*anyopaque,
    note_id: i32,
    port_index: i16,
    channel: i16,
    key: i16,
    amount: f64,
};

pub const EventParamGesture = struct {
    header: EventHeader,
    param_id: Id,
};

pub const TransportFlags = enum(u32) {
    CLAP_TRANSPORT_HAS_TEMPO = 1 << 0,
    CLAP_TRANSPORT_HAS_BEATS_TIMELINE = 1 << 1,
    CLAP_TRANSPORT_HAS_SECONDS_TIMELINE = 1 << 2,
    CLAP_TRANSPORT_HAS_TIME_SIGNATURE = 1 << 3,
    CLAP_TRANSPORT_IS_PLAYING = 1 << 4,
    CLAP_TRANSPORT_IS_RECORDING = 1 << 5,
    CLAP_TRANSPORT_IS_LOOP_ACTIVE = 1 << 6,
    CLAP_TRANSPORT_IS_WITHIN_PRE_ROLL = 1 << 7,
};

pub const BEATTIME_FACTOR: i64 = 1 << 31;
pub const SECTIME_FACTOR: i64 = 1 << 31;
pub const beattime = i64;
pub const sectime = i64;

pub const EventTransport = struct {
    header: EventHeader,
    flags: u32,

    song_pos_beats: beattime,
    song_pos_seconds: sectime,

    tempo: f64,
    tempo_inc: f64,

    loop_start_beats: beattime,
    loop_end_beats: beattime,
    loop_start_seconds: sectime,
    loop_end_seconds: sectime,

    bar_start: beattime,
    bar_number: i32,

    tsig_num: u16,
    tsig_denom: u16,
};

pub const EventMidi = struct {
    header: EventHeader,
    port_index: u16,
    data: [3]u8,
};

pub const EventMidiSysex = struct {
    header: EventHeader,
    port_index: u16,
    buffer: [*]u8,
    size: u32,
};

pub const EventMidi2 = struct {
    header: EventHeader,
    port_index: u16,
    data: [4]u32,
};

pub const InputEvents = struct {
    ctx: ?*anyopaque,
    size: ?*const fn (list: ?*const InputEvents) u32,
    get: ?*const fn (list: ?*const InputEvents, index: u32) EventHeader,
};

pub const OutputEvents = struct {
    ctx: ?*anyopaque,
    try_push: ?*const fn (list: ?*OutputEvents, event: ?*EventHeader) bool,
};

pub const Host = struct {
    clap_version: Version,
    host_data: ?*anyopaque,
    name: [*]const u8,
    vendor: [*]const u8,
    url: [*]const u8,
    version: [*]const u8,

    get_extension: ?*const fn (
        host: ?*const Host,
        extension_id: [*]const u8,
    ) ?*const anyopaque,
    request_restart: ?*const fn (host: ?*const Host) void,
    request_process: ?*const fn (host: ?*const Host) void,
    request_callback: ?*const fn (host: ?*const Host) void,
};

pub const AudioBuffer = struct {
    data32: [*][*]f32,
    data64: [*][*]f64,
    channel_count: u32,
    latency: u32,
    constant_mask: u64,
};
