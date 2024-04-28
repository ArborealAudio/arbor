#include <windows.h>
#include <wingdi.h>
#include <winuser.h>
#include <windowsx.h>

#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>

typedef struct GuiImpl {
	HWND window;
	uint32_t *bits;
	uint32_t width, height;
	void *user;
} GuiImpl_t;

void render(void *);

// button 0 = drag, 1 = press, -1 = release
void inputEvent(void *user, int32_t x, int32_t y, int8_t button);

static int globalOpenGUICount = 0;

void guiRender(GuiImpl_t *gui, bool internal)
{
	if (internal) render(gui->user);
	RedrawWindow(gui->window, 0, 0, RDW_INVALIDATE);
}

LRESULT CALLBACK windowProc(HWND window, UINT message, WPARAM wParam, LPARAM lParam)
{
	GuiImpl_t *gui = (GuiImpl_t*)GetWindowLongPtr(window, 0);
	if (!gui) {
		return DefWindowProc(window, message, wParam, lParam);
	}

	switch (message) {
	case WM_PAINT: {
		PAINTSTRUCT paint;
		HDC dc = BeginPaint(window, &paint);
		BITMAPINFO info = { {sizeof(BITMAPINFOHEADER), gui->width, -gui->height, 1, 32, BI_RGB} };
		StretchDIBits(dc, 0, 0,  gui->width, gui->height, 0, 0, gui->width, gui->height,
			gui->bits, &info, DIB_RGB_COLORS, SRCCOPY);
		EndPaint(window, &paint);
	} break;
	case WM_MOUSEMOVE:
		inputEvent(gui->user, GET_X_LPARAM(lParam), GET_Y_LPARAM(lParam), 0);
		guiRender(gui, true);
		break;
	case WM_LBUTTONDOWN:
	 	SetCapture(window);
		inputEvent(gui->user, GET_X_LPARAM(lParam), GET_Y_LPARAM(lParam), 1);
		guiRender(gui, true);
		break;
	case WM_LBUTTONUP:
		ReleaseCapture();
		inputEvent(gui->user, GET_X_LPARAM(lParam), GET_Y_LPARAM(lParam), -1);
		guiRender(gui, true);
		break;
	default:
		return DefWindowProc(window, message, wParam, lParam);
		break;
	}

	return 0;
}

GuiImpl_t *guiCreate (void *user, uint32_t *bits, uint32_t w, uint32_t h)
{
	GuiImpl_t *gui = (GuiImpl_t*)calloc(1, sizeof(GuiImpl_t));
	
	if (globalOpenGUICount++ == 0) {
		WNDCLASS windowClass = {};
		windowClass.lpfnWndProc = windowProc;
		windowClass.cbWndExtra = sizeof(GuiImpl_t);
		windowClass.lpszClassName = "com.ArborealAudio.ZigVerb";
		windowClass.hCursor = LoadCursor(NULL, IDC_ARROW);
		windowClass.style = CS_DBLCLKS;
		RegisterClass(&windowClass);
	}

	gui->window = CreateWindow("com.ArborealAudio.ZigVerb", "ZigVerb",
		WS_CHILDWINDOW | WS_CLIPSIBLINGS,
		CW_USEDEFAULT, 0, w, h, GetDesktopWindow(), NULL, NULL, NULL);
	gui->bits = bits;
	gui->width = w;
	gui->height = h;
	gui->user = user;
	SetWindowLongPtr(gui->window, 0, (LONG_PTR)gui);
	// Maybe this is...not necessary? We still have to set other parts of GUI
	// guiRender(gui->user, true);

	return gui;
}

void guiDestroy(GuiImpl_t *gui)
{
	DestroyWindow(gui->window);
	free(gui);
	gui = NULL;

	if (--globalOpenGUICount == 0)
		UnregisterClass("ZigVerb", NULL);
}

void guiSetParent(GuiImpl_t *gui, void *parent) {
	SetParent(gui->window, (HWND)parent);
}

void guiSetVisible(GuiImpl_t *gui, bool visible) {
	ShowWindow(gui->window, visible ? SW_SHOW : SW_HIDE);
}

void guiOnPosixFd(GuiImpl_t *gui) {}
