// X11 GUI impl.

#include <X11/X.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Xatom.h>

#include <stdlib.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <assert.h>

typedef struct GuiImpl {
    Display *display;
    Window window;
    XImage *image;
    uint32_t *bits;
    uint32_t width, height;
    void *user;
} GuiImpl_t;

typedef Window window_t;

extern void inputEvent(void*, int32_t, int32_t, int8_t);
extern void render(void*);

GuiImpl_t *guiCreate(void *user, uint32_t *bits, uint32_t w, uint32_t h)
{
    GuiImpl_t *gui = (GuiImpl_t*)calloc(1, sizeof(GuiImpl_t));
    gui->user = user;
    gui->display = XOpenDisplay(NULL);
    XSetWindowAttributes attributes = {};
    gui->window = XCreateWindow(gui->display, DefaultRootWindow(gui->display),
                                0, 0, w, h, 0, 0, InputOutput, CopyFromParent,
                                CWOverrideRedirect, &attributes);
    XStoreName(gui->display, gui->window, "ZigVerb");

    Atom embedInfoAtom = XInternAtom(gui->display, "_XEMBED_INFO", 0);
    uint32_t embedInfoData[2] = {0, 0};
    XChangeProperty(gui->display, gui->window, embedInfoAtom, embedInfoAtom,
                    32, PropModeReplace, (uint8_t*)embedInfoData, 2);

    XSizeHints sizeHints = {};
    sizeHints.flags = PMinSize | PMaxSize;
    sizeHints.min_width = sizeHints.max_width = w;
    sizeHints.min_height = sizeHints.max_height = h;
    XSetWMNormalHints(gui->display, gui->window, &sizeHints);

    XSelectInput(gui->display, gui->window, SubstructureNotifyMask |
                ExposureMask | PointerMotionMask | ButtonPressMask |
                ButtonReleaseMask | KeyPressMask | KeyReleaseMask |
                SubstructureNotifyMask | EnterWindowMask | LeaveWindowMask |
                ButtonMotionMask | KeymapStateMask | FocusChangeMask |
                PropertyChangeMask);

    gui->image = XCreateImage(gui->display, DefaultVisual(gui->display, 0), 24,
                              ZPixmap, 0, NULL, 10, 10, 32, 0);
    gui->bits = bits;
    gui->image->width = w;
    gui->image->height = h;
    gui->image->bytes_per_line = w * 4;
    gui->image->data = (char *)gui->bits;

    return gui;

    // TODO: Register fd outside this call
    // if (hostPOSIXFDSupport && hostPOSIXFDSupport->register_fd)
    // {
    //     hostPOSIXFDSupport->register_fd(host, ConnectionNumber(gui->display), CLAP_POSIX_FD_READ);
    // }
}

void processX11Event(GuiImpl_t *gui, XEvent *event)
{
    switch(event->type) {
    case Expose:
        if (event->xexpose.window == gui->window)
            render(gui->user);
        break;
    case MotionNotify:
        if (event->xmotion.window == gui->window)
            inputEvent(gui->user, event->xmotion.x, event->xmotion.y, 0);
        break;
    case ButtonPress:
        if (event->xbutton.window == gui->window && event->xbutton.button == 1)
            inputEvent(gui->user, event->xbutton.x, event->xbutton.y, 1);
        break;
    case ButtonRelease:
        if (event->xbutton.window == gui->window && event->xbutton.button == 1)
            inputEvent(gui->user, event->xbutton.x, event->xbutton.y, -1);
        break;
    }
}

void guiOnPosixFD(GuiImpl_t *gui)
{
    XFlush(gui->display);

    if (XPending(gui->display)) {
        XEvent event;
        XNextEvent(gui->display, &event);
        while (XPending(gui->display)) {
            XEvent event0;
            XNextEvent(gui->display, &event0);
            if(event.type == MotionNotify && event0.type == MotionNotify) {
                // Merge adjacent mouse motion events
            } else {
                processX11Event(gui, &event);
                XFlush(gui->display);
            }
            event = event0;
        }
        processX11Event(gui, &event);
        XFlush(gui->display);
        render(gui->user);
    }
}

void guiDestroy(GuiImpl_t *gui)
{
    assert(gui);

    gui->image->data = NULL;
    XDestroyImage(gui->image);
    XDestroyWindow(gui->display, gui->window);
    XCloseDisplay(gui->display);

    free(gui);
    gui = NULL;
}

void guiSetParent(GuiImpl_t *gui, Window parent_window)
{
    XReparentWindow(gui->display, gui->window, parent_window, 0, 0);
    XFlush(gui->display);
}

void guiSetVisible(GuiImpl_t *gui, bool visible)
{
    if (visible) XMapRaised(gui->display, gui->window);
    else XUnmapWindow(gui->display, gui->window);
    XFlush(gui->display);
}

void guiRender(GuiImpl_t *gui, bool internal)
{
    if (internal) render(gui->user);
    XPutImage(gui->display, gui->window, DefaultGC(gui->display, 0), gui->image,
              0, 0, 0, 0, gui->image->width, gui->image->height); 
}
