#ifndef RENDER_H
#define RENDER_H

#ifdef WIN32
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
typedef HWND Window;
typedef UINT Timer;
typedef const wchar_t* String;
#elif __APPLE__
#include <Cocoa/Cocoa.h>
typedef NSView* Window;
typedef CFRunLoopTimerRef Timer;
typedef const char* String;
#endif
#include <stdbool.h>
#include <stdint.h>

typedef uint8_t u8;
typedef uint32_t u32;
typedef uintptr_t usize;

#define log_err_continue(S) fprintf(stderr, "D2D error: " S "\n")

#define log_err_return(S) fprintf(stderr, "D2D error: " S "\n"); return;

#define log_err_return_null(S) fprintf(stderr, "D2D error: " S "\n"); return NULL;

// PUBLIC API //
#ifdef __cplusplus
extern "C" {
#endif

typedef struct D2DColor {
    float r, g, b, a;
} D2DColor;

typedef struct D2DPoint {
    float x, y;
} D2DPoint;

typedef struct D2DSize {
    float width, height;
} D2DSize;

typedef struct D2DRect {
    float x, y, width, height;
} D2DRect;

enum {
    Idle,
    MouseOver,
    MouseDown,
    MouseUp,
    MouseDrag,
};
typedef u8 D2DMouseState;

typedef struct D2DContext D2DContext;

D2DContext *d2dl_initDesktopWindow(int width, int height, u32 timer_ms,
                                   const char *window_title);
D2DContext *guiInitChildWindow(void *user, int width, int height, u32 timer_ms,
                               const char *window_title);
void guiDeinit(D2DContext*);
void guiBeginDrawing(D2DContext *ctx);
void guiEndDrawing(D2DContext *ctx);
void guiRedraw(D2DContext *ctx);
void guiClear(D2DContext *ctx, D2DColor color);
void guiDrawRect(D2DContext *ctx, D2DRect rect, float stroke_width, D2DColor color);
void guiFillRect(D2DContext *ctx, D2DRect rect, D2DColor color);
void guiDrawRoundedRect(D2DContext *ctx, D2DRect rect, float radius,
                          float stroke_width, D2DColor color);
void guiFillRoundedRect(D2DContext *ctx, D2DRect rect, float radius,
                          D2DColor color);
void guiDrawEllipse(D2DContext *ctx, D2DPoint center, float rx, float ry,
                      float stroke_width, D2DColor color);
void guiFillEllipse(D2DContext *ctx, D2DPoint center, float rx, float ry,
                      D2DColor color);
void guiLoadFont(D2DContext *ctx, String font_name, float size);
void guiDrawText(D2DContext *ctx, String text, D2DRect rect, D2DColor color);
D2DSize guiGetRenderSize(D2DContext *ctx);
void guiSetRenderSize(D2DContext *ctx, D2DSize size);
void guiSetParent(D2DContext*, Window parent);
void guiSetVisible(D2DContext*, bool);

// Extern library functions
// TODO: Is there a better way to handle this, one that would make this library
// more portable?
extern void arbor_sys_event(void *user, int32_t cursorX, int32_t cursorY,
                            D2DMouseState state);
extern void arbor_timer_cb(Timer timer, void *info);
extern void arbor_gui_render(void *);

#ifdef __cplusplus
}
#endif

#endif
