#include <windows.h>
#include <winuser.h>
#include <windowsx.h>
#include <clap/clap.h>

void *implGuiCreateDisplay() {}

void implGuiSetParent(void *display, void *main, const clap_window_t *window) {
	SetParent((HWND)main, (HWND)window->win32);
}
void implGuiSetVisible(void *display, void *main, bool visible) {
	ShowWindow((HWND)main, visible ? SW_SHOW : SW_HIDE);
}
