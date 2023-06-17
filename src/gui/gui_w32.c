#include <windows.h>
#include <winuser.h>
#include <windowsx.h>
#include <clap/clap.h>

void implGuiSetParent(void *main, const clap_window_t *window) {
	SetParent((HWND)main, (HWND)window->win32);
}
void implGuiSetVisible(void *main, bool visible) {
	ShowWindow((HWND)main, visible ? SW_SHOW : SW_HIDE);
}
