
typedef struct {
    float last_freq;
    float last_reso;
    int last_type;
    IIR_Filter filter[2];
} PluginData;

static void init(Plugin *plugin) {
    PluginData *data = plugin_get_user(plugin);
    *data = (PluginData) {
        .filter = {
            [0] = (IIR_Filter){
                .cutoff = get_parameter_default(plugin, Param_Freq),
                .reso = get_parameter_default(plugin, Param_Reso),
            },
            [1] = (IIR_Filter){
                .cutoff = get_parameter_default(plugin, Param_Freq),
                .reso = get_parameter_default(plugin, Param_Reso),
            },
        },
    };
}

static void deinit(Plugin *plugin) {
}

static void prepare(Plugin *plugin, f64 sample_rate, u32 max_frames) {
    PluginData *data = plugin_get_user(plugin);
    filter_set_sample_rate(&data->filter[0], sample_rate);
    filter_set_sample_rate(&data->filter[1], sample_rate);
}

static void process(Plugin *plugin, const AudioBuffer32 in_buf, AudioBuffer32 out_buf, MidiBuffer midi_buffer) {
    PluginData *data = plugin_get_user(plugin);
    u32 num_ch = in_buf.num_ch;
    u32 num_frames = in_buf.num_frames;

    float freq = get_parameter(plugin, Param_Freq);
    if (freq != data->last_freq) {
        filter_set_cutoff(&data->filter[0], freq);
        filter_set_cutoff(&data->filter[1], freq);
        data->last_freq = freq;
    }
    float reso = get_parameter(plugin, Param_Reso);
    if (reso != data->last_reso) {
        filter_set_reso(&data->filter[0], reso);
        filter_set_reso(&data->filter[1], reso);
        data->last_reso = reso;
    }
    FilterType type = (FilterType)get_parameter(plugin, Param_FilterType);
    if (type != data->last_type) {
        filter_set_type(&data->filter[0], (IIR_FilterType)type);
        filter_set_type(&data->filter[1], (IIR_FilterType)type);
        data->last_type = type;
    }

    for (u32 ch = 0; ch < num_ch; ++ch) {
        filter_process(&data->filter[ch], in_buf.data[ch], out_buf.data[ch], num_frames);
    }
}

PluginInterface plugin_create(Allocator *allocator) {
    PluginData *data = allocator->alloc(allocator, sizeof(PluginData));
    return (PluginInterface){
        .user = data,
        .init_cb = init,
        .deinit_cb = deinit,
        .prepare_cb = prepare,
        .process_cb = process,
    };
}
