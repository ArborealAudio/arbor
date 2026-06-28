#define APP_NAME "arbor_builder"
#include "build.h"
#include "../cbase/cbase.h"
#include "../cbase/cbase.c"

#include "stdlib.h"

static Arena *_arena;

#define check_rebuild() _check_rebuild(string(argv[0]), STR_LIT(__FILE__))

static void _check_rebuild(String bin, String src) {
    if (file_mtime(bin) < file_mtime(src)) {
        // self-rebuild
        println("Recompiling build runner");

        char cmd[512] = {0};
        sprintf(cmd, "cc -o %.*s %.*s", bin.len, bin.data, src.len, src.data);
        // STACK_ALLOC_BEGIN(512);
        // String cmd = string_printf(STACK_ALLOC, "cc -o %s %s", bin, src);
        // char *cstr = cstring_from_string(STACK_ALLOC, cmd);

        println("Executing self-build: %s", cmd);

        if (system(cmd) != 0) {
            err("Self-build failed\n");
            exit(1);
        }

        STACK_ALLOC_BEGIN(512);
        const char *cstr_bin = cstring_from_string(STACK_ALLOC, bin);
        if (system(cstr_bin) != 0) {
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
    const char *fmt = file_read_full_alloc(fd, &_arena->allocator);
    file_close(fd);

    PluginDescription desc = build->config.desc;

    return string_printf(&_arena->allocator, fmt, desc.name, desc.id, desc.name, desc.name, desc.version,
        desc.version, desc.copyright);
}

static void install_plugin(PluginBuild *build, String output_path) {
    STACK_ALLOC_BEGIN(KB(16));
    String bundle_stem = string_split_after(output_path, '/');
    // Get system plugin dir
    const char *home = getenv("HOME");
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

typedef enum {
    ParseError_None,
    ParseError_InvalidToken,
    ParseError_ExpectedNewline,
    ParseError_MaxNodesReached,
    ParseError_FilesystemError,
} ParseError;

static ParseError config_build(PluginBuild *build);

static void build_plugin(PluginBuild *build) {
    _arena = arena_init();

    if (file_exists(STR_LIT("generated/user_code.c"))) {
        if (file_mtime(string(build->config_file)) > file_mtime(STR_LIT("generated/user_code.c"))) {
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

    while (build->format != 0) {
        TempAlloc tmp = temp_alloc_begin(_arena);
        Allocator *alloc = &_arena->allocator;
        // build plugin
        const char *base_args [] = {"-shared", "-Werror", "-I./generated",
            /* TODO factor these out */ "-ObjC", "-framework Cocoa"};
        StringArray args = string_array_from_cstrs(alloc, base_args, array_len(base_args), 16);

        if (build->debug) {
            string_array_append(alloc, &args, STR_LIT("-g"));
        } else {
            string_array_append(alloc, &args, STR_LIT("-DNDEBUG"));
        }

        switch (build->optimize_mode) {
        case Optimize_Regular:
            string_array_append(alloc, &args, STR_LIT("-O2"));
            break;
        case Optimize_Fast:
            string_array_append(alloc, &args, STR_LIT("-O3"));
            break;
        case Optimize_Size:
            string_array_append(alloc, &args, STR_LIT("-Os"));
            break;
        default: break;
        }

        String out_path = {0};
        if (build->format & BuildFormat_VST3) {
            println("Building VST3");
            string_array_append(alloc, &args, STR_LIT("-DARBOR_VST3"));
            out_path = string_printf(alloc, ".build/%s.vst3/Contents/MacOS/%s",
                plugin_desc.name, plugin_desc.name);
        } else if (build->format & BuildFormat_CLAP) {
            println("Building CLAP");
            string_array_append(alloc, &args, STR_LIT("-DARBOR_CLAP"));
            out_path = string_printf(alloc, ".build/%s.clap/Contents/MacOS/%s",
                plugin_desc.name, plugin_desc.name);
        }
        if (make_dir(out_path)) {
            println("Created directory: %.*s", out_path.len, out_path.data);
        }
        String out_arg = string_concat(alloc, (String[]){STR_LIT("-o"), out_path}, 2);
        string_array_append(alloc, &args, out_arg);

        String args_str = string_array_flatten(alloc, &args);
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

        temp_alloc_end(&tmp);
    }

cleanup: {
    usize arena_mem = arena_query_size(_arena);
    println("Build process finished");
    println("Arena mem: %.2fkB", (float)arena_mem / 1024);
    arena_deinit(_arena);
}
}

// Config generation

typedef enum {
    Token_Invalid,
    Token_Identifier,
    Token_True,
    Token_False,
    Token_Number,
    Token_Equal,
    Token_OpenBrace,
    Token_CloseBrace,
    Token_OpenBracket,
    Token_CloseBracket,
    Token_Newline,
    TokenTypeCount,
} TokenType;

static const char *token_type_names[] = {
    "Invalid",
    "Identifier",
    "Number",
    "Equal",
    "OpenBrace",
    "CloseBrace",
    "OpenBracket",
    "CloseBracket",
    "Newline",
};

typedef struct {
    TokenType type;
    u32 offset;
} Token;

static Token tokens[1024];
static u32 token_head = 0;

typedef enum {
	Node_Invalid,
	Node_ParamDecl,
	Node_ParamProperty,
	Node_ParamPropertyValue,
	Node_ListItem,
} NodeType;

static const char *node_type_names[] = {
	"Invalid",
	"ParamDecl",
	"ParamProperty",
	"ParamPropertyValue",
	"ListItem",
};

typedef enum {
	ParamField_None,
	ParamField_Name,
	ParamField_Type,
	ParamField_Default,
	ParamField_Min,
	ParamField_Max,
	ParamField_Choices,
	ParamField_Count,
} ParamField;

static char *param_fields[ParamField_Count] = {
	"",
	"name",
	"type",
	"default",
	"min",
	"max",
	"choices",
};

static ParamField match_param_field(String identifier) {
	for (int i = 1; i < ParamField_Count; ++i) {
		if (string_match(string(param_fields[i]), identifier)) {
			return i;
		}
	}
	return ParamField_None;
}

typedef enum {
	ParamType_None,
	ParamType_Float,
	ParamType_Int,
	ParamType_Choice,
	ParamType_Bool,
	ParamType_Count,
} ParamType;

static char *param_types[ParamType_Count] = {
	"",
	"Float",
	"Int",
	"Choice",
	"Bool",
};

static char *param_types_output[ParamType_Count] = {
	"",
	"ParameterType_Float",
	"ParameterType_Int",
	"ParameterType_Choice",
	"ParameterType_Bool",
};

static ParamType match_param_type(String identifier) {
	for (int i = 1; i < ParamType_Count; ++i) {
		if (string_match(string(param_types[i]), identifier)) {
			return i;
		}
	}
	return ParamType_None;
}


typedef struct {
	NodeType type;
	u32 token_id;
	u32 parent;
	u32 first;
	u32 last;
	u32 next;

	// If the node is corresponds to a parameter field declaration, this should be non-zero
	ParamField param_field;
	// If the node is corresponds to a parameter type declaration, this should be non-zero.
	// `param_field` should be set to ParamField_Type
	ParamType param_type;
} Node;

#define MAX_NODES 512
static Node nodes[MAX_NODES] = {
	[0] = {0},
};

// State to handle conversion of tokens into parsed data fields
static struct {
	enum {
		Parse_Init, // Intial state / finished a param expression
		Parse_Parameter, // Parsing inside a parameter expression
		Parse_ParameterProperty, // Parsing a parameter property, expect a value
		Parse_ListItem,
		Parse_Error, // Invalid token sequence
	} state;
	u32 head;
	TokenType last_token;
	u32 parent_stack[8];
	u32 parent_stack_head;
} parser = {0};

// Global reference to user config data
static char *config_data;

static Node *get_node(u32 id) {
	if (id >= parser.head || id == 0)
		return NULL;

	return &nodes[id];
}

static Node *get_last_node() {
	return &nodes[parser.head];
}

static u32 parser_get_parent() {
	if (parser.parent_stack_head) {
		u32 id = parser.parent_stack[parser.parent_stack_head-1];
		return id;
	}
	return 0;
}

static void parser_push_parent(u32 id) {
	parser.parent_stack[parser.parent_stack_head++] = id;
}

static void parser_pop_parent() {
	parser.parent_stack[parser.parent_stack_head--] = 0;
}

static Node *parser_get_last_param_decl() {
    if (!parser.head)
        return NULL;
    u32 i = parser.head - 1;
    while (i > 0) {
        Node *node = get_node(i);
        if (node->type == Node_ParamDecl)
            return node;
        i = node->parent;
    }

    return NULL;
}

static ParseError parser_push_node(NodeType node_type, u32 token_id) {
	const u32 id = parser.head;
	Node node = (Node){
		.type = node_type,
		.token_id = token_id,
	};
	u32 parent = parser_get_parent();
	node.parent = parent;
	switch (node_type) {
	case Node_ParamDecl: {
	    assert(!parent);
		// Get last param decl, if there is one
		Node *last_param_decl = parser_get_last_param_decl();
  		if (last_param_decl) {
 			last_param_decl->next = id; // link ourselves to previous sibling
  		}
  		parser_push_parent(id);
	} break;
    case Node_ParamProperty: {
        if (parent) {
    	    u32 last = get_node(parent)->last;
    		if (last) {
    		    get_node(last)->next = id;
    		}
    		parser_push_parent(id);
        }
    } break;
	case Node_ParamPropertyValue: break;
	case Node_ListItem: {
	    if (parent) {
       	    u32 last = get_node(parent)->last;
    		if (last) {
    			get_node(last)->next = id; // link ourselves to previous sibling
    		}
		}
	} break;
	case Node_Invalid: {
		Token t = tokens[node.token_id];
		// TODO Improve error messages
		println("Error: invalid node @ byte %d", t.offset);
		return ParseError_InvalidToken;
	} break;
	}
	if (id >= MAX_NODES) {
		return ParseError_MaxNodesReached;
	}

	// Link ourselves to parent
	if (parent) {
		Node *ptr = get_node(parent);
		if (!ptr->first)
			ptr->first = id;
		ptr->last = id;
	}
	nodes[parser.head] = node;
	parser.head += 1;

	return ParseError_None;
}

static bool32 is_whitespace(const u8 c) {
	return (c == ' ' || c == '\t');
}

static bool32 is_numeric(const u8 c) {
	return (c >= '0' && c <= '9');
}

static bool32 is_alpha(const u8 c) {
	return (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z');
}

// TODO Support printing string literals i.e. stuff w/ spaces in it
// may necessitate a new kind of token that includes the quotes as its data, is treated a little differently
static String get_identifier(const char *token_start) {
	u32 len = 0, i = 0;
	while (TRUE) {
		const u8 c = token_start[i];
		if (is_whitespace(c) || c == '\n') {
			break;
		}
		++i, ++len;
	}

	return (String){.data = (char*)token_start, .len = len};
}

static String node_get_identifier(Node *n) {
    return get_identifier(config_data + tokens[n->token_id].offset);
}

static String node_get_parameter_name(Node *n) {
    if (n->type == Node_ParamDecl || n->param_field == ParamField_Name)
        return node_get_identifier(n);

	// search siblings
	u32 parent = n->parent;
	if (parent) {
    	Node *first_child = get_node(get_node(parent)->first);
    	for (Node *node = first_child; node != NULL; node = get_node(node->next)) {
    		if (n->type == Node_ParamDecl || n->param_field == ParamField_Name)
    			return node_get_identifier(node);
    	}
	}

	// Check parent
    while (parent) {
        Node *ptr = get_node(parent);
    	if (ptr->type == Node_ParamDecl || ptr->param_field == ParamField_Name) {
    	    return node_get_identifier(ptr);
    	}
        parent = ptr->parent;
    }

	return (String){0};
}

static ParamType node_get_parameter_type(Node *n) {
    assert(n->type == Node_ParamDecl);
    for (Node *child = get_node(n->first); child != NULL; child = get_node(child->next)) {
        if (child->type == Node_ParamProperty && child->param_field == ParamField_Type) {
            return get_node(child->first)->param_type;
        }
    }

    return ParamType_None;
}

// Given a param declaration node, get the property node which holds choices, if it exists
static Node *node_get_choices(Node *n) {
    assert(n->type == Node_ParamDecl);
    for (Node *node = get_node(n->first); node != NULL; node = get_node(node->next)) {
        if (node->type == Node_ParamProperty && node->param_field == ParamField_Choices) {
            return node;
        }
    }

    return NULL;
}

// Checks whether node has a child or sibling which provides a parameter name
static bool32 node_has_field(Node *node, ParamField field) {
    if (node->param_field == field)
        return TRUE;
    // Search siblings
    u32 parent = node->parent;
    if (parent) {
        for (Node *child = get_node(get_node(parent)->first); child != NULL; child = get_node(child->next)) {
            if (child->param_field == field)
                return TRUE;
        }
    }

    for (Node *child = get_node(node->first); child != NULL; child = get_node(child->next)) {
        if (child->param_field == field)
            return TRUE;
    }

    return FALSE;
}

static void print_parameter_data(File f, Allocator *alloc, Node *root) {
    switch (root->type) {
    case Node_ParamDecl: {
        ParamType type = node_get_parameter_type(root);
        String type_name = node_get_parameter_name(root);
        String field_name = string_to_snake_case(alloc, type_name);
        switch (type) {
        case ParamType_Choice:
            file_printf(f, alloc, "\t%.*s %.*s;\n", type_name.len, type_name.data, field_name.len, field_name.data);
            break;
        case ParamType_Bool:
            file_printf(f, alloc, "\tbool32 %.*s;\n", field_name.len, field_name.data);
            break;
        case ParamType_Float:
            file_printf(f, alloc, "\tfloat %.*s;\n", field_name.len, field_name.data);
            break;
        case ParamType_Int:
            file_printf(f, alloc, "\tint %.*s;\n", field_name.len, field_name.data);
            break;
        default: break;
        }
    } break;
    default: break;
    }
}

static void print_parameter_info(File f, Allocator *alloc, Node *root) {
	String data = node_get_identifier(root);
	dbg("Printing node data: %.*s", data.len, data.data);
	switch (root->type) {
	case Node_ParamDecl:
		file_printf(f, alloc, "\t[Param_%.*s] = {\n", data.len, data.data);
		if (!node_has_field(root, ParamField_Name)) {
		    file_printf(f, alloc, "\t\t.name = STR_LIT(\"%.*s\"),\n", data.len, data.data);
		}
		if (!node_has_field(root, ParamField_Min)) {
		    if (node_get_parameter_type(root) == ParamType_Bool) {
				file_write_string(f, STR_LIT("\t\t.min_value = FALSE,\n"));
			} else {
    			Node *choices = node_get_choices(root);
    			Node *min = get_node(choices->first);
    			String min_value = node_get_identifier(min);
                if (string_match(min_value, STR_LIT("false"))) {
                    min_value = STR_LIT("FALSE");
                }
    			file_printf(f, alloc, "\t\t.min_value = %.*s,\n", min_value.len, min_value.data);
			}
		}
		if (!node_has_field(root, ParamField_Max)) {
    		if (node_get_parameter_type(root) == ParamType_Bool) {
				file_write_string(f, STR_LIT("\t\t.max_value = TRUE,\n"));
			} else {
    			Node *choices = node_get_choices(root);
    			Node *max = get_node(choices->last);
    			String max_value = node_get_identifier(max);
    			file_printf(f, alloc, "\t\t.max_value = %.*s,\n", max_value.len, max_value.data);
			}
		}
		break;
	case Node_ParamProperty: {
		ParamField field_type = root->param_field;
		switch (field_type) {
		case ParamField_Min: {
            String field = STR_LIT("\t\t.min_value = ");
			file_write_string(f, field);
		} break;
		case ParamField_Max: {
			String field = STR_LIT("\t\t.max_value = ");
			file_write_string(f, field);
		} break;
		case ParamField_Default: {
			String field = STR_LIT("\t\t.default_value = ");
			file_write_string(f, field);
		} break;
		case ParamField_Choices: {
		    String param_name = node_get_parameter_name(root);
			file_printf(f, alloc, "\t\t.choices = (StringArray){%.*s_names, %.*s_Count},\n", param_name.len,
    			param_name.data, param_name.len, param_name.data);
		} break;
		default:
		    file_printf(f, alloc, "\t\t.%.*s = ", data.len, data.data);
			break;
		}
	} break;
	case Node_ParamPropertyValue: {
		Node *parent = get_node(root->parent);
		assert(parent && parent->type == Node_ParamProperty);
		ParamField parent_param_field = parent->param_field;
		switch (parent_param_field) {
		case ParamField_Type:
			file_printf(f, alloc, "%s,\n", param_types_output[root->param_type]);
			break;
		case ParamField_Name:
			file_printf(f, alloc, "STR_LIT(\"%.*s\"),\n", data.len, data.data);
			break;
       	case ParamField_Choices: break;
		default:
		    if (string_match(data, STR_LIT("true"))) {
		        file_printf(f, alloc, "TRUE,\n");
		    } else if (string_match(data, STR_LIT("false"))) {
		        file_printf(f, alloc, "FALSE,\n");
		    } else {
                file_printf(f, alloc, "%.*s,\n", data.len, data.data);
			}
		    break;
		}
	} break;
	default: break;
	}

	for (Node *node = get_node(root->first); node != NULL; node = get_node(node->next)) {
		print_parameter_info(f, alloc, node);
	}

	if (root->type == Node_ParamDecl) {
		String close = STR_LIT("\t},\n");
		file_write_string(f, close);
	}
}

static u32 hash_plugin_id(const char *plugin_id) {
    u32 hash = 0x311311;
    int len = string_len(plugin_id);
    for (int i = 0; i < len; ++i) {
        hash = (hash ^ plugin_id[i]) * 0x01000193;
    }

    return hash;
}

static ParseError config_build(PluginBuild *build) {
    Allocator *alloc = &_arena->allocator;
    File user_config_fd = file_open(string(build->config_file), FileOpen_ReadOnly);
    char *const data = file_read_full_alloc(user_config_fd, alloc);
    config_data = data;
    file_close(user_config_fd);

    ParseError result = ParseError_None;

    struct {
        enum {
            TokenState_Normal,
            TokenState_Number,
        } state;
    } ts = {.state = TokenState_Normal};

	#define push_token(Type) tokens[token_head++] = (Token){(Type), i}

	//
	// TOKENIZATION
	//
	for (u32 i = 0; i < user_config_fd.size; ++i) {
        while (is_whitespace(data[i])) {
            i++;
        }
        u8 c = data[i];
        if (is_numeric(c)) {
            if (ts.state != TokenState_Number) {
                ts.state = TokenState_Number;
                push_token(Token_Number);
            }
            // consume remaining number
        	while (is_numeric(c))
        		c = data[++i];
        } else if (is_alpha(c)) {
            if (string_match(STR_LIT("TRUE"), (String){data + i, 4})) {
                push_token(Token_True);
            } else if (string_match(STR_LIT("FALSE"), (String){data + i, 5})) {
                push_token(Token_False);
            } else {
                push_token(Token_Identifier);
            }
            // consume remaining identifier
        	while (is_alpha(c))
        		c = data[++i];
        }
        switch (c) {
        case '.': {
            if (ts.state != TokenState_Number)
                push_token(Token_Invalid);
        } break;
        case '-': {
            if (is_numeric(data[i + 1])) {
                push_token(Token_Number);
                ts.state = TokenState_Number;
            } else {
                push_token(Token_Invalid);
            }
        } break;
        case '=': {
            push_token(Token_Equal);
        } break;
        case '{': {
            push_token(Token_OpenBrace);
        } break;
        case '}': {
            push_token(Token_CloseBrace);
        } break;
        case '[': {
            push_token(Token_OpenBracket);
        } break;
        case ']': {
            push_token(Token_CloseBracket);
        } break;
		case '"': {
			u32 j = i;
			c = data[++j];
			for (; is_alpha(c) || is_numeric(c) || c == ' '; c = data[++j]);
			if (c == '"') {
				push_token(Token_Identifier);
			} else
				push_token(Token_Invalid);
			i = j;
		} break;
        case '\n': {
            if (ts.state == TokenState_Number)
                ts.state = TokenState_Normal;
        	push_token(Token_Newline);
    	} break;
        }
    }

    #if !defined(NDEBUG)
    for (u32 i = 0; i < token_head; ++i) {
		Token *t = &tokens[i];
    	dbg("%s @ %d: ", token_type_names[t->type], t->offset);
    	string_println(get_identifier(data + t->offset));
    }
    #endif

    //
    // PARSING
    //
	#define eat_token() t++
	#define check_token(Type) (t->type == (Type))

	parser.head = 1;
	Token *t = &tokens[0];
	for (u32 i = 0; i < token_head; ++i) {
		if (parser.state == Parse_Error) {
			print("Parse error: %d", result);
			string_println(get_identifier(data + t->offset));
			return result;
		}
		t = &tokens[i];
		switch (t->type) {
		case Token_Identifier:
			switch (parser.state) {
			case Parse_Init:
				// Parameter name
				if (eat_token(), check_token(Token_OpenBrace)) {
					parser_push_node(Node_ParamDecl, i);
					parser.state = Parse_Parameter;
				}
				break;
			case Parse_Parameter:
				// Parameter property name
				parser_push_node(Node_ParamProperty, i);
				parser.state = Parse_ParameterProperty;
				break;
			case Parse_ParameterProperty:
				parser_push_node(Node_ParamPropertyValue, i);
				if (eat_token(), check_token(Token_Newline)) {
					parser.state = Parse_Parameter;
					parser_pop_parent();
				} else {
				    result = ParseError_ExpectedNewline;
					parser.state = Parse_Error;
				}
				break;
			case Parse_ListItem:
				parser_push_node(Node_ListItem, i);
				if (eat_token(), !check_token(Token_Newline)) {
                    result = ParseError_ExpectedNewline;
					parser.state = Parse_Error;
				}
				break;
			default: break;
			}
			break;
		case Token_True:
		case Token_False:
		    if (parser.state == Parse_ParameterProperty) {
				parser_push_node(Node_ParamPropertyValue, i);
				if (eat_token(), check_token(Token_Newline)) {
				    parser.state = Parse_Parameter;
					parser_pop_parent();
				} else {
                    result = ParseError_ExpectedNewline;
				    parser.state = Parse_Error;
				}
			}
		    break;
		case Token_Number:
			if (parser.state == Parse_ParameterProperty) {
				parser_push_node(Node_ParamPropertyValue, i);
				if (eat_token(), check_token(Token_Newline)) {
					parser.state = Parse_Parameter;
					parser_pop_parent();
				} else {
                    result = ParseError_ExpectedNewline;
					parser.state = Parse_Error;
				}
			} else {
				parser.state = Parse_Error;
			}
			break;
		case Token_OpenBracket:
			if (parser.state == Parse_ParameterProperty) {
				parser.state = Parse_ListItem;
			} else {
			    result = ParseError_InvalidToken;
				parser.state = Parse_Error;
			}
			break;
		case Token_CloseBracket:
			parser_pop_parent();
			parser.state = Parse_Parameter;
			break;
		case Token_CloseBrace:
			parser_pop_parent();
			parser.state = Parse_Init;
			break;
		default: break;
		}
		parser.last_token = t->type;
	}

	// Assign relevant type information to nodes
	for (u32 i = 1; i < parser.head; ++i) {
		Node *n = get_node(i);
		String content = node_get_identifier(n);
		dbg("Node %d: (%s) ^%d >%d | ", i, node_type_names[n->type], n->parent, n->next);
		string_println(content);
		switch (n->type) {
		case Node_ParamProperty: {
			String identifier = node_get_identifier(n);
			n->param_field = match_param_field(identifier);
		} break;
		case Node_ParamPropertyValue: {
			Node *parent = get_node(n->parent);
			if (parent->param_field == ParamField_Type) {
				String identifier = node_get_identifier(n);
				n->param_type = match_param_type(identifier);
			}
		} break;
		default: break;
		}
	}

	//
	// CODE GEN
	//
	if (!file_exists(STR_LIT("generated/"))) {
        if (!make_dir(STR_LIT("generated/"))) {
            err("Failed to make generated dir\n");
            result = ParseError_FilesystemError;
            return result;
        }
	}
	File config_fd = file_open(STR_LIT("generated/user_code.c"), 0);
	if (!config_fd.fd) {
        result = ParseError_FilesystemError;
        return result;
	}
	file_write_string(config_fd, STR_LIT("//\n// Generated code, do not edit\n//\n\n"));
	// Iterate all top-level parameter nodes & generate enum & param names table
	// Params enum
	{
		String header = STR_LIT("typedef enum {\n");
		file_write_string(config_fd, header);
		for (Node *node = get_node(1); node != NULL; node = get_node(node->next)) {
			Token t = tokens[node->token_id];
			String name = get_identifier(data + t.offset);
			file_printf(config_fd, alloc, "\tParam_%.*s,\n", name.len, name.data);
		}
		String param_count = STR_LIT("\tParam_Count,\n");
		file_write_string(config_fd, param_count);
		String enum_end = STR_LIT("} PluginParams;\n\n");
		file_write_string(config_fd, enum_end);
	}
	// Param names array
	{
		String header = STR_LIT("static String param_names[Param_Count] = {\n");
		file_write_string(config_fd, header);
		for (Node *node = get_node(1); node != NULL; node = get_node(node->next)) {
			Token t = tokens[node->token_id];
			String name = get_identifier(data + t.offset);
			file_printf(config_fd, alloc, "\tSTR_LIT(\"%.*s\"),\n", name.len, name.data);
		}
		String footer = STR_LIT("};\n\n");
		file_write_string(config_fd, footer);
	}
	// Find any enum parameters & generate enums & names
	{
		for (Node *node = get_node(1); node != NULL; node = get_node(node->next)) {
		    assert(node->type == Node_ParamDecl);
			String param_name = node_get_parameter_name(node);
 			Node *choices = node_get_choices(node);
            if (!choices)
                continue;
            STACK_ALLOC_BEGIN(KB(1));
            // Print enum
            file_printf(config_fd, alloc, "typedef enum {\n");
            Array(String) names;
            array_init_capacity(STACK_ALLOC, &names, 16);
            // iterate each choice
            for (Node *choice = get_node(choices->first); choice != NULL; choice = get_node(choice->next)) {
                String identifier = node_get_identifier(choice);
                array_append(STACK_ALLOC, &names, identifier);
                file_printf(config_fd, alloc, "\t%.*s,\n", identifier.len, identifier.data);
            }
            file_printf(config_fd, alloc, "\t%.*s_Count,\n", param_name.len, param_name.data);
            file_printf(config_fd, alloc, "} %.*s;\n\n", param_name.len, param_name.data);

            // Print names array
            file_printf(config_fd, alloc, "static String %.*s_names[%.*s_Count] = {\n",
                param_name.len, param_name.data, param_name.len, param_name.data);
            for (int i = 0; i < names.len; ++i) {
                file_printf(config_fd, alloc, "\tSTR_LIT(\"%.*s\"),\n", names.items[i].len, names.items[i].data);
            }
            file_printf(config_fd, alloc, "};\n\n");
		}
	}
	// Iterate tree & print ParameterData struct
	{
		String header = STR_LIT("struct ParameterData{\n");
		file_write_string(config_fd, header);
		for (Node *node = get_node(1); node != NULL; node = get_node(node->next)) {
			print_parameter_data(config_fd, alloc, node);
		}
		String footer = STR_LIT("};\n\n");
		file_write_string(config_fd, footer);
	}
	// Iterate tree & print ParameterInfo array
	{
		String header = STR_LIT("static ParameterInfo parameter_layout[Param_Count] = {\n");
		file_write_string(config_fd, header);
		for (Node *node = get_node(1); node != NULL; node = get_node(node->next)) {
			print_parameter_info(config_fd, alloc, node);
		}
		String footer = STR_LIT("};\n\n");
		file_write_string(config_fd, footer);
	}

	// Write plugin config struct
	{
    	PluginConfig plugin_config = build->config;
        file_write_string(config_fd, STR_LIT("static PluginConfig plugin_config = {\n\t.desc = {\n"));
        if (plugin_config.desc.name) {
            file_printf(config_fd, alloc, "\t\t.name = \"%s\",\n", plugin_config.desc.name);
        }
        if (plugin_config.desc.id) {
            file_printf(config_fd, alloc, "\t\t.id = \"%s\",\n", plugin_config.desc.id);
        }
        if (plugin_config.desc.company) {
            file_printf(config_fd, alloc, "\t\t.company = \"%s\",\n", plugin_config.desc.company);
        }
        if (plugin_config.desc.version) {
            file_printf(config_fd, alloc, "\t\t.version = \"%s\",\n", plugin_config.desc.version);
        }
        if (plugin_config.desc.copyright) {
            file_printf(config_fd, alloc, "\t\t.copyright = \"%s\",\n", plugin_config.desc.copyright);
        }
        if (plugin_config.desc.url) {
            file_printf(config_fd, alloc, "\t\t.url = \"%s\",\n", plugin_config.desc.url);
        }
        if (plugin_config.desc.contact) {
            file_printf(config_fd, alloc, "\t\t.contact = \"%s\",\n", plugin_config.desc.contact);
        }
        if (plugin_config.desc.manual) {
            file_printf(config_fd, alloc, "\t\t.manual = \"%s\",\n", plugin_config.desc.manual);
        }
        if (plugin_config.desc.description) {
            file_printf(config_fd, alloc, "\t\t.description = \"%s\",\n", plugin_config.desc.description);
        }
        file_write_string(config_fd, STR_LIT("\t},\n")); // } desc
        file_write_string(config_fd, STR_LIT("\t.audio_ports = {\n"));
        file_printf(config_fd, alloc, "\t\t.inputs = %d,\n", plugin_config.audio_ports.inputs);
        file_printf(config_fd, alloc, "\t\t.outputs = %d,\n", plugin_config.audio_ports.outputs);
        file_write_string(config_fd, STR_LIT("\t},\n")); // } audio ports
        file_write_string(config_fd, STR_LIT("\t.note_ports = {\n"));
        file_printf(config_fd, alloc, "\t\t.inputs = %d,\n", plugin_config.note_ports.inputs);
        file_printf(config_fd, alloc, "\t\t.outputs = %d,\n", plugin_config.note_ports.outputs);
        file_write_string(config_fd, STR_LIT("\t},\n")); // } audio ports
        file_printf(config_fd, alloc, "\t.features = 0x%x,\n", plugin_config.features);
        file_write_string(config_fd, STR_LIT("};\n\n"));

        u32 plugin_id_hash = hash_plugin_id(plugin_config.desc.id);
        file_printf(config_fd, alloc, "#define PLUGIN_ID_HASH 0x%x\n\n", plugin_id_hash);
	}

	file_printf(config_fd, alloc, "#include \"../%s\"\n", build->src_file);

	file_close(config_fd);

    return result;
}
