#ifndef UI_H
#define UI_H

#include "common.h"
#include "platform.h"

#define ui_new(T) (T*)arena_alloc(ctx->arena, sizeof(T))
#define ui_frame_alloc(T) (T*)arena_alloc(ctx->frame_arena, sizeof(T))

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
    BoxMouseUp = 1 << 7,
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
    DrawImage = 1 << 5,
    FloatingX = 1 << 6,
    FloatingY = 1 << 7,
    FloatingPos = FloatingX | FloatingY,
    FixedX = 1 << 8,
    FixedY = 1 << 9,
    FixedPos = FixedX | FixedY,
    FocusHot = 1 << 10, // e.g. mouse hover
    FocusActive = 1 << 11, // e.g. mouse down
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

// General information about a box's appearance.
// Each UiBox has its own style field, however this is not to be filled out by the user nor is it
// to be written out per-box -- styling should be handled through the stacking API, allowing for natural
// and stateful grouping of styles.
typedef struct {
    av_TextStyle text_style;
    av_Colorf background_color;
    av_Colorf highlight_color;
    av_Colorf border_color;
    float border_width;
    float corner_radius;
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
    .border_color = (av_Colorf){0.75f, 0.75f, 0.75f, 1},
    .border_width = 2,
    .corner_radius = 10.f,
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
    float rel_pos[2];
    UiAxis child_layout_axis;
    UiBoxStyle style;
    int gap[2]; // Gap btw this element & others
    UiBoxFlag flags;
    int state; // For boxes which need some kind of persistent state value, e.g. whether an expander should remain open
    pv_IconSlot icon;

    UiBoxEvent last_event;

    UiBox *first_child;
    UiBox *last_child;
    UiBox *next;
    UiBox *prev;
    UiBox *parent;
    int num_children;
};

static UiBox *null_box = NULL;

typedef struct Table {
    String key;
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

    Array(UiBoxFlag) flag_stack;
    Array(UiSize) pref_width_stack;
    Array(UiSize) pref_height_stack;
    Array(av_Colorf) background_color_stack;
    Array(av_Colorf) border_color_stack;
    Array(av_Colorf) highlight_color_stack;
    Array(av_TextStyle) text_style_stack;
    Array(int) x_gap_stack;
    Array(int) y_gap_stack;
    Array(float) border_width_stack;
    Array(float) corner_radius_stack;
} UiCtx;

UiCtx *ui_init(pv_Context *pv_ctx);
void ui_deinit(UiCtx *ctx);

void ui_begin(UiCtx *ctx);
void ui_end(UiCtx *ctx);

void ui_send_event(UiCtx *ctx, pv_Event *event);

void ui_row_begin(UiCtx *ctx);
void ui_row_end(UiCtx *ctx);
void ui_column_begin(UiCtx *ctx);
void ui_column_end(UiCtx *ctx);
void ui_spacer(UiCtx *ctx, UiAxis direction);
bool32 ui_expander(UiCtx *ctx, String display);

void ui_label(UiCtx *ctx, String display);
void ui_labelf(UiCtx *ctx, const char *fmt, ...);
bool32 ui_button(UiCtx *ctx, String display);
void ui_toggle_button(UiCtx *ctx, bool32 *state, String display);
bool32 ui_icon_button(UiCtx *ctx, pv_IconSlot icon, String id);
void ui_popup_begin(UiCtx *ctx, UiAxis direction, String display);
void ui_popup_end(UiCtx *ctx);
void ui_combo_box(UiCtx *ctx, int *value, String display, String *choices, int choice_count);
UiBoxEvent ui_slider(UiCtx *ctx, float *value, float min, float max, String display);

void ui_pref_width(UiCtx *ctx, UiSize size);
void ui_pref_width_pop(UiCtx *ctx);
void ui_pref_height(UiCtx *ctx, UiSize size);
void ui_pref_height_pop(UiCtx *ctx);
UiSize ui_size_text();
UiSize ui_children_sum(float strict);
UiSize ui_px(float pixels, float strict);
UiSize ui_pct(float pct, float strict);
void ui_border_width(UiCtx *ctx, float width);
void ui_border_width_pop(UiCtx *ctx);
void ui_gap_x(UiCtx *ctx, int gap);
void ui_gap_x_pop(UiCtx *ctx);
void ui_gap_y(UiCtx *ctx, int gap);
void ui_gap_y_pop(UiCtx *ctx);
void ui_background_color(UiCtx *ctx, av_Colorf color);
void ui_background_color_pop(UiCtx *ctx);
void ui_border_color(UiCtx *ctx, av_Colorf color);
void ui_border_color_pop(UiCtx *ctx);
void ui_corner_radius(UiCtx *ctx, float radius);
void ui_corner_radius_pop(UiCtx *ctx);

void ui_enable_performance_clock(UiCtx *ctx);

#endif
