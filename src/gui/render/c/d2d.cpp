#include "d2d.h"
#include <d2d1.h>
#include <dwrite.h>
#include <stdio.h>
#include <stdbool.h>

struct D2DContext {
    HWND window;
    ID2D1Factory *factory;
    ID2D1HwndRenderTarget *rt;
    IDWriteFactory *dwrite_factory;
    // TODO: Support loading an arbitrary number of these
    IDWriteTextFormat *text_format;

    ID2D1SolidColorBrush *solid_color;

    void *user;
};

static int globalOpenGUICount = 0;

static void setBrushColor(D2DContext *ctx, D2DColor color) {
    if (!ctx->solid_color) {
        HRESULT hr = ctx->rt->CreateSolidColorBrush(
            {.r = color.r, .g = color.g, .b = color.b, .a = color.a},
            &ctx->solid_color
        );
        if (!SUCCEEDED(hr)) {
            log_err_return("Brush create failed");
        }
    } else {
        ctx->solid_color->SetColor({.r = color.r, .g = color.g, .b = color.b, .a = color.a});
    }
}

void d2dl_beginDrawing(D2DContext *ctx) {
    ctx->rt->BeginDraw();
}

void d2dl_endDrawing(D2DContext *ctx) {
    HRESULT hr = ctx->rt->EndDraw();
    if (!SUCCEEDED(hr)) {
        log_err_return("EndDraw failed for some reason");
    }
}

void d2dl_clear(D2DContext *ctx, D2DColor color) {
    ctx->rt->Clear({.r = color.r, .g = color.g, .b = color.b, .a = color.a});
}

void d2dl_drawRect(D2DContext *ctx, D2DRect rect, float stroke_width, D2DColor color) {
    setBrushColor(ctx, color);
    ctx->rt->DrawRectangle(
        {.left = rect.left, .top = rect.top, .right = rect.right, .bottom = rect.bottom},
        ctx->solid_color,
        stroke_width
    );
}

void d2dl_fillRect(D2DContext *ctx, D2DRect rect, D2DColor color) {
    setBrushColor(ctx, color);
    ctx->rt->FillRectangle(
        {.left = rect.left, .top = rect.top, .right = rect.right, .bottom = rect.bottom},
        ctx->solid_color
    );
}

void d2dl_drawRoundedRect(D2DContext *ctx, D2DRect rect, float radius,
                          float stroke_width, D2DColor color) {
    setBrushColor(ctx, color);
    D2D1_RECT_F reg_rect = {.left = rect.left, .top = rect.top, .right = rect.right, .bottom = rect.bottom};
    ctx->rt->DrawRoundedRectangle(
        {.rect = reg_rect, .radiusX = radius, .radiusY = radius},
        ctx->solid_color, stroke_width
    );
}

void d2dl_fillRoundedRect(D2DContext *ctx, D2DRect rect, float radius,
                          D2DColor color) {
    setBrushColor(ctx, color);
    D2D1_RECT_F reg_rect = {.left = rect.left, .top = rect.top, .right = rect.right, .bottom = rect.bottom};
    ctx->rt->FillRoundedRectangle(
        {.rect = reg_rect, .radiusX = radius, .radiusY = radius},
        ctx->solid_color
    );
}

void d2dl_drawEllipse(D2DContext *ctx, D2DPoint center, float rx, float ry,
                      float stroke_width, D2DColor color) {
    setBrushColor(ctx, color);
    ctx->rt->DrawEllipse(
        {{center.x, center.y}, rx, ry},
        ctx->solid_color,
        stroke_width
    );
}

void d2dl_fillEllipse(D2DContext *ctx, D2DPoint center, float rx, float ry,
                      D2DColor color) {
    setBrushColor(ctx, color);
    ctx->rt->FillEllipse(
        {{center.x, center.y}, rx, ry},
        ctx->solid_color
    );
}

void d2dl_loadFont(D2DContext *ctx, const wchar_t *font_name, float size) {
    // TODO: Implement loading different font styles
    ctx->dwrite_factory->CreateTextFormat(
        font_name, NULL, DWRITE_FONT_WEIGHT_NORMAL,
        DWRITE_FONT_STYLE_NORMAL, DWRITE_FONT_STRETCH_NORMAL, size, L"",
        &ctx->text_format);
}

void d2dl_drawText(D2DContext *ctx, const wchar_t *text, D2DRect rect, D2DColor color) {
    setBrushColor(ctx, color);
    ctx->text_format->SetTextAlignment(DWRITE_TEXT_ALIGNMENT_CENTER);
    ctx->text_format->SetParagraphAlignment(DWRITE_PARAGRAPH_ALIGNMENT_CENTER);
    size_t len = wcslen(text);
    ctx->rt->DrawText(text, len, ctx->text_format,
        {.left = rect.left, .top = rect.top, .right = rect.right, .bottom = rect.bottom},
        ctx->solid_color
    );
}

D2DSize d2dl_getRenderSize(D2DContext *ctx) {
    auto size = ctx->rt->GetSize();
    return {.width = size.width, .height = size.height};
}

void d2dl_setRenderSize(D2DContext *ctx, D2DSize size) {
    HRESULT hr = ctx->rt->Resize({.width = (u32)size.width, .height = (u32)size.height});
    if (!SUCCEEDED(hr)) {
        log_err_return("Resize failed");
    }
}

static void d2dl_createFactory(D2DContext *ctx) {
  HRESULT hr = D2D1CreateFactory(D2D1_FACTORY_TYPE_SINGLE_THREADED,
                                 &ctx->factory);
  if (SUCCEEDED(hr)) {
    return;
  } else {
    log_err_return("ID2D1Factory creation failed");
  }
}

static void d2dl_createDirectWriteFactory(D2DContext *ctx) {
    HRESULT hr = DWriteCreateFactory(DWRITE_FACTORY_TYPE_SHARED, 
                                     __uuidof(ctx->dwrite_factory),
                                     (IUnknown**)&ctx->dwrite_factory);
    if (!SUCCEEDED(hr)) {
        log_err_return("DWriteFactory creation failed")
    }
}


static void d2dl_createRenderTarget(D2DContext *ctx) {
    RECT rc;
    GetClientRect(ctx->window, &rc);

    ID2D1HwndRenderTarget *rt = NULL;

    HRESULT hr = ctx->factory->CreateHwndRenderTarget(
      D2D1::RenderTargetProperties(),
      D2D1::HwndRenderTargetProperties(
          ctx->window, D2D1::SizeU(rc.right - rc.left, rc.bottom - rc.top)), &rt);

    if (SUCCEEDED(hr)) {
        ctx->rt = rt;
    }
    else {
        log_err_return("CreateHwndRenderTarget failed")
    }
}

D2DContext *d2dl_initDesktopWindow(int width, int height, const char *window_title) {
    D2DContext *ctx = (D2DContext*)calloc(0, sizeof(D2DContext));
    if (ctx == NULL) {
        log_err_return_null("D2DContext allocation failed")
    }
    memset(ctx, 0, sizeof(D2DContext));
    d2dl_createFactory(ctx);
    d2dl_createDirectWriteFactory(ctx);
    HWND hwnd = CreateWindow(window_title, window_title, WS_OVERLAPPEDWINDOW,
                             CW_USEDEFAULT, CW_USEDEFAULT, width,
                         height, NULL, NULL, NULL, ctx);
    if (hwnd == NULL) {
        log_err_return_null("CreateWindow failed");
    }
    ctx->window = hwnd;
    d2dl_createRenderTarget(ctx);

    ShowWindow(hwnd, SW_SHOW);
    return ctx;
}

static LRESULT CALLBACK windowProc(HWND , UINT , WPARAM , LPARAM );

D2DContext *d2dl_initChildWindow(void *user, int width, int height,
                                  const char *window_title) {
    D2DContext *ctx = (D2DContext*)malloc(sizeof(D2DContext));
    if (ctx == NULL) {
        log_err_return_null("D2DContext allocation failed")
    }
    
    memset(ctx, 0, sizeof(D2DContext));
        
    if (globalOpenGUICount++ == 0) {
		WNDCLASS windowClass = {};
		windowClass.lpfnWndProc = windowProc;
		windowClass.lpszClassName = window_title;
		windowClass.hCursor = LoadCursor(NULL, IDC_ARROW);
		windowClass.style = CS_DBLCLKS;
		RegisterClass(&windowClass);
	}
	
    d2dl_createFactory(ctx);
    d2dl_createDirectWriteFactory(ctx);
    
    HWND hwnd = CreateWindow(window_title, window_title, WS_CHILDWINDOW | WS_CLIPSIBLINGS,
                             CW_USEDEFAULT, CW_USEDEFAULT, width,
                         height, GetDesktopWindow(), NULL, NULL, ctx);
    if (hwnd == NULL) {
        log_err_return_null("CreateWindow failed");
    }
    ctx->window = hwnd;
    ctx->user = user;
    d2dl_createRenderTarget(ctx);

    return ctx;
}

void d2dl_deinit(D2DContext *c) {
    DestroyWindow(c->window);
    c->solid_color->Release();
    c->rt->Release();
    c->factory->Release();
    c->dwrite_factory->Release();
    if (c->text_format)
        c->text_format->Release();
    free(c);
}

void d2dl_setParent(D2DContext *c, HWND parent) {
    SetParent(c->window, parent);
}

void d2dl_setVisible(D2DContext *c, bool visible) {
    ShowWindow(c->window, visible ? SW_SHOW : SW_HIDE);
}

static LRESULT CALLBACK windowProc(HWND window, UINT msg, WPARAM wParam, LPARAM lParam) {
    if (msg == WM_CREATE) {
        LPCREATESTRUCT pcs = (LPCREATESTRUCT)lParam;
        D2DContext *ctx = (D2DContext *)pcs->lpCreateParams;
        SetWindowLongPtr(window, GWLP_USERDATA, (LONG_PTR)ctx);
        return 1;
    }
    D2DContext *ctx = (D2DContext*)GetWindowLongPtr(window, GWLP_USERDATA);

    switch (msg) {
        case WM_DESTROY:
            PostQuitMessage(0);
            return 0;
        case WM_SIZE:
            if (!ctx->rt) {
                log_err_continue("Can't handle WM_SIZE yet");
                break;
            }
            d2dl_setRenderSize(ctx, {(float)LOWORD(lParam), (float)HIWORD(lParam)});
            return 0;
        case WM_PAINT:
            arbor_gui_render(ctx->user);
            return 0;
    }

    return DefWindowProc(window, msg, wParam, lParam);
}
