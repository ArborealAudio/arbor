#include <arbor.h>
#include "math.h"

static void init(Plugin *plugin) {
    dbg();
}

static void deinit(Plugin *plugin) {
    dbg();
}

static void prepare(Plugin *plugin, f64 sample_rate, u32 max_frames) {}

static void process(Plugin *plugin, const AudioBuffer32 in_buf, AudioBuffer32 out_buf, MidiBuffer midi_buffer) {
    const float gain = powf(10.f, get_parameter(plugin, Param_Gain) / 20.f);
    const float out_gain = powf(10.f, get_parameter(plugin, Param_Out) / 20.f);
    const float ceil = (bool32)get_parameter(plugin, Param_Mondo) ? 0.05f : 1.f;
    const Mode sat_mode = (Mode)get_parameter(plugin, Param_SatMode);

    u32 num_ch = in_buf.num_ch;
    u32 num_frames = in_buf.num_frames;

    for (int ch = 0; ch < num_ch; ++ch) {
        const float *in = in_buf.data[ch];
        float *out = out_buf.data[ch];
        for (int i = 0; i < num_frames; ++i) {
            float y = in[i];
            y *= gain;
            if (y > ceil)
                y = ceil;
            if (y < -ceil)
                y = -ceil;
            y /= ceil;
            switch (sat_mode) {
            case Vintage:
                if (y < 0) {
                    y = (3.f/2.f) * (y - (y*y*y) / 3.f);
                } else {
                    y = tanhf(y) * (3.f/2.f);
                }
                break;
            case Modern:
                y = (5.f/4.f) * (y - (y*y*y*y*y) / 5.f);
                break;
            case Apocalypse:
                y *= 1.5;
                y -= fabsf(sinf(y / M_2_SQRTPI));
                y += fabsf(sinf(y / M_PI));
                y = 2.f * sinf(y / (2 * M_PI));
                break;
            default: break;
            }
            y /= gain;
            y *= out_gain;
            out[i] = y;
        }
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
