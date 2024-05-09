#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <wingdi.h>
#include <winuser.h>
#include <windowsx.h>

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>

typedef struct GuiImpl {
	HWND window;
	uint32_t *bits;
	uint32_t width, height;
	void *user;
	const char *id;
	UINT_PTR timer_id;
} GuiImpl_t;

enum GuiState{
	Idle,
	MouseOver,
	MouseDown,
	MouseUp,
	MouseDrag,
};

void gui_render(void *user);

// button 0 = drag, 1 = press, -1 = release
void sysInputEvent(void *user, int32_t x, int32_t y, uint8_t button);
void guiTimerCallback(void *timer, void *user);

static int globalOpenGUICount = 0;

void guiRender(GuiImpl_t *gui, bool internal)
{
	if (internal) gui_render(gui->user);
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
	case WM_MOUSEMOVE: {
		bool drag = (MK_LBUTTON & wParam) > 0;
		sysInputEvent(gui->user, GET_X_LPARAM(lParam), GET_Y_LPARAM(lParam), drag ?
		              MouseDrag : MouseOver);
		} break;
	case WM_LBUTTONDOWN:
	 	SetCapture(window);
		sysInputEvent(gui->user, GET_X_LPARAM(lParam), GET_Y_LPARAM(lParam), MouseDown);
		break;
	case WM_LBUTTONUP:
		ReleaseCapture();
		sysInputEvent(gui->user, GET_X_LPARAM(lParam), GET_Y_LPARAM(lParam), MouseUp);
		break;
	case WM_MOUSELEAVE:
		ReleaseCapture();
		break;
	case WM_TIMER:
		guiTimerCallback(NULL, gui->user);
		break;
	default:
		return DefWindowProc(window, message, wParam, lParam);
		break;
	}

	return 0;
}

GuiImpl_t *guiCreate (void *user, uint32_t *bits, uint32_t w, uint32_t h, const char* id)
{
	GuiImpl_t *gui = (GuiImpl_t*)calloc(1, sizeof(GuiImpl_t));
	
	if (globalOpenGUICount++ == 0) {
		WNDCLASS windowClass = {};
		windowClass.lpfnWndProc = windowProc;
		windowClass.cbWndExtra = sizeof(GuiImpl_t);
		windowClass.lpszClassName = id; // Woops! Forgot this was here...
		windowClass.hCursor = LoadCursor(NULL, IDC_ARROW);
		windowClass.style = CS_DBLCLKS;
		RegisterClass(&windowClass);
	}

	gui->window = CreateWindow(id, id, WS_CHILDWINDOW | WS_CLIPSIBLINGS,
		CW_USEDEFAULT, 0, w, h, GetDesktopWindow(), NULL, NULL, NULL);
	gui->bits = bits;
	gui->width = w;
	gui->height = h;
	gui->user = user;
	gui->id = id;
	SetWindowLongPtr(gui->window, 0, (LONG_PTR)gui);

	SetTimer(gui->window, 0, 16, NULL);

	return gui;
}

void guiDestroy(GuiImpl_t *gui)
{
	DestroyWindow(gui->window);
	if (--globalOpenGUICount == 0)
		UnregisterClass(gui->id, NULL);
	free(gui);
	gui = NULL;
}

void guiSetParent(GuiImpl_t *gui, HWND parent) {
	SetParent(gui->window, parent);
}

void guiSetVisible(GuiImpl_t *gui, bool visible) {
	ShowWindow(gui->window, visible ? SW_SHOW : SW_HIDE);
}

void guiOnPosixFd(GuiImpl_t *gui) {}
