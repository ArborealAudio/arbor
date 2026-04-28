// Copyright (c) 2026 Arboreal Audio, LLC
// See LICENSE at this repository's root

#ifndef ARBOR_H
#define ARBOR_H

#include "../cbase/cbase.h"

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

typedef struct Parameter Parameter;

typedef void(*ParameterValueToText)(const Parameter *p, f32 value, char *buf, u32 buf_size);
typedef float(*ParameterTextToValue)(const Parameter *p, const char *text);

struct Parameter {
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

typedef struct PluginParameterData PluginParameterData;

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

    struct {
        MidiEvent buffer[MIDI_BUFFER_CAP]; // TODO What's a reasonable max size for MIDI
        uint head;
    } midi;

    // format-specific plugin type, e.g. clap_plugin_t
    void *plugin_wrapper;
    const void *host;

    void *user;
    PluginInterface user_iface;

    // TODO: Rename this type to ParameterInfo & field to parameter_info
    Parameter *parameters;
    PluginParameterData *params;
};

Allocator *plugin_allocator(Plugin *p);

#define plugin_push_struct(p, T) (T*)arena_alloc(&p->main_arena, sizeof(T))

// User code
PluginInterface plugin_create();

f64 get_sample_rate(Plugin *p);
// [Audio Thread] Get a parameter value
f32 get_parameter(Plugin *p, u32 param_id);
// [Main Thread] Get a parameter value
f32 get_parameter_main(Plugin *p, u32 param_id);
// [Audio Thread] Set a parameter value
void set_parameter(Plugin *p, u32 param_id, float value);
// [Main Thread] Set a parameter value
void set_parameter_main(Plugin *p, u32 param_id, float value);
const Parameter *get_parameter_info(Plugin *p, u32 param_id);
f32 get_parameter_normalized(Plugin *p, u32 param_id, f32 value);
f32 get_parameter_from_normalized(Plugin *p, u32 param_id, f32 value);

#define XSTR(x) #x
#define STR(x) XSTR(x)

#include "dsp.h"

#endif
