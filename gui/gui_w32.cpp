#define GUI_API CLAP_WINDOW_API_WIN32

#include <windowsx.h>

struct GUI
{
    HWND window;
    uint32_t *bits;
};

static int globalOpenGUICount = 0;

static void GUIPaint(MyPlugin *plugin, bool internal)
{
    if (internal) PluginPaint(plugin, plugin->gui->bits);
    RedrawWindow(plugin->gui->window, 0, 0, RDW_INVALIDATE);
}

LRESULT CALLBACK GUIWindowProcedure(HWND window, UINT message, WPARAM wParam, LPARAM lParam) {
	MyPlugin *plugin = (MyPlugin *) GetWindowLongPtr(window, 0);

	if (!plugin) {
		return DefWindowProc(window, message, wParam, lParam);
	}

	if (message == WM_PAINT) {
		PAINTSTRUCT paint;
		HDC dc = BeginPaint(window, &paint);
		BITMAPINFO info = { { sizeof(BITMAPINFOHEADER), GUI_WIDTH, -GUI_HEIGHT, 1, 32, BI_RGB } };
		StretchDIBits(dc, 0, 0, GUI_WIDTH, GUI_HEIGHT, 0, 0, GUI_WIDTH, GUI_HEIGHT, plugin->gui->bits, &info, DIB_RGB_COLORS, SRCCOPY);
		EndPaint(window, &paint);
	} else if (message == WM_MOUSEMOVE) {
		PluginProcessMouseDrag(plugin, GET_X_LPARAM(lParam), GET_Y_LPARAM(lParam));
		GUIPaint(plugin, true);
	} else if (message == WM_LBUTTONDOWN) {
		SetCapture(window); 
		PluginProcessMousePress(plugin, GET_X_LPARAM(lParam), GET_Y_LPARAM(lParam));
		GUIPaint(plugin, true);
	} else if (message == WM_LBUTTONUP) {
		ReleaseCapture(); 
		PluginProcessMouseRelease(plugin);
		GUIPaint(plugin, true);
	} else {
		return DefWindowProc(window, message, wParam, lParam);
	}

	return 0;
}

static void GUICreate(MyPlugin *plugin)
{
    assert(!plugin->gui);
    plugin->gui = (GUI *) calloc(1, sizeof(GUI));

    if (globalOpenGUICount++ == 0)
    {
        WNDCLASS windowClass = {};
        windowClass.lpfnWndProc = GUIWindowProcedure;
        windowClass.cbWndExtra = sizeof(MyPlugin *);
        windowClass.lpszClassName = pluginDescriptor.id;
        windowClass.hCursor = LoadCursor(NULL, IDC_ARROW);
        windowClass.style = CS_DBLCLKS;
        RegisterClass(&windowClass);
    }

    plugin->gui->window = CreateWindow(pluginDescriptor.id, pluginDescriptor.name, WS_CHILDWINDOW | WS_CLIPSIBLINGS, CW_USEDEFAULT, 0, GUI_WIDTH, GUI_HEIGHT, GetDesktopWindow(), NULL, NULL, NULL);
    plugin->gui->bits = (uint32_t *) calloc(1, GUI_WIDTH * GUI_HEIGHT * 4);
    SetWindowLongPtr(plugin->gui->window, 0, (LONG_PTR) plugin);
    GUIPaint(plugin, true);
}

static void GUIDestroy(MyPlugin *plugin)
{
    assert(plugin->gui);
    DestroyWindow(plugin->gui->window);
    free(plugin->gui->bits);
    free(plugin->gui);
    plugin->gui = nullptr;

    if (--globalOpenGUICount == 0)
    {
        UnregisterClass(pluginDescriptor.id, NULL);
    }
}

#define GUISetParent(plugin, parent) SetParent((plugin)->gui->window, (HWND)(parent)->win32)
#define GUISetVisible(plugin, visible) ShowWindow((plugin)->gui->window, (visible) ? SW_SHOW : SW_HIDE)
static void GUIOnPOSIXFD(MyPlugin *) {}