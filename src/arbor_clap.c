#include "clap/clap.h"
#include "arbor.h"

static const char *const *get_clap_features() {
    PluginFeatures plugin_features = plugin_config.features;
    Array(const char *) list;
    array_init_capacity(&global_arena->allocator, &list, 32);

    if (plugin_features & Feature_Mono)
        array_append(&global_arena->allocator, &list, CLAP_PLUGIN_FEATURE_MONO);
    if (plugin_features & Feature_Stereo)
        array_append(&global_arena->allocator, &list, CLAP_PLUGIN_FEATURE_STEREO);
    if (plugin_features & Feature_Surround)
        array_append(&global_arena->allocator, &list, CLAP_PLUGIN_FEATURE_SURROUND);
    if (plugin_features & Feature_Effect)
        array_append(&global_arena->allocator, &list, CLAP_PLUGIN_FEATURE_AUDIO_EFFECT);
    if (plugin_features & Feature_Instrument)
        array_append(&global_arena->allocator, &list, CLAP_PLUGIN_FEATURE_INSTRUMENT);

    array_append(&global_arena->allocator, &list, NULL);

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
        return p->audio_input_count > 0;
    return p->audio_output_count > 0;
}

static bool get_audio_port(const clap_plugin_t *plugin, u32 index, bool is_input, clap_audio_port_info_t *info) {
    Plugin *p = plugin->plugin_data;
    u32 count = is_input ? p->audio_input_count : p->audio_output_count;
    if (count == 0)
        return false;

    *info = (clap_audio_port_info_t){
        .id = index,
        .port_type = count > 1 ? CLAP_PORT_STEREO : CLAP_PORT_MONO,
        .channel_count = count,
        .flags = index == 0, // TODO Supporting/preferring 64 bits
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
    usize size = sizeof(params->main);
    i64 written = 0;
    while (written < size) {
        usize to_write = size - written;
        i64 res = stream->write(stream, (char*)params->main + written, to_write);
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
    usize size = sizeof(params->main);
    i64 read = 0;
    while (read < size) {
        usize to_read = size - read;
        i64 res = stream->read(stream, (char*)params->main + read, to_read);
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

static void param_flush(const clap_plugin_t *plugin, const clap_input_events_t *in, const clap_output_events_t *out) {
    dbg();
    Plugin *p = plugin->plugin_data;
    u32 num_in = in->size(in);
    if (num_in > 0) {
        for (int i = 0; i < num_in; ++i) {
            const clap_event_header_t *hdr = in->get(in, i);
            switch (hdr->type) {
            case CLAP_EVENT_PARAM_VALUE: {
                clap_event_param_value_t *event = (clap_event_param_value_t*)hdr;
                _plugin_update_param(p, event->param_id, event->value);
            } break;
            }
        }
    }

    // TODO out events
}

static clap_plugin_params_t plugin_params = {
    .count = param_count,
    .get_info = param_get_info,
    .get_value = param_get_value,
    .value_to_text = param_value_to_text,
    .text_to_value = param_text_to_value,
    .flush = param_flush,
};

// GUI
// TODO

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
    // Sync audio params to any changes in main
    // ISSUE this is kind of pointless because we're going to write to audio params anyway if
    // there are changes
    memcpy(p->params->audio, p->params->main, sizeof(p->params->main));

    const u32 num_frames = process->frames_count;
    const clap_input_events_t *in_events = process->in_events;
    u32 num_in_events = in_events != NULL ? in_events->size(in_events) : 0;

    u32 i = 0;
    u32 event_id = 0;
    u32 next_event_frame = num_in_events > 0 ? 0 : num_frames;
    while (i < num_frames) {
        while (next_event_frame == i) {
        // if (next_event_frame == i) {
            const clap_event_header_t *hdr = in_events->get(in_events, event_id);
            if (hdr && hdr->space_id == CLAP_CORE_EVENT_SPACE_ID) {
                if (hdr->time != i)
                    next_event_frame = hdr->time;
                switch (hdr->type) {
                case CLAP_EVENT_PARAM_VALUE: {
                    clap_event_param_value_t *event = (clap_event_param_value_t*)hdr;
                    dbg("Param value event: %d = %.2f", event->param_id, event->value);
                    _plugin_update_param(p, event->param_id, event->value);
                } break;
                case CLAP_EVENT_PARAM_MOD: {
                    clap_event_param_mod_t *event = (clap_event_param_mod_t*)hdr;
                    dbg("Param mod: %d += %.2f", event->param_id, event->amount);
                    _plugin_modulate_param(p, event->param_id, event->amount);
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
                               .offset = i,
                               // ISSUE This won't translate in a
                               // sample-accurate context because we're going to
                               // always start processing audio at i. So the
                               // offset needs to be relative to i, but
                               // like...we'll never have multiple events in one
                               // process call...so I guess we should only send
                               // one MIDI event per process callback??
                               // OR, we build a queue of MIDI to send per N frames
                           });
                } break;
                case CLAP_EVENT_MIDI: {
                    clap_event_midi_t *event = (clap_event_midi_t*)hdr;
                    dbg("Port: %d | %x", event->port_index, *((u32*)event->data));
                } break;
                }
                event_id++;
                if (event_id == num_in_events)
                    next_event_frame = num_frames;
            }
        }
        u32 frames_to_process = next_event_frame - i;

        AudioBuffer32 in = {
            .data = process->audio_inputs->data32,
            .num_frames = frames_to_process,
            .num_ch = process->audio_inputs->channel_count,
        };

        AudioBuffer32 out = {
            .data = process->audio_outputs->data32,
            .num_frames = frames_to_process,
            .num_ch = process->audio_outputs->channel_count,
        };

        for (u32 ch = 0; ch < in.num_ch; ++ch) {
            in.data[ch] += i;
        }

        for (u32 ch = 0; ch < out.num_ch; ++ch) {
            out.data[ch] += i;
        }

        p->user_iface.process_cb(p, in, out, p->midi);

        _midi_clear(p);
        _plugin_reset_param_changes(p);
        i += frames_to_process;
    }
    // Sync main params to audio params
    // ISSUE What if the main thread is in the middle of writing to its params?
    // We need to queue a list of changes for the main thread rather than just hard-overwriting here
    memcpy(p->params->main, p->params->audio, sizeof(p->params->audio));
    return CLAP_PROCESS_CONTINUE;
}

static const void *plugin_get_extension(const clap_plugin_t *plugin, const char *id) {
    if (const_string_match(const_string(id), const_string(CLAP_EXT_AUDIO_PORTS)))
        return &audio_port_info;
    if (((plugin_config.features & Feature_Instrument) || (plugin_config.features & Feature_Synth)) &&
            (plugin_config.note_ports.inputs > 0 || plugin_config.note_ports.outputs > 0)) {
        if (const_string_match(const_string(id), const_string(CLAP_EXT_NOTE_PORTS)))
            return &note_ports;
    }
    if (const_string_match(const_string(id), const_string(CLAP_EXT_PARAMS)))
        return &plugin_params;
    if (const_string_match(const_string(id), const_string(CLAP_EXT_STATE)))
        return &plugin_state;
    if (const_string_match(const_string(id), const_string(CLAP_EXT_LATENCY)))
        return &plugin_latency;
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
    if (const_string_match(const_string(plugin_id), const_string(clap_desc.id))) {
        Plugin *plugin = new(Plugin);
        clap_plugin_t *clap = new(clap_plugin_t);
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
    ConstString in = const_string(factory_id);
    ConstString fid = const_string(CLAP_PLUGIN_FACTORY_ID);
    if (const_string_match(in, fid)) {
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
