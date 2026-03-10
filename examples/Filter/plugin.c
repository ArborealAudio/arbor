#include <arbor.h>

struct {
    float last_freq;
    float last_reso;
    int last_type;
    Filter filter[2];
} g = {0};

static void init(Plugin *plugin) {
    g.filter[0] = g.filter[1] = (Filter){
        .cutoff = parameter_layout[Param_Freq].default_value,
        .reso = parameter_layout[Param_Reso].default_value,
    };
    dbg();
}

static void deinit(Plugin *plugin) {
    dbg();
}

static void prepare(Plugin *plugin, f64 sample_rate, u32 max_frames, u32 num_ch) {
    filter_set_sample_rate(&g.filter[0], sample_rate);
    filter_set_sample_rate(&g.filter[1], sample_rate);
}

static void process(Plugin *plugin, const AudioBuffer32 in_buf, AudioBuffer32 out_buf, MidiBuffer midi_buffer) {
    u32 num_ch = in_buf.num_ch;
    u32 num_frames = in_buf.num_frames;

    float freq = get_parameter(plugin, Param_Freq);
    if (freq != g.last_freq) {
        filter_set_cutoff(&g.filter[0], freq);
        filter_set_cutoff(&g.filter[1], freq);
        g.last_freq = freq;
    }
    float reso = get_parameter(plugin, Param_Reso);
    if (reso != g.last_reso) {
        filter_set_reso(&g.filter[0], reso);
        filter_set_reso(&g.filter[1], reso);
        g.last_reso = reso;
    }
    Type type = (Type)get_parameter(plugin, Param_FilterType);
    if (type != g.last_type) {
        filter_set_type(&g.filter[0], (FilterType)type);
        filter_set_type(&g.filter[1], (FilterType)type);
        g.last_type = type;
    }

    for (u32 ch = 0; ch < num_ch; ++ch) {
        filter_process(&g.filter[ch], in_buf.data[ch], out_buf.data[ch], num_frames);
    }
}

PluginInterface plugin_create() {
    return (PluginInterface){
        .init_cb = init,
        .deinit_cb = deinit,
        .prepare_cb = prepare,
        .process_cb = process,
    };
}
