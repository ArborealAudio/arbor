#define APP_NAME "arbor_builder"
#include "build.h"
#include "../cbase/cbase.h"
#include "../cbase/cbase.c"
#include "config_gen.c"

#include "stdlib.h"

static struct {
    String output_path;
} _post_build;

static Arena _arena = {0};

#define check_rebuild() _check_rebuild(argv[0], __FILE__)

static void _check_rebuild(const char *bin, const char *src) {
    // NOTE We also need to check if user config file has changed, since that drives codegen
    if (file_mtime(bin) < file_mtime(src)) {
        // self-rebuild
        println("Recompiling build runner");

        char cmd[512] = {0};
        sprintf(cmd, "cc -o %s %s", bin, src);

        println("Executing self-build: %s", cmd);

        if (system(cmd) != 0) {
            err("Self-build failed\n");
            exit(1);
        }

        if (system(bin) != 0) {
            err("Compilation failed\n");
            exit(1);
        }

        exit(0);
    }
}

static void build_plugin(PluginBuild *build) {
    _arena = arena_init(page_size());
    STACK_ALLOC_BEGIN(KB(16));
    config_build(build);

    PluginDescription plugin_desc = build->config.desc;

    // build plugin
    char *base_args [] = {"-shared", "-Werror", "-I./generated"};
    StringArray args = string_array_from_cstrs(STACK_ALLOC, base_args, array_len(base_args), 16);

    if (build->debug) {
        string_array_append(STACK_ALLOC, &args, STR_LIT("-g"));
    }

    String out_path = {0};
    if (build->format & BuildFormat_VST3) {
        string_array_append(STACK_ALLOC, &args, STR_LIT("-DARBOR_VST3"));
        out_path = string_printf(STACK_ALLOC, ".build/%s.vst3/Contents/MacOS/%s",
            plugin_desc.name, plugin_desc.name);
    }
    _post_build.output_path = string_clone(&_arena.allocator, out_path);
    if (make_dir(out_path)) {
        println("Created directory: %.*s", out_path.len, out_path.data);
    }
    String out_arg = string_concat(STACK_ALLOC, (String[]){STR_LIT("-o"), out_path}, 2);
    string_array_append(STACK_ALLOC, &args, out_arg);

    String args_str = string_array_flatten(STACK_ALLOC, &args);
    char cmd[512] = {0};
    string_print_buf(cmd, sizeof(cmd), "cc %.*s %s/arbor.c", args_str.len, args_str.data,
        build->arbor_path);

    dbg("Executing command: %s", cmd);

    int result = system(cmd);
    println("Command exited with code %d", result);
    if (result != 0) {
        err("Build command failed with code %d\n", result);
    }
}

static String _format_plist(PluginBuild *build) {
    STACK_ALLOC_BEGIN(512);
    String plist_path = path_join(STACK_ALLOC, (String[]){
        string(build->arbor_path),
        STR_LIT("macos_bundle_plist.txt"),
    }, 2);
    File fd = file_open(string_to_cstring(STACK_ALLOC, plist_path), FileOpen_ReadOnly);
    const u8 *fmt = file_read_full_alloc(fd, &_arena.allocator);
    file_close(fd);

    PluginDescription desc = build->config.desc;

    return string_printf(&_arena.allocator, fmt, desc.name, desc.id, desc.name, desc.name, desc.version,
        desc.version, desc.copyright);

}

static void install_plugin(PluginBuild *build) {
    STACK_ALLOC_BEGIN(KB(16));
    String output_path = _post_build.output_path;
    String bundle_stem = {0};
    // chop .build dir
    for (int i = 0; i < output_path.len; ++i) {
        if (output_path.data[i] == '/') {
            bundle_stem.data = output_path.data + i + 1;
            bundle_stem.len = output_path.len - i;
            break;
        }
    }
    // Get system plugin dir
    char *home = getenv("HOME");
    String user_plugin_dir = {0};
    String plugin_dest = {0};
    String plugin_ext = {0};
    if (build->format & BuildFormat_VST3) {
        user_plugin_dir = path_join(STACK_ALLOC, (String[]){
            string(home), STR_LIT("Library/Audio/Plug-Ins/VST3")
        }, 2);
        plugin_ext = STR_LIT(".vst3");
    }
    plugin_dest = path_join(STACK_ALLOC, (String[]){
        user_plugin_dir, bundle_stem
    }, 2);
    String bin_dir = string_clone(STACK_ALLOC, plugin_dest);
    String bin_name = path_split(&bin_dir);
    String contents_dir = string_clone(STACK_ALLOC, bin_dir);
    path_split(&contents_dir);

    String plist_path = path_join(STACK_ALLOC, (String[]){
        contents_dir, STR_LIT("Info.plist")
    }, 2);
    String pkginfo_path = path_join(STACK_ALLOC, (String[]){
        contents_dir, STR_LIT("PkgInfo")
    }, 2);

    if (make_dir(bin_dir)) {
        println("Created bundle directory: %.*s", bin_dir.len, bin_dir.data);
    }

    // Update plugin binary
    println("Installing plugin file @ %.*s", plugin_dest.len, plugin_dest.data);
    File src = file_open(string_to_cstring(STACK_ALLOC, _post_build.output_path), FileOpen_ReadOnly);
    File dest = file_open(string_to_cstring(STACK_ALLOC, plugin_dest), 0);
    file_copy(&_arena.allocator, src, dest);
    file_close(src);
    file_close(dest);

    // Update plugin plist
    {
        File plist_fd = file_open(string_to_cstring(STACK_ALLOC, plist_path), 0);
        String plist = _format_plist(build);
        file_write_string(plist_fd, plist);
        file_close(plist_fd);
    }
    // Update plugin PkgInfo file
    {
        File pkginfo_fd = file_open(string_to_cstring(STACK_ALLOC, pkginfo_path), 0);
        file_write_string(pkginfo_fd, STR_LIT("BNDL????"));
        file_close(pkginfo_fd);
    }

    // Codesign bundle
    {
        String bundle_dir = path_join(STACK_ALLOC, (String[]){
            user_plugin_dir, string_concat(STACK_ALLOC, (String[]){
                string(build->config.desc.name), plugin_ext
            }, 2)
        }, 2);
        // NOTE: stb_sprintf dropping the ball here for some reason
        // String cmd = string_printf(STACK_ALLOC, "codesign -f -s - %.*s", bundle_dir.len, bundle_dir.data);
        char *cmd = STACK_ALLOC->alloc(STACK_ALLOC, bundle_dir.len * 2);
        sprintf(cmd, "codesign -f -s - %.*s", bundle_dir.len, bundle_dir.data);
        // char *cstr = string_to_cstring(STACK_ALLOC, cmd);
        println("Codesigning bundle: %s", cmd);
        if (system(cmd) != 0) {
            err("Codesign failed: %s", strerror(errno));
        }
    }

    // Copy debug contents
    char copy_cmd[256] = {0};
    sprintf(copy_cmd, "cp -r %.*s.dSYM ~/.%.*s/", output_path.len, output_path.data,
        plugin_ext.len, plugin_ext.data);
    if (system(copy_cmd) != 0) {
        err("Copy debug info failed: %s", strerror(errno));
    }

    arena_deinit(&_arena);
}
