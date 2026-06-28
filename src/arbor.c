// Copyright (c) 2026 Arboreal Audio, LLC
// See LICENSE at this repository's root

#include "arbor.h"
#include <string.h>

// An arena for doing global allocations, i.e. plugin factories, plugin wrapper types before the
// main plugin data is allocated
static Arena *global_arena;

#define new(T) (T*)arena_alloc(global_arena, sizeof(T))

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
    f32 data[Param_Count];
};

struct ParameterSmoother {
    f32 a, b;
    f32 state[Param_Count];
};

f64 get_sample_rate(Plugin *p) {
    return p->sample_rate;
}

static char *_raw_param_data_from_id(ParameterData *data, u32 id) {
    return (char*)data + (id * 4);
}

static ParameterData _param_data(float *params) {
    ParameterData data;
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

ParameterData get_audio_parameters(Plugin *p) {
    return _param_data(p->params->data);
}

ParameterData get_gui_parameters(PluginGui *p) {
    return _param_data(p->param_cache->data);
}

f32 *get_gui_raw_parameters(PluginGui *p) {
    return p->param_cache->data;
}

// TODO should all these bounds checks on param_id be asserts?

static f32 _calc_smoothed_param(ParameterSmoother *sm, f32 value, u32 param_id) {
    f32 z = sm->state[param_id];
    f32 y = value * sm->a + z * sm->b;
    sm->state[param_id] = y;
    return y;
}

// `param` is a pointer to the param field in `ParameterData` that you wish to obtain the smoothed value for
f32 _get_parameter_smoothed(Plugin *p, u32 param_id, u32 ch) {
    if (param_id >= Param_Count) {
        err("Invalid param ID\n");
        return 0;
    }

    f32 value = p->params->data[param_id];
    return _calc_smoothed_param(&p->param_smoother[ch], value, param_id);
}

f32 get_parameter(Plugin *p, u32 param_id) {
    if (param_id >= Param_Count) {
        err("Invalid param ID\n");
        return 0;
    }

    return p->params->data[param_id];
}

f32 get_gui_parameter(PluginGui *gui, u32 param_id) {
    if (param_id >= Param_Count) {
        err("Invalid param ID\n");
        return 0;
    }

    return gui->param_cache->data[param_id];
}

void set_parameter(Plugin *p, u32 param_id, float value) {
    dbg("%d: %.2f", param_id, value);
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

bool32 parameter_changed(Plugin *p, u32 param_id) {
    return (p->param_change_mask & (1 << param_id)) > 0;
}

AudioBuffer32 audio_buffer32_create(Allocator *alloc, u32 num_ch, u32 num_frames) {
    AudioBuffer32 buf = {
        .num_frames = num_frames,
        .num_ch = num_ch,
    };

    buf.data = alloc->alloc(alloc, num_ch * sizeof(f32*));
    for (u32 ch = 0; ch < num_ch; ++ch) {
        buf.data[ch] = alloc->alloc(alloc, num_frames * sizeof(f32));
    }

    return buf;
}

AudioBuffer64 audio_buffer64_create(Allocator *alloc, u32 num_ch, u32 num_frames) {
    AudioBuffer64 buf = {
        .num_frames = num_frames,
        .num_ch = num_ch,
    };

    buf.data = alloc->alloc(alloc, num_ch * sizeof(f64*));
    for (u32 ch = 0; ch < num_ch; ++ch) {
        buf.data[ch] = alloc->alloc(alloc, num_frames * sizeof(f64));
    }

    return buf;
}

void audio_buffer64_copy_from_32(AudioBuffer64 dst, const AudioBuffer32 src) {
    assert(dst.num_ch == src.num_ch);
    assert(dst.num_frames == src.num_frames);

    for (u32 ch = 0; ch < src.num_ch; ++ch) {
        for (u32 i = 0; i < src.num_frames; ++i) {
            dst.data[ch][i] = (f64)src.data[ch][i];
        }
    }
}

void create_plugin_gui(Plugin* plugin, PluginGuiDesc desc) {
    if (desc.create_ui_builder) {
        plugin->gui.ui = ui_init(plugin->gui.platform);
    }
}

static void _plugin_push_param_update(Plugin *p, ParamChange change);

void toggle_button(PluginGui *gui, u32 param_id, UiBoxStyle style) {
    bool32 value, cache;
    value = cache = (bool32)get_gui_parameter(gui, param_id);
    ui_toggle_button(gui->ui, &value, param_names[param_id], default_style);
    if (value != cache) {
        _plugin_push_param_update(plugin_from_gui(gui), (ParamChange){
            .valid = TRUE,
            .id = param_id,
            .value = value,
        });
    }
}

void slider(PluginGui *gui, u32 param_id, UiBoxStyle style) {
    f32 value, cache;
    value = cache = get_gui_parameter(gui, param_id);
    const ParameterInfo *info = get_parameter_info(plugin_from_gui(gui), param_id);
    ui_slider(gui->ui, &value, info->min_value, info->max_value, param_names[param_id], style);
    if (value != cache) {
        _plugin_push_param_update(plugin_from_gui(gui), (ParamChange){
            .valid = TRUE,
            .id = param_id,
            .value = value,
        });
    }
}

void arbor_quick_ui(PluginGui *gui) {
    Plugin *p = plugin_from_gui(gui);
    for (int i = 0; i < Param_Count; ++i) {
        const ParameterInfo *info = get_parameter_info(p, i);
        switch (info->type) {
        case ParameterType_Bool:
            toggle_button(gui, i, default_style);
            break;
        case ParameterType_Float:
            slider(gui, i, default_style);
            break;
        default: break;
        }
    }
}

// Internal functions

// NOTE Maybe rename this to arbor_init
static bool32 _plugin_init(Plugin *p, void *wrapper_ptr, const void *host_ptr) {
    bool32 ok = TRUE;
    Arena *arena = arena_init();
    *p = (Plugin){
        .audio_input_count = plugin_config.audio_ports.inputs * 2, // TODO Don't assume stereo
        .audio_output_count = plugin_config.audio_ports.outputs * 2,
        .note_input_count = plugin_config.note_ports.inputs,
        .main_arena = arena,
        .plugin_wrapper = wrapper_ptr,
        .user_iface = plugin_create(&arena->allocator),
    };
    array_init_capacity(plugin_allocator(p), &p->param_changes.data, PARAM_CHANGES_CAPACITY);
    mutex_init(p->param_lock);
    p->gui.width = p->user_iface.gui_width;
    p->gui.height = p->user_iface.gui_height;
    p->params = plugin_alloc(p, InternalParameters);
    p->gui.param_cache = plugin_alloc(p, InternalParameters);
    p->param_smoother = arena_alloc(arena, sizeof(ParameterSmoother) * p->audio_input_count);

    if ((plugin_config.features & Feature_Instrument) || (plugin_config.features & Feature_Synth)) {
        MidiEvent *data = arena_alloc(arena, sizeof(MidiEvent) * MIDI_BUFFER_CAP);
        p->midi = (MidiBuffer){
            .buffer = data,
            .head = 0,
        };
    }

    // check for user errors in provided interface
    if (!p->user_iface.init_cb) {
        err("Must provide an init callback function in plugin_create()\n");
        ok = FALSE;
        goto cleanup;
    }
    if (!p->user_iface.prepare_cb) {
        err("Must provide a prepare callback function in plugin_create()\n");
        ok = FALSE;
        goto cleanup;
    }
    if (!p->user_iface.process_cb) {
        err("Must provide a process callback function in plugin_create()\n");
        ok =  FALSE;
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
            arena_deinit(p->main_arena);
        }
    }

    return ok;
}

static void _plugin_reset_param_changes_mask(Plugin *p) {
    p->param_change_mask = 0;
}

static void _plugin_push_param_change_id(Plugin *p, u32 id) {
    assert(id < 64);
    p->param_change_mask |= (1 << id);
}

static void _plugin_deinit(Plugin *p) {
    mutex_deinit(p->param_lock);
    arena_deinit(p->main_arena);
}

static void _plugin_prepare(Plugin *p, f64 sample_rate, u32 min_frames, u32 max_frames) {
    p->sample_rate = sample_rate;
    p->min_frames = min_frames;
    p->max_frames = max_frames;
    // Prepare parameter smoothers
    for (int ch = 0; ch < p->audio_input_count; ++ch) {
        p->param_smoother[ch].b = exp(-2 * PI * (PARAM_SMOOTH_HZ / sample_rate));
        p->param_smoother[ch].a = 1.0 - p->param_smoother[ch].b;
        memset(p->param_smoother[ch].state, 0, sizeof(p->param_smoother[ch].state));
    }

    p->user_iface.prepare_cb(p, sample_rate, max_frames);
}

static bool32 _plugin_lock_params(Plugin *p) {
    if (mutex_lock(p->param_lock) != 0) {
        err("Failed to lock mutex: %s\n", strerror(errno));
        return FALSE;
    }
    return TRUE;
}

static void _plugin_unlock_params(Plugin *p) {
    if (mutex_release(p->param_lock) != 0) {
        err("Failed to unlock mutex: %s\n", strerror(errno));
    }
}

static void _plugin_push_param_update(Plugin *p, ParamChange change) {
    const ParameterInfo *info = get_parameter_info(p, change.id);
    f32 min = info->min_value;
    f32 max = info->max_value;
    change.value = clamp(change.value, min, max);
    array_append(plugin_allocator(p), &p->param_changes.data, change);
    _plugin_push_param_change_id(p, change.id);
}

static void _plugin_push_param_mod(Plugin *p, u32 param_id, f32 amount, u32 offset) {
    const ParameterInfo *info = get_parameter_info(p, param_id);
    f32 min = info->min_value;
    f32 max = info->max_value;
    f32 current = get_parameter(p, param_id);
    _plugin_push_param_update(p, (ParamChange){
        .valid = TRUE,
        .id = param_id,
        .value = clamp(current + amount, min, max),
        .offset = offset,
    });
    _plugin_push_param_change_id(p, param_id);
}

static ParamChange _plugin_next_param_change(Plugin *p) {
    return p->param_changes.data.items[p->param_changes.read_head];
}

static void _plugin_apply_next_param_update(Plugin *p) {
    ParamChange change = p->param_changes.data.items[p->param_changes.read_head];
    assert(change.valid);
    f32 *param = &p->params->data[change.id];
    *param = change.value;
    p->param_changes.read_head += 1;
}

static int _compare_param_change_offset(const void *a, const void *b) {
    ParamChange *change_a = (ParamChange*)a;
    ParamChange *change_b = (ParamChange*)b;

    return change_a->offset - change_b->offset;
}

static void _sort_param_changes(Plugin *plugin) {
    qsort(plugin->param_changes.data.items, plugin->param_changes.data.len, sizeof(ParamChange), _compare_param_change_offset);
}

static void _midi_push(Plugin *p, MidiEvent e) {
    if (p->midi.head >= MIDI_BUFFER_CAP) {
        err("MIDI event overflow\n");
        return;
    }
    p->midi.buffer[p->midi.head] = e;
    p->midi.head += 1;
}

static void _midi_clear(Plugin *p) {
    memset(p->midi.buffer, 0, p->midi.head * sizeof(MidiEvent));
    p->midi.head = 0;
}

static void _plugin_end_processing(Plugin *p) {
    _midi_clear(p);
    _plugin_reset_param_changes_mask(p);
    memset(p->param_changes.data.items, 0, p->param_changes.read_head * sizeof(ParamChange));
    p->param_changes.read_head = 0;
    array_reset(&p->param_changes.data);
}

static void _on_pv_init(pv_Context *pv) {
    Plugin *p = pv->desc.user_data;
    if (p->user_iface.gui_init_cb)
        p->user_iface.gui_init_cb(p);
}

static void _on_pv_cleanup(pv_Context *pv) {
    Plugin *p = pv->desc.user_data;
    if (p->user_iface.gui_deinit_cb)
        p->user_iface.gui_deinit_cb(&p->gui);
    if (p->gui.ui) {
        ui_deinit(p->gui.ui);
    }
}

static void _on_pv_render(pv_Context *pv) {
    Plugin *p = pv->desc.user_data;
    UICtx *ui = p->gui.ui;

    // Set GUI parameter state
    if (mutex_lock(p->param_lock) == 0) {
        memcpy(p->gui.param_cache, p->params, sizeof(*p->params));

        if (mutex_release(p->param_lock) != 0) {
            err("Failed to unlock mutex: %s\n", strerror(errno));
        }
    } else {
        err("Failed to lock mutex: %s\n", strerror(errno));
    }

    if (ui) {
        ui_begin(ui);
    }

    if (p->user_iface.gui_render_cb)
        p->user_iface.gui_render_cb(&p->gui);

    if (ui) {
        ui_end(ui);
    }
}

static void _on_pv_event(pv_Context *pv, pv_Event *event) {
    Plugin *p = pv->desc.user_data;
    if (p->user_iface.gui_event_cb) {
        p->user_iface.gui_event_cb(&p->gui, event);
    }

   if (p->gui.ui) {
       ui_send_event(p->gui.ui, event);
   }
}

static bool32 _visual_init(Plugin* p) {
    pv_Context *pv = pv_init_child_window((pv_Desc){
        .title = plugin_config.desc.name,
        .width = p->gui.width,
        .height = p->gui.height,
        .init_proc = _on_pv_init,
        .cleanup_proc = _on_pv_cleanup,
        .render_proc = _on_pv_render,
        .event_proc = _on_pv_event,
        .user_data = p,
    });
    p->gui.platform = pv;
    return pv != NULL;
}

static void _visual_deinit(Plugin* p) {
    pv_deinit(p->gui.platform);
}

static void _visual_set_parent(Plugin *p, pv_Window parent) {
    pv_set_parent(p->gui.platform, parent);
}

static void _visual_open(Plugin *p) {
    p->gui.active = TRUE;
    pv_set_visible(p->gui.platform, TRUE);
}

static void _visual_close(Plugin *p) {
    p->gui.active = FALSE;
    pv_set_visible(p->gui.platform, FALSE);
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
#include "visual/visual.c"
