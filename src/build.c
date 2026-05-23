#define APP_NAME "arbor_builder"
#include "build.h"
#include "../cbase/cbase.h"
#include "../cbase/cbase.c"
#include "config_gen.c"

#include "stdlib.h"

static Arena _arena = {0};

#define check_rebuild() _check_rebuild(argv[0], __FILE__)

static void _check_rebuild(const char *bin, const char *src) {
    if (file_mtime(bin) < file_mtime(src)) {
        // self-rebuild
        println("Recompiling build runner");

        char cmd[512] = {0};
        sprintf(cmd, "cc -o %s %s", bin, src);
        // STACK_ALLOC_BEGIN(512);
        // String cmd = string_printf(STACK_ALLOC, "cc -o %s %s", bin, src);
        // char *cstr = cstring_from_string(STACK_ALLOC, cmd);

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

static String _format_plist(PluginBuild *build) {
    STACK_ALLOC_BEGIN(512);
    String plist_path = path_join(STACK_ALLOC, (String[]){
        string(build->arbor_src_path),
        STR_LIT("macos_bundle_plist.txt"),
    }, 2);
    File fd = file_open(plist_path, FileOpen_ReadOnly);
    const char *fmt = file_read_full_alloc(fd, &_arena.allocator);
    file_close(fd);

    PluginDescription desc = build->config.desc;

    return string_printf(&_arena.allocator, fmt, desc.name, desc.id, desc.name, desc.name, desc.version,
        desc.version, desc.copyright);
}

static void install_plugin(PluginBuild *build, String output_path) {
    STACK_ALLOC_BEGIN(KB(16));
    String bundle_stem = string_split_after(output_path, '/');
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
    } else if (build->format & BuildFormat_CLAP) {
        user_plugin_dir = path_join(STACK_ALLOC, (String[]){
            string(home), STR_LIT("Library/Audio/Plug-Ins/CLAP")
        }, 2);
        plugin_ext = STR_LIT(".clap");
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
    file_copy(output_path, plugin_dest);

    // Update plugin plist
    {
        File plist_fd = file_open(plist_path, 0);
        String plist = _format_plist(build);
        file_write_string(plist_fd, plist);
        file_close(plist_fd);
    }
    // Update plugin PkgInfo file
    {
        File pkginfo_fd = file_open(pkginfo_path, 0);
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
        println("Codesigning bundle: %s", cmd);
        if (system(cmd) != 0) {
            err("Codesign failed: %s", strerror(errno));
        }
    }

    // Copy debug contents
    String dbg_src = string_concat(STACK_ALLOC, (String[]){output_path, STR_LIT(".dSYM")}, 2);
    String dbg_dst = string_concat(STACK_ALLOC, (String[]){plugin_dest, STR_LIT(".dSYM")}, 2);
    if (!file_copy_recursive(dbg_src, dbg_dst)) {
        err("Copy debug info failed\n");
    }

}

static void build_plugin(PluginBuild *build) {
    _arena = arena_init(page_size());

    if (file_exists(STR_LIT("generated/user_code.c"))) {
        if (file_mtime(build->config_file) > file_mtime("generated/user_code.c")) {
            if (config_build(build) != ParseError_None) {
                err("Config parse failed\n");
                goto cleanup;
            }
        }
    } else {
        if (config_build(build) != ParseError_None) {
            err("Config parse failed\n");
            goto cleanup;
        }
    }

    PluginDescription plugin_desc = build->config.desc;

    STACK_ALLOC_BEGIN(KB(16));

    while (build->format != 0) {
        STACK_ALLOC_RESET;
        // build plugin
        char *base_args [] = {"-shared", "-Werror", "-I./generated"};
        StringArray args = string_array_from_cstrs(STACK_ALLOC, base_args, array_len(base_args), 16);

        if (build->debug) {
            string_array_append(STACK_ALLOC, &args, STR_LIT("-g"));
        } else {
            string_array_append(STACK_ALLOC, &args, STR_LIT("-DNDEBUG"));
        }

        switch (build->optimize_mode) {
        case Optimize_Regular:
            string_array_append(STACK_ALLOC, &args, STR_LIT("-O2"));
            break;
        case Optimize_Fast:
            string_array_append(STACK_ALLOC, &args, STR_LIT("-O3"));
            break;
        case Optimize_Size:
            string_array_append(STACK_ALLOC, &args, STR_LIT("-Os"));
            break;
        default: break;
        }

        String out_path = {0};
        if (build->format & BuildFormat_VST3) {
            println("Building VST3");
            string_array_append(STACK_ALLOC, &args, STR_LIT("-DARBOR_VST3"));
            out_path = string_printf(STACK_ALLOC, ".build/%s.vst3/Contents/MacOS/%s",
                plugin_desc.name, plugin_desc.name);
        } else if (build->format & BuildFormat_CLAP) {
            println("Building CLAP");
            string_array_append(STACK_ALLOC, &args, STR_LIT("-DARBOR_CLAP"));
            out_path = string_printf(STACK_ALLOC, ".build/%s.clap/Contents/MacOS/%s",
                plugin_desc.name, plugin_desc.name);
        }
        if (make_dir(out_path)) {
            println("Created directory: %.*s", out_path.len, out_path.data);
        }
        String out_arg = string_concat(STACK_ALLOC, (String[]){STR_LIT("-o"), out_path}, 2);
        string_array_append(STACK_ALLOC, &args, out_arg);

        String args_str = string_array_flatten(STACK_ALLOC, &args);
        char cmd[512] = {0};
        string_print_buf(cmd, sizeof(cmd), "cc %.*s %s/arbor.c", args_str.len, args_str.data,
            build->arbor_src_path);

        dbg("Executing command: %s", cmd);

        int result = system(cmd);
        println("Command exited with code %d", result);
        if (result != 0) {
            err("Build command failed with code %d\n", result);
            goto cleanup;
        }

        if (build->install)
            install_plugin(build, out_path);


        if (build->format & BuildFormat_VST3) {
            build->format ^= BuildFormat_VST3;
        } else if (build->format & BuildFormat_CLAP) {
            build->format ^= BuildFormat_CLAP;
        }
    }

cleanup: {
    usize arena_mem = arena_query_capacity(&_arena);
    usize stack_mem = _sa.head;
    println("Build process finished");
    println("Arena mem: %.2fkB | Stack mem: %.2fkB", (float)arena_mem / 1024, (float)stack_mem / 1024);
    arena_deinit(&_arena);
}
}
