/**
 * gui_mac.cpp
 * Mac-specific GUI code
*/

#define GUI_API CLAP_WINDOW_API_COCOA

struct GUI
{
    void *mainView;
    uint32_t *bits;
};

void *MacInitialise(struct MyPlugin *plugin, uint32_t *bits, uint32_t width, uint32_t height);
void MacDestroy(void *mainView);
void MacSetParent(void *mainView, void *parentView);
void MacSetVisible(void *mainView, bool show);
void MacPaint(void *mainView);


static void GUIPaint(MyPlugin *plugin, bool internal)
{
    if (internal)
        PluginPaint(plugin, plugin->gui->bits);
    MacPaint(plugin->gui->mainView);
}

static void GUICreate(MyPlugin *plugin)
{
    assert(!plugin->gui);
    plugin->gui = (struct GUI *)calloc(1, sizeof(struct GUI));
    plugin->gui->bits = (uint32_t *)calloc(1, GUI_WIDTH * GUI_HEIGHT * 4);
    PluginPaint(plugin, plugin->gui->bits);
    plugin->gui->mainView = MacInitialise(plugin, plugin->gui->bits, GUI_WIDTH, GUI_HEIGHT);
}

static void GUIDestroy(MyPlugin *plugin)
{
    assert(plugin->gui);
    MacDestroy(plugin->gui->mainView);
    free(plugin->gui->bits);
    free(plugin->gui);
    plugin->gui = NULL;
}

static void GUISetParent(MyPlugin *plugin, const clap_window_t *parent) { MacSetParent(plugin->gui->mainView, parent->cocoa); }
static void GUISetVisible(MyPlugin *plugin, bool visible) { MacSetVisible(plugin->gui->mainView, visible); }
static void GUIOnPOSIXFD(MyPlugin *) {}

void MacInputEvent(struct MyPlugin *plugin, int32_t cursorX, int32_t cursorY, int8_t button)
{
    if (button == -1)
        PluginProcessMouseRelease(plugin);
    if (button == 0)
        PluginProcessMouseDrag(plugin, cursorX, GUI_HEIGHT - 1 - cursorY);
    if (button == 1)
        PluginProcessMousePress(plugin, cursorX, GUI_HEIGHT - 1 - cursorY);
    GUIPaint(plugin, true);
}