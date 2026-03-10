// Copyright (c) 2026 Arboreal Audio, LLC
// See LICENSE at this repository's root

#include "arbor.h"

static void default_float_print(Parameter *p, f32 value, char *buf, u32 buf_size) {
    string_print_buf(buf, buf_size, "%.3f", value);
}

static void default_choice_print(Parameter *p, f32 value, char *buf, u32 buf_size) {
    if ((uint)value >= p->choices.count)
        return;

    String choice = p->choices.strings[(uint)value];
    memcpy(buf, choice.data, choice.len);
}

static void default_bool_print(Parameter *p, f32 value, char *buf, u32 buf_size) {
    const char on[] = "On";
    const char off[] = "Off";
    if (value > 0) {
        memcpy(buf, on, sizeof(on)-1);
    } else {
        memcpy(buf, off, sizeof(off)-1);
    }
}

#ifdef USER_CONFIG
#include STR(USER_CONFIG)
#else
#error Please define USER_CONFIG with the path to your plugin configuration file
#endif

#ifndef MIDI_BUFFER_CAP
#define MIDI_BUFFER_CAP 512
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

    struct {
        MidiEvent buffer[MIDI_BUFFER_CAP]; // TODO What's a reasonable max size for MIDI
        uint head;
    } midi;
    
    // format-specific plugin type, e.g. clap_plugin_t
    void *plugin_wrapper;
    const void *host;

    void *user;
    PluginInterface user_iface;

    Parameter *parameters;
    // TODO replace these with a generated struct that just contains fields named after parameters,
    // would be sick if they were typed the same as the input e.g. {float gain; Mode mode;}
    float params_audio[Param_Count];
    float params_main[Param_Count];
};

f64 get_sample_rate(Plugin *p) {
    return p->sample_rate;
}

f32 get_parameter(Plugin *p, u32 param_id) {
    if (param_id >= Param_Count) {
        err("Invalid param ID\n");
        return 0;
    }

    return p->params_audio[param_id];
}

// User code
extern PluginInterface plugin_create();
extern PluginConfig plugin_config;

#ifdef USER_CODE
#include STR(USER_CODE)
#else
#error Please define USER_CODE with the path to your main plugin C file
#endif

// Internal functions

static void _plugin_init(Plugin *p, void *wrapper_ptr, const void *host_ptr) {
    *p = (Plugin){
        .audio_input_count = plugin_config.audio_ports.inputs * 2, // TODO Don't assume stereo
        .audio_output_count = plugin_config.audio_ports.outputs * 2,
        .note_input_count = plugin_config.note_ports.inputs,
        .main_arena = arena_init(4096),
        .plugin_wrapper = wrapper_ptr,
        .parameters = plugin_config.parameter_layout,
        .user_iface = plugin_create(),
    };
    for (int i = 0; i < Param_Count; ++i) {
        Parameter *param = &p->parameters[i];
        if (param->type == ParameterType_Bool) {
            param->min_value = FALSE;
            param->max_value = TRUE;
        }

        if (!param->value_to_text) {
            switch (param->type) {
            case ParameterType_Float:
                param->value_to_text = default_float_print;
                break;
            case ParameterType_Choice:
                param->value_to_text = default_choice_print;
                break;
            case ParameterType_Bool:
                param->value_to_text = default_bool_print;
                break;
            default: break;
            }
        }
        p->params_audio[i] = p->params_main[i] = param->default_value;
    }
}

static void _push_midi(Plugin *p, MidiEvent e) {
    if (p->midi.head >= MIDI_BUFFER_CAP) {
        err("MIDI event overflow\n");
        return;
    }
    p->midi.buffer[p->midi.head] = e;
    p->midi.head += 1;    
}

static void _clear_midi(Plugin *p) {
    p->midi.head = 0;
    memset(p->midi.buffer, 0, sizeof(p->midi.buffer));
}

// Globals
static Arena global_arena;

#define new(T) (T*)arena_alloc(&global_arena, sizeof(T))
#define new_plugin() (Plugin*)arena_alloc(&global_arena, sizeof(Plugin))

// Plugin wrapper impl
#if ARBOR_CLAP
#include "arbor_clap.c"
#endif

// Other required impl
#include "dsp.c"
#include "../cbase/cbase.c"

