#ifndef D2DL_H
#define D2DL_H

#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <stdbool.h>
#include <stdint.h>

typedef uint8_t u8;
typedef uint32_t u32;
typedef uintptr_t usize;

#define log_err_continue(S) fprintf(stderr, "D2DL error: " S "\n")

#define log_err_return(S) fprintf(stderr, "D2DL error: " S "\n"); return;

#define log_err_return_null(S) fprintf(stderr, "D2DL error: " S "\n"); return NULL;

// PUBLIC API //
#ifdef __cplusplus
extern "C" {
#endif

typedef struct D2DColor {
    float r, g, b, a;
} D2DColor;

const D2DColor White = {1};
const D2DColor Black = {.a = 1};
const D2DColor Red = {1, 0, 0, 1};
const D2DColor Green = {0, 1, 0, 1};
const D2DColor Blue = {0, 0, 1, 1};

typedef struct D2DPoint {
    float x, y;
} D2DPoint;

typedef struct D2DSize {
    float width, height;
} D2DSize;

typedef struct D2DRect {
    float left, top, right, bottom;
} D2DRect;

typedef struct D2DContext D2DContext;

D2DContext *d2dl_initDesktopWindow(int width, int height, const char *window_title);
D2DContext *d2dl_initChildWindow(void *user, int width, int height, const char *window_title);
void d2dl_deinit(D2DContext*);
void d2dl_beginDrawing(D2DContext *ctx);
void d2dl_endDrawing(D2DContext *ctx);
void d2dl_clear(D2DContext *ctx, D2DColor color);
void d2dl_drawRect(D2DContext *ctx, D2DRect rect, float stroke_width, D2DColor color);
void d2dl_fillRect(D2DContext *ctx, D2DRect rect, D2DColor color);
void d2dl_drawRoundedRect(D2DContext *ctx, D2DRect rect, float radius,
                          float stroke_width, D2DColor color);
void d2dl_fillRoundedRect(D2DContext *ctx, D2DRect rect, float radius,
                          D2DColor color);
void d2dl_drawEllipse(D2DContext *ctx, D2DPoint center, float rx, float ry,
                      float stroke_width, D2DColor color);
void d2dl_fillEllipse(D2DContext *ctx, D2DPoint center, float rx, float ry,
                      D2DColor color);
void d2dl_drawText(D2DContext *ctx, const wchar_t *text, D2DRect rect, D2DColor color);
D2DSize d2dl_getRenderSize(D2DContext *ctx);
void d2dl_setRenderSize(D2DContext *ctx, D2DSize size);
void d2dl_loadFont(D2DContext *ctx, const wchar_t *font_name, float size);
void d2dl_setParent(D2DContext*, HWND hwnd);
void d2dl_setVisible(D2DContext*, bool);

// Extern library render
// TODO: Is there a better way to handle this, one that would make this library
// more portable?
void arbor_gui_render(void *);

#ifdef __cplusplus
}
#endif

#endif
