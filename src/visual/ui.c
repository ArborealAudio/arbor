#include "ui.h"

static inline Allocator *allocator(UICtx *ctx) {
    return &ctx->arena->allocator;
}

UICtx* ui_init(pv_Context *pv_ctx) {
    UICtx *ctx = arena_alloc(pv_ctx->arena, sizeof(UICtx));
    av_Size size = pv_get_render_size(pv_ctx);
    *ctx = (UICtx){
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

    return ctx;
}

void ui_deinit(UICtx *ctx) {
    shfree(ctx->table);
    arena_deinit(ctx->frame_arena);
}

void ui_send_event(UICtx *ctx, pv_Event *event) {
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

UiBox *_get_box(UICtx *ctx, const char *key) {
    Table *entry = NULL;
    if ((entry = shgetp_null(ctx->table, key))) {
        return entry->value;
    }

    return NULL;
}


UiBoxEvent _get_box_mouse_event(UICtx *ctx, UiBox *box) {
    UiBoxEvent e = {
        .mouse_x = ctx->mouse.x,
        .mouse_y = ctx->mouse.y,
        .mouse_dx = ctx->mouse.dx,
        .mouse_dy = ctx->mouse.dy,
        .mouse_button = ctx->mouse.button,
    };
    bool32 mouse_over = FALSE;
    if (rect_contains(box->bounds, e.mouse_x, e.mouse_y)) {
        e.mouse_event |= BoxMouseOver | BoxMouseHover;
        mouse_over = TRUE;
    }

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
    }

    if ((ctx->mouse.dx != 0 || ctx->mouse.dy != 0) && (box->flags & Draggable)) {
        // NOTE Technically weird since you could continue the drag by switching from left->right
        // mouse button. uhuhhh
        if ((mouse_down && mouse_over) ||
            (e.mouse_button != pv_MouseNone && (box->last_event & BoxMouseDrag)))
            e.mouse_event |= BoxMouseDrag;
    }

    if (!mouse_down && (box->last_event & BoxMouseDown) && (box->flags & Clickable) && mouse_over) {
        e.mouse_event |= BoxMouseClick;
    }

    box->last_event = e.mouse_event;
    return e;
}

void _push_parent(UICtx *ctx, UiBox *parent) {
    array_append(allocator(ctx), &ctx->parent_stack, parent);
}

UiBox *_pop_parent(UICtx *ctx) {
    return array_pop(&ctx->parent_stack);
}

UiBox *_get_parent(UICtx *ctx) {
    return array_last(&ctx->parent_stack);
}

void _push_flags(UICtx *ctx, uint32_t flag) {
    array_append(allocator(ctx), &ctx->flag_stack, flag);
}

UiBoxFlag _last_flags(UICtx *ctx) {
    size_t len = ctx->flag_stack.len;
    if (len == 0)
        return 0;
    return array_last(&ctx->flag_stack);
}

UiBoxFlag *_last_flags_ptr(UICtx *ctx) {
    size_t len = ctx->flag_stack.len;
    if (len == 0)
        return &box_flag_null;
    return array_last_ptr(&ctx->flag_stack);
}

void _pop_flags(UICtx *ctx) {
    array_pop(&ctx->flag_stack);
}

void _clear_flag_stack(UICtx *ctx) {
    array_resize(allocator(ctx), &ctx->flag_stack, 0);
}

UiBoxStyle _build_style(UiBoxStyle style) {
    UiBoxStyle s = style;
    if (av_colorf_is_zero(&s.text_style.color))
        s.text_style.color = default_style.text_style.color;
    if (av_colorf_is_zero(&s.background_color))
        s.background_color = default_style.background_color;
    if (av_colorf_is_zero(&s.border_color))
        s.border_color = default_style.border_color;
    if (av_colorf_is_zero(&s.highlight_color))
        s.highlight_color = default_style.highlight_color;
    if (av_colorf_is_zero(&s.active_color))
        s.active_color = default_style.active_color;
    if (av_colorf_is_zero(&s.value_color))
        s.value_color = default_style.value_color;
    if (style.text_style.padding == 0)
        s.text_style.padding = default_style.text_style.padding;

    return s;
}

void _append_to_tree(UICtx *ctx, UiBox *new) {
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

void _build_root(UICtx *ctx) {
    av_Size size = pv_get_render_size(ctx->rdr_ctx);
    UiBox root = (UiBox){
        .style = {},
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

void _set_box_string(UiBox *box, const char *string) {
    memcpy(box->display, string, string_len(string));
}

UiBox *_build_box(UICtx *ctx, UiBoxFlag flags, UiBoxStyle style, const char *key) {
    bool32 is_transient = key == null_key;
    UiBox *box = is_transient ? null_box : _get_box(ctx, key);
    if (!box) {
        if (is_transient) {
            box = ui_frame_alloc(UiBox);
        } else {
            box = ui_new(UiBox);
        }
        *box = (UiBox){
            .style = _build_style(style),
            .flags = flags | _last_flags(ctx),
        };
        if (!is_transient) {
            _set_box_string(box, key);
            shput(ctx->table, key, box);
        }
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

void ui_set_background_color(UICtx *ctx, av_Colorf color) {
    ctx->root_box.style.background_color = color;
}

void ui_row_begin(UICtx *ctx, UiBoxStyle style) {

    UiBox *box = _build_box(ctx, DrawBackground | DrawBorder, style, null_key);
    box->child_layout_axis = Horizontal;
    box->pref_size[Horizontal] = (UiSize){SizeKindParentPct, 1};
    box->pref_size[Vertical] = (UiSize){SizeKindChildrenSum};
    _push_parent(ctx, box);
}

void ui_row_end(UICtx *ctx) {
    _pop_parent(ctx);
}

void ui_column_begin(UICtx *ctx, UiBoxStyle style) {

    UiBox *box = _build_box(ctx, DrawBackground | DrawBorder, style, null_key);
    box->child_layout_axis = Vertical;
    box->pref_size[Vertical] = (UiSize){SizeKindChildrenSum};
    box->pref_size[Horizontal] = (UiSize){SizeKindChildrenSum};
    _push_parent(ctx, box);
}

void ui_column_end(UICtx *ctx) {
    _pop_parent(ctx);
}

void ui_label(UICtx *ctx, const char *text, UiBoxStyle style) {
    UiBox *box = _build_box(ctx, DrawText, style, null_key);
    _set_box_string(box, text);
    box->pref_size[Horizontal] = (UiSize){.kind = SizeKindText, .strictness = 1};
    box->pref_size[Vertical] = (UiSize){.kind = SizeKindText, .strictness = 1};
}

void ui_labelf(UICtx *ctx, UiBoxStyle style, const char *fmt, ...) {
    va_list args;
    va_start(args, fmt);
    String str = string_printfv(&ctx->frame_arena->allocator, fmt, args);
    ui_label(ctx, str.data, style);
    va_end(args);
}

bool32 ui_button(UICtx *ctx, const char *text, UiBoxStyle style) {
    UiBox *box = _build_box(ctx, Clickable | DrawText | DrawBackground | DrawBorder, style, text);
    box->pref_size[Horizontal] = (UiSize){.kind = SizeKindText, .strictness = 1};
    box->pref_size[Vertical] = (UiSize){.kind = SizeKindText, .strictness = 1};

    UiBoxEvent e = _get_box_mouse_event(ctx, box);
    bool32 clicked = FALSE;
    if (e.mouse_event & BoxMouseHover) {
        // box->background_color = button_color_highlight;
        box->flags |= FocusHot;
    }
    if (e.mouse_event & BoxMouseDown) {
        // box->background_color = button_color_down;
        box->flags |= FocusActive;
    }
    if (e.mouse_event & BoxMouseClick) {
        clicked = TRUE;
    }
    return clicked;
}

void ui_toggle_button(UICtx *ctx, bool32 *state, const char *display, UiBoxStyle style) {
    UiBox *container = _build_box(ctx, Clickable | DrawBackground | DrawBorder, style, display);
    container->child_layout_axis = Horizontal;
    container->pref_size[Horizontal] = (UiSize){SizeKindChildrenSum};
    container->pref_size[Vertical] = (UiSize){SizeKindChildrenSum};
    _push_parent(ctx, container);
    UiBoxFlag toggle_flags = *state ? DrawBackground : DrawBorder;

    array_append(allocator(ctx), &ctx->pref_width_stack,
                 ((UiSize){SizeKindPixels, 20}));
    array_append(allocator(ctx), &ctx->pref_height_stack,
                 ((UiSize){SizeKindPixels, 20}));
    // TODO Determine toggle box's background & border color programmatically--inherit/default
    UiBox *toggle = _build_box(ctx, toggle_flags, (UiBoxStyle){
                                   .background_color = {1, 1, 1, 1},
                                   .border_width = 2,
                               }, null_key);
    array_pop(&ctx->pref_height_stack);
    array_pop(&ctx->pref_width_stack);

    array_append(allocator(ctx), &ctx->pref_width_stack,
                 ((UiSize){SizeKindText, 0, 1}));
    array_append(allocator(ctx), &ctx->pref_height_stack,
                 ((UiSize){SizeKindText, 0, 1}));
    UiBox *label = _build_box(ctx, DrawText, style, null_key);
    _set_box_string(label, display);
    array_pop(&ctx->pref_height_stack);
    array_pop(&ctx->pref_width_stack);

    _pop_parent(ctx);

    UiBoxEvent e = _get_box_mouse_event(ctx, container);
    if (e.mouse_event & BoxMouseHover) {
        container->flags |= FocusHot;
    }
    if (e.mouse_event & BoxMouseDown) {
        container->flags |= FocusActive;
    }
    if (e.mouse_event & BoxMouseClick) {
        // box->background_color = button_background;
        *state = !*state;
    }
    container->value = (float)*state;
}

bool32 ui_icon_button(UICtx *ctx, pv_IconSlot icon, const char *id, UiBoxStyle style) {
    UiBox *box = _build_box(ctx, DrawBackground | DrawBorder | Clickable | DrawImage, style, id);
    box->pref_size[Horizontal] = (UiSize){SizeKindPixels, 32};
    box->pref_size[Vertical] = (UiSize){SizeKindPixels, 32};
    box->icon = icon;

    UiBoxEvent e = _get_box_mouse_event(ctx, box);
    if (e.mouse_event & BoxMouseHover) {
        box->flags |= FocusHot;
    }
    if (e.mouse_event & BoxMouseDown) {
        box->flags |= FocusActive;
    }
    if (e.mouse_event & BoxMouseClick) {
        return TRUE;
    } else {
        return FALSE;
    }
}

void ui_spacer(UICtx *ctx, UiAxis direction) {
    UiBox *box = ui_frame_alloc(UiBox);
    box->pref_size[direction] = (UiSize){SizeKindGrow};
    box->pref_size[!direction] = (UiSize){SizeKindPixels, 0};
    _append_to_tree(ctx, box);
}

// Create a popup window at a specific size and location
// Not a new OS window
// Returns whether the window is open
// ISSUE doesn't really create a floating window
bool32 ui_window_begin(UICtx *ctx, char *display, UiBoxStyle style, av_Rect rect) {
    String close_window = string_concat(&ctx->frame_arena->allocator,
                                     (String[]){string(display), string("-close")}, 2);

    UiBox *window = _build_box(ctx, FloatingPos | DrawBorder | DrawBackground, style, null_key);
    window->pref_size[Horizontal] = (UiSize){SizeKindPixels, rect.width, 1};
    window->pref_size[Vertical] = (UiSize){SizeKindPixels, rect.height, 1};
    window->child_layout_axis = Vertical;
    // window->bounds = rect;
    _push_parent(ctx, window);
    _push_flags(ctx, FloatingPos);
    UiBox *titlebar = _build_box(ctx, Clickable | Draggable, style, display);
    titlebar->pref_size[Horizontal] = (UiSize){SizeKindParentPct, 1};
    titlebar->pref_size[Vertical] = (UiSize){SizeKindChildrenSum};
    bool32 should_close = FALSE;
    {
        _push_parent(ctx, titlebar);
        ui_row_begin(ctx, style);
        ui_label(ctx, display, style);
        ui_spacer(ctx, Horizontal);
        if (ui_icon_button(ctx, pv_IconX, close_window.data, (UiBoxStyle){
                .background_color = (av_Colorf){.r = 0.5, .a = 1}
            }))
                should_close = TRUE;
        ui_row_end(ctx);
        _pop_parent(ctx);
    }

    UiBoxMouseEvent le = titlebar->last_event;
    UiBoxEvent e = _get_box_mouse_event(ctx, titlebar);
    if (e.mouse_event & BoxMouseDrag) {
        // ISSUE This sin't doing what we want it to, since this gets set to TRUE even if we are
        // dragging outside title bounds
        bool32 continuing_drag = le & BoxMouseDrag;
        av_Rect tb_rect = titlebar->bounds;
        if ((rect_contains(tb_rect, e.mouse_x, e.mouse_y) && !continuing_drag) ||
                continuing_drag) {
            // translate box by mouse delta
            window->bounds.x += e.mouse_dx;
            window->bounds.y += e.mouse_dy;
        }
    }

    return !should_close;
}

void ui_window_end(UICtx *ctx) {
    if (ctx->flag_stack.len != 0) {
        _pop_flags(ctx);
    }
    _pop_parent(ctx);
}

// Returns TRUE if menu is opened
bool32 ui_popup_begin(UICtx *ctx, UiAxis direction, const char *display,
                         UiBoxStyle button_style, UiBoxStyle popup_style) {
    UiBox *button = _build_box(ctx, Clickable | DrawText | DrawBackground | DrawBorder,
                               button_style, display);
    button->pref_size[Horizontal] = (UiSize){.kind = SizeKindText, .strictness = 1};
    button->pref_size[Vertical] = (UiSize){.kind = SizeKindText, .strictness = 1};
    UiBoxEvent e = _get_box_mouse_event(ctx, button);
    if (e.mouse_event & BoxMouseHover)
        button->flags |= FocusHot;
    if (e.mouse_event & BoxMouseDown)
        button->flags |= FocusActive;
    if (e.mouse_event & BoxMouseClick) {
        button->value = (float)!(bool)button->value;
    }
    if ((bool)button->value) {
        const char *popup_key = "popup_root";
        UiBox *popup = _get_box(ctx, popup_key);
        if (!popup) {
            popup = ui_new(UiBox);
            shput(ctx->table, popup_key, popup);
        }
        *popup = (UiBox) {
            .flags = FloatingPos | DrawBackground | DrawBorder,
            .style = popup_style,
            .child_layout_axis = direction,
            .pref_size = {{SizeKindChildrenSum}, {SizeKindChildrenSum}},
        };
        _clear_box_links(popup);
        _push_parent(ctx, popup);
        ctx->popup_root = popup;
        if (direction == Horizontal) {
            popup->bounds.x = button->bounds.x + button->bounds.width;
            popup->bounds.y = button->bounds.y;
        } else {
            popup->bounds.x = button->bounds.x;
            popup->bounds.y = button->bounds.y + button->bounds.height;
        }
        return TRUE;
    }
    return FALSE;
}

void ui_popup_end(UICtx *ctx) {
    _pop_parent(ctx);
}

bool32 ui_expander(UICtx *ctx, char *display, UiBoxStyle style) {
    UiBox *box = _build_box(ctx,
                            DrawBackground | DrawBorder | Clickable,
                            style,
                            display);
    box->child_layout_axis = Horizontal;
    box->pref_size[Horizontal] = (UiSize){SizeKindParentPct, 1};
    box->pref_size[Vertical] = (UiSize){SizeKindText};
    _push_parent(ctx, box);
    ui_spacer(ctx, Horizontal);
    ui_label(ctx, display, style);
    UiBox *icon = _build_box(ctx, DrawImage, style, null_key);
    icon->pref_size[Horizontal] = (UiSize){SizeKindPixels, 12};
    icon->pref_size[Vertical] = (UiSize){SizeKindPixels, 12};
    ui_spacer(ctx, Horizontal);
    _pop_parent(ctx);

    UiBoxEvent e = _get_box_mouse_event(ctx, box);
    UiBoxMouseEvent me = e.mouse_event;
    bool32 open = (bool)box->value;
    if (me & BoxMouseHover) {
        box->flags |= FocusHot;
    }
    if (me & BoxMouseDown) {
        box->flags |= FocusActive;
    }
    if (me & BoxMouseClick) {
        open = !open;
        box->value = (float)open;
    }

    if (open)
        icon->icon = pv_IconExpanderOpen;
    else
        icon->icon = pv_IconExpanderClosed;

    return open;
}


void ui_slider(UICtx *ctx, float *value, float min, float max,
                    const char *display, UiBoxStyle style) {
    UiBox *container = _build_box(ctx, DrawBackground | DrawBorder, style, null_key);
    container->child_layout_axis = Vertical;
    container->pref_size[Horizontal] = (UiSize){SizeKindChildrenSum};
    container->pref_size[Vertical] = (UiSize){SizeKindChildrenSum};
    _push_parent(ctx, container);

    ui_labelf(ctx, style, display, *value);

    UiBox *slider = _build_box(ctx,
        Clickable | Draggable | DrawBackground | DrawBorder | DrawValue,
        style, display);
    slider->style.border_width = 2;
    // TODO Could we programatically determine a default value color based on the background
    // color, such that it "automatically" contrasts?
    slider->pref_size[Horizontal] = (UiSize){SizeKindParentPct, 1};
    slider->pref_size[Vertical] = (UiSize){SizeKindPixels, 50.f, 0.5f};

    _pop_parent(ctx);

    UiBoxEvent e = _get_box_mouse_event(ctx, slider);

    if (e.mouse_event & BoxMouseHover) {
        // box->background_color = 0xff444444;
        slider->flags |= FocusHot;
    } else {
        // box->background_color = 0xff222222;
    }

    if (e.mouse_event & BoxMouseDrag) {
        float v = *value;
        float vnorm = (v - min) / (max - min);
        const float drag_scale = 0.01f;
        float delta = (float)e.mouse_dx * drag_scale;
        vnorm += delta;
        vnorm = fminf(1.f, vnorm);
        vnorm = fmaxf(0.f, vnorm);
        v = vnorm * (max - min) + min;
        v = fminf(max, v);
        v = fmaxf(min, v);
        *value = v;
        slider->value = vnorm;
    }
}

// Must call before doing layout
void ui_enable_performance_clock(UICtx *ctx) {
    ctx->measure_perf = TRUE;
    clock_gettime(CLOCK_MONOTONIC, &ctx->layout_start);
}

static usize timespec_delta(struct timespec start, struct timespec end) {
    return (usize)(((float)end.tv_sec - (float)start.tv_sec) * 1e6)  +
                      (end.tv_nsec - start.tv_nsec) / 1000;
}

// Call this after ui_render to profile the full render & layout pass
// TODO calc a moving average rather than displaying exact delta each frame
void _perf_clock_end(UICtx *ctx) {
    usize layout_delta_us = timespec_delta(ctx->layout_start, ctx->layout_end);
    usize render_delta_us = timespec_delta(ctx->draw_start, ctx->draw_end);
    float layout_delta = (float)layout_delta_us / 1000.f;
    float render_delta = (float)render_delta_us / 1000.f;
    float total = layout_delta + render_delta;
    float layout_pct = (layout_delta / total) * 100.f;
    float render_pct = (render_delta / total) * 100.f;

    String time = string_printf(&ctx->frame_arena->allocator,
        "Layout: %.2f ms | %.2f%%\nDraw: %.2f ms | %.2f%%\nTotal: %.2f ms",
        layout_delta, layout_pct, render_delta, render_pct, total);
    String ram = string_printf(&ctx->frame_arena->allocator, "Arena: %$dB | Frame: %$dB",
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

void _draw_box(UICtx *ctx, UiBox *box) {
    pv_Context *rdr = ctx->rdr_ctx;
    av_Rect bounds = box->bounds;
    float text_size = pv_get_current_font_size(rdr);
    UiBoxStyle style = box->style;
    av_TextStyle text_style = style.text_style;

    av_Colorf fill_color = style.background_color;
    if (box->flags & FocusHot)
        fill_color = style.highlight_color;
    if (box->flags & FocusActive)
        fill_color = style.active_color;

    if (box->flags & DrawBackground)
        pv_fill_rect(rdr, bounds, fill_color);
    if (box->flags & DrawBorder)
        pv_draw_rect(rdr, bounds, style.border_width, style.border_color);
    if (box->flags & DrawValue) {
        av_Rect value_rect = rect_with_width(bounds, (int)(bounds.width * box->value));
        pv_fill_rect(rdr, value_rect, style.value_color);
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

void _calc_fixed_sizes(UICtx *ctx, UiBox *root, UiAxis axis) {
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
            // if (root->flags & ValueFixedSize && axis == Horizontal) {
            //     root->fixed_size[axis] += root->value_fixed_size[axis] * 1.5f; // fudge number
            // }
        } break;
        default: break;
    }

    for (UiBox *child = root->first_child; child != NULL; child = child->next) {
        _calc_fixed_sizes(ctx, child, axis);
    }
}

void _calc_top_down_sizes(UICtx *ctx, UiBox *root, UiAxis axis) {
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

void _calc_bottom_up_sizes(UICtx *ctx, UiBox *root, UiAxis axis) {
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
                    sum = fmaxf(sum, child->fixed_size[axis] + child->gap[axis] * 2);
                }
            }
            root->fixed_size[axis] = sum;
        } break;
        default: break;
    }
}

void _calc_lateral_sizes(UICtx *ctx, UiBox *root, UiAxis axis) {
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

void _resolve_sizes(UICtx *ctx, UiBox *root, UiAxis axis) {
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
            Array(float) fixups = {0};
			array_reserve(&ctx->frame_arena->allocator, &fixups, root->num_children);
            for (UiBox *child = root->first_child; child != NULL; child = child->next) {
                if (!(child->flags & (FloatingX << axis))) {
                    float fixup = child->fixed_size[axis] * (1.f - child->pref_size[axis].strictness);
                    fixup = fmaxf(0.f, fixup);
                    array_append(&ctx->frame_arena->allocator, &fixups, fixup);
                }
            }

            float fix_pct = fmaxf(0, fminf(over / total_size, 1.f));
            size_t child_idx = 0;
            for (UiBox *child = root->first_child; child != NULL; child = child->next, child_idx++) {
                if (!(child->flags & (FloatingX << axis))) {
                    child->fixed_size[axis] -= fix_pct * fixups.items[child_idx];
                }
            }
        }
    } else {
        float max_size = root->fixed_size[axis];
        for (UiBox *child = root->first_child; child != NULL; child = child->next) {
            if (!(child->flags & (FloatingX << axis))) {
                float size = child->fixed_size[axis];
                float over = size - max_size;
                if (over > 0) {
                    child->fixed_size[axis] -= fminf(over, size);
                }
            }
        }
    }

    // bottom-up resolutions
    // NOTE How do we enforce some kind of fixup when these pref. sizes overflow?
    // for (UiBox *child = root->first_child; child != NULL; child = child->next) {
    //     if (child->pref_size[axis].kind == SizeKindParentPct) {
    //         child->fixed_size[axis] = root->fixed_size[axis] * child->pref_size[axis].value;
    //     }
    // }

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

void ui_do_layout(UICtx *ctx) {
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

void _reset_tree(UICtx *ctx) {
    memset(&ctx->root_box, 0, sizeof(UiBox));
    ctx->popup_root = NULL;
    _pop_parent(ctx);
}

void _draw_tree(UICtx *ctx, UiBox *root) {
    _draw_box(ctx, root);
    for (UiBox *child = root->first_child; child != NULL; child = child->next) {
        _draw_tree(ctx, child);
    }
}

void ui_begin(UICtx *ctx) {
    pv_begin_drawing(ctx->rdr_ctx);
    _build_root(ctx);
}

void _ui_render(UICtx *ctx) {
    UiBox *root = &ctx->root_box;
    pv_clear(ctx->rdr_ctx, root->style.background_color);
    _draw_tree(ctx, root);
    // draw popup trees
    if (ctx->popup_root)
        _draw_tree(ctx, ctx->popup_root);
    // reset at frame end
    _reset_tree(ctx);
    _clear_flag_stack(ctx);
    ctx->frame_idx++;
}

// Call this when UI description & layout is complete
void ui_end(UICtx *ctx) {
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
    arena_reset(ctx->frame_arena);
}
