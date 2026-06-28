// Copyright (c) 2026 Arboreal Audio, LLC
// See LICENSE at this repository's root

#ifndef ARBOR_H
#define ARBOR_H

#include "../cbase/cbase.h"
#include "dsp/dsp.h"
#include "visual/visual.h"

typedef struct {
    const char *name;
    const char *id;
    const char *company;
    const char *version;
    const char *copyright;
    const char *url;
    const char *contact;
    const char *manual;
    const char *description;
} PluginDescription;

typedef enum {
    Feature_Mono = (1<<0),
    Feature_Stereo = (1<<1),
    Feature_Surround = (1<<2),
    Feature_Ambisonic = (1<<3),
    Feature_Effect = (1<<4),
    Feature_Distortion = (1<<5),
    Feature_Dynamics = (1<<6),
    Feature_Eq = (1<<7),
    Feature_Reverb = (1<<8),
    Feature_PitchShift = (1<<9),
    Feature_Mastering = (1<<10),
    Feature_Analyzer = (1<<11),
    Feature_Restoration = (1<<12),
    Feature_Instrument = (1<<13),
    Feature_Synth = (1<<14),
    Feature_Sampler = (1<<15),
    Feature_Drum = (1<<16),
    Feature_Gui = (1<<17),
} PluginFeatures;

#define DefaultPluginFeatures Feature_Stereo | Feature_Effect | Feature_Gui

typedef enum {
    ParameterType_Float,
    ParameterType_Int,
    ParameterType_Choice,
    ParameterType_Bool,
} ParameterType;

typedef struct ParameterInfo ParameterInfo;

typedef void(*ParameterValueToText)(const ParameterInfo *p, f32 value, char *buf, u32 buf_size);
typedef float(*ParameterTextToValue)(const ParameterInfo *p, const char *text);

struct ParameterInfo {
    String name;
    StringArray choices;
    ParameterType type;
    float min_value;
    float max_value;
    float default_value;
    ParameterValueToText value_to_text;
    ParameterTextToValue text_to_value;
    // Sets whether this parameter should be merged with the host's bypass parameter
    bool32 is_bypass;
};

typedef struct {
    PluginDescription desc;
    struct {
        int inputs;
        int outputs;
    } audio_ports;
    struct {
        int inputs;
        int outputs;
    } note_ports;
    PluginFeatures features;
} PluginConfig;

typedef struct {
    f32 **data;
    u32 num_frames;
    u32 num_ch;
} AudioBuffer32;

typedef struct {
    f64 **data;
    u32 num_frames;
    u32 num_ch;
} AudioBuffer64;

typedef enum {
    MIDI_NOTE_ON,
    MIDI_NOTE_OFF,
} MidiEventType;

// TODO I think you gotta support stuff like "expressions", modulation, etc.
typedef struct {
    bool32 valid;
    MidiEventType type;
    i16 port_id;
    i16 channel;
    i16 note;
    f64 velocity;
    u32 offset;
} MidiEvent;

typedef struct {
    MidiEvent *buffer;
    uint head;
} MidiBuffer;

#ifndef MIDI_BUFFER_CAP
#define MIDI_BUFFER_CAP 512
#endif

typedef struct Plugin Plugin;
typedef struct PluginGui PluginGui;

typedef void (*InitFn)(Plugin *);
typedef void (*DeinitFn)(Plugin *);
typedef void (*PrepareFn)(Plugin *, f64 sample_rate, u32 max_frames);
typedef void (*ProcessFn)(Plugin *, const AudioBuffer32 in, AudioBuffer32 out, MidiBuffer midi);
typedef void (*GuiInitFn)(Plugin *);
typedef void (*GuiDeinitFn)(PluginGui *);
typedef void (*GuiRenderFn)(PluginGui *);
typedef void (*GuiEventFn)(PluginGui *, pv_Event *);

typedef struct {
    void *user;
    InitFn init_cb;
    DeinitFn deinit_cb;
    PrepareFn prepare_cb;
    ProcessFn process_cb;
    GuiInitFn gui_init_cb;
    GuiDeinitFn gui_deinit_cb;
    GuiRenderFn gui_render_cb;
    GuiEventFn gui_event_cb;
    int gui_width;
    int gui_height;
} PluginInterface;

typedef struct ParameterData ParameterData;
typedef struct InternalParameters InternalParameters;
typedef struct ParameterSmoother ParameterSmoother;

#ifndef PARAM_SMOOTH_HZ
#define PARAM_SMOOTH_HZ 10.0
#endif

typedef struct {
    bool32 create_ui_builder;
} PluginGuiDesc;

struct PluginGui {
    bool32 active;
    int width;
    int height;
    void *user;
    pv_Context *platform;
    UICtx *ui;
    InternalParameters *param_cache;
};

typedef struct {
    bool32 valid;
    u32 id;
    u32 offset;
    double value;
} ParamChange;

#define PARAM_CHANGES_CAPACITY 128 // Initial capacity, may grow

typedef struct {
    Array(ParamChange) data;
    int read_head;
} ParamChangeList;

struct Plugin {
    u32 audio_input_count;
    u32 audio_output_count;
    u32 note_input_count;
    u32 note_output_count;

    u32 min_frames;
    u32 max_frames;
    f64 sample_rate;
    u32 latency;

    Arena *main_arena;

    MidiBuffer midi;

    // format-specific plugin type, e.g. clap_plugin_t
    void *plugin_wrapper;
    const void *host;

    PluginInterface user_iface;

    Mutex param_lock;
    InternalParameters *params;
    // An n-channel-sized array, manages smoothing of all parameter values
    ParameterSmoother *param_smoother;
    ParamChangeList param_changes;
    u64 param_change_mask;

    PluginGui gui;
};

#define plugin_from_gui(p) (Plugin*)((char*)p - offsetof(Plugin, gui))

#define plugin_alloc(p, T) (T*)arena_alloc(p->main_arena, sizeof(T))

static inline Allocator *plugin_allocator(Plugin *p) {
    return &p->main_arena->allocator;
}

// A user-defined function which provides a `PluginInterface` to call the user's functions and
// provide a reference to user-allocated data
PluginInterface plugin_create(Allocator *);
// Get the user data provided in the `PluginInterface`
void *plugin_get_user(Plugin *p);

f64 get_sample_rate(Plugin *p);
// [Audio Thread Only]
// Get a struct representing all current parameter data. This is a copy of the plugin's parameter
// state, hence why it is returned by value rather than by pointer. The intended way to use this
// is by calling it once in your plugin's process callback, then passing references by pointer to
// any downstream functions which will need it.
ParameterData get_audio_parameters(Plugin *p);
static f32 _get_parameter_smoothed(Plugin *p, u32 param_id, u32 ch);
// Get a parameter value run through a smoothing funciton to prevent audio artefacts. Requires a
// channel index.
#define get_parameter_smoothed(plugin, param, ch) _get_parameter_smoothed((plugin), offsetof(ParameterData, param)/4, (ch))
//  Get a parameter value
f32 get_parameter(Plugin *p, u32 param_id);
//  Set a parameter value
void set_parameter(Plugin *p, u32 param_id, float value);
const ParameterInfo *get_parameter_info(Plugin *p, u32 param_id);
f32 get_parameter_normalized(Plugin *p, u32 param_id, f32 value);
f32 get_parameter_from_normalized(Plugin *p, u32 param_id, f32 value);
f32 get_parameter_default(Plugin *p, u32 param_id);
// Checks a param change mask against the provided ID
// The return value should remain valid for the duration of the audio process callback
bool32 parameter_changed(Plugin *p, u32 param_id);

// GUI functions
void create_plugin_gui(Plugin*, PluginGuiDesc);
ParameterData get_gui_parameters(PluginGui *gui);
f32 *get_gui_raw_parameters(PluginGui *gui);
// UI builder function wrappers -- provides a set of GUI parameter controls
// which will automatically propagate changes to the underlying parameter state
void slider(PluginGui *gui, u32 param_id, UiBoxStyle style);

// Generates a basic prototype UI with sliders, combo boxes and buttons for all parameters
void arbor_quick_ui(PluginGui *gui);

AudioBuffer32 audio_buffer32_create(Allocator *alloc, u32 num_ch, u32 num_frames);
AudioBuffer64 audio_buffer64_create(Allocator *alloc, u32 num_ch, u32 num_frames);
// Copy a 32-bit buffer to a pre-allocated 64-bit buffer
void audio_buffer64_copy_from_32(AudioBuffer64 dst, const AudioBuffer32 src);


#define XSTR(x) #x
#define STR(x) XSTR(x)

#endif
