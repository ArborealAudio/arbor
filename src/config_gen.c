#define APP_NAME "config-gen"
#include "../cbase/cbase.h"
#include "../cbase/cbase.c"

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
*/

static Arena arena;

typedef enum {
    Token_Invalid,
    Token_Identifier,
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

	ParamField param_field;
	ParamType param_type;
} Node;

#define MAX_NODES 512
static Node nodes[MAX_NODES] = {
	[0] = (Node){},
};

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

static Node *get_node(u32 id) {
	if (id >= parser.head || id == 0)
		return NULL;

	return &nodes[id];
}

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

static void parser_push_node(NodeType node_type, u32 token_id) {
	const u32 id = parser.head;
	Node node = (Node){
		.type = node_type,
		.token_id = token_id,
	};
	u32 parent = parser_get_parent();
	node.parent = parent;
	switch (node_type) {
	case Node_ParamDecl: {
		Node *ptr = get_node_incl_root(parent);
		Node *last = get_node(ptr->last);
		if (last) {
			last->next = id; // link ourselves to previous sibling
		}
		parser_push_parent(id);
	} break;
	case Node_ParamProperty: 
		parser_push_parent(id);
		break;
	case Node_ParamPropertyValue: break;
	case Node_ListItem: {
		Node *ptr = get_node_incl_root(parent);
		Node *last = get_node(ptr->last);
		if (last) {
			last->next = id; // link ourselves to previous sibling
		}
	} break;
	case Node_Invalid: {
		Token t = tokens[node.token_id];
		println("Error: invalid node @ byte %d", t.offset);
	} break;
	}
	if (id >= MAX_NODES) {
		err("Max node count reached\n");
		return;
	}

	// Link ourselves to parent
	{
		Node *ptr = get_node_incl_root(parent);
		if (!ptr->first)
			ptr->first = id;
		ptr->last = id;
	}
	nodes[parser.head] = node;
	parser.head += 1;
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
static String get_identifier(const u8 *token_start) {
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

static String node_get_parameter_name(Node *n, const u8 *config_data) {
	if (n->param_field == ParamField_Name)
		return get_identifier(config_data + tokens[n->token_id].offset);

	// search siblings
	// ISSUE what if we're in the middle of the list of siblings? We just wont' search previous siblings
	for (Node *node = get_node(n->next); node != NULL; node = get_node(node->next)) {
		if (n->param_field == ParamField_Name)
			return get_identifier(config_data + tokens[node->token_id].offset);
	}

	return (String){0};
}

// ISSUE we're not getting all fields for some reason
static void print_node_fields_recursive(File f, Allocator *alloc, Node *root,
                                        const u8 *config_data) {
	String data = get_identifier(config_data + tokens[root->token_id].offset);
	print("Printing node data: ");
	string_println(data);
	switch (root->type) {
	case Node_ParamDecl:
		file_printf(f, alloc, "\t[%.*s] = {\n", data.len, data.data);
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
		case ParamField_Choices:
			// need name of choice parameter
			// is there a way we can take an arbitrary node and look up its associated parameter name?
			// file_printf(f, alloc, "(StringArray){%s_Names, %s_Count},\n");
			break;
		default:
			file_printf(f, alloc, "%.*s,\n", data.len, data.data);
			break;
		}
	} break;
	default: break;
	}

	for (Node *node = get_node(root->first); node != NULL; node = get_node(node->next)) {
		print_node_fields_recursive(f, alloc, node, config_data);
	}

	if (root->type == Node_ParamDecl) {
		String close = STR_LIT("\t},\n");
		file_write_string(f, close);
	}
}

static void config_build(const char *config_path) {
    arena = arena_init(KB(1));
    Allocator *alloc = &arena.allocator;
    File user_config_fd = file_open(config_path, FileOpen_ReadOnly);
    const u8 *const data = file_read_full_alloc(user_config_fd, &arena.allocator);
    file_close(user_config_fd);

	#define push_token(Type) tokens[token_head++] = (Token){(Type), i}

    for (u32 i = 0; i < user_config_fd.size; ++i) {
        while (is_whitespace(data[i])) {
            i++;
        }
        u8 c = data[i];
        if (is_numeric(c)) {
            push_token(Token_Number);
            // consume remaining number
        	while (is_numeric(c))
        		c = data[++i];
        } else if (is_alpha(c)) {
            push_token(Token_Identifier);
            // consume remaining identifier
        	while (is_alpha(c))
        		c = data[++i];
        }
        switch (c) {
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
        	push_token(Token_Newline);
    	} break;
        }
    }

    #if 1
    for (u32 i = 0; i < token_head; ++i) {
		Token *t = &tokens[i];
    	print("%s @ %d: ", token_type_names[t->type], t->offset);
    	string_println(get_identifier(data + t->offset));
    }
    #endif

    // Build syntax tree
	#define eat_token() t++
	#define check_token(Type) (t->type == (Type))

	parser.head = 1;
	Token *t = &tokens[0];
	for (u32 i = 0; i < token_head; ++i) {
		if (parser.state == Parse_Error) {
			print("Parse error:");
			string_println(get_identifier(data + t->offset));
			break;
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
					parser.state = Parse_Error;
				}
				break;
			case Parse_ListItem:
				parser_push_node(Node_ListItem, i);
				if (eat_token(), !check_token(Token_Newline)) {
					parser.state = Parse_Error;
				}
				break;
			default: break;
			}
			break;
		case Token_Number:
			if (parser.state == Parse_ParameterProperty) {
				parser_push_node(Node_ParamPropertyValue, i);
				if (eat_token(), check_token(Token_Newline)) {
					parser.state = Parse_Parameter;
					parser_pop_parent();
				} else {
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
		String content = get_identifier(data + tokens[n->token_id].offset);
		print("Node %d: (%s) ^%d >%d | ", i, node_type_names[n->type], n->parent, n->next);
		string_println(content);
		switch (n->type) {
		case Node_ParamProperty: {
			String identifier = get_identifier(data + tokens[n->token_id].offset);
			n->param_field = match_param_field(identifier);
		} break;
		case Node_ParamPropertyValue: {
			Node *parent = get_node(n->parent);
			if (parent->param_field == ParamField_Type) {
				String identifier = get_identifier(data + tokens[n->token_id].offset);
				n->param_type = match_param_type(identifier);
			}
		} break;
		default: break;
		}
	}

	#if 1
	// Generate C code
	File config_fd = file_open("config.gen.c", 0);
	// Iterate all top-level parameter nodes & generate enum & param names table
	Node *first_param = NULL;
	// Params enum
	{
		String header = STR_LIT("typedef enum {\n");
		file_write_string(config_fd, header);
		Node *root = get_node_incl_root(0);
		for (Node *node = get_node(root->first); node != NULL; node = get_node(node->next)) {
			first_param = node;
			Token t = tokens[node->token_id];
			String name = get_identifier(data + t.offset);
			file_printf(config_fd, &arena.allocator, "\t%.*s,\n", name.len, name.data);
		}
		String param_count = STR_LIT("\tParam_Count,\n");
		file_write_string(config_fd, param_count);
		String enum_end = STR_LIT("} PluginParams;\n\n");
		file_write_string(config_fd, enum_end);
	}
	// Param names array
	{
		String header = STR_LIT("static const char *param_names[] = {\n");
		file_write_string(config_fd, header);
		Node *root = &nodes[0];
		for (Node *node = get_node(root->first); node != NULL; node = get_node(node->next)) {
			Token t = tokens[node->token_id];
			String name = get_identifier(data + t.offset);
			file_printf(config_fd, &arena.allocator, "\t\"%.*s\",\n", name.len, name.data);
		}
		String footer = STR_LIT("};\n\n");
		file_write_string(config_fd, footer);
	}
	// Find any enum parameters & generate enums & names
	{}
	// Iterate tree & write out its fields
	{
		String header = STR_LIT("static const Parameter parameter_layout[Param_Count] = {\n");
		file_write_string(config_fd, header);
		Node *root = get_node_incl_root(0);
		for (Node *node = get_node(root->first); node != NULL; node = get_node(node->next)) {
			print_node_fields_recursive(config_fd, &arena.allocator, node, data);
		}
		String footer = STR_LIT("};\n");
		file_write_string(config_fd, footer);
	}
	file_close(config_fd);
	#endif

	usize mem_used = arena_query_capacity(&arena);
	println("Arena mem used: %zuB", mem_used);
    arena_deinit(&arena);
}


int main() {
	config_build("example_config.txt");
}
