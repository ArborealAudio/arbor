#include "arbor.h"

typedef enum {
    Optimize_None,
    Optimize_Regular, // O2
    Optimize_Fast, // O3
    Optimize_Size, // Os
} OptimizeMode;

enum {
    BuildFormat_All,
    BuildFormat_CLAP,
    BuildFormat_VST3,
    BuildFormat_AU,
};
typedef u32 BuildFormat;

typedef struct {
    char *src_file;
    char *config_file;
    char *arbor_path;
    PluginConfig config;
    BuildFormat format;
    bool debug;
    OptimizeMode optimize_mode;
} PluginBuild;

static void build_plugin(PluginBuild *);
static void install_plugin(PluginBuild *);
