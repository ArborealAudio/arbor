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
    char *src_file;
    char *config_file;
    char *arbor_path;
    PluginConfig config;
    BuildFormat format;
    bool debug;
    OptimizeMode optimize_mode;
    bool install;
} PluginBuild;

static void build_plugin(PluginBuild *);
