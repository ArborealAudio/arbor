//! Clap Zig API bindings

const std = @import("std");
const arbor = @import("arbor.zig");

pub const Version = extern struct {
    major: u32,
    minor: u32,
    revision: u32,

    pub fn init() Version {
        return .{
            .major = CLAP_VERSION.major,
            .minor = CLAP_VERSION.minor,
            .revision = CLAP_VERSION.revision,
        };
    }

    pub fn fromString(str: []const u8) !Version {
        var iter = std.mem.splitSequence(u8, str, ".");
        var version: Version = undefined;
        comptime var i: u32 = 0;
        inline while (iter.next()) |num| : (i += 1) {
            switch (i) {
                0 => version.major = try std.fmt.parseInt(u8, num, 10),
                1 => version.minor = try std.fmt.parseInt(u8, num, 10),
                2 => version.revision = try std.fmt.parseInt(u8, num, 10),
                else => {},
            }
        }
        return version;
    }

    /// checks whether your version is less than SDK version
    pub fn lt(v: Version) bool {
        return (v.major < CLAP_VERSION.major or
            (v.major == CLAP_VERSION.major and v.minor > CLAP_VERSION.minor) or
            (v.major == CLAP_VERSION.major and v.minor == CLAP_VERSION.minor and v.revision > CLAP_VERSION.revision));
    }

    pub fn eq(v: Version) bool {
        return (v.major == CLAP_VERSION.major and
            v.minor == CLAP_VERSION.minor and v.revision == CLAP_VERSION.revision);
    }

    pub fn ge(v: Version) bool {
        return !lt(v);
    }
};

pub fn clap_version_is_compatible(v: Version) bool {
    return v.major >= 1;
}

pub const CLAP_VERSION: Version = .{ .major = 1, .minor = 1, .revision = 10 };

pub const NAME_SIZE = 256;
pub const PATH_SIZE = 1024;

pub const INVALID_ID = std.math.maxInt(u32);

pub const Id = u32;

pub const PluginEntry = extern struct {
    clap_version: Version,
    init: *const fn (plugin_path: [*:0]const u8) callconv(.C) bool,
    deinit: *const fn () callconv(.C) void,
    get_factory: *const fn (factory_id: [*:0]const u8) callconv(.C) ?*const anyopaque,
};

pub const PLUGIN_FACTORY_ID = "clap.plugin-factory";

pub const PluginFactory = extern struct {
    get_plugin_count: *const fn (factory: ?*const PluginFactory) callconv(.C) u32,
    get_plugin_descriptor: *const fn (factory: ?*const PluginFactory, index: u32) callconv(.C) ?*const PluginDescriptor,
    create_plugin: *const fn (
        factory: ?*const PluginFactory,
        host: ?*const Host,
        plugin_id: [*:0]const u8,
    ) callconv(.C) ?*const Plugin,
};

pub const PluginDescriptor = extern struct {
    clap_version: Version,
    id: [*:0]const u8,
    name: [*:0]const u8,
    vendor: [*:0]const u8,
    url: [*:0]const u8,
    manual_url: [*:0]const u8,
    support_url: [*:0]const u8,
    version: [*:0]const u8,
    description: [*:0]const u8,

    features: ?[*][*:0]const u8,
};

pub const Plugin = extern struct {
    desc: ?*const PluginDescriptor,
    plugin_data: ?*anyopaque,
    init: *const fn (plugin: ?*const Plugin) callconv(.C) bool,
    destroy: *const fn (plugin: ?*const Plugin) callconv(.C) void,
    activate: *const fn (
        plugin: ?*Plugin,
        sample_rate: f64,
        min_frames: u32,
        max_frames: u32,
    ) callconv(.C) bool,
    deactivate: *const fn (plugin: ?*const Plugin) callconv(.C) void,
    start_processing: *const fn (plugin: ?*const Plugin) callconv(.C) bool,
    stop_processing: *const fn (plugin: ?*const Plugin) callconv(.C) void,
    reset: *const fn (plugin: ?*const Plugin) callconv(.C) void,
    process: *const fn (plugin: ?*const Plugin, process: ?*const Process) callconv(.C) ProcessStatus,
    get_extension: *const fn (plugin: ?*const Plugin, id: [*:0]const u8) callconv(.C) ?*const anyopaque,
    on_main_thread: *const fn (plugin: ?*const Plugin) callconv(.C) void,
};

pub const AudioBuffer = extern struct {
    data32: [*][*]f32,
    data64: [*][*]f64,
    channel_count: u32,
    latency: u32,
    constant_mask: u64,
};

pub const Process = extern struct {
    steady_time: i64,
    frames_count: u32,
    transport: ?*const EventTransport,
    audio_inputs: ?*const AudioBuffer,
    audio_outputs: ?*AudioBuffer,
    audio_inputs_count: u32,
    audio_outputs_count: u32,
    in_events: ?*const InputEvents,
    out_events: ?*const OutputEvents,
};

pub const ProcessStatus = enum(i32) {
    // Processing failed. The output buffer must be discarded.
    PROCESS_ERROR = 0,

    // Processing succeeded, keep processing.
    PROCESS_CONTINUE = 1,

    // Processing succeeded, keep processing if the output is not quiet.
    PROCESS_CONTINUE_IF_NOT_QUIET = 2,

    // Rely upon the plugin's tail to determine if the plugin should continue to process.
    // see clap_plugin_tail
    PROCESS_TAIL = 3,

    // Processing succeeded, but no more processing is required,
    // until the next event or variation in audio input.
    PROCESS_SLEEP = 4,
};

pub const EventHeader = extern struct {
    size: u32,
    time: u32,
    space_id: u16,
    type: Type,
    flags: Flags,

    pub const Flags = packed struct(u32) {
        /// Indicate a live user event, for example a user turning a physical knob
        /// or playing a physical key.
        IS_LIVE: bool = false,
        /// Indicate that the event should not be recorded.
        /// For example this is useful when a parameter changes because of a MIDI CC,
        /// because if the host records both the MIDI CC automation and the parameter
        /// automation there will be a conflict.
        DONT_RECORD: bool = false,
        _: u30 = 0,
    };

    pub const Type = enum(u16) {
        NOTE_ON = 0,
        NOTE_OFF = 1,
        NOTE_CHOKE = 2,
        NOTE_END = 3,
        NOTE_EXPRESSION = 4,
        PARAM_VALUE = 5,
        PARAM_MOD = 6,
        PARAM_GESTURE_BEGIN = 7,
        PARAM_GESTURE_END = 8,
        /// update the transport info; clap_event_transport
        TRANSPORT = 9,
        /// raw midi event; clap_event_midi
        MIDI = 10,
        /// raw midi sysex event; clap_event_midi_sysex
        MIDI_SYSEX = 11,
        /// raw midi 2 event; clap_event_midi2
        MIDI2 = 12,
    };
};

pub const CLAP_CORE_EVENT_SPACE_ID: u16 = 0;

pub const NoteEvent = extern struct {
    header: EventHeader,
    note_id: i32,
    port_index: i16,
    channel: i16,
    key: i16,
    velocity: f64,
};

pub const NoteExpression = enum(i32) {
    // with 0 < x <= 4, plain = 20 * log(x)
    VOLUME = 0,

    // pan, 0 left, 0.5 center, 1 right
    PAN = 1,

    // Relative tuning in semitones, from -120 to +120. Semitones are in
    // equal temperament and are doubles; the resulting note would be
    // retuned by `100 * evt->value` cents.
    TUNING = 2,

    // 0..1
    VIBRATO = 3,
    EXPRESSION = 4,
    BRIGHTNESS = 5,
    PRESSURE = 6,
};

pub const EventNoteExpression = extern struct {
    header: EventHeader,
    expression_id: NoteExpression,
    note_id: i32,
    port_index: i16,
    channel: i16,
    key: i16,
    value: f64,
};

pub const EventParamValue = extern struct {
    header: EventHeader,
    param_id: Id,
    cookie: ?*anyopaque,
    note_id: i32,
    port_index: i16,
    channel: i16,
    key: i16,
    value: f64,
};

pub const EventParamMod = extern struct {
    header: EventHeader,
    param_id: Id,
    cookie: ?*anyopaque,
    note_id: i32,
    port_index: i16,
    channel: i16,
    key: i16,
    amount: f64,
};

pub const EventParamGesture = extern struct {
    header: EventHeader,
    param_id: Id,
};

pub const BEATTIME_FACTOR: i64 = 1 << 31;
pub const SECTIME_FACTOR: i64 = 1 << 31;
pub const beattime = i64;
pub const sectime = i64;

pub const EventTransport = extern struct {
    pub const Flags = packed struct(u32) {
        has_tempo: bool = false,
        has_beats_timeline: bool = false,
        has_seconds_timeline: bool = false,
        has_time_signature: bool = false,
        is_playing: bool = false,
        is_recording: bool = false,
        is_loop_active: bool = false,
        is_within_pre_roll: bool = false,
        _: u24 = 0,
    };

    header: EventHeader,
    flags: Flags,

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

pub const EventMidi = extern struct {
    header: EventHeader,
    port_index: u16,
    data: [3]u8,
};

pub const EventMidiSysex = extern struct {
    header: EventHeader,
    port_index: u16,
    buffer: [*]u8,
    size: u32,
};

pub const EventMidi2 = extern struct {
    header: EventHeader,
    port_index: u16,
    data: [4]u32,
};

pub const InputEvents = extern struct {
    ctx: ?*anyopaque,
    size: *const fn (list: ?*const InputEvents) callconv(.C) u32,
    get: *const fn (list: ?*const InputEvents, index: u32) callconv(.C) ?*const EventHeader,
};

pub const OutputEvents = extern struct {
    ctx: ?*anyopaque,
    try_push: *const fn (list: ?*OutputEvents, event: ?*EventHeader) callconv(.C) bool,
};

pub const Host = extern struct {
    clap_version: Version,
    host_data: ?*anyopaque,
    name: [*:0]const u8,
    vendor: [*:0]const u8,
    url: [*:0]const u8,
    version: [*:0]const u8,

    get_extension: *const fn (
        host: ?*const Host,
        extension_id: [*:0]const u8,
    ) callconv(.C) ?*const anyopaque,
    request_restart: *const fn (host: ?*const Host) callconv(.C) void,
    request_process: *const fn (host: ?*const Host) callconv(.C) void,
    request_callback: *const fn (host: ?*const Host) callconv(.C) void,
};

pub const PluginFeatures = struct {
    /// Add this feature if your plugin can process note events and then produce audio
    pub const INSTRUMENT = "instrument";
    /// Add this feature if your plugin is an audio effect
    pub const AUDIO_EFFECT = "audio-effect";

    /// Add this feature if your plugin is a note effect or a note generator/sequencer
    pub const NOTE_EFFECT = "note-effect";

    /// Add this feature if your plugin converts audio to notes
    pub const NOTE_DETECTOR = "note-detector";

    /// Add this feature if your plugin is an analyzer
    pub const ANALYZER = "analyzer";

    /////////////////////////
    // Plugin sub-category //
    /////////////////////////

    pub const SYNTHESIZER = "synthesizer";
    pub const SAMPLER = "sampler";
    pub const DRUM = "drum"; // For single drum
    pub const DRUM_MACHINE = "drum-machine";

    pub const FILTER = "filter";
    pub const PHASER = "phaser";
    pub const EQUALIZER = "equalizer";
    pub const DEESSER = "de-esser";
    pub const PHASE_VOCODER = "phase-vocoder";
    pub const GRANULAR = "granular";
    pub const FREQUENCY_SHIFTER = "frequency-shifter";
    pub const PITCH_SHIFTER = "pitch-shifter";

    pub const DISTORTION = "distortion";
    pub const TRANSIENT_SHAPER = "transient-shaper";
    pub const COMPRESSOR = "compressor";
    pub const EXPANDER = "expander";
    pub const GATE = "gate";
    pub const LIMITER = "limiter";

    pub const FLANGER = "flanger";
    pub const CHORUS = "chorus";
    pub const DELAY = "delay";
    pub const REVERB = "reverb";

    pub const TREMOLO = "tremolo";
    pub const GLITCH = "glitch";

    pub const UTILITY = "utility";
    pub const PITCH_CORRECTION = "pitch-correction";
    pub const RESTORATION = "restoration"; // repair the sound

    pub const MULTI_EFFECTS = "multi-effects";

    pub const MIXING = "mixing";
    pub const MASTERING = "mastering";

    ////////////////////////
    // Audio Capabilities //
    ////////////////////////

    pub const MONO = "mono";
    pub const STEREO = "stereo";
    pub const SURROUND = "surround";
    pub const AMBISONIC = "ambisonic";
};

pub const EXT_AUDIO_PORTS = "clap.audio-ports";
pub const AudioPorts = extern struct {
    pub const MONO = "mono";
    pub const STEREO = "stereo";

    pub const Flags = packed struct(u32) {
        // This port is the main audio input or output.
        // There can be only one main input and main output.
        // Main port must be at index 0.
        IS_MAIN: bool = false,
        // This port can be used with 64 bits audio
        SUPPORTS_64_BITS: bool = false,
        // 64 bits audio is preferred with this port
        PREFERS_64_BITS: bool = false,
        // This port must be used with the same sample size as all the other ports which have this flag.
        // In other words if all ports have this flag then the plugin may either be used entirely with
        // 64 bits audio or 32 bits audio, but it can't be mixed.
        REQUIRES_COMMON_SAMPLE_SIZE: bool = false,

        _: u28 = 0,
    };

    pub const Info = extern struct {
        id: Id,
        name: [NAME_SIZE]u8,
        flags: Flags,
        channel_count: u32,
        port_type: [*:0]const u8,
        in_place_pair: Id,
    };

    count: *const fn (plugin: ?*const Plugin, is_input: bool) callconv(.C) u32,
    get: *const fn (plugin: ?*const Plugin, index: u32, is_input: bool, info: ?*Info) callconv(.C) bool,
};

pub const HostAudioPorts = extern struct {
    pub const Flags = packed struct(u32) {
        /// The ports name did change, the host can scan them right away.
        RESCAN_NAMES: bool = false,

        /// [!active] The flags did change
        RESCAN_FLAGS: bool = false,

        /// [!active] The channel_count did change
        RESCAN_CHANNEL_COUNT: bool = false,

        /// [!active] The port type did change
        RESCAN_PORT_TYPE: bool = false,

        /// [!active] The in-place pair did change, this requires.
        RESCAN_IN_PLACE_PAIR: bool = false,

        /// [!active] The list of ports have changed: entries have been removed/added.
        RESCAN_LIST: bool = false,

        _: u26 = 0,
    };

    is_rescan_flag_supported: *const fn (host: ?*const Host, flag: Flags) callconv(.C) bool,
    rescan: *const fn (host: ?*const Host, flags: Flags) callconv(.C) void,
};

pub const EXT_LATENCY = "clap.latency";
pub const Latency = extern struct {
    get: *const fn (plugin: ?*const Plugin) callconv(.C) u32,
};

pub const HostLatency = extern struct {
    changed: *const fn (host: ?*const Host) callconv(.C) void,
};

pub const EXT_LOG = "clap.log";
pub const HostLog = extern struct {
    const Severity = enum(i32) {
        Debug = 0,
        Info,
        Warning,
        Error,
        Fatal,
        HostMisbehaving,
        PluginMisbehaving,
    };

    log: *const fn (host: ?*const Host, msg: [*:0]const u8) callconv(.C) void,
};

pub const EXT_NOTE_NAME = "clap.note-name";
pub const PluginNoteName = extern struct {
    count: *const fn (plugin: ?*const Plugin) callconv(.C) u32,
    get: *const fn (plugin: ?*const Plugin, index: u32, note_name: ?*NoteName) callconv(.C) bool,

    pub const NoteName = extern struct {
        name: [NAME_SIZE]u8,
        port: i16,
        key: i16,
        channel: i16,
    };
};
pub const HostNoteName = extern struct {
    changed: *const fn (host: ?*const Host) callconv(.C) void,
};

pub const EXT_NOTE_PORTS = "clap.note-ports";
// TODO: NOte ports

pub const EXT_PARAMS = "clap.params";
pub const params = struct {
    pub const Info = extern struct {
        pub const Flags = packed struct(u32) {
            // Is this param stepped? (integer values only)
            // if so the double value is converted to integer using a cast (equivalent to trunc).
            IS_STEPPED: bool = false,

            // Useful for periodic parameters like a phase
            IS_PERIODIC: bool = false,

            // The parameter should not be shown to the user, because it is currently not used.
            // It is not necessary to process automation for this parameter.
            IS_HIDDEN: bool = false,

            // The parameter can't be changed by the host.
            IS_READONLY: bool = false,

            // This parameter is used to merge the plugin and host bypass button.
            // It implies that the parameter is stepped.
            // min: 0 -> bypass off
            // max: 1 -> bypass on
            IS_BYPASS: bool = false,

            // When set:
            // - automation can be recorded
            // - automation can be played back
            //
            // The host can send live user changes for this parameter regardless of this flag.
            //
            // If this parameter affects the internal processing structure of the plugin, ie: max delay, fft
            // size, ... and the plugins needs to re-allocate its working buffers, then it should call
            // host->request_restart(), and perform the change once the plugin is re-activated.
            IS_AUTOMATABLE: bool = false,

            // Does this parameter support per note automations?
            IS_AUTOMATABLE_PER_NOTE_ID: bool = false,

            // Does this parameter support per key automations?
            IS_AUTOMATABLE_PER_KEY: bool = false,

            // Does this parameter support per channel automations?
            IS_AUTOMATABLE_PER_CHANNEL: bool = false,

            // Does this parameter support per port automations?
            IS_AUTOMATABLE_PER_PORT: bool = false,

            // Does this parameter support the modulation signal?
            IS_MODULATABLE: bool = false,

            // Does this parameter support per note modulations?
            IS_MODULATABLE_PER_NOTE_ID: bool = false,

            // Does this parameter support per key modulations?
            IS_MODULATABLE_PER_KEY: bool = false,

            // Does this parameter support per channel modulations?
            IS_MODULATABLE_PER_CHANNEL: bool = false,

            // Does this parameter support per port modulations?
            IS_MODULATABLE_PER_PORT: bool = false,

            // Any change to this parameter will affect the plugin output and requires to be done via
            // process() if the plugin is active.
            //
            // A simple example would be a DC Offset, changing it will change the output signal and must be
            // processed.
            REQUIRES_PROCESS: bool = false,

            // This parameter represents an enumerated value.
            // If you set this flag, then you must set IS_STEPPED too
            // values from min to max must not have a blank value_to_text().
            IS_ENUM: bool = false,

            _: u15 = 0,
        };

        id: Id,
        flags: Flags,
        cookie: ?*anyopaque,
        name: [NAME_SIZE]u8,
        module: [PATH_SIZE]u8,
        min_value: f64,
        max_value: f64,
        default_value: f64,
    };

    pub const PluginParams = extern struct {
        count: *const fn (plugin: ?*const Plugin) callconv(.C) u32,
        get_info: *const fn (plugin: ?*const Plugin, param_index: u32, param_info: ?*Info) callconv(.C) bool,
        get_value: *const fn (plugin: ?*const Plugin, param_id: Id, out_value: ?*f64) callconv(.C) bool,
        value_to_text: *const fn (
            plugin: ?*const Plugin,
            param_id: Id,
            value: f64,
            out_buf: [*:0]u8,
            out_buf_cap: u32,
        ) callconv(.C) bool,
        text_to_value: *const fn (
            plugin: ?*const Plugin,
            param_id: Id,
            param_value_text: [*:0]const u8,
            out_value: ?*f64,
        ) callconv(.C) bool,
        flush: *const fn (plugin: ?*const Plugin, in: ?*const InputEvents, out: ?*const OutputEvents) callconv(.C) void,
    };

    pub const RescanFlags = packed struct(u32) {
        // The parameter values did change, eg. after loading a preset.
        // The host will scan all the parameters value.
        // The host will not record those changes as automation points.
        // New values takes effect immediately.
        RESCAN_VALUES: bool = false,

        // The value to text conversion changed, and the text needs to be rendered again.
        RESCAN_TEXT: bool = false,

        // The parameter info did change, use this flag for:
        // - name change
        // - module change
        // - is_periodic (flag)
        // - is_hidden (flag)
        // New info takes effect immediately.
        RESCAN_INFO: bool = false,

        // Invalidates everything the host knows about parameters.
        // It can only be used while the plugin is deactivated.
        // If the plugin is activated use clap_host->restart() and delay any change until the host calls
        // clap_plugin->deactivate().
        //
        // You must use this flag if:
        // - some parameters were added or removed.
        // - some parameters had critical changes:
        //   - is_per_note (flag)
        //   - is_per_key (flag)
        //   - is_per_channel (flag)
        //   - is_per_port (flag)
        //   - is_readonly (flag)
        //   - is_bypass (flag)
        //   - is_stepped (flag)
        //   - is_modulatable (flag)
        //   - min_value
        //   - max_value
        //   - cookie
        RESCAN_ALL: bool = false,

        _: u28,
    };

    pub const ClearFlags = packed struct(u32) {
        // Clears all possible references to a parameter
        CLEAR_ALL: bool = false,

        // Clears all automations to a parameter
        CLEAR_AUTOMATIONS: bool = false,

        // Clears all modulations to a parameter
        CLEAR_MODULATIONS: bool = false,

        _: u29 = 0,
    };

    pub const HostParams = extern struct {
        rescan: *const fn (host: ?*const Host, flags: RescanFlags) callconv(.C) void,
        clear: *const fn (host: ?*const Host, param_id: Id, flags: ClearFlags) callconv(.C) void,
        request_flush: *const fn (host: ?*const Host) callconv(.C) void,
    };
};

pub const EXT_GUI = "clap.gui";
pub const gui = struct {
    pub const Window = extern struct {
        pub const API_WIN32 = "win32";
        pub const API_COCOA = "cocoa";
        pub const API_X11 = "x11";
        pub const API_WAYLAND = "wayland";

        api: [*:0]const u8,
        window: extern union {
            cocoa: ?*anyopaque,
            x11: c_ulong,
            win32: std.os.windows.HWND,
            ptr: ?*anyopaque,
        },
    };

    pub const ResizeHints = extern struct {
        can_resize_horizontally: bool,
        can_resize_vertically: bool,
        preserve_aspect_ratio: bool,
        aspect_ratio_width: u32,
        aspect_ratio_height: u32,
    };

    pub const PluginGui = extern struct {
        is_api_supported: *const fn (
            plugin: ?*const Plugin,
            api: [*:0]const u8,
            is_floating: bool,
        ) callconv(.C) bool,
        get_preferred_api: *const fn (
            plugin: ?*const Plugin,
            api: ?*[*:0]const u8,
            is_floating: ?*bool,
        ) callconv(.C) bool,
        create: *const fn (plugin: ?*const Plugin, api: [*:0]const u8, is_floating: bool) callconv(.C) bool,
        destroy: *const fn (plugin: ?*const Plugin) callconv(.C) void,
        set_scale: *const fn (plugin: ?*const Plugin, scale: f64) callconv(.C) bool,
        get_size: *const fn (plugin: ?*const Plugin, width: ?*u32, height: ?*u32) callconv(.C) bool,
        can_resize: *const fn (plugin: ?*const Plugin) callconv(.C) bool,
        get_resize_hints: *const fn (plugin: ?*const Plugin, hints: ?*ResizeHints) callconv(.C) bool,
        adjust_size: *const fn (plugin: ?*const Plugin, width: ?*u32, height: ?*u32) callconv(.C) bool,
        set_size: *const fn (plugin: ?*const Plugin, width: u32, height: u32) callconv(.C) bool,
        set_parent: *const fn (plugin: ?*const Plugin, window: ?*const Window) callconv(.C) bool,
        set_transient: *const fn (plugin: ?*const Plugin, window: ?*const Window) callconv(.C) bool,
        suggest_title: *const fn (plugin: ?*const Plugin, title: [*:0]const u8) callconv(.C) void,
        show: *const fn (plugin: ?*const Plugin) callconv(.C) bool,
        hide: *const fn (plugin: ?*const Plugin) callconv(.C) bool,
    };

    pub const HostGui = extern struct {
        resize_hints_changed: *const fn (host: ?*const Host) callconv(.C) void,
        request_resize: *const fn (host: ?*const Host, width: u32, height: u32) callconv(.C) bool,
        request_show: *const fn (host: ?*const Host) callconv(.C) bool,
        request_hide: *const fn (host: ?*const Host) callconv(.C) bool,
        closed: *const fn (host: ?*const Host, was_destroyed: bool) callconv(.C) void,
    };
};

pub const EXT_POSIX_FD_SUPPORT = "clap.posix-fd-support";
pub const posix_fd = struct {
    pub const Flags = packed struct(u32) {
        // IO events flags, they can be used to form a mask which describes:
        // - which events you are interested in (register_fd/modify_fd)
        // - which events happened (on_fd)
        FD_READ: bool = false,
        FD_WRITE: bool = false,
        FD_ERROR: bool = false,

        _: u29 = 0,
    };

    pub const PluginSupport = extern struct {
        on_fd: *const fn (plugin: ?*const Plugin, fd: i32, flags: Flags) callconv(.C) void,
    };

    pub const HostSupport = extern struct {
        register_fd: *const fn (host: ?*const Host, fd: i32, flags: Flags) callconv(.C) bool,
        modify_fd: *const fn (host: ?*const Host, fd: i32, flags: Flags) callconv(.C) bool,
        unregister_fd: *const fn (host: ?*const Host, fd: i32) callconv(.C) bool,
    };
};

pub const EXT_RENDER = "clap.render";
pub const Render = extern struct {
    const Mode = enum(i32) { Realtime = 0, Offline = 1 };

    has_hard_realtime_requirement: *const fn (plugin: ?*const Plugin) callconv(.C) bool,
    set: *const fn (plugin: ?*const Plugin, mode: Mode) callconv(.C) bool,
};

pub const InStream = extern struct {
    ctx: ?*anyopaque,

    read: *const fn (stream: ?*const InStream, buffer: ?*anyopaque, size: u64) callconv(.C) i64,
};

pub const OutStream = extern struct {
    ctx: ?*anyopaque,

    write: *const fn (stream: ?*const OutStream, buffer: ?*const anyopaque, size: u64) callconv(.C) i64,
};

pub const EXT_STATE = "clap.state";
pub const PluginState = extern struct {
    save: *const fn (plugin: ?*const Plugin, stream: ?*const OutStream) callconv(.C) bool,
    load: *const fn (plugin: ?*const Plugin, stream: ?*const InStream) callconv(.C) bool,
};

pub const HostState = extern struct {
    mark_dirty: *const fn (host: ?*const Host) callconv(.C) void,
};

pub const EXT_TAIL = "clap.tail";
pub const PluginTail = extern struct {
    get: *const fn (plugin: ?*const Plugin) callconv(.C) u32,
};

pub const HostTail = extern struct {
    changed: *const fn (host: ?*const Host) callconv(.C) void,
};

pub const EXT_THREAD_CHECK = "clap.thread-check";
/// This interface is useful to do runtime checks and make
/// sure that the functions are called on the correct threads.
/// It is highly recommended that hosts implement this extension.
pub const HostThreadCheck = extern struct {
    is_main_thread: *const fn (host: ?*const Host) callconv(.C) bool,
    is_audio_thread: *const fn (host: ?*const Host) callconv(.C) bool,
};

pub const EXT_TIMER_SUPPORT = "clap.timer-support";
pub const PluginTimer = extern struct {
    /// [main-thread]
    on_timer: *const fn (plugin: ?*const Plugin, timer_id: Id) callconv(.C) void,
};

pub const HostTimer = extern struct {
    /// Registers a periodic timer.
    /// The host may adjust the period if it is under a certain threshold.
    /// 30 Hz should be allowed.
    /// Returns true on success.
    /// [main-thread]
    register_timer: *const fn (host: ?*const Host, period_ms: u32, timer_id: ?*Id) callconv(.C) bool,
    /// Returns true on success.
    /// [main-thread]
    unregister_timer: *const fn (host: ?*const Host, timer_id: Id) callconv(.C) bool,
};

pub const Color = extern struct {
    alpha: u8,
    red: u8,
    green: u8,
    blue: u8,
};
