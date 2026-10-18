#include "clap/audio-buffer.h"
#include "clap/clap.h"
#include "arbor.h"
#include "clap/events.h"
#include "clap/ext/params.h"
#include "clap/plugin.h"

static const char *const *get_clap_features() {
    PluginFeatures plugin_features = plugin_config.features;
    Array(const char *) list;
    array_init_capacity(global_arena, &list, 32);

    if (plugin_features & Feature_Mono)
        array_append(global_arena, &list, CLAP_PLUGIN_FEATURE_MONO);
    if (plugin_features & Feature_Stereo)
        array_append(global_arena, &list, CLAP_PLUGIN_FEATURE_STEREO);
    if (plugin_features & Feature_Surround)
        array_append(global_arena, &list, CLAP_PLUGIN_FEATURE_SURROUND);
    if (plugin_features & Feature_Effect)
        array_append(global_arena, &list, CLAP_PLUGIN_FEATURE_AUDIO_EFFECT);
    if (plugin_features & Feature_Instrument)
        array_append(global_arena, &list, CLAP_PLUGIN_FEATURE_INSTRUMENT);

    array_append(global_arena, &list, NULL);

    return list.items;
}

static clap_plugin_descriptor_t clap_desc;
static void _make_clap_desc() {
    clap_desc = (clap_plugin_descriptor_t){
        .clap_version = CLAP_VERSION,
        .id = plugin_config.desc.id,
        .name = plugin_config.desc.name,
        .vendor = plugin_config.desc.company,
        .version = plugin_config.desc.version,
        .description = plugin_config.desc.description,
    };
};

// AUDIO PORTS
static u32 audio_ports_count(const clap_plugin_t *plugin, bool is_input) {
    Plugin *p = plugin->plugin_data;
    if (is_input)
        return plugin_config.audio_ports.inputs;
    return plugin_config.audio_ports.outputs;
}

static bool get_audio_port(const clap_plugin_t *plugin, u32 index, bool is_input, clap_audio_port_info_t *info) {
    Plugin *p = plugin->plugin_data;
    u32 count = is_input ? p->audio_input_count : p->audio_output_count;
    if (count == 0)
        return false;

    u32 flags = 0;
    if (p->supports_double_precision) {
        flags |= CLAP_AUDIO_PORT_SUPPORTS_64BITS;
        flags |= CLAP_AUDIO_PORT_PREFERS_64BITS;
    }
    if (index == 0) {
        flags |= CLAP_AUDIO_PORT_IS_MAIN;
    }
    *info = (clap_audio_port_info_t){
        .id = index,
        .port_type = count > 1 ? CLAP_PORT_STEREO : CLAP_PORT_MONO,
        .channel_count = count,
        .flags = flags,
    };
    return true;
}

static clap_plugin_audio_ports_t audio_port_info = {
    .count = audio_ports_count,
    .get = get_audio_port,
};

// NOTE PORTS
static u32 clap_note_port_count(const clap_plugin_t *plugin, bool is_input) {
    dbg("Input: %d", is_input);
    Plugin *p = plugin->plugin_data;
    if (is_input)
        return p->note_input_count > 0;

    return p->note_output_count > 0;
}

static bool clap_note_port_get(const clap_plugin_t *plugin, u32 index, bool is_input, clap_note_port_info_t *info) {
    dbg("ID %d (input: %d)", index, is_input);
    Plugin *p = plugin->plugin_data;
    u32 count = is_input ? p->note_input_count : p->note_output_count;
    if (count == 0)
        return false;

    *info = (clap_note_port_info_t){
        .id = index,
        .supported_dialects = CLAP_NOTE_DIALECT_CLAP | CLAP_NOTE_DIALECT_MIDI, // TODO support MIDI/MPE/MIDI2
        .preferred_dialect = CLAP_NOTE_DIALECT_CLAP,
    };
    const char port_name[] = "Note Input";
    memcpy(info->name, port_name, sizeof(port_name));

    return true;
}

static clap_plugin_note_ports_t note_ports = {
    .count = clap_note_port_count,
    .get = clap_note_port_get,
};

// LATENCY
static u32 get_latency(const clap_plugin_t *plugin) {
    Plugin *p = (plugin->plugin_data);
    dbg("Plugin latency: %d", p->latency);
    return p->latency;
}

static clap_plugin_latency_t plugin_latency = {
    .get = get_latency,
};

// STATE
static bool state_save(const clap_plugin_t *plugin, const clap_ostream_t *stream) {
    dbg();
    Plugin *p = plugin->plugin_data;
    InternalParameters *params = p->params;
    usize size = sizeof(params->data);
    i64 written = 0;
    while (written < size) {
        usize to_write = size - written;
        i64 res = stream->write(stream, (char*)params->data + written, to_write);
        if (res < 0) {
            err("Error saving plugin state\n");
            return false;
        }
        written += res;
    }
    return size == written;
}

static bool state_load(const clap_plugin_t *plugin, const clap_istream_t *stream) {
    dbg();
    Plugin *p = plugin->plugin_data;
    InternalParameters *params = p->params;
    usize size = sizeof(params->data);
    i64 read = 0;
    while (read < size) {
        usize to_read = size - read;
        i64 res = stream->read(stream, (char*)params->data + read, to_read);
        if (res < 0) {
            err("Error loading plugin state\n");
            return false;
        }
        if (res == 0)
            return size == read;
        read += res;
    }
    return size == read;
}

static clap_plugin_state_t plugin_state = {
    .load = state_load,
    .save = state_save,
};

// PARAMETERS
static u32 param_count(const clap_plugin_t *plugin) {
    return Param_Count;
}

static bool param_get_info(const clap_plugin_t *plugin, u32 param_idx, clap_param_info_t *info) {
    dbg("ID %d", param_idx);
    if (param_idx >= Param_Count)
        return false;
    Plugin* plug = plugin->plugin_data;
    const ParameterInfo *p = get_parameter_info(plug, param_idx);
    info->default_value = p->default_value;
    info->min_value = p->min_value;
    info->max_value = p->max_value;
    info->id = param_idx;
    switch (p->type) {
    case ParameterType_Float:
        info->flags = CLAP_PARAM_IS_AUTOMATABLE | CLAP_PARAM_IS_MODULATABLE;
        break;
    case ParameterType_Int:
        info->flags = CLAP_PARAM_IS_AUTOMATABLE | CLAP_PARAM_IS_MODULATABLE | CLAP_PARAM_IS_STEPPED;
        break;
    case ParameterType_Choice:
        info->flags = CLAP_PARAM_IS_AUTOMATABLE | CLAP_PARAM_IS_MODULATABLE | CLAP_PARAM_IS_STEPPED | CLAP_PARAM_IS_ENUM;
        break;
    case ParameterType_Bool:
        info->flags = CLAP_PARAM_IS_AUTOMATABLE | CLAP_PARAM_IS_MODULATABLE | CLAP_PARAM_IS_STEPPED;
        break;
    }
    if (p->is_bypass)
        info->flags |= CLAP_PARAM_IS_BYPASS;

    // info->cookie = p;
    memset(info->name, 0, sizeof(info->name));
    memcpy(info->name, p->name.data, p->name.len);
    return true;
}

static bool param_get_value(const clap_plugin_t *plugin, clap_id id, double *out_value) {
    dbg("ID %d", id);
    if (id >= Param_Count)
        return false;

    Plugin *p = plugin->plugin_data;
    *out_value = (f64)get_parameter(p, id);
    return true;
}

static bool param_value_to_text(const clap_plugin_t *plugin, clap_id id, f64 value, char *out_buffer, u32 out_buffer_size) {
    dbg("ID %d", id);
    if (id >= Param_Count)
        return false;
    Plugin *p = plugin->plugin_data;
    const ParameterInfo *param = get_parameter_info(p, id);
    if (param->value_to_text) {
        // Zero input buffer--sometimes it's still filled w/ old string data
        memset(out_buffer, 0, out_buffer_size);
        param->value_to_text(param, (f32)value, out_buffer, out_buffer_size);
        return true;
    }
    return false;
}

static bool param_text_to_value(const clap_plugin_t *plugin, clap_id id, const char *text, f64 *out_value) {
    dbg("ID %d: %s", id, text);
    if (id >= Param_Count)
        return false;
    Plugin *p = plugin->plugin_data;
    const ParameterInfo *param = get_parameter_info(p, id);
    if (param->text_to_value) {
        *out_value = param->text_to_value(param, text);
        return true;
    }
    return false;
}

// Apply host automation to plugin's parameters
static void _input_param_changes(const clap_plugin_t *plugin, const clap_input_events_t *in) {
    dbg();
    Plugin *p = plugin->plugin_data;
    u32 num_in = in->size(in);
    if (num_in > 0) {
        for (int i = 0; i < num_in; ++i) {
            const clap_event_header_t *hdr = in->get(in, i);
            if (hdr && hdr->space_id == CLAP_CORE_EVENT_SPACE_ID) {
                switch (hdr->type) {
                case CLAP_EVENT_PARAM_VALUE: {
                    clap_event_param_value_t *event = (clap_event_param_value_t*)hdr;
                    _plugin_push_param_change(p, (ParamChange){
                        // .valid = TRUE,
                        .id = event->param_id,
                        .value = event->value,
                        .offset = hdr->time,
                    });
                } break;
                case CLAP_EVENT_PARAM_MOD: {
                    clap_event_param_mod_t *event = (clap_event_param_mod_t*)hdr;
                    _plugin_push_param_mod(p, event->param_id, event->amount, hdr->time);
                } break;
                case CLAP_EVENT_NOTE_ON:
                case CLAP_EVENT_NOTE_OFF: {
                    clap_event_note_t *event = (clap_event_note_t*)hdr;
                    _midi_push(
                        p, (MidiEvent){
                            .valid = TRUE,
                            .note = event->key,
                            .velocity = event->velocity,
                            .type = hdr->type,
                            .offset = hdr->time,
                        });
                } break;
                case CLAP_EVENT_MIDI: {
                    clap_event_midi_t *event = (clap_event_midi_t*)hdr;
                    dbg("Port: %d | %x", event->port_index, *((u32*)event->data));
                } break;
                }
            }
        }
    }
}

// Notify host of parameter changes generated by plugin
static void _output_param_changes(const clap_plugin_t *plugin, const clap_output_events_t *out) {
    Plugin *p = plugin->plugin_data;
    for (u32 i = 0; i < Param_Count; ++i) {
        if (!(p->clap_gui_param_change_mask & (1ull << i)))
            continue;
        clap_event_param_value_t event = {
            .header = {
                .size = sizeof(event),
                .type = CLAP_EVENT_PARAM_VALUE,
                .flags = CLAP_EVENT_IS_LIVE,
                .space_id = CLAP_CORE_EVENT_SPACE_ID,
            },
            .param_id = i,
            .value = get_parameter(p, i),
            .channel = -1,
            .key = -1,
            .note_id = -1,
            .port_index = -1,
            .cookie = NULL,
        };
        if (!out->try_push(out, &event.header)) {
            err("CLAP output event push failed\n");
            continue;
        }
        p->clap_gui_param_change_mask &= ~(1ull << i);
    }
}

static void param_flush(const clap_plugin_t *plugin, const clap_input_events_t *in, const clap_output_events_t *out) {
    dbg();
    Plugin *p = plugin->plugin_data;
    if (in)
        _input_param_changes(plugin, in);
    if (out)
        _output_param_changes(plugin, out);

    while (_plugin_has_param_changes(p)) {
        _plugin_apply_next_param_change(p);
    }

    _plugin_end_processing(p);
}

// arbor Gui -> CLAP host parameters glue

static void _begin_gui_param_edit(void *ctx, u32 param_id) {}

static void _push_gui_param_edit(void *ctx, u32 param_id, f64 value) {
    clap_plugin_t *clap = (clap_plugin_t*)ctx;
    Plugin *p = clap->plugin_data;
    p->clap_gui_param_change_mask |= 1ull << (param_id);
    const clap_host_t *host = p->host;
    assert(host);
    const clap_host_params_t *hp = host->get_extension(host, CLAP_EXT_PARAMS);
    if (hp)
        hp->request_flush(host);
}

static void _end_gui_param_edit(void *ctx, u32 param_id) {}

static clap_plugin_params_t plugin_params = {
    .count = param_count,
    .get_info = param_get_info,
    .get_value = param_get_value,
    .value_to_text = param_value_to_text,
    .text_to_value = param_text_to_value,
    .flush = param_flush,
};

// GUI

#ifdef __APPLE__
#define CLAP_GUI_API CLAP_WINDOW_API_COCOA
#endif

static bool gui_is_api_supported(const clap_plugin_t *plugin, const char *api, bool is_floating) {
    return string_match(STR_LIT(CLAP_GUI_API), string(api)) && !is_floating;
}

static bool gui_get_preferred_api(const clap_plugin_t *plugin, const char **api,
    bool *is_floating) {
    *api = CLAP_GUI_API;
    *is_floating = false;
    return true;
}

static bool gui_create(const clap_plugin_t *plugin, const char *api, bool is_floating) {
    if (!gui_is_api_supported(plugin, api, is_floating)) {
        return false;
    }
    Plugin *p = (Plugin*)plugin->plugin_data;
    return _visual_init(p) == TRUE;
}

static void gui_destroy(const clap_plugin_t *plugin) {
    Plugin *p = (Plugin*)plugin->plugin_data;
    _visual_deinit(p);
}

static bool gui_set_scale(const clap_plugin_t *plugin, double scale) {
    return TRUE;
}

static bool gui_get_size(const clap_plugin_t *plugin, uint32_t *width, uint32_t *height) {
    Plugin *p = (Plugin*)plugin->plugin_data;
    *width = (u32)p->gui.width;
    *height = (u32)p->gui.height;
    return TRUE;
}

static bool gui_can_resize(const clap_plugin_t *plugin) {
    return FALSE;
}

static bool gui_get_resize_hints(const clap_plugin_t *plugin, clap_gui_resize_hints_t *hints) {
    return FALSE;
}

static bool gui_adjust_size(const clap_plugin_t *plugin, uint32_t *width, uint32_t *height) {
    return FALSE;
}

static bool gui_set_size(const clap_plugin_t *plugin, uint32_t width, uint32_t height) {
    Plugin *p = (Plugin*)plugin->plugin_data;
    pv_set_render_size(p->gui.platform, (av_Size){.width = width, .height = height});
    return TRUE;
}

static bool gui_set_parent(const clap_plugin_t *plugin, const clap_window_t *window) {
    Plugin *p = (Plugin*)plugin->plugin_data;
#ifdef __APPLE__
    _visual_set_parent(p, (pv_Window)window->cocoa);
#endif
    return TRUE;
}

static bool gui_set_transient(const clap_plugin_t *plugin, const clap_window_t *window) {
    return FALSE;
}

static void gui_suggest_title(const clap_plugin_t *plugin, const char *title) {}

static bool gui_show(const clap_plugin_t *plugin) {
    Plugin *p = (Plugin*)plugin->plugin_data;
    _visual_open(p);
    return true;
}

static bool gui_hide(const clap_plugin_t *plugin) {
    Plugin *p = (Plugin*)plugin->plugin_data;
    _visual_close(p);
    return true;
}

static clap_plugin_gui_t plugin_gui = {
    .is_api_supported = gui_is_api_supported,
    .get_preferred_api = gui_get_preferred_api,
    .create = gui_create,
    .destroy = gui_destroy,
    .set_scale = gui_set_scale,
    .get_size = gui_get_size,
    .can_resize = gui_can_resize,
    .get_resize_hints = gui_get_resize_hints,
    .adjust_size = gui_adjust_size,
    .set_size = gui_set_size,
    .set_parent = gui_set_parent,
    .set_transient = gui_set_transient,
    .suggest_title = gui_suggest_title,
    .show = gui_show,
    .hide = gui_hide,
};

// PLUGIN
static bool plugin_init(const clap_plugin_t *plugin) {
    dbg();
    Plugin *p = plugin->plugin_data;
    p->user_iface.init_cb(p);
    return true;
}

static void plugin_destroy(const clap_plugin_t *plugin) {
    dbg();
    Plugin *p = plugin->plugin_data;
    p->user_iface.deinit_cb(p);
    arena_deinit(p->main_arena);
}

static bool plugin_activate(const clap_plugin_t *plugin, f64 sample_rate, u32 min_frames, u32 max_frames) {
    dbg();
    Plugin *p = plugin->plugin_data;
    _plugin_prepare(p, sample_rate, min_frames, max_frames);
    return true;
}

static void plugin_deactivate(const clap_plugin_t *plugin) {
    dbg();
}

static bool plugin_start_processing(const clap_plugin_t *plugin) {
    dbg();
    return true;
}

static void plugin_stop_processing(const clap_plugin_t *plugin) {
    dbg();
}

static void plugin_reset(const clap_plugin_t *plugin) {
    dbg();
}

static clap_process_status plugin_process(const clap_plugin_t *plugin, const clap_process_t *process) {
    Plugin *p = plugin->plugin_data;

    const u32 num_frames = process->frames_count;
    if (process->in_events)
        _input_param_changes(plugin, process->in_events);

    u32 next_event_frame = num_frames;
    int next_param_change_frame = _plugin_next_param_change_offset(p);
    if (next_param_change_frame >= 0) {
        next_event_frame = next_param_change_frame;
    }
    // TODO handle MIDI w/ no param changes

    const clap_audio_buffer_t *audio_in = process->audio_inputs;
    const clap_audio_buffer_t *audio_out = process->audio_outputs;
    bool32 have_audio = audio_in && audio_out && (audio_in->data32 || audio_in->data64) && (audio_out->data32 || audio_out->data64);

    stack_arena_begin(512);
    u32 i = 0;

    while (i < num_frames) {
        while (next_event_frame == i) {
            _plugin_apply_next_param_change(p);
            int next_param_change_frame = _plugin_next_param_change_offset(p);
            if (next_param_change_frame >= 0) {
                next_event_frame = next_param_change_frame;
            } else {
                next_event_frame = num_frames;
            }
            assert(next_event_frame <= num_frames);
        }
        u32 frames_to_process = next_event_frame - i;
        assert(frames_to_process <= num_frames);

        if (have_audio) {
            u32 in_ch = audio_in->channel_count;
            u32 out_ch = audio_out->channel_count;
            if (audio_in->data32 && audio_out->data32) {
                f32 **in_data = arena_alloc(stack_arena(), sizeof(f32*) * in_ch);
                f32 **out_data = arena_alloc(stack_arena(), sizeof(f32*) * out_ch);
                AudioBuffer32 in = audio_buffer32_from_data(in_data, audio_in->data32, in_ch, frames_to_process, i);
                AudioBuffer32 out = audio_buffer32_from_data(out_data, audio_out->data32, out_ch, frames_to_process, i);
                p->user_iface.process_cb(p, in, out, p->midi);
                audio_buffer_sanitize(out);
            } else if (audio_in->data64 && audio_out->data64) {
                f64 **in_data = arena_alloc(stack_arena(), sizeof(f64*) * in_ch);
                f64 **out_data = arena_alloc(stack_arena(), sizeof(f64*) * out_ch);
                AudioBuffer64 in = audio_buffer64_from_data(in_data, audio_in->data64, in_ch, frames_to_process, i);
                AudioBuffer64 out = audio_buffer64_from_data(out_data, audio_out->data64, out_ch, frames_to_process, i);
                assert(p->supports_double_precision && p->user_iface.process_double_cb);
                p->user_iface.process_double_cb(p, in, out, p->midi);
                audio_buffer_sanitize(out);
            }
        }

        i += frames_to_process;
    }

    while (_plugin_has_param_changes(p)) {
        _plugin_apply_next_param_change(p);
    }

    if (process->out_events)
        _output_param_changes(plugin, process->out_events);

    _plugin_end_processing(p);

    return CLAP_PROCESS_CONTINUE;
}

static const void *plugin_get_extension(const clap_plugin_t *plugin, const char *id) {
    if (string_match(string(id), STR_LIT(CLAP_EXT_AUDIO_PORTS)))
        return &audio_port_info;
    if (((plugin_config.features & Feature_Instrument) || (plugin_config.features & Feature_Synth)) &&
            (plugin_config.note_ports.inputs > 0 || plugin_config.note_ports.outputs > 0)) {
        if (string_match(string(id), STR_LIT(CLAP_EXT_NOTE_PORTS)))
            return &note_ports;
    }
    if (string_match(string(id), STR_LIT(CLAP_EXT_PARAMS)))
        return &plugin_params;
    if (string_match(string(id), STR_LIT(CLAP_EXT_STATE)))
        return &plugin_state;
    if (string_match(string(id), STR_LIT(CLAP_EXT_LATENCY)))
        return &plugin_latency;
    if (string_match(string(id), STR_LIT(CLAP_EXT_GUI)))
        return &plugin_gui;
    return NULL;
}

static void plugin_on_main_thread(const clap_plugin_t *plugin) {
    dbg();
}

// FACTORY
static u32 get_plugin_count(const struct clap_plugin_factory *factory) {
    dbg();
    return 1;
}

static const clap_plugin_descriptor_t *get_plugin_descriptor(const struct clap_plugin_factory *factory, u32 index) {
    dbg();
    if (index == 0) {
        clap_desc.features = get_clap_features();
        return &clap_desc;
    }
    return NULL;
}

static const clap_plugin_t *create_plugin(const struct clap_plugin_factory *factory,
                                          const clap_host_t *host, const char *plugin_id) {
    dbg();
    if (!host) {
        err("Host is null\n");
        return NULL;
    }
    if (!clap_version_is_compatible(host->clap_version)) {
        err("Incompatible CLAP version\n");
        return NULL;
    }
    if (string_match(string(plugin_id), string(clap_desc.id))) {
        Plugin *plugin = global_struct_alloc(Plugin);
        clap_plugin_t *clap = global_struct_alloc(clap_plugin_t);
        _plugin_init(plugin, clap, host);
        *clap = (clap_plugin_t){
            .plugin_data = plugin,
            .desc = &clap_desc,
            .init = plugin_init,
            .destroy = plugin_destroy,
            .activate = plugin_activate,
            .deactivate = plugin_deactivate,
            .start_processing = plugin_start_processing,
            .stop_processing = plugin_stop_processing,
            .reset = plugin_reset,
            .process = plugin_process,
            .get_extension = plugin_get_extension,
            .on_main_thread = plugin_on_main_thread,
        };
        return clap;
    }
    return NULL;
}

static clap_plugin_factory_t plugin_factory = (clap_plugin_factory_t){
    .create_plugin = create_plugin,
    .get_plugin_count = get_plugin_count,
    .get_plugin_descriptor = get_plugin_descriptor,
};

// ENTRY
static bool entry_init(const char *plugin_path) {
    dbg("plugin_path: %s", plugin_path);
    _make_clap_desc(); // make description as early as possible
    global_arena = arena_init();
    return true;
}

static void entry_deinit() {
    dbg();
    arena_deinit(global_arena);
}

static const void *get_factory(const char *factory_id) {
    dbg("factory_id: %s", factory_id);
    String in = string(factory_id);
    String fid = STR_LIT(CLAP_PLUGIN_FACTORY_ID);
    if (string_match(in, fid)) {
        return &plugin_factory;
    }
    return NULL;
}

CLAP_EXPORT const clap_plugin_entry_t clap_entry = (clap_plugin_entry_t){
    .clap_version = CLAP_VERSION,
    .init = entry_init,
    .deinit = entry_deinit,
    .get_factory = get_factory,
};
