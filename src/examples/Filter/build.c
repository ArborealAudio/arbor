#include "../../build.c"

int main(int argc, char *argv[]) {
    check_rebuild();

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
        .features = DefaultPluginFeatures,
    };

    PluginBuild pb = {
        .src_file = "filter.c",
        .config_file = "config.txt",
        .config = plugin_config,
        .arbor_path = "../..",
        .format = BuildFormat_VST3 | BuildFormat_CLAP,
        .debug = true,
        .install = true,
    };

    build_plugin(&pb);
}
