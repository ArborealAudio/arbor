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

void *plugin_get_user(Plugin *p) { return p->user_iface.user; }

static void default_float_print(const ParameterInfo *p, f32 value, char *buf, u32 buf_size) {
    string_print_buf(buf, buf_size, "%.3f", value);
}

static void default_choice_print(const ParameterInfo *p, f32 value, char *buf, u32 buf_size) {
    if ((uint)value >= p->choices.count)
        return;

    String choice = p->choices.strings[(uint)value];
    memcpy(buf, choice.data, choice.len);
}

static void default_bool_print(const ParameterInfo *p, f32 value, char *buf, u32 buf_size) {
    const char on[] = "On";
    const char off[] = "Off";
    if (value > 0) {
        memcpy(buf, on, sizeof(on)-1);
    } else {
        memcpy(buf, off, sizeof(off)-1);
    }
}

#include <user_code.c>

struct InternalParameters {
    float data[Param_Count];
};

f64 get_sample_rate(Plugin *p) {
    return p->sample_rate;
}

char *_raw_param_data_from_id(ParameterData *data, u32 id) {
    return (char*)data + (id * 4);
}

ParameterData get_plugin_parameters(Plugin *p) {
    ParameterData data;
    float *params = p->params->data;
    for (int i = 0; i < Param_Count; ++i) {
        ParameterInfo *info = &parameter_layout[i];
        char *raw = _raw_param_data_from_id(&data, i);
        switch (info->type) {
        case ParameterType_Bool:
        case ParameterType_Int:
        case ParameterType_Choice: {
            int v = (int)params[i];
            memcpy(raw, &v, 4);
        } break;
        case ParameterType_Float: {
            float v = params[i];
            memcpy(raw, &v, 4);
        } break;
        }
    }

    return data;
}

f32 get_parameter_smoothed(Plugin *p, u32 param_id) {
    if (param_id >= Param_Count) {
        err("Invalid param ID\n");
        return 0;
    }

    // TODO smooth result i.e.:
    // f32 smoothed = _calc_smoothed_param(p, param_id);
    // return smoothed;
    return p->params->data[param_id];
}

f32 get_parameter(Plugin *p, u32 param_id) {
    // TODO assert that this is the main thread
    if (param_id >= Param_Count) {
        err("Invalid param ID\n");
        return 0;
    }

    return p->params->data[param_id];
}

f32 get_parameter_main(Plugin *p, u32 param_id) {
    if (param_id >= Param_Count) {
        err("Invalid param ID\n");
        return 0;
    }
    return p->params->data[param_id];
}

void set_parameter(Plugin *p, u32 param_id, float value) {
    // TODO assert that this is the main thread
    dbg("%d: %.2f", param_id, value);
    if (param_id >= Param_Count) {
        err("Invalid param ID\n");
        return;
    }

    p->params->data[param_id] = value;
}

void set_parameter_main(Plugin *p, u32 param_id, float value) {
    if (param_id >= Param_Count) {
        err("Invalid param ID\n");
        return;
    }

    p->params->data[param_id] = value;
}

const ParameterInfo *get_parameter_info(Plugin *p, u32 param_id) {
    if (param_id >= Param_Count) {
        err("Invalid param ID\n");
        return NULL;
    }

    return &parameter_layout[param_id];
    // return &p->parameters[param_id];
}

f32 get_parameter_normalized(Plugin *p, u32 param_id, f32 value) {
    ParameterInfo *param = &parameter_layout[param_id];
    return (value - param->min_value) / (param->max_value - param->min_value);
}

f32 get_parameter_from_normalized(Plugin *p, u32 param_id, f32 value) {
    ParameterInfo *param = &parameter_layout[param_id];
    return value * (param->max_value - param->min_value) + param->min_value;
}

f32 get_parameter_default(Plugin *p, u32 param_id) {
    ParameterInfo *param = &parameter_layout[param_id];
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
        // .parameters = parameter_layout,
        .user_iface = plugin_create(&arena.allocator),
        .params = arena_alloc(&arena, sizeof(InternalParameters)),
    };

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
        ParameterInfo *pinfo = &parameter_layout[i];

        if (!pinfo->value_to_text) {
            switch (pinfo->type) {
            case ParameterType_Float:
                pinfo->value_to_text = default_float_print;
                break;
            case ParameterType_Choice:
                pinfo->value_to_text = default_choice_print;
                break;
            case ParameterType_Bool:
                pinfo->value_to_text = default_bool_print;
                break;
            default: break;
            }
        }
        p->params->data[i] = pinfo->default_value;
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
