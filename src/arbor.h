// Copyright (c) 2026 Arboreal Audio, LLC
// See LICENSE at this repository's root

#ifndef ARBOR_H
#define ARBOR_H

#include "../cbase/cbase.h"

typedef struct {
    char *name;
    char *id;
    char *company;
    char *version;
    char *copyright;
    char *url;
    char *contact;
    char *manual;
    char *description;
} PluginDescription;

typedef u32 PluginFeatures;
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
} PluginFeature;

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
    bool is_bypass;
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
    MidiEvent *events;
    uint length;
} MidiBuffer;

#ifndef MIDI_BUFFER_CAP
#define MIDI_BUFFER_CAP 512
#endif

typedef struct Plugin Plugin;

typedef void (*InitFn)(Plugin *);
typedef void (*DeinitFn)(Plugin *);
typedef void (*PrepareFn)(Plugin *, f64 sample_rate, u32 max_frames);
typedef void (*ProcessFn)(Plugin *, const AudioBuffer32 in, AudioBuffer32 out, MidiBuffer midi);
typedef struct {
    void *user;
    InitFn init_cb;
    DeinitFn deinit_cb;
    PrepareFn prepare_cb;
    ProcessFn process_cb;
} PluginInterface;

typedef struct ParameterData ParameterData;
typedef struct InternalParameters InternalParameters;
typedef struct ParameterSmoother ParameterSmoother;

#ifndef PARAM_SMOOTH_HZ
#define PARAM_SMOOTH_HZ 10.0
#endif

struct Plugin {
    u32 audio_input_count;
    u32 audio_output_count;
    u32 note_input_count;
    u32 note_output_count;

    u32 min_frames;
    u32 max_frames;
    f64 sample_rate;
    u32 latency;

    Arena main_arena;

    // TODO Make this a pointer to a struct, so that we can leave this empty if MIDI is not needed
    struct {
        MidiEvent buffer[MIDI_BUFFER_CAP]; // TODO What's a reasonable max size for MIDI
        uint head;
    } midi;

    // format-specific plugin type, e.g. clap_plugin_t
    void *plugin_wrapper;
    const void *host;

    PluginInterface user_iface;

    InternalParameters *params;
    // An n-channel-sized array, manages smoothing of all parameter values
    ParameterSmoother *param_smoother;
    u64 param_change_mask;
};

Allocator *plugin_allocator(Plugin *p);

#define plugin_alloc(p, T) (T*)arena_alloc(&p->main_arena, sizeof(T))

// A user-defined function which provides a `PluginInterface` to call the user's functions and
// provide a reference to user-allocated data
PluginInterface plugin_create(Allocator *);
// Get the user data provided in the `PluginInterface`
void *plugin_get_user(Plugin *p);

f64 get_sample_rate(Plugin *p);
// Get a struct representing all current parameter data. This is a copy of the plugin's parameter
// state, hence why it is returned by value rather than by pointer. The intended way to use this
// is by calling it once in your plugin's process callback, then passing references by pointer to
// any downstream functions which will need it.
ParameterData get_plugin_parameters(Plugin *p);
// Get a parameter value run through a smoothing funciton to prevent audio artefacts.
// TODO figure out how to handle multiple channels
f32 get_parameter_smoothed(Plugin *p, u32 param_id, u32 ch);
//  Get a parameter value
f32 get_parameter(Plugin *p, u32 param_id);
//  Set a parameter value
void set_parameter(Plugin *p, u32 param_id, float value);
const ParameterInfo *get_parameter_info(Plugin *p, u32 param_id);
f32 get_parameter_normalized(Plugin *p, u32 param_id, f32 value);
f32 get_parameter_from_normalized(Plugin *p, u32 param_id, f32 value);
f32 get_parameter_default(Plugin *p, u32 param_id);
// TODO API for parameter changes, e.g.:
// Checks a param change mask against the provided ID
// bool parameter_changed(Plugin *p, u32 param_id);

AudioBuffer32 audio_buffer32_create(Allocator *alloc, u32 num_ch, u32 num_frames);
AudioBuffer64 audio_buffer64_create(Allocator *alloc, u32 num_ch, u32 num_frames);
// Copy a 32-bit buffer to a pre-allocated 64-bit buffer
void audio_buffer64_copy_from_32(AudioBuffer64 dst, const AudioBuffer32 src);

#define XSTR(x) #x
#define STR(x) XSTR(x)

#include "dsp/dsp.h"

#endif
