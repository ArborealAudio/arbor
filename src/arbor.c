// Copyright (c) 2026 Arboreal Audio, LLC
// See LICENSE at this repository's root

#include "arbor.h"

// An arena for doing global allocations, i.e. plugin factories, plugin wrapper types before the
// main plugin data is allocated
static Arena global_arena;

#define new(T) (T*)arena_alloc(&global_arena, sizeof(T))

Allocator *plugin_allocator(Plugin *p) {
    return &p->main_arena.allocator;
}

void *plugin_get_user(Plugin *p) { return p->user; }

static void default_float_print(const Parameter *p, f32 value, char *buf, u32 buf_size) {
    string_print_buf(buf, buf_size, "%.3f", value);
}

static void default_choice_print(const Parameter *p, f32 value, char *buf, u32 buf_size) {
    if ((uint)value >= p->choices.count)
        return;

    String choice = p->choices.strings[(uint)value];
    memcpy(buf, choice.data, choice.len);
}

static void default_bool_print(const Parameter *p, f32 value, char *buf, u32 buf_size) {
    const char on[] = "On";
    const char off[] = "Off";
    if (value > 0) {
        memcpy(buf, on, sizeof(on)-1);
    } else {
        memcpy(buf, off, sizeof(off)-1);
    }
}

#include <user_code.c>

struct PluginParameterData {
    // TODO replace these with a generated struct that just contains fields named after parameters,
    // would be sick if they were typed the same as the input e.g.:
    // float gain;
    // float out_gain;
    // float freq;
    // Mode saturation_mode;
    // bool input_boost;
    float audio[Param_Count];
    float main[Param_Count];
};

f64 get_sample_rate(Plugin *p) {
    return p->sample_rate;
}

f32 get_parameter(Plugin *p, u32 param_id) {
    if (param_id >= Param_Count) {
        err("Invalid param ID\n");
        return 0;
    }

    return p->params->audio[param_id];
}

f32 get_parameter_main(Plugin *p, u32 param_id) {
    if (param_id >= Param_Count) {
        err("Invalid param ID\n");
        return 0;
    }

    return p->params->main[param_id];
}

void set_parameter(Plugin *p, u32 param_id, float value) {
    dbg("%d: %.2f", param_id, value);
    if (param_id >= Param_Count) {
        err("Invalid param ID\n");
        return;
    }

    p->params->audio[param_id] = value;
}

void set_parameter_main(Plugin *p, u32 param_id, float value) {
    if (param_id >= Param_Count) {
        err("Invalid param ID\n");
        return;
    }

    p->params->main[param_id] = value;
}

const Parameter *get_parameter_info(Plugin *p, u32 param_id) {
    if (param_id >= Param_Count) {
        err("Invalid param ID\n");
        return NULL;
    }

    return &p->parameters[param_id];
}

f32 get_parameter_normalized(Plugin *p, u32 param_id, f32 value) {
    Parameter *param = &p->parameters[param_id];
    return (value - param->min_value) / (param->max_value - param->min_value);
}

f32 get_parameter_from_normalized(Plugin *p, u32 param_id, f32 value) {
    Parameter *param = &p->parameters[param_id];
    return value * (param->max_value - param->min_value) + param->min_value;
}

f32 get_parameter_default(Plugin *p, u32 param_id) {
    Parameter *param = &p->parameters[param_id];
    if (!param) {
        err("Invalid param ID\n");
        return 0;
    }
    return param->default_value;
}

// Internal functions

static bool _plugin_init(Plugin *p, void *wrapper_ptr, const void *host_ptr) {
    bool ok = true;
    Arena arena = arena_init(KB(64));
    *p = (Plugin){
        .audio_input_count = plugin_config.audio_ports.inputs * 2, // TODO Don't assume stereo
        .audio_output_count = plugin_config.audio_ports.outputs * 2,
        .note_input_count = plugin_config.note_ports.inputs,
        .main_arena = arena,
        .plugin_wrapper = wrapper_ptr,
        .parameters = parameter_layout,
        .user_iface = plugin_create(&arena.allocator),
        .params = arena_alloc(&arena, sizeof(PluginParameterData)),
    };
    // Copy user pointer "up" one level for quicker access
    p->user = p->user_iface.user;

    // check for user errors in provided interface
    if (!p->user_iface.init_cb) {
        err("Must provide an init callback function in plugin_create()\n");
        ok = false;
        goto cleanup;
    }
    if (!p->user_iface.prepare_cb) {
        err("Must provide a prepare callback function in plugin_create()\n");
        ok = false;
        goto cleanup;
    }
    if (!p->user_iface.process_cb) {
        err("Must provide a process callback function in plugin_create()\n");
        ok =  false;
        goto cleanup;
    }

    for (int i = 0; i < Param_Count; ++i) {
        Parameter *param = &p->parameters[i];

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
        p->params->audio[i] = p->params->main[i] = param->default_value;
    }

    cleanup: {
        if (!ok) {
            arena_deinit(&p->main_arena);
        }
    }

    return ok;
}

static void _plugin_deinit(Plugin *p) {
    arena_deinit(&p->main_arena);
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

// Plugin wrapper impl
#if defined(ARBOR_CLAP)
#include "arbor_clap.c"
#elif defined(ARBOR_VST3)
#include "arbor_vst3.c"
#endif

// Other required impl
#include "dsp/dsp.c"
#include "../cbase/cbase.c"
