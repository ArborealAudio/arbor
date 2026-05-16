#include "../cbase/cbase.h"
#include "arbor.h"

/*
TODO refactor to generate a struct like this:
struct Parameters {
	float gain;
	Mode mode;
	FilterType filter_type;
};

And embed this in the main plugin struct. This could involve defining something like `Parameters`
as an opaque type in arbor.h, putting a `parameters` field in the Plugin, then defining that
struct in the generated config file.

other ideas just spitballin':
    This struct should be read only and purely user-facing, it's data that gets "cooked" or "prepared" for the user during plugin wrapper param changes.

    Provide an API for getting smoothed param changes
*/

static Arena arena;

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

typedef enum {
    ParseError_None,
    ParseError_InvalidToken,
    ParseError_ExpectedNewline,
    ParseError_MaxNodesReached,
    ParseError_FilesystemError,
} ParseError;

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

__attribute__((deprecated("Don't use this! Refactor around not using 0 as root ID")))
static Node *get_node_incl_root(u32 id) {
	if (id == 0)
		return &nodes[0];

	if (id >= parser.head)
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

static bool is_whitespace(const u8 c) {
	return (c == ' ' || c == '\t');
}

static bool is_numeric(const u8 c) {
	return (c >= '0' && c <= '9');
}

static bool is_alpha(const u8 c) {
	return (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z');
}

// TODO Support printing string literals i.e. stuff w/ spaces in it
// may necessitate a new kind of token that includes the quotes as its data, is treated a little differently
static String get_identifier(const char *token_start) {
	u32 len = 0, i = 0;
	while (true) {
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
static bool node_has_field(Node *node, ParamField field) {
    if (node->param_field == field)
        return true;
    // Search siblings
    u32 parent = node->parent;
    if (parent) {
        for (Node *child = get_node(get_node(parent)->first); child != NULL; child = get_node(child->next)) {
            if (child->param_field == field)
                return true;
        }
    }

    for (Node *child = get_node(node->first); child != NULL; child = get_node(child->next)) {
        if (child->param_field == field)
            return true;
    }

    return false;
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
				file_write_string(f, STR_LIT("\t\t.min_value = false,\n"));
			} else {
    			Node *choices = node_get_choices(root);
    			Node *min = get_node(choices->first);
    			String min_value = node_get_identifier(min);
    			file_printf(f, alloc, "\t\t.min_value = %.*s,\n", min_value.len, min_value.data);
			}
		}
		if (!node_has_field(root, ParamField_Max)) {
    		if (node_get_parameter_type(root) == ParamType_Bool) {
				file_write_string(f, STR_LIT("\t\t.max_value = true,\n"));
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
			file_printf(f, alloc, "%.*s,\n", data.len, data.data);
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

static u32 hash_plugin_id(char *plugin_id) {
    u32 hash = 0x311311;
    int len = string_len(plugin_id);
    for (int i = 0; i < len; ++i) {
        hash = (hash ^ plugin_id[i]) * 0x01000193;
    }

    return hash;
}

static ParseError config_build(PluginBuild *build) {
    arena = arena_init(page_size());
    Allocator *alloc = &arena.allocator;
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
            if (string_match(STR_LIT("true"), (String){data + i, 4})) {
                push_token(Token_True);
            } else if (string_match(STR_LIT("false"), (String){data + i, 5})) {
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
			goto cleanup;
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
	if (!dir_exists(STR_LIT("generated/"))) {
        if (!make_dir(STR_LIT("generated/"))) {
            err("Failed to make generated dir\n");
            arena_deinit(&arena);
            result = ParseError_FilesystemError;
            goto cleanup;
        }
	}
	File config_fd = file_open(STR_LIT("generated/user_code.c"), 0);
	if (!config_fd.fd) {
        arena_deinit(&arena);
        result = ParseError_FilesystemError;
        goto cleanup;
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
			file_printf(config_fd, &arena.allocator, "\tParam_%.*s,\n", name.len, name.data);
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

cleanup: {
    usize mem_used = arena_query_capacity(&arena);
    println("Config generation complete");
    println("Arena mem: %.2fkB", (float)mem_used / 1024);
    arena_deinit(&arena);
}

    return result;
}
