#include "../../build.c"

int main(int argc, char *argv[]) {
    check_rebuild();

    PluginConfig plugin_config = {
        .desc = {
            .name = "Example_Distortion",
            .company = "Arboreal Audio",
            .id = "com.ArborealAudio.ExDist",
            .version = "1.0.0",
            .copyright = "(c) 2026 Arboreal Audio, LLC",
            .description = "Vintage analog warmth",
        },
        .audio_ports = {
            .inputs = 1,
            .outputs = 1,
        },
        .features = DefaultPluginFeatures,
    };

    PluginBuild build = {
        .src_file = "plugin.c",
        .config_file = "config.txt",
        .config = plugin_config,
        .arbor_path = "../..",
        .format = BuildFormat_CLAP | BuildFormat_VST3,
        .debug = true,
        .install = true,
    };

    build_plugin(&build);
}
