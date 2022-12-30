// X11 GUI impl.

#pragma once
#define GUI_API CLAP_WINDOW_API_X11

#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Xatom.h>

struct GUI
{
    Display *display;
    Window window;
    XImage *image;
    uint32_t *bits;
};

static void GUICreate(MyPlugin *plugin)
{
    assert(!plugin->gui);
    plugin->gui = (GUI *)calloc(1, sizeof(GUI));

    plugin->gui->display = XOpenDisplay(NULL);
    XSetWindowAttributes attributes = {};
    plugin->gui->window = XCreateWindow(plugin->gui->display, DefaultRootWindow(plugin->gui->display), 0, 0, GUI_WIDTH, GUI_HEIGHT, 0, 0, InputOutput, CopyFromParent, CWOverrideRedirect, &attributes);
    XStoreName(plugin->gui->display, plugin->gui->window, pluginDescriptor.name);

    Atom embedInfoAtom = XInternAtom(plugin->gui->display, "_XEMBED_INFO", 0);
    uint32_t embedInfoData[2] = {0, 0};
    XChangeProperty(plugin->gui->display, plugin->gui->window, embedInfoAtom, embedInfoAtom, 32, PropModeReplace, (uint8_t*)embedInfoData, 2);

    XSizeHints sizeHints = {};
    sizeHints.flags = PMinSize | PMaxSize;
    sizeHints.min_width = sizeHints.max_width = GUI_WIDTH;
    sizeHints.min_height = sizeHints.max_height = GUI_HEIGHT;
    XSetWMNormalHints(plugin->gui->display, plugin->gui->window, &sizeHints);

    XSelectInput(plugin->gui->display, plugin->gui->window, SubstructureNotifyMask | ExposureMask | PointerMotionMask | ButtonPressMask | ButtonReleaseMask | KeyPressMask | KeyReleaseMask | SubstructureNotifyMask | EnterWindowMask | LeaveWindowMask | ButtonMotionMask | KeymapStateMask | FocusChangeMask | PropertyChangeMask);

    plugin->gui->image = XCreateImage(plugin->gui->display, DefaultVisual(plugin->gui->display, 0), 24, ZPixmap, 0, NULL, 10, 10, 32, 0);
    plugin->gui->bits = (uint32_t*)calloc(1, GUI_WIDTH * GUI_HEIGHT * 4);
    plugin->gui->image->width = GUI_WIDTH;
    plugin->gui->image->height = GUI_HEIGHT;
    plugin->gui->image->bytes_per_line = GUI_WIDTH * 4;
    plugin->gui->image->data = (char *)plugin->gui->bits;

    if (plugin->hostPOSIXFDSupport && plugin->hostPOSIXFDSupport->register_fd)
    {
        plugin->hostPOSIXFDSupport->register_fd(plugin->host, ConnectionNumber(plugin->gui->display), CLAP_POSIX_FD_READ);
    }
}

static void GUIPaint(MyPlugin *plugin, bool internal)
{
    if (internal)
        PluginPaint(plugin, plugin->gui->bits);
    XPutImage(plugin->gui->display, plugin->gui->window, DefaultGC(plugin->gui->display, 0), plugin->gui->image, 0, 0, 0, 0, GUI_WIDTH, GUI_HEIGHT);
}

static void GUIX11ProcessEvent(MyPlugin *plugin, XEvent *event)
{
    switch (event->type)
    {
    case Expose:
        if (event->xexpose.window == plugin->gui->window)
            GUIPaint(plugin, false);
        break;
    case MotionNotify:
        if (event->xmotion.window == plugin->gui->window)
            PluginProcessMouseDrag(plugin, event->xmotion.x, event->xmotion.y);
        break;
    case ButtonPress:
        if (event->xbutton.window == plugin->gui->window && event->xbutton.button == 1)
            PluginProcessMousePress(plugin, event->xbutton.x, event->xbutton.y);
        break;
    case ButtonRelease:
        if (event->xbutton.window == plugin->gui->window && plugin->gui->window && event->xbutton.button == 1 )
            PluginProcessMouseRelease(plugin);
        break;
    }
}

static void GUIOnPOSIXFD(MyPlugin *plugin)
{
    XFlush(plugin->gui->display);

    if (XPending(plugin->gui->display))
    {
        XEvent event;
        XNextEvent(plugin->gui->display, &event);

        while(XPending(plugin->gui->display))
        {
            XEvent event0;
            XNextEvent(plugin->gui->display, &event0);

            if (event.type == MotionNotify && event0.type == MotionNotify)
            {
                // Merge adjacent mouse motion events
            }
            else
            {
                GUIX11ProcessEvent(plugin, &event);
                XFlush(plugin->gui->display);
            }

            event = event0;
        }

        GUIX11ProcessEvent(plugin, &event);
        XFlush(plugin->gui->display);
        GUIPaint(plugin, true);
    }

    XFlush(plugin->gui->display);
}



static void GUIDestroy(MyPlugin *plugin)
{
    assert(plugin->gui);

    // Unregister the connection's file descriptor with the host.
    if (plugin->hostPOSIXFDSupport && plugin->hostPOSIXFDSupport->unregister_fd) {
        plugin->hostPOSIXFDSupport->unregister_fd(plugin->host, ConnectionNumber(plugin->gui->display));
    }

    // Destroy the bitmap, window and display.
    free(plugin->gui->bits);
    plugin->gui->image->data = NULL;
    XDestroyImage(plugin->gui->image);
    XDestroyWindow(plugin->gui->display, plugin->gui->window);
    XCloseDisplay(plugin->gui->display);

    // Free the GUI structure.
    free(plugin->gui);
    plugin->gui = nullptr;
}

static void GUISetParent(MyPlugin *plugin, const clap_window_t *window)
{
    XReparentWindow(plugin->gui->display, plugin->gui->window, (Window) window->x11, 0, 0);
    XFlush(plugin->gui->display);
}

static void GUISetVisible(MyPlugin *plugin, bool visible)
{
    if (visible) XMapRaised(plugin->gui->display, plugin->gui->window);
    else XUnmapWindow(plugin->gui->display, plugin->gui->window);
    XFlush(plugin->gui->display);
}