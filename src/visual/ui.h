#ifndef UI_H
#define UI_H

#include "platform.h"

#define USE_ARENA 1

#if USE_ARENA
#define ui_new(T) (T*)arena_alloc(ctx->arena, sizeof(T))
#define ui_frame_alloc(T) (T*)arena_alloc(ctx->frame_arena, sizeof(T))
#else
#define debugui_new(T) (T*)malloc(sizeof(T))
#define debugui_frame_alloc(T) debugui_new(T)
#endif

// TODO Use our own hash table
#define STB_DS_IMPLEMENTATION
#include "stb_ds.h"

typedef enum {
    Horizontal,
    Vertical,
} UiAxis;

typedef uint32_t UiBoxMouseEvent;
enum UiBoxMouseEvents {
    BoxMouseNone = 0,
    BoxMouseOver = 1 << 0,
    BoxMouseHover = 1 << 1,
    BoxMouseDown = 1 << 2,
    BoxMouseClick = 1 << 3,
    BoxMouseHold = 1 << 4,
    BoxMouseDrag = 1 << 5,
    BoxMouseScroll = 1 << 6,
};

typedef struct {
    UiBoxMouseEvent mouse_event;
    pv_MouseButton mouse_button;
    pv_KeyMod mod;
    pv_Key key;
    int mouse_x;
    int mouse_y;
    int mouse_dx;
    int mouse_dy;
} UiBoxEvent;

typedef u32 UiBoxFlag;
static UiBoxFlag box_flag_null = 0;

enum UiBoxFlags {
    Clickable = 1 << 0,
    Draggable = 1 << 1,
    DrawText = 1 << 2,
    DrawBackground = 1 << 3,
    DrawBorder = 1 << 4,
    FloatingX = 1 << 5,
    FloatingY = 1 << 6,
    FloatingPos = FloatingX | FloatingY,
    FixedX = 1 << 7,
    FixedY = 1 << 8,
    FixedPos = FixedX | FixedY,
    FocusHot = 1 << 9, // e.g. mouse hover
    FocusActive = 1 << 10, // e.g. mouse down
    DrawValue = 1 << 11,
    DrawImage = 1 << 12,
};

typedef enum {
    SizeKindNone,
    SizeKindPixels,
    SizeKindText,
    SizeKindParentPct,
    SizeKindChildrenSum,
    SizeKindGrow, // Fill maximum amount of parent along layout axis
} UiSizeKind;

typedef struct {
    UiSizeKind kind;
    float value;
    float strictness;
} UiSize;

// General style information passed in each box creation function call
// Zero == widget-specific default
typedef struct {
    av_TextStyle text_style;
    av_Colorf background_color;
    av_Colorf highlight_color;
    av_Colorf active_color;
    av_Colorf value_color;
    av_Colorf border_color;
    float border_width;
} UiBoxStyle;

static UiBoxStyle default_style = {
    .text_style = {
        .justify = av_TextJustifyCenter,
        .align = av_TextAlignInside,
        .padding = 5.f,
        .color = (av_Colorf){1, 1, 1, 1},
    },
    .background_color = (av_Colorf){0.2f, 0.2f, 0.2f, 1},
    .highlight_color = (av_Colorf){0.3f, 0.3f, 0.3f, 1},
    .active_color = (av_Colorf){0.f, 0.3f, 0.3f, 1},
    .value_color = (av_Colorf){0.5f, 0.7f, 0.7f, 1},
    .border_color = (av_Colorf){0.75f, 0.75f, 0.75f, 1},
};

static bool32 is_null_key(String key) {
    return key.data == NULL || key.len == 0;
}

static String null_key = {0};

typedef struct UiBox UiBox;
struct UiBox {
    bool32 first_frame;
    // TODO Make this a `String`
    char display[64];
    av_Rect bounds;
    UiSize pref_size[2];
    float fixed_size[2];
    float value_fixed_size[2];
    float rel_pos[2];
    UiAxis child_layout_axis;
    UiBoxStyle style; // NOTE Is this redundant now that most UI functions take a style parameter?
    int gap[2]; // Gap btw this element & others
    UiBoxFlag flags;
    float value;
    pv_IconSlot icon;

    UiBoxMouseEvent last_event;

    UiBox *first_child;
    UiBox *last_child;
    UiBox *next;
    UiBox *prev;
    UiBox *parent;
    int num_children;
};

static UiBox *null_box = NULL;

typedef struct Table {
    char *key;
    UiBox *value;
} Table;

typedef enum {
    PerfMeasureLayout,
    PerfMeasureRender,
    PerfMeasureAll,
} PerfClockType;

typedef struct {
    Arena *arena;
    Arena *frame_arena;

    int width, height;
    pv_Context *rdr_ctx;

    struct {
        int x, y;
        int dx, dy;
        pv_MouseButton button;
    } mouse;
    pv_KeyMod key_mod;
    UiBox *mouse_latch_box;

    bool32 measure_perf;
    struct timespec layout_start, layout_end;
    struct timespec draw_start, draw_end;
    usize frame_idx;

    Table *table;
    Array(UiBox *) parent_stack;
    UiBox root_box;
    UiBox *popup_root;

    // Used for any stateful application of flags
    Array(UiBoxFlag) flag_stack;
    Array(UiSize) pref_width_stack;
    Array(UiSize) pref_height_stack;
    Array(int) x_gap_stack;
    Array(int) y_gap_stack;
} UICtx;

UICtx *ui_init(pv_Context *pv_ctx);
void ui_deinit(UICtx *ctx);
void ui_begin(UICtx *ctx);
void ui_end(UICtx *ctx);
void ui_send_event(UICtx *ctx, pv_Event *event);
void ui_set_background_color(UICtx *ctx, av_Colorf color);
void ui_row_begin(UICtx *ctx, UiBoxStyle style);
void ui_row_end(UICtx *ctx);
void ui_column_begin(UICtx *ctx, UiBoxStyle style);
void ui_column_end(UICtx *ctx);
void ui_label(UICtx *ctx, String display, UiBoxStyle style);
void ui_labelf(UICtx *ctx, UiBoxStyle style, const char *fmt, ...);
bool32 ui_button(UICtx *ctx, String display, UiBoxStyle style);
void ui_toggle_button(UICtx *ctx, bool32 *state, String display, UiBoxStyle style);
bool32 ui_icon_button(UICtx *ctx, pv_IconSlot icon, String id, UiBoxStyle style);
void ui_spacer(UICtx *ctx, UiAxis direction);
bool32 ui_popup_begin(UICtx *ctx, UiAxis direction, String display, UiBoxStyle button_style, UiBoxStyle popup_style);
void ui_popup_end(UICtx *ctx);
bool32 ui_expander(UICtx *ctx, String display, UiBoxStyle style);
void ui_slider(UICtx *ctx, float *value, float min, float max, String display, UiBoxStyle style);
void ui_enable_performance_clock(UICtx *ctx);

#endif
