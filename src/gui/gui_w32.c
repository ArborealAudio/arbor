#include <windows.h>
#include <winuser.h>
#include <windowsx.h>
#include <clap/clap.h>

void *implGuiCreateDisplay() {}

void implGuiSetParent(void *display, void *main, void *window) {
	SetParent((HWND)main, (HWND)window);
}
void implGuiSetVisible(void *display, void *main, bool visible) {
	ShowWindow((HWND)main, visible ? SW_SHOW : SW_HIDE);
}
