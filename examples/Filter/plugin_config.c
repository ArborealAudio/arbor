#include <arbor.h>

enum {
    Param_Freq,
    Param_Reso,
    Param_FilterType,
    Param_Count,
};

typedef enum {
    Lowpass,
    Highpass,
    Bandpass,
    Type_Count,
} Type;

static String type_names[Type_Count] = {
    STR_LIT("Lowpass"),
    STR_LIT("Highpass"),
    STR_LIT("Bandpass"),
};

static void freq_param_print(Parameter *p, f32 value, char *buf, u32 buf_size) {
    string_print_buf(buf, buf_size, "%$.2fHz", value);
}

Parameter parameter_layout[Param_Count] = {
    [Param_Freq] = {
        .name = STR_LIT("Freq"),
        .type = ParameterType_Float,
        .value_to_text = freq_param_print,
        .min_value = 20,
        .max_value = 20e3,
        .default_value = 1500,
    },
    [Param_Reso] = {
        .name = STR_LIT("Reso"),
        .type = ParameterType_Float,
        .min_value = 0.1,
        .max_value = 32,
        .default_value = SQRT1_2,
    },
    [Param_FilterType] = {
        .name = STR_LIT("Type"),
        .type = ParameterType_Choice,
        .choices = {type_names, Type_Count},
        .min_value = Lowpass,
        .max_value = Bandpass,
        .default_value = Lowpass,
    },
};

PluginConfig plugin_config = {
    .desc = {
        .name = "Example_Filter",
        .id = "com.ArborealAudio.ExFilt",
        .company = "Arboreal Audio",
        .version = "1.0.0",
        .copyright = "(c) 2026 Arboreal Audio, LLC",
        .description = "Vintage analog warmth",
    },
    .audio_ports = {
        .inputs = 1, .outputs = 1,
    },
    // .note_ports = {
    //     .inputs = 1,
    // },
    .features = DefaultPluginFeatures,
    .parameter_layout = parameter_layout,
};
