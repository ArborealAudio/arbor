#include "ui.h"
#include "common.h"
#include "platform.h"

static inline Arena *allocator(UiCtx *ctx) {
    return ctx->arena;
}

static inline Arena *frame_allocator(UiCtx *ctx) {
    return ctx->frame_arena;
}

#define clamp_bot(v, bot) (v < bot ? bot : v)
#define clamp_top(v, top) (v > top ? top : v)
#define clamp(v, min, max) clamp_top(clamp_bot((v), min), max)


UiCtx* ui_init(pv_Context *pv_ctx) {
    UiCtx *ctx = arena_alloc(pv_ctx->arena, sizeof(UiCtx));
    av_Size size = pv_get_render_size(pv_ctx);
    *ctx = (UiCtx){
        .arena = pv_ctx->arena,
        .frame_arena = arena_init(),
        .rdr_ctx = pv_ctx,
        .width = size.width,
        .height = size.height,
    };
    array_init_capacity(allocator(ctx), &ctx->parent_stack, 64);
    array_init_capacity(allocator(ctx), &ctx->flag_stack, 64);
    array_init_capacity(allocator(ctx), &ctx->pref_width_stack, 64);
    array_init_capacity(allocator(ctx), &ctx->pref_height_stack, 64);
    array_init_capacity(allocator(ctx), &ctx->x_gap_stack, 64);
    array_init_capacity(allocator(ctx), &ctx->y_gap_stack, 64);
    array_init_capacity(allocator(ctx), &ctx->pref_width_stack, 64);
    array_init_capacity(allocator(ctx), &ctx->pref_height_stack, 64);
    array_init_capacity(allocator(ctx), &ctx->text_style_stack, 64);
    array_init_capacity(allocator(ctx), &ctx->background_color_stack, 64);
    array_init_capacity(allocator(ctx), &ctx->highlight_color_stack, 64);
    array_init_capacity(allocator(ctx), &ctx->border_color_stack, 64);
    array_init_capacity(allocator(ctx), &ctx->border_width_stack, 64);
    array_init_capacity(allocator(ctx), &ctx->corner_radius_stack, 64);

    return ctx;
}

void ui_deinit(UiCtx *ctx) {
    shfree(ctx->table);
    arena_deinit(ctx->frame_arena);
}

void ui_send_event(UiCtx *ctx, pv_Event *event) {
    ctx->key_mod = event->modifiers;

    switch (event->type) {
    case pv_EventMouseDown:
        ctx->mouse.button |= event->mouse_button;
        break;
    case pv_EventMouseUp:
        ctx->mouse.button &= ~event->mouse_button;
        break;
    case pv_EventMouseMove:
    case pv_EventMouseDrag:
        ctx->mouse.dx = event->mouse_x - ctx->mouse.x;
        ctx->mouse.dy = event->mouse_y - ctx->mouse.y;
        ctx->mouse.x = event->mouse_x;
        ctx->mouse.y = event->mouse_y;
        break;
    // TODO KeyDown
    default: break;
    }
}

UiBox *_get_box(UiCtx *ctx, String key) {

    Table *entry = hmgetp_null(ctx->table, key);
    if (entry) {
        return entry->value;
    }

    return NULL;
}

UiBoxEvent _get_box_mouse_event(UiCtx *ctx, UiBox *box) {
    if (ctx->mouse.button == pv_MouseNone)
        ctx->mouse_latch_box = NULL;
    if (box->first_frame || (ctx->mouse_latch_box && ctx->mouse_latch_box != box))
        return (UiBoxEvent){0};

    UiBoxEvent e = {
        .mouse_x = ctx->mouse.x,
        .mouse_y = ctx->mouse.y,
        .mouse_dx = ctx->mouse.dx,
        .mouse_dy = ctx->mouse.dy,
        .mouse_button = ctx->mouse.button,
    };

    bool32 mouse_over = FALSE;
    if (rect_contains(box->bounds, e.mouse_x, e.mouse_y)) {
        mouse_over = TRUE;
    }
    UiBoxEvent last_event = box->last_event;
    bool32 drag_continue = (last_event.mouse_event & BoxMouseDrag) > 0;
    bool32 mouse_hold = (last_event.mouse_event & BoxMouseDown) > 0;
    if (drag_continue) {
        mouse_over = TRUE;
    }
    if (mouse_over)
        e.mouse_event |= BoxMouseOver | BoxMouseHover;

    bool32 is_dropdown = FALSE;
    for (UiBox *parent = box->parent; parent != NULL; parent = parent->parent) {
        if (parent == ctx->popup_root) {
            is_dropdown = TRUE;
            break;
        }
    }

    // Don't send mouse hover if we're under the dropdown
    if (ctx->popup_root && mouse_over && !is_dropdown) {
        av_Rect dropdown_bounds = ctx->popup_root->bounds;
        if (rect_intersect(box->bounds, dropdown_bounds)) {
            mouse_over = FALSE;
            e.mouse_event &= ~BoxMouseHover;
        }
    }

    bool32 mouse_down = FALSE;
    if (e.mouse_button != pv_MouseNone && mouse_over) {
        mouse_down = TRUE;
        e.mouse_event |= BoxMouseDown;
        ctx->mouse_latch_box = box;
    }

    if (!mouse_down) {
        drag_continue = FALSE;
        mouse_hold = FALSE;
    }

    if (mouse_hold)
        e.mouse_event |= BoxMouseHold;

    bool32 mouse_drag = drag_continue || ((e.mouse_dx != 0 || e.mouse_dy != 0) && mouse_down && mouse_over);
    if (mouse_drag && (box->flags & Draggable)) {
        // NOTE Technically weird since you could continue the drag by switching from left->right
        // mouse button. uhuhhh
        e.mouse_event |= BoxMouseDrag;
        // ctx->mouse_latch_box = box;
    }

    if (mouse_over && mouse_down && !mouse_hold && (box->flags & Clickable)) {
        e.mouse_event |= BoxMouseClick;
    }

    if (e.mouse_event & BoxMouseHover)
        box->flags |= FocusHot;
    if (e.mouse_event & BoxMouseDown)
        box->flags |= FocusActive;

    box->last_event = e;
    return e;
}

void _push_parent(UiCtx *ctx, UiBox *parent) {
    array_append(allocator(ctx), &ctx->parent_stack, parent);
}

UiBox *_pop_parent(UiCtx *ctx) {
    return array_pop(&ctx->parent_stack);
}

UiBox *_get_parent(UiCtx *ctx) {
    return array_last(&ctx->parent_stack);
}

void _push_flags(UiCtx *ctx, uint32_t flag) {
    array_append(allocator(ctx), &ctx->flag_stack, flag);
}

UiBoxFlag _last_flags(UiCtx *ctx) {
    size_t len = ctx->flag_stack.len;
    if (len == 0)
        return 0;
    return array_last(&ctx->flag_stack);
}

UiBoxFlag *_last_flags_ptr(UiCtx *ctx) {
    size_t len = ctx->flag_stack.len;
    if (len == 0)
        return &box_flag_null;
    return array_last_ptr(&ctx->flag_stack);
}

void _pop_flags(UiCtx *ctx) {
    array_pop(&ctx->flag_stack);
}

UiBoxStyle _build_style(UiCtx *ctx) {
    UiBoxStyle s = {0};
    if (ctx->text_style_stack.len != 0)
        s.text_style = array_last(&ctx->text_style_stack);
    if (ctx->background_color_stack.len != 0)
        s.background_color = array_last(&ctx->background_color_stack);
    if (ctx->border_color_stack.len != 0)
        s.border_color = array_last(&ctx->border_color_stack);
    if (ctx->highlight_color_stack.len != 0)
        s.highlight_color = array_last(&ctx->highlight_color_stack);
    if (ctx->border_width_stack.len != 0)
        s.border_width = array_last(&ctx->border_width_stack);
    if (ctx->corner_radius_stack.len != 0)
        s.corner_radius = array_last(&ctx->corner_radius_stack);

    return s;
}

void _append_to_tree(UiCtx *ctx, UiBox *new) {
    // append to last parent
    UiBox *parent = _get_parent(ctx);
    assert(parent);
    if (!parent->first_child) {
        parent->first_child = new;
        parent->last_child = new;
        new->parent = parent;
        parent->num_children++;
    } else {
        UiBox *prev = parent->last_child;
        parent->last_child = new;
        prev->next = new;
        new->prev = prev;
        new->parent = parent;
        parent->num_children++;
    }
}

void _clear_box_links(UiBox *box) {
    box->first_child = box->last_child = box->next = box->prev = box->parent = NULL;
    box->num_children = 0;
}

void _build_root(UiCtx *ctx) {
    av_Size size = pv_get_render_size(ctx->rdr_ctx);
    UiBox root = (UiBox){
        .style = {0},
        .display = "root",
        .pref_size = {
            [Horizontal] = {SizeKindPixels, size.width, 1},
            [Vertical] = {SizeKindPixels, size.height, 1},
        },
        .child_layout_axis = Horizontal,
    };
    ctx->root_box = root;
    _push_parent(ctx, &ctx->root_box);
}

void _set_box_string(UiBox *box, String string) {
    memcpy(box->display, string.data, string.len);
}

UiBox *_build_box(UiCtx *ctx, UiBoxFlag flags, String key) {
    bool32 is_transient = is_null_key(key);
    UiBox *box = is_transient ? null_box : _get_box(ctx, key);
    if (!box) {
        if (is_transient) {
            box = ui_frame_alloc(UiBox);
        } else {
            box = ui_new(UiBox);
        }
        *box = (UiBox){
            .style = _build_style(ctx),
            .flags = flags | _last_flags(ctx),
            .first_frame = TRUE,
        };
        if (!is_transient) {
            _set_box_string(box, key);
            hmput(ctx->table, key, box);
        }
    } else {
        box->first_frame = FALSE;
    }

    box->flags = flags | _last_flags(ctx);
    if (ctx->pref_width_stack.len != 0)
        box->pref_size[Horizontal] = array_last(&ctx->pref_width_stack);
    if (ctx->pref_height_stack.len != 0)
        box->pref_size[Vertical] = array_last(&ctx->pref_height_stack);
    _clear_box_links(box);
    _append_to_tree(ctx, box);

    return box;
}

void ui_row_begin(UiCtx *ctx) {
    ui_pref_width(ctx, ui_pct(1, 1));
    ui_pref_height(ctx, ui_children_sum(1));
    UiBox *box = _build_box(ctx, DrawBackground | DrawBorder, null_key);
    box->child_layout_axis = Horizontal;
    _push_parent(ctx, box);
    ui_pref_height_pop(ctx);
    ui_pref_width_pop(ctx);
}

void ui_row_end(UiCtx *ctx) {
    _pop_parent(ctx);
}

void ui_column_begin(UiCtx *ctx) {
    ui_pref_width(ctx, ui_children_sum(1));
    ui_pref_height(ctx, ui_children_sum(1));
    UiBox *box = _build_box(ctx, DrawBackground | DrawBorder, null_key);
    box->child_layout_axis = Vertical;
    _push_parent(ctx, box);
    ui_pref_height_pop(ctx);
    ui_pref_width_pop(ctx);
}

void ui_column_end(UiCtx *ctx) {
    _pop_parent(ctx);
}

void ui_label(UiCtx *ctx, String display) {
    ui_pref_width(ctx, ui_size_text());
    ui_pref_height(ctx, ui_size_text());
    UiBox *box = _build_box(ctx, DrawText, null_key);
    _set_box_string(box, display);
    ui_pref_height_pop(ctx);
    ui_pref_width_pop(ctx);
}

void ui_labelf(UiCtx *ctx, const char *fmt, ...) {
    va_list args;
    va_start(args, fmt);
    String str = string_printfv(frame_allocator(ctx), fmt, args);
    ui_label(ctx, str);
    va_end(args);
}

bool32 ui_button(UiCtx *ctx, String display) {
    bool32 clicked = FALSE;
    ui_pref_width(ctx, ui_size_text());
    ui_pref_height(ctx, ui_size_text());
    UiBox *box = _build_box(ctx, Clickable | DrawText | DrawBackground | DrawBorder, display);
    UiBoxEvent e = _get_box_mouse_event(ctx, box);
    clicked = (e.mouse_event & BoxMouseClick) > 0;
    ui_pref_height_pop(ctx);
    ui_pref_width_pop(ctx);

    return clicked;
}

void ui_toggle_button(UiCtx *ctx, bool32 *state, String display) {
    ui_pref_width(ctx, ui_children_sum(1));
    ui_pref_height(ctx, ui_children_sum(1));
    UiBox *container = _build_box(ctx, Clickable | DrawBackground | DrawBorder, display);
    container->child_layout_axis = Horizontal;

    _push_parent(ctx, container);
    {
        UiBoxFlag toggle_flags = *state ? DrawBackground : DrawBorder;

        ui_pref_width(ctx, ui_px(20, 1));
        ui_pref_height(ctx, ui_px(20, 1));
        ui_background_color(ctx, (av_Colorf){1, 1, 1, 1});
        UiBox *toggle = _build_box(ctx, toggle_flags, null_key);
        ui_background_color_pop(ctx);
        ui_pref_height_pop(ctx);
        ui_pref_width_pop(ctx);

        ui_pref_width(ctx, ui_size_text());
        ui_pref_height(ctx, ui_size_text());
        UiBox *label = _build_box(ctx, DrawText, null_key);
        _set_box_string(label, display);
        ui_pref_height_pop(ctx);
        ui_pref_width_pop(ctx);
    }

    _pop_parent(ctx);

    UiBoxEvent e = _get_box_mouse_event(ctx, container);
    if (e.mouse_event & BoxMouseClick) {
        *state = !*state;
    }
    ui_pref_height_pop(ctx);
    ui_pref_width_pop(ctx);
}

bool32 ui_icon_button(UiCtx *ctx, pv_IconSlot icon, String display) {
    bool32 clicked = FALSE;
    ui_pref_width(ctx, ui_px(32, 1));
    ui_pref_height(ctx, ui_px(32, 1));
    UiBox *box = _build_box(ctx, DrawBackground | DrawBorder | Clickable | DrawImage, display);
    box->icon = icon;

    UiBoxEvent e = _get_box_mouse_event(ctx, box);
    clicked = (e.mouse_event & BoxMouseClick) > 0;
    ui_pref_height_pop(ctx);
    ui_pref_width_pop(ctx);
    return clicked;
}

void ui_spacer(UiCtx *ctx, UiAxis direction) {
    UiBox *box = _build_box(ctx, 0, null_key);
    box->pref_size[direction] = ui_pct(0.5f, 0);
    box->pref_size[!direction] = ui_px(0, 0);
}

void ui_window_begin(UiCtx *ctx) {}

void ui_window_end(UiCtx *ctx) {}

void ui_popup_begin(UiCtx *ctx, UiAxis direction, String display) {
    ui_pref_width(ctx, ui_size_text());
    ui_pref_height(ctx, ui_size_text());
    UiBox *button = _build_box(ctx, Clickable | DrawText | DrawBackground | DrawBorder, display);
    UiBoxEvent e = _get_box_mouse_event(ctx, button);
    if (e.mouse_event & BoxMouseClick) {
        button->state = !button->state;
    }
    if (button->state) {
        ui_pref_width(ctx, ui_pct(1, 0));
        ui_pref_height(ctx, ui_children_sum(1));
        UiBox *popup = _build_box(ctx, DrawBackground | DrawBorder | FloatingPos, STR_LIT("popup_root"));
        _push_parent(ctx, popup);
        {
            ctx->popup_root = popup;
            if (direction == Horizontal) {
                popup->bounds.x = button->bounds.x + button->bounds.width;
                popup->bounds.y = button->bounds.y;
            } else {
                popup->bounds.x = button->bounds.x;
                popup->bounds.y = button->bounds.y + button->bounds.height;
            }
        }
        ui_pref_height_pop(ctx);
        ui_pref_width_pop(ctx);
    }
    ui_pref_height_pop(ctx);
    ui_pref_width_pop(ctx);
}

void ui_popup_end(UiCtx *ctx) {
    _pop_parent(ctx);
}

void ui_combo_box(UiCtx *ctx, int *value, String display, String *choices, int choice_count) {
    ui_pref_width(ctx, ui_children_sum(1));
    ui_pref_height(ctx, ui_children_sum(1));
    UiBox *container = _build_box(ctx, Clickable | DrawBackground | DrawBorder, display);
    _push_parent(ctx, container);
    String choice = choices[*value];
    ui_labelf(ctx, "%.*s: %.*s", display.len, display.data, choice.len, choice.data);
    _pop_parent(ctx);
    ui_pref_height_pop(ctx);
    ui_pref_width_pop(ctx);

    UiBoxEvent e = _get_box_mouse_event(ctx, container);
    if (e.mouse_event & BoxMouseClick) {
        container->state = !container->state;
    }

    ctx->popup_root = NULL;

    if (container->state) {
        ui_pref_width(ctx, ui_children_sum(1));
        ui_pref_height(ctx, ui_children_sum(1));
        // UiBox *popup = _build_box(ctx, DrawBackground | DrawBorder | FloatingPos, string_concat(frame_allocator(ctx), (String[]){display, "-popup"}, 2));
        UiBox *popup = _build_box(ctx, DrawBackground | DrawBorder | FloatingPos, null_key);
        popup->child_layout_axis = Vertical;
        _push_parent(ctx, popup);
        {
            ctx->popup_root = popup;
            popup->bounds.x = container->bounds.x;
            popup->bounds.y = container->bounds.y + container->bounds.height;
            ui_border_width(ctx, 0);
            for (int i = 0; i < choice_count; ++i) {
                if (ui_button(ctx, choices[i])) {
                    *value = i;
                    container->state = 0;
                }
            }
            ui_border_width_pop(ctx);
        }
        _pop_parent(ctx);
        ui_pref_height_pop(ctx);
        ui_pref_width_pop(ctx);
    }
}

bool32 ui_expander(UiCtx *ctx, String display) {
    bool32 open = FALSE;
    ui_pref_width(ctx, ui_pct(1, 1));
    ui_pref_height(ctx, ui_size_text());
    UiBox *box = _build_box(ctx, DrawBackground | DrawBorder | Clickable, display);
    box->child_layout_axis = Horizontal;
    UiBoxEvent e = _get_box_mouse_event(ctx, box);
    UiBoxMouseEvent me = e.mouse_event;
    if (me & BoxMouseClick) {
        box->state = !box->state;
    }
    open = box->state;
    _push_parent(ctx, box);
    {
        ui_spacer(ctx, Horizontal);
        String symbol = open ? STR_LIT(" v") : STR_LIT(" >");
        ui_label(ctx, string_concat(frame_allocator(ctx), (String[]){display, symbol}, 2));
        // ui_pref_width(ui_px(12, 1)) ui_pref_height(ui_px(12, 1)) {
        //     UiBox *icon = _build_box(ctx, DrawImage, null_key);
        //     icon->pref_size[Horizontal] = (UiSize){SizeKindPixels, 12};
        //     icon->pref_size[Vertical] = (UiSize){SizeKindPixels, 12};
        // }
        ui_spacer(ctx, Horizontal);
    }
    _pop_parent(ctx);

    ui_pref_height_pop(ctx);
    ui_pref_width_pop(ctx);

    return open;
}


// IDEA To provide us with different options for slider appearences, e.g. our current method of
// filling a rectangle, or a single "thumb" that slides along the bounding box
void ui_slider(UiCtx *ctx, float *value, float min, float max, String display) {
    ui_pref_width(ctx, ui_children_sum(1));
    ui_pref_height(ctx, ui_children_sum(1));
    UiBox *container = _build_box(ctx, 0, null_key);
    container->child_layout_axis = Vertical;
    _push_parent(ctx, container);
    {
        TempAlloc tmp = temp_alloc_begin(ctx->frame_arena);
        const char *fmt = cstring_from_string(ctx->frame_arena, display);
        ui_labelf(ctx, fmt, *value);
        ui_border_width(ctx, 2);
        ui_pref_width(ctx, ui_pct(1, 0));
        ui_pref_height(ctx, ui_px(30, 0));
        UiBox *slider_frame = _build_box(ctx, Clickable | Draggable | DrawBorder, display);
        _push_parent(ctx, slider_frame);
        {
            UiBoxEvent e = _get_box_mouse_event(ctx, slider_frame);
            float v = *value;
            float vnorm = (v - min) / (max - min);
            ui_pref_width(ctx, ui_pct(vnorm, 0));
            UiBox *slider = _build_box(ctx, DrawBackground, null_key);
            if (e.mouse_event & BoxMouseDrag) {
                float drag_scale = 0.005f;
                float max_delta = 1.f;

                float delta = clamp_top((float)e.mouse_dx * drag_scale, max_delta);
                vnorm += delta;
                vnorm = clamp(vnorm, 0, 1);
                v = vnorm * (max - min) + min;
                v = clamp(v, min, max);
                *value = v;
            }
            ui_pref_width_pop(ctx);
        }
        _pop_parent(ctx);
        ui_pref_height_pop(ctx);
        ui_pref_width_pop(ctx);
        ui_border_width_pop(ctx);
    }
    _pop_parent(ctx);
    ui_pref_height_pop(ctx);
    ui_pref_width_pop(ctx);
}

void ui_pref_width(UiCtx *ctx, UiSize size) {
    array_append(frame_allocator(ctx), &ctx->pref_width_stack, size);
}

void ui_pref_width_pop(UiCtx *ctx) {
    array_pop(&ctx->pref_width_stack);
}

void ui_pref_height(UiCtx *ctx, UiSize size) {
    array_append(frame_allocator(ctx), &ctx->pref_height_stack, size);
}

void ui_pref_height_pop(UiCtx *ctx) {
    array_pop(&ctx->pref_height_stack);
}

UiSize ui_size_text() {
    return (UiSize){.kind = SizeKindText, .strictness = 1};
}

UiSize ui_children_sum(float strict) {
    return (UiSize){.kind = SizeKindChildrenSum, .strictness = strict};
}

UiSize ui_px(float pixels, float strict) {
    return (UiSize){.kind = SizeKindPixels, .value = pixels, .strictness = strict};
}

UiSize ui_pct(float pct, float strict) {
    return (UiSize){.kind = SizeKindParentPct, .value = pct, .strictness = strict};
}

void ui_border_width(UiCtx *ctx, float width) {
    array_append(allocator(ctx), &ctx->border_width_stack, width);
}

void ui_border_width_pop(UiCtx *ctx) {
    array_pop(&ctx->border_width_stack);
}

void ui_gap_x(UiCtx *ctx, int gap) {
    array_append(allocator(ctx), &ctx->x_gap_stack, gap);
}

void ui_gap_x_pop(UiCtx *ctx) {
    array_pop(&ctx->x_gap_stack);
}

void ui_gap_y(UiCtx *ctx, int gap) {
    array_append(allocator(ctx), &ctx->y_gap_stack, gap);
}

void ui_gap_y_pop(UiCtx *ctx) {
    array_pop(&ctx->y_gap_stack);
}

void ui_background_color(UiCtx *ctx, av_Colorf color) {
    array_append(allocator(ctx), &ctx->background_color_stack, color);
}

void ui_background_color_pop(UiCtx *ctx) {
    array_pop(&ctx->background_color_stack);
}

void ui_highlight_color(UiCtx *ctx, av_Colorf color) {
    array_append(allocator(ctx), &ctx->highlight_color_stack, color);
}

void ui_highlight_color_pop(UiCtx *ctx) {
    array_pop(&ctx->highlight_color_stack);
}

void ui_border_color(UiCtx *ctx, av_Colorf color) {
    array_append(allocator(ctx), &ctx->border_color_stack, color);
}

void ui_border_color_pop(UiCtx *ctx) {
    array_pop(&ctx->border_color_stack);
}

void ui_corner_radius(UiCtx *ctx, float radius) {
    array_append(allocator(ctx), &ctx->corner_radius_stack, radius);
}

void ui_corner_radius_pop(UiCtx *ctx) {
    array_pop(&ctx->corner_radius_stack);
}

// Must be called before doing layout
void ui_enable_performance_clock(UiCtx *ctx) {
    ctx->measure_perf = TRUE;
    clock_gettime(CLOCK_MONOTONIC, &ctx->layout_start);
}

static usize timespec_delta(struct timespec start, struct timespec end) {
    return (usize)(((float)end.tv_sec - (float)start.tv_sec) * 1e6)  +
                      (end.tv_nsec - start.tv_nsec) / 1000;
}

// Call this after ui_render to profile the full render & layout pass
// TODO calc a moving average rather than displaying exact delta each frame
void _perf_clock_end(UiCtx *ctx) {
    usize layout_delta_us = timespec_delta(ctx->layout_start, ctx->layout_end);
    usize render_delta_us = timespec_delta(ctx->draw_start, ctx->draw_end);
    float layout_delta = (float)layout_delta_us / 1000.f;
    float render_delta = (float)render_delta_us / 1000.f;
    float total = layout_delta + render_delta;
    float layout_pct = (layout_delta / total) * 100.f;
    float render_pct = (render_delta / total) * 100.f;

    String time = string_printf(frame_allocator(ctx),
        "Layout: %.2f ms | %.2f%%\nDraw: %.2f ms | %.2f%%\nTotal: %.2f ms",
        layout_delta, layout_pct, render_delta, render_pct, total);
    String ram = string_printf(frame_allocator(ctx), "Arena: %$dB | Frame: %$dB",
            arena_query_size(ctx->arena),
            arena_query_size(ctx->frame_arena));
    av_Size time_size = pv_measure_text(ctx->rdr_ctx, time);
    av_Size ram_size = pv_measure_text(ctx->rdr_ctx, ram);
    float total_height = time_size.height + ram_size.height;
    av_TextStyle style = (av_TextStyle){
        .justify = av_TextJustifyLeft,
        .color = {1, 1, 1, 1},
    };
    pv_draw_text(ctx->rdr_ctx, time, (av_Rect){0, ctx->height - total_height,
                time_size.width, time_size.height},
                style, 14);
    pv_draw_text(ctx->rdr_ctx, ram, (av_Rect){0, ctx->height - ram_size.height,
                ram_size.width, ram_size.height},
                style, 14);
    ctx->measure_perf = FALSE;
}

void _draw_box(UiCtx *ctx, UiBox *box) {
    pv_Context *rdr = ctx->rdr_ctx;
    av_Rect bounds = box->bounds;
    float text_size = pv_get_current_font_size(rdr);
    UiBoxStyle style = box->style;
    av_TextStyle text_style = style.text_style;

    av_Colorf fill_color = style.background_color;
    if (box->flags & FocusHot)
        fill_color = style.highlight_color;
    // if (box->flags & FocusActive)
    //     fill_color = style.active_color;

    if (box->flags & DrawBackground) {
        if (style.corner_radius == 0)
            pv_fill_rect(rdr, bounds, fill_color);
        else
            pv_fill_rounded_rect(rdr, bounds, style.corner_radius, fill_color);
    }
    if (box->flags & DrawBorder) {
        if (style.corner_radius == 0)
            pv_draw_rect(rdr, bounds, style.border_width, style.border_color);
        else
            pv_draw_rounded_rect(rdr, bounds, style.corner_radius, style.border_width, style.border_color);
    }
    if (box->flags & DrawImage) {
        pv_draw_icon(rdr, box->icon, bounds, (av_Colorf){1, 1, 1, 1});
    }
    if (box->flags & DrawText)
        pv_draw_text(rdr, string(box->display), bounds, text_style, text_size);
    // if (box->flags & DrawText) {
    //     switch (text_style.align) {
    //         case TextAlignInside:
    //         {
    //             rdrFillRect(rdr, bounds, fill_color);
    //             rdrDrawRect(rdr, bounds, style.border_width, style.border_color);
    //             rdrDrawText(rdr, box->display, bounds, text_style.color, text_size);
    //         } break;
    //         case TextAlignAbove:
    //         {
    //             av_Rect text_bounds = rect_with_height(bounds, bounds.height / 2);
    //             rdrDrawText(rdr, box->display, text_bounds, text_style.color, text_size);
    //             bounds.height /= 2;
    //             bounds.y += bounds.height;
    //             rdrFillRect(rdr, bounds, fill_color);
    //             rdrDrawRect(rdr, bounds, style.border_width, style.border_color);
    //         } break;
    //         default:
    //             rdrFillRect(rdr, bounds, fill_color);
    //             rdrDrawRect(rdr, bounds, style.border_width, style.border_color);
    //             rdrDrawText(rdr, box->display, bounds, text_style.color, text_size);
    //             break;
    //     }
    // } else {
    //     rdrFillRect(rdr, bounds, fill_color);
    //     rdrDrawRect(rdr, bounds, style.border_width, style.border_color);
    // }

    // if (box->flags & DrawValue) {
    //     if (box->flags & ValueFixedSize) {
    //         bool32 on = box->value == 1.f;
    //         av_Rect value_bounds = {bounds.x + box->gap[Horizontal],
    //             bounds.y + box->value_fixed_size[Vertical] / 2.f - box->gap[Vertical],
    //             box->value_fixed_size[Horizontal],
    //             box->value_fixed_size[Vertical]};
    //         if (on)
    //             rdrFillRect(rdr, value_bounds, style.value_color);
    //         else
    //             rdrDrawRect(rdr, value_bounds, 2, style.value_color);
    //     } else {
    //         av_Rect value_bounds = rect_with_width(bounds, (int)(bounds.width * box->value));
    //         rdrFillRect(rdr, value_bounds, style.value_color);
    //     }
    // }
}

void _calc_fixed_sizes(UiCtx *ctx, UiBox *root, UiAxis axis) {
    switch (root->pref_size[axis].kind) {
        case SizeKindPixels:
            root->fixed_size[axis] = root->pref_size[axis].value;
            break;
        case SizeKindText:
        {
            av_Size size = pv_measure_text(ctx->rdr_ctx, string(root->display));
            if (axis == Horizontal) {
                root->fixed_size[axis] = size.width + root->style.text_style.padding * 2;
            } else {
                root->fixed_size[axis] = size.height + root->style.text_style.padding * 2;
            }
        } break;
        default: break;
    }

    for (UiBox *child = root->first_child; child != NULL; child = child->next) {
        _calc_fixed_sizes(ctx, child, axis);
    }
}

void _calc_top_down_sizes(UiCtx *ctx, UiBox *root, UiAxis axis) {
    switch(root->pref_size[axis].kind) {
        case SizeKindParentPct:
        {
            UiBox *fixed_parent = NULL;
            for (UiBox *p = root->parent; p != NULL; p = p->parent) {
                if (p->pref_size[axis].kind == SizeKindPixels ||
                    p->pref_size[axis].kind == SizeKindText ||
                    p->pref_size[axis].kind == SizeKindParentPct) {
                    fixed_parent = p;
                    break;
                }
            }
            root->fixed_size[axis] = fixed_parent->fixed_size[axis] * root->pref_size[axis].value;
        } break;
        default: break;
    }

    for (UiBox *child = root->first_child; child != NULL; child = child->next) {
        _calc_top_down_sizes(ctx, child, axis);
    }
}

void _calc_bottom_up_sizes(UiCtx *ctx, UiBox *root, UiAxis axis) {
    // recurse first
    for (UiBox *child = root->first_child; child != NULL; child = child->next) {
        _calc_bottom_up_sizes(ctx, child, axis);
    }

    switch (root->pref_size[axis].kind) {
        case SizeKindChildrenSum:
        {
            float sum = 0;
            for (UiBox *child = root->first_child; child != NULL; child = child->next) {
                if (axis == root->child_layout_axis) {
                    sum += child->fixed_size[axis] + child->gap[axis] * 2;
                } else {
                    sum = clamp_bot(sum, child->fixed_size[axis] + child->gap[axis] * 2);
                }
            }
            root->fixed_size[axis] = sum;
        } break;
        default: break;
    }
}

void _calc_lateral_sizes(UiCtx *ctx, UiBox *root, UiAxis axis) {
    int n = 0;
    UiBox *parent = root->parent;
    if (parent) {
        for (UiBox *sib = parent->first_child; sib != NULL; sib = sib->next) {
            if (sib->pref_size[axis].kind == SizeKindGrow) {
                n += 1;
            }
        }
    }

    if (root->pref_size[axis].kind == SizeKindGrow) {
        float sibling_sum = 0;
        float rem = 0;
        UiBox *parent = root->parent;
        float total_size = parent->fixed_size[axis];
        for (UiBox *sib = parent->first_child; sib != NULL; sib = sib->next) {
            sibling_sum += sib->fixed_size[axis];
        }
        rem = total_size - sibling_sum;

        root->fixed_size[axis] = rem / n;
    }

    for (UiBox *child = root->first_child; child != NULL; child = child->next) {
        _calc_lateral_sizes(ctx, child, axis);
    }
}

void _resolve_sizes(UiCtx *ctx, UiBox *root, UiAxis axis) {
    // top-down resolutions
    if (axis == root->child_layout_axis) {
        float max_size = root->fixed_size[axis];
        float total_size = 0;
        float total_weighted_size = 0;
        for (UiBox *child = root->first_child; child != NULL; child = child->next) {
            if (!(child->flags & (FloatingX << axis))) {
                total_size += child->fixed_size[axis];
                total_weighted_size += child->fixed_size[axis] * (1.f - child->pref_size[axis].strictness);
            }
        }

        float over = total_size - max_size;
        if (over > 0 & total_weighted_size > 0) {
            // Array(float) fixups = {0};
            TempAlloc tmp = temp_alloc_begin(ctx->frame_arena);
            float *fixups = (float*)arena_alloc(ctx->frame_arena, sizeof(f32) * root->num_children);
            int fid = 0;
            for (UiBox *child = root->first_child; child != NULL; child = child->next) {
                if (!(child->flags & (FloatingX << axis))) {
                    float fixup = child->fixed_size[axis] * (1.f - child->pref_size[axis].strictness);
                    fixup = fmaxf(0.f, fixup);
                    // array_append(&ctx->frame_arena->allocator, &fixups, fixup);
                    fixups[fid] = fixup;
                    fid += 1;
                }
            }

            float fix_pct = clamp(over / total_size, 0, 1);
            size_t child_idx = 0;
            for (UiBox *child = root->first_child; child != NULL; child = child->next, child_idx++) {
                if (!(child->flags & (FloatingX << axis))) {
                    child->fixed_size[axis] -= fix_pct * fixups[child_idx];
                }
            }

            temp_alloc_end(&tmp);
        }
    } else {
        float max_size = root->fixed_size[axis];
        for (UiBox *child = root->first_child; child != NULL; child = child->next) {
            if (!(child->flags & (FloatingX << axis))) {
                float size = child->fixed_size[axis];
                float over = size - max_size;
                float fix = clamp(over, 0, size);
                if (fix > 0) {
                    child->fixed_size[axis] -= fix;
                }
            }
        }
    }

    // bottom-up resolutions
    // NOTE How do we enforce some kind of fixup when these pref. sizes overflow?
    for (UiBox *child = root->first_child; child != NULL; child = child->next) {
        if (child->pref_size[axis].kind == SizeKindParentPct) {
            child->fixed_size[axis] = root->fixed_size[axis] * child->pref_size[axis].value;
        }
    }

    for (UiBox *child = root->first_child; child != NULL; child = child->next) {
        _resolve_sizes(ctx, child, axis);
    }
}

void _calc_positions(UiBox *root, UiAxis axis) {
    float rel_pos = 0;

    for (UiBox *child = root->first_child; child != NULL; child = child->next) {
        if (!(child->flags & (FloatingX << axis))) {
            child->rel_pos[axis] = rel_pos + child->gap[axis];
            if (axis == root->child_layout_axis) {
                rel_pos += child->fixed_size[axis] + child->gap[axis] * 2.f;
            }

            av_Rect *child_bounds = &child->bounds;
            av_Rect root_bounds = root->bounds;
            if (axis == Horizontal) {
                child_bounds->x = floorf(root_bounds.x + child->rel_pos[axis]);
                child_bounds->width = floorf(child->fixed_size[axis]);
            } else {
                child_bounds->y = floorf(root_bounds.y + child->rel_pos[axis]);
                child_bounds->height = floorf(child->fixed_size[axis]);
            }
        } else {
            child->rel_pos[axis] = rel_pos + child->gap[axis];
            UiAxis layout_axis = root->child_layout_axis;
            if (axis == layout_axis)
                rel_pos += child->fixed_size[axis] + child->gap[axis] * 2.f;
            if (axis == Horizontal) {
                child->bounds.x = floorf(child->rel_pos[axis] + root->bounds.x);
                child->bounds.width = floorf(child->fixed_size[axis]);
            } else {
                child->bounds.y = floorf(child->rel_pos[axis] + root->bounds.y);
                child->bounds.height = floorf(child->fixed_size[axis]);
            }
        }
    }

    for (UiBox *child = root->first_child; child != NULL; child = child->next) {
        _calc_positions(child, axis);
    }
}

void ui_do_layout(UiCtx *ctx) {
    for (UiAxis axis = 0; axis < 2; axis++) {
        _calc_fixed_sizes(ctx, &ctx->root_box, axis);
        _calc_top_down_sizes(ctx, &ctx->root_box, axis);
        _calc_bottom_up_sizes(ctx, &ctx->root_box, axis);
        _resolve_sizes(ctx, &ctx->root_box, axis);
        _calc_lateral_sizes(ctx, &ctx->root_box, axis);
        _calc_positions(&ctx->root_box, axis);
    }

    // layout popup
    // TODO this repetition feels dumb. What is wrong with our approach here?
    UiBox *proot = ctx->popup_root;
    if (proot) {
        for (UiAxis axis = 0; axis < 2; axis++) {
            _calc_fixed_sizes(ctx, proot, axis);
            _calc_top_down_sizes(ctx, proot, axis);
            _calc_bottom_up_sizes(ctx, proot, axis);
            _resolve_sizes(ctx, proot, axis);
            _calc_lateral_sizes(ctx, proot, axis);
            _calc_positions(proot, axis);
        }
    }
}

void _reset_tree(UiCtx *ctx) {
    memset(&ctx->root_box, 0, sizeof(UiBox));
    ctx->popup_root = NULL;
    _pop_parent(ctx);
}

void _draw_tree(UiCtx *ctx, UiBox *root) {
    _draw_box(ctx, root);
    for (UiBox *child = root->first_child; child != NULL; child = child->next) {
        _draw_tree(ctx, child);
    }
}

void ui_begin(UiCtx *ctx) {
    pv_begin_drawing(ctx->rdr_ctx);
    // init stack defaults
    av_TextStyle ts = {
        .color = (av_Colorf){.r = 1, .g = 1, .b = 1, .a = 1},
        .padding = 2.f,
    };
    array_append(frame_allocator(ctx), &ctx->text_style_stack, ts);
    ui_background_color(ctx, (av_Colorf){.r = 0.15f, .g = 0.3f, .b = 0.3f, .a = 1});
    ui_highlight_color(ctx, (av_Colorf){.r = 0.3f, .g = 0.3f, .b = 0.3f, .a = 1});
    ui_border_color(ctx, (av_Colorf){1, 1, 1, 1});
    _build_root(ctx);
}

void _ui_render(UiCtx *ctx) {
    UiBox *root = &ctx->root_box;
    pv_clear(ctx->rdr_ctx, root->style.background_color);
    _draw_tree(ctx, root);
    // draw popup trees
    if (ctx->popup_root)
        _draw_tree(ctx, ctx->popup_root);
    // reset at frame end
    _reset_tree(ctx);
    ctx->frame_idx++;
}

void _clear_all_stacks(UiCtx *ctx) {
    array_reset(&ctx->flag_stack);
    array_reset(&ctx->pref_width_stack);
    array_reset(&ctx->pref_height_stack);
    array_reset(&ctx->x_gap_stack);
    array_reset(&ctx->y_gap_stack);
    array_reset(&ctx->pref_width_stack);
    array_reset(&ctx->pref_height_stack);
    array_reset(&ctx->text_style_stack);
    array_reset(&ctx->background_color_stack);
    array_reset(&ctx->highlight_color_stack);
    array_reset(&ctx->border_color_stack);
    array_reset(&ctx->border_width_stack);
    array_reset(&ctx->corner_radius_stack);
}

// Call this when UI description & layout is complete
void ui_end(UiCtx *ctx) {
    ui_do_layout(ctx);
    clock_gettime(CLOCK_MONOTONIC, &ctx->layout_end);
    clock_gettime(CLOCK_MONOTONIC, &ctx->draw_start);
    _ui_render(ctx);
    pv_end_drawing(ctx->rdr_ctx);
    clock_gettime(CLOCK_MONOTONIC, &ctx->draw_end);
    if (ctx->measure_perf)
        _perf_clock_end(ctx);
    ctx->mouse.dx = 0;
    ctx->mouse.dy = 0;
    _clear_all_stacks(ctx);
    arena_reset(ctx->frame_arena);
}
