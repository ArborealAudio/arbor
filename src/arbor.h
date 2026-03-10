// Copyright (c) 2026 Arboreal Audio, LLC
// See LICENSE at this repository's root

#ifndef ARBOR_H
#define ARBOR_H

#include "../cbase/cbase.h"

typedef struct Plugin Plugin;

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

typedef void(*ParameterValueToText)(Parameter *p, f32 value, char *buf, u32 buf_size);
typedef float(*ParameterTextToValue)(Parameter *p, const char *text);

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
    Parameter *parameter_layout;
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

typedef void (*InitFn)(Plugin *);
typedef void (*DeinitFn)(Plugin *);
typedef void (*PrepareFn)(Plugin *, f64 sample_rate, u32 max_frames, u32 num_ch);
typedef void (*ProcessFn)(Plugin *, const AudioBuffer32 in, AudioBuffer32 out, MidiBuffer midi);

typedef struct {
    void *user;
    InitFn init_cb;
    DeinitFn deinit_cb;
    PrepareFn prepare_cb;
    ProcessFn process_cb;
} PluginInterface;

f32 get_parameter(Plugin *p, u32 param_id);
f64 get_sample_rate(Plugin *p);

#define XSTR(x) #x
#define STR(x) XSTR(x)

#include "dsp.h"

#endif
