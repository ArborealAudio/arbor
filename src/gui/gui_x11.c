// X11 GUI impl.

#include <X11/X.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Xatom.h>
#include <clap/clap.h>

Display *implGuiCreateDisplay()
{
    return XOpenDisplay(NULL);
}

void implGuiSetParent(void *display, void *main_window, const clap_window_t *window)
{
    Display *_disp = (Display *) display;
    Window _win = (Window) main_window;
    XReparentWindow(display, _win, (Window) window->x11, 0, 0);
    XFlush(_disp);
}

void implGuiSetVisible(void *display, void *main_window, bool visible)
{
    Display *_disp = (Display *) display;
    Window _win = (Window) main_window;
    if (visible) XMapRaised(_disp, _win);
    else XUnmapWindow(_disp, _win);
    XFlush(_disp);
}
