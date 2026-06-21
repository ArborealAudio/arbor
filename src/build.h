#include "arbor.h"

typedef enum {
    Optimize_None,
    Optimize_Regular, // O2
    Optimize_Fast, // O3
    Optimize_Size, // Os
} OptimizeMode;

enum {
    BuildFormat_All = 0,
    BuildFormat_CLAP = 1 << 0,
    BuildFormat_VST3 = 1 << 1,
    BuildFormat_AU = 1 << 2,
};
typedef u32 BuildFormat;

typedef struct {
    const char *src_file;
    const char *config_file;
    const char *arbor_src_path;
    PluginConfig config;
    BuildFormat format;
    bool32 debug;
    OptimizeMode optimize_mode;
    bool32 install;
} PluginBuild;

static void build_plugin(PluginBuild *);
