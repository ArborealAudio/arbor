#include <arbor.h>

enum {
    Param_Gain,
    Param_Out,
    Param_SatMode,
    Param_Mondo,
    Param_Count,
};

typedef enum {
    Vintage,
    Modern,
    Apocalypse,
    ModesCount,
} Mode;

String mode_names[ModesCount] = {
    STR_LIT("Vintage"),
    STR_LIT("Modern"),
    STR_LIT("Apocalypse"),
};

static void db_param_print(Parameter *p, f32 value, char *buf, u32 buf_size) {
    string_print_buf(buf, buf_size, "%.2f dB", value);
}

Parameter parameter_layout[Param_Count] = {
    [Param_Gain] = {
        .name = STR_LIT("Gain"),
        .type = ParameterType_Float,
        .value_to_text = db_param_print,
        .min_value = 0,
        .max_value = 48,
        .default_value = 0,
    },
    [Param_Out] = {
        .name = STR_LIT("Out"),
        .type = ParameterType_Float,
        .value_to_text = db_param_print,
        .min_value = -24,
        .max_value = 24,
        .default_value = 0,
    },
    [Param_SatMode] = {
        .name = STR_LIT("Sat Mode"),
        .choices = (StringArray){mode_names, ModesCount},
        .type = ParameterType_Choice,
        .min_value = Vintage,
        .max_value = Apocalypse,
        .default_value = Vintage,
    },
    [Param_Mondo] = {
        .name = STR_LIT("Mondo!"),
        .type = ParameterType_Bool,
        .default_value = FALSE,
    },
};

PluginConfig plugin_config = {
    .desc = {
        .name = "Example_Distortion",
        .id = "com.ArborealAudio.ExDist",
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
