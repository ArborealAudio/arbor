//! plugin.zig
//! where we define our plugin's properties

const std = @import("std");

const clap = @cImport({@cInclude("clap/clap.h");});
const param = @import("param.zig");
const GUI_WIDTH = 300;
const GUI_HEIGHT  = 200;

const Rect = struct
{
    x: u32,
    y: u32,
    width: u32,
    height: u32,
};

const Plugin = struct 
{
    // clap_plugin_t plugin;
    plugin: clap.clap_plugin_t,
    // const clap_host_t *host;
    host: *clap.clap_host_t,
    sampleRate: f32,
    parameters: [P_COUNT]f32,
    mainParameters: [P_COUNT]f32,
    changed: [P_COUNT]bool,
    mainChanged: [P_COUNT]bool,
    // const clap_host_params_t *hostParams;
    hostParams: *clap.clap_host_params_t,
    // Mutex syncParameters;
    syncParameters: std.Thread.Mutex,
    gestureStart: [P_COUNT] bool,
    gestureEnd: [P_COUNT] bool,

    mouseDragging: bool,
    mouseDraggingParameter: u32,
    mouseDragOriginX: i32,
    mouseDragOriginY: i32,
    mouseDragOriginValue: f32,

    gui: *GUI,
    const hostPOSIXFDSupport: *clap.clap_host_posix_fd_support_t,

    paramBounds: [P_COUNT] Rect, // absolute bounds of a clickable parameter

    const hostTimerSupport: *clap.clap_host_timer_support_t,
    timerID: clap.clap_id,
};

fn PluginProcessEvent(plugin: *Plugin, event: *clap.clap_event_header_t) void
{
    if (event.space_id == CLAP_CORE_EVENT_SPACE_ID)
    {
        if (event.type == CLAP_EVENT_PARAM_VALUE)
        {
            const clap_event_param_value_t *valueEvent = (const clap_event_param_value_t *)event;
            uint32_t i = (uint32_t)valueEvent->param_id;
            MutexAcquire(plugin->syncParameters);
            plugin->parameters[i] = valueEvent->value;
            plugin->changed[i] = true;
            MutexRelease(plugin->syncParameters);
        }
    }
}

float saturate(float x)
{
    return x / (1.f + fabsf(x));
}

static void PluginRenderAudio(MyPlugin *plugin, uint32_t start, uint32_t end, const float *inL, const float *inR, float *outL, float *outR)
{
    for (uint32_t index = start; index < end; ++index)
    {
        float left = inL[index];
        left *= 24.f;
        left = saturate(left);
        left /= 24.f;
        outL[index] = left;

        float right = inR[index];
        right *= 24.f;
        right = saturate(left);
        right /= 24.f;
        outR[index] = right;
    }
}

static void PluginPaintRectangle(MyPlugin *plugin, uint32_t *bits, GUIRectangle rect, uint32_t border, uint32_t fill)
{
    uint32_t r = rect.x + rect.width;
    uint32_t b = rect.y + rect.height;
    for (uint32_t y = rect.y; y < b; y++)
    {
        for (uint32_t x = rect.x; x < r; x++)
        {
            bits[y * GUI_WIDTH + x] = (y == rect.y || y == b - 1 || x == rect.x || x == r - 1) ? border : fill;
        }
    }
}

static void PluginPaint(MyPlugin *plugin, uint32_t *bits)
{
    // Draw the background.
    PluginPaintRectangle(plugin, bits, (GUIRectangle){0, 0, GUI_WIDTH, GUI_HEIGHT}, 0xC0C0C0, 0xC0C0C0);

    uint32_t centerX = GUI_WIDTH / 2;
    uint32_t centerY = GUI_HEIGHT / 2;
    uint32_t width = (float)GUI_WIDTH * 0.35f;
    uint32_t height = (float)GUI_HEIGHT * 0.75f;
    uint32_t x = centerX - (width * 0.5f);
    uint32_t y = centerY - (height * 0.5f);

    GUIRectangle bounds = {x, y, width, height, };
    plugin->paramBounds[P_VOLUME] = bounds;

    // Draw the parameter, using the parameter value owned by the main thread.
    PluginPaintRectangle(plugin, bits, bounds, 0x000000, 0xC0C0C0);
    float paramVal = 1.0f - plugin->mainParameters[P_VOLUME];
    int paramY = y + (height - y) * paramVal;
    PluginPaintRectangle(plugin, bits, (GUIRectangle){x, paramY, width, height}, 0x000000, 0x000000);
}

static void PluginProcessMouseDrag(MyPlugin *plugin, int32_t x, int32_t y)
{
    if (plugin->mouseDragging)
    {
        float newValue = FloatClamp01(plugin->mouseDragOriginValue + (plugin->mouseDragOriginY - y) * 0.01f);

        MutexAcquire(plugin->syncParameters);
        plugin->mainParameters[plugin->mouseDraggingParameter] = newValue;
        plugin->mainChanged[plugin->mouseDraggingParameter] = true;
        MutexRelease(plugin->syncParameters);

        if (plugin->hostParams && plugin->hostParams->request_flush)
            plugin->hostParams->request_flush(plugin->host);
    }
}

static void PluginProcessMousePress(MyPlugin *plugin, int32_t x, int32_t y)
{
    if (x >= 10 && x < 40 && y >= 10 && y < 40)
    {
        plugin->mouseDragging = true;
        plugin->mouseDraggingParameter = P_VOLUME;
        plugin->mouseDragOriginX = x;
        plugin->mouseDragOriginY = y;
        plugin->mouseDragOriginValue = plugin->mainParameters[P_VOLUME];

        MutexAcquire(plugin->syncParameters);
        plugin->gestureStart[plugin->mouseDraggingParameter] = true;
        MutexRelease(plugin->syncParameters);

        if (plugin->hostParams && plugin->hostParams->request_flush)
            plugin->hostParams->request_flush(plugin->host);
    }
}

static void PluginProcessMouseRelease(MyPlugin *plugin)
{
    if (plugin->mouseDragging)
    {
        MutexAcquire(plugin->syncParameters);
        plugin->gestureEnd[plugin->mouseDraggingParameter] = true;
        MutexRelease(plugin->syncParameters);

        if (plugin->hostParams && plugin->hostParams->request_flush)
            plugin->hostParams->request_flush(plugin->host);

        plugin->mouseDragging = false;
    }
}

static void PluginSyncMainToAudio(MyPlugin *plugin, const clap_output_events_t *out)
{
    MutexAcquire(plugin->syncParameters);

    for (uint32_t i = 0; i < P_COUNT; ++i)
    {
        if (plugin->gestureStart[i])
        {
            plugin->gestureStart[i] = false;
            clap_event_param_gesture_t event = {};
            event.header.size = sizeof(event);
            event.header.time = 0;
            event.header.space_id = CLAP_CORE_EVENT_SPACE_ID;
            event.header.type = CLAP_EVENT_PARAM_GESTURE_BEGIN;
            event.header.flags = 0;
            event.param_id = i;
            out->try_push(out, &event.header);
        }

        if (plugin->mainChanged[i])
        {
            plugin->parameters[i] = plugin->mainParameters[i];
            plugin->mainChanged[i] = false;

            clap_event_param_value_t event = {};
            event.header.size = sizeof(event);
            event.header.time = 0;
            event.header.space_id = CLAP_CORE_EVENT_SPACE_ID;
            event.header.type = CLAP_EVENT_PARAM_VALUE;
            event.header.flags = 0;
            event.param_id = i;
            event.cookie = NULL;
            event.note_id = -1;
            event.port_index = -1;
            event.channel = -1;
            event.key = -1;
            event.value = plugin->parameters[i];
            out->try_push(out, &event.header);
        }

        if(plugin->gestureEnd[i])
        {
            plugin->gestureEnd[i] = false;

            clap_event_param_gesture_t event = {};
            event.header.size = sizeof(event);
            event.header.time = 0;
            event.header.space_id = CLAP_CORE_EVENT_SPACE_ID;
            event.header.type = CLAP_EVENT_PARAM_GESTURE_END;
            event.header.flags = 0;
            event.param_id = i;
            out->try_push(out, &event.header);
        }
    }

    MutexRelease(plugin->syncParameters);
}

static bool PluginSyncAudioToMain(MyPlugin *plugin)
{
    bool anyChanged = false;
    MutexAcquire(plugin->syncParameters);
    for (uint32_t i = 0; i < P_COUNT; ++i)
    {
        if (plugin->changed[i])
        {
            plugin->mainParameters[i] = plugin->parameters[i];
            plugin->changed[i] = false;
            anyChanged = true;
        }
    }

    MutexRelease(plugin->syncParameters);
    return anyChanged;
}

/* audio ports extension */
uint32_t audioPortCount(const clap_plugin_t *plugin, bool isInput) {
    return isInput ? 1 : 1;
}

bool audioPortGet(const clap_plugin_t *plugin, uint32_t index, bool isInput,
                  clap_audio_port_info_t *info) {
    if (index)
        return false;
    info->id = 0;
    info->channel_count = 2;
    info->flags = CLAP_AUDIO_PORT_IS_MAIN;
    info->port_type = CLAP_PORT_MONO;
    info->in_place_pair = true;
    snprintf(info->name, sizeof(info->name), "%s", "Audio Output");
    return true;
}

static const clap_plugin_audio_ports_t extensionAudioPorts = {
    .count = audioPortCount,
    .get = audioPortGet,
};

/* params extension */
uint32_t paramCount(const clap_plugin_t *plugin) { return P_COUNT; }

bool paramGetInfo(const clap_plugin_t *plugin, uint32_t index,
                  clap_param_info_t *information) {
    if (index == P_VOLUME) {
        memset(information, 0, sizeof(clap_param_info_t));
        information->id = index;
        information->flags = CLAP_PARAM_IS_AUTOMATABLE |
                             CLAP_PARAM_IS_MODULATABLE |
                             CLAP_PARAM_IS_MODULATABLE_PER_NOTE_ID;
        information->min_value = 0.f;
        information->max_value = 1.f;
        information->default_value = 0.5f;
        strcpy(information->name, "Volume");
        return true;
    } else
        return false;
}

bool paramGetValue(const clap_plugin_t *_plugin, clap_id id, double *value) {
    MyPlugin *plugin = (MyPlugin *)_plugin->plugin_data;
    uint32_t i = (uint32_t)id;
    if (i >= P_COUNT)
        return false;
    MutexAcquire(plugin->syncParameters);
    *value = plugin->mainChanged[i] ? plugin->mainParameters[i]
                                    : plugin->parameters[i];
    MutexRelease(plugin->syncParameters);
    return true;
}

bool paramValueToText(const clap_plugin_t *_plugin, clap_id id, double value,
                      char *display, uint32_t size) {
    uint32_t i = (uint32_t)id;
    if (i >= P_COUNT)
        return false;
    snprintf(display, size, "%f", value);
    return true;
}

bool paramTextToValue(const clap_plugin_t *_plugin, clap_id param_id,
                      const char *display, double *value) {
    return false;
}

void paramsFlush(const clap_plugin_t *_plugin, const clap_input_events_t *in,
                 const clap_output_events_t *out) {
    MyPlugin *plugin = (MyPlugin *)_plugin->plugin_data;
    const uint32_t eventCount = in->size(in);
    PluginSyncMainToAudio(plugin, out);

    for (uint32_t eventIndex = 0; eventIndex < eventCount; ++eventIndex)
        PluginProcessEvent(plugin, in->get(in, eventIndex));
}

static const clap_plugin_params_t extensionParams = {
    .count = paramCount,
    .get_info = paramGetInfo,
    .get_value = paramGetValue,
    .value_to_text = paramValueToText,
    .text_to_value = paramTextToValue,
    .flush = paramsFlush,
};

/* state extension */

bool stateSave(const clap_plugin_t *_plugin, const clap_ostream_t *stream) {
    MyPlugin *plugin = (MyPlugin *)_plugin->plugin_data;
    PluginSyncAudioToMain(plugin);
    return sizeof(float) * P_COUNT == stream->write(stream,
                                                    plugin->mainParameters,
                                                    sizeof(float) * P_COUNT);
}

bool stateLoad(const clap_plugin_t *_plugin, const clap_istream_t *stream) {
    MyPlugin *plugin = (MyPlugin *)_plugin->plugin_data;

    MutexAcquire(plugin->syncParameters);
    bool success =
        sizeof(float) * P_COUNT ==
        stream->read(stream, plugin->mainParameters, sizeof(float) * P_COUNT);
    for (uint32_t i = 0; i < P_COUNT; ++i)
        plugin->mainChanged[i] = true;

    MutexRelease(plugin->syncParameters);
    return success;
}

static const clap_plugin_state_t extensionState = {
    .save = stateSave,
    .load = stateLoad,
};

/* plugin descriptor */

static const clap_plugin_descriptor_t pluginDescriptor = {
    .clap_version = CLAP_VERSION_INIT,
    .id = "strix.MyFirstCLAP",
    .name = "CLAP-raw",
    .vendor = "Arboreal Audio",
    .url = "https://arborealaudio.com",
    .version = "0.2",
    .description = "Vintage analog warmth",
    .features = (const char *[]){"stereo", "audio-effect", NULL},
};

/* GUI shite */

#if defined(_WIN32)
#include "gui/gui_w32.c"
#elif defined(__linux__)
#include "gui/gui_x11.c"
#elif defined(__APPLE__)
#include "gui/gui_mac.c"
#endif

void onPOSIXFD(const clap_plugin_t *_plugin, int fd,
               clap_posix_fd_flags_t flags) {
    MyPlugin *plugin = (MyPlugin *)_plugin->plugin_data;
    GUIOnPOSIXFD(plugin);
}

static const clap_plugin_posix_fd_support_t extensionPOSIXFDSupport = {
    .on_fd = onPOSIXFD,
};

/* GUI extension */

bool extGUIIsAPISupported(const clap_plugin_t *plugin, const char *api, bool isFloating)
{
    // We'll define GUI_API in our platform specific code file.
    return 0 == strcmp(api, GUI_API) && !isFloating;
}

bool extGUIGetPreferredAPI(const clap_plugin_t *plugin, const char **api, bool *isFloating)
{
    *api = GUI_API;
    *isFloating = false;
    return true;
}

bool extGUICreate(const clap_plugin_t *_plugin, const char *api, bool isFloating)
{
    if (!extGUIIsAPISupported(_plugin, api, isFloating))
        return false;
    // We'll define GUICreate in our platform specific code file.
    GUICreate((MyPlugin *)_plugin->plugin_data);
    return true;
}

void extGUIDestroy(const clap_plugin_t *_plugin)
{
    // We'll define GUIDestroy in our platform specific code file.
    GUIDestroy((MyPlugin *)_plugin->plugin_data);
}

bool extGUISetScale(const clap_plugin_t *plugin, double scale)
{
    return false;
}

bool extGUIGetSize(const clap_plugin_t *plugin, uint32_t *width, uint32_t *height)
{
    *width = GUI_WIDTH;
    *height = GUI_HEIGHT;
    return true;
}

bool extGUICanResize(const clap_plugin_t *plugin)
{
    return false;
}

bool extGUIGetResizeHints(const clap_plugin_t *plugin, clap_gui_resize_hints_t *hints)
{
    return false;
}

bool extGUIAdjustSize(const clap_plugin_t *plugin, uint32_t *width, uint32_t *height)
{
    return extGUIGetSize(plugin, width, height);
}

bool extGUISetSize(const clap_plugin_t *plugin, uint32_t width, uint32_t height)
{
    return true;
}

bool extGUISetParent(const clap_plugin_t *_plugin, const clap_window_t *window)
{
    assert(0 == strcmp(window->api, GUI_API));
    // We'll define GUISetParent in our platform specific code file.
    GUISetParent((MyPlugin *)_plugin->plugin_data, window);
    return true;
}

bool extGUISetTransient(const clap_plugin_t *plugin, const clap_window_t *window)
{
    return false;
}

void extGUISuggestTitle(const clap_plugin_t *plugin, const char *title) {}

bool extGUIShow(const clap_plugin_t *_plugin)
{
    // We'll define GUISetVisible in our platform specific code file.
    GUISetVisible((MyPlugin *)_plugin->plugin_data, true);
    return true;
}

bool extGUIHide(const clap_plugin_t *_plugin)
{
    GUISetVisible((MyPlugin *)_plugin->plugin_data, false);
    return true;
}

static const clap_plugin_gui_t extensionGUI = {
    .is_api_supported = extGUIIsAPISupported,
    .get_preferred_api = extGUIGetPreferredAPI,
    .create = extGUICreate,
    .destroy = extGUIDestroy,
    .set_scale = extGUISetScale,
    .get_size = extGUIGetSize,
    .can_resize = extGUICanResize,
    .get_resize_hints = extGUIGetResizeHints,
    .adjust_size = extGUIAdjustSize,
    .set_size = extGUISetSize,
    .set_parent = extGUISetParent,
    .set_transient = extGUISetTransient,
    .suggest_title = extGUISuggestTitle,
    .show = extGUIShow,
    .hide = extGUIHide,
};

/* timer */

void timerCallback(const clap_plugin_t *_plugin, clap_id timerID)
{
    MyPlugin *plugin = (MyPlugin *)_plugin->plugin_data;
    if (plugin->gui && PluginSyncAudioToMain(plugin))
        GUIPaint(plugin, true);
}

static const clap_plugin_timer_support_t extensionTimerSupport = {
    .on_timer = timerCallback,
};

/* plugin class */

bool pluginInit(const struct clap_plugin *_plugin)
{
    MyPlugin *plugin = (MyPlugin *)_plugin->plugin_data;
    (void)plugin;

    plugin->hostParams =
        (const clap_host_params_t *)plugin->host->get_extension(
            plugin->host, CLAP_EXT_PARAMS);

    plugin->hostPOSIXFDSupport =
        (const clap_host_posix_fd_support_t *)plugin->host->get_extension(
            plugin->host, CLAP_EXT_POSIX_FD_SUPPORT);

    MutexInitialise(plugin->syncParameters);

    for (uint32_t i = 0; i < P_COUNT; ++i)
    {
        clap_param_info_t information = {};
        extensionParams.get_info(_plugin, i, &information);
        plugin->mainParameters[i] = plugin->parameters[i] =
            information.default_value;
    }

    plugin->hostTimerSupport =
        (const clap_host_timer_support_t *)plugin->host->get_extension(
            plugin->host, CLAP_EXT_TIMER_SUPPORT);
    if (plugin->hostTimerSupport && plugin->hostTimerSupport->register_timer)
        plugin->hostTimerSupport->register_timer(plugin->host, 200,
                                                 &plugin->timerID);

    return true;
}

void pluginDestroy(const struct clap_plugin *_plugin)
{
    MyPlugin *plugin = (MyPlugin *)_plugin->plugin_data;

    if (plugin->hostTimerSupport && plugin->hostTimerSupport->register_timer)
        plugin->hostTimerSupport->unregister_timer(plugin->host,
                                                   plugin->timerID);

    MutexDestroy(plugin->syncParameters);
    free(plugin);
}

bool pluginActivate(const struct clap_plugin *_plugin, double sampleRate,
                    uint32_t minimumFramesCount, uint32_t maximumFramesCount)
{
    MyPlugin *plugin = (MyPlugin *)_plugin->plugin_data;
    plugin->sampleRate = sampleRate;
    return true;
}

void pluginDeactivate(const struct clap_plugin *_plugin) {}

bool pluginStartProcessing(const struct clap_plugin *_plugin) { return true; }

void pluginStopProcessing(const struct clap_plugin *_plugin) {}

void pluginReset(const struct clap_plugin *_plugin)
{
    MyPlugin *plugin = (MyPlugin *)_plugin->plugin_data;
}

clap_process_status pluginProcess(const struct clap_plugin *_plugin,
                                  const clap_process_t *process)
{
    MyPlugin *plugin = (MyPlugin *)_plugin->plugin_data;
    assert(process->audio_outputs_count == 1);
    assert(process->audio_inputs_count == 1);

    PluginSyncMainToAudio(plugin, process->out_events);

    const uint32_t frameCount = process->frames_count;
    const uint32_t inputEventCount = process->in_events->size(process->in_events);
    uint32_t eventIndex = 0;
    uint32_t nextEventFrame = inputEventCount ? 0 : frameCount;
    for (uint32_t i = 0; i < frameCount;)
    {
        while (eventIndex < inputEventCount && nextEventFrame == i)
        {
            const clap_event_header_t *event =
                process->in_events->get(process->in_events, eventIndex);

            if (event->time != i)
            {
                nextEventFrame = event->time;
                break;
            }

            PluginProcessEvent(plugin, event);
            eventIndex++;
            if (eventIndex == inputEventCount)
            {
                nextEventFrame = frameCount;
                break;
            }
        }

        PluginRenderAudio(plugin, i, nextEventFrame,
                          process->audio_inputs[0].data32[0], process->audio_inputs[0].data32[1], process->audio_outputs[0].data32[0],
                          process->audio_outputs[0].data32[1]);
        i = nextEventFrame;
    }

    return CLAP_PROCESS_CONTINUE;
}

const void *pluginGetExtension(const struct clap_plugin *plugin,
                               const char *id)
{
    if (0 == strcmp(id, CLAP_EXT_AUDIO_PORTS))
        return &extensionAudioPorts;
    if (0 == strcmp(id, CLAP_EXT_PARAMS))
        return &extensionParams;
    if (0 == strcmp(id, CLAP_EXT_STATE))
        return &extensionState;
    if (0 == strcmp(id, CLAP_EXT_GUI))
        return &extensionGUI;
    if (0 == strcmp(id, CLAP_EXT_TIMER_SUPPORT))
        return &extensionTimerSupport;
    if (0 == strcmp(id, CLAP_EXT_POSIX_FD_SUPPORT))
        return &extensionPOSIXFDSupport;
    return NULL;
}

void pluginOnMainThread(const struct clap_plugin *_plugin) {}

static const clap_plugin_t pluginClass = {
    .desc = &pluginDescriptor,
    .plugin_data = NULL,
    .init = pluginInit,
    .destroy = pluginDestroy,
    .activate = pluginActivate,
    .deactivate = pluginDeactivate,
    .start_processing = pluginStartProcessing,
    .stop_processing = pluginStopProcessing,
    .reset = pluginReset,
    .process = pluginProcess,
    .get_extension = pluginGetExtension,
    .on_main_thread = pluginOnMainThread,
};

uint32_t getPluginCount(const struct clap_plugin_factory *factory) { return 1; }
const clap_plugin_descriptor_t *getPluginDescriptor(const struct clap_plugin_factory *factory,
                                 uint32_t index) {
    return index == 0 ? &pluginDescriptor : NULL;
}
const clap_plugin_t *createPlugin(const struct clap_plugin_factory *factory,
                                  const clap_host_t *host,
                                  const char *pluginID) {
    if (!clap_version_is_compatible(host->clap_version) ||
        strcmp(pluginID, pluginDescriptor.id))
        return NULL;

    MyPlugin *plugin = (MyPlugin *)calloc(1, sizeof(MyPlugin));
    plugin->host = host;
    plugin->plugin = pluginClass;
    plugin->plugin.plugin_data = plugin;
    return &plugin->plugin;
}

static const clap_plugin_factory_t pluginFactory = {
    .get_plugin_count = getPluginCount,

    .get_plugin_descriptor = getPluginDescriptor,

    .create_plugin = createPlugin,
};

bool init(const char *path) { return true; }
void deinit(void) {}
const void *getFactory(const char *factoryID) {
        return strcmp(factoryID, CLAP_PLUGIN_FACTORY_ID) ? NULL
                                                         : &pluginFactory;
}

const clap_plugin_entry_t clap_entry = {
    .clap_version = CLAP_VERSION_INIT,
    .init = init,
    .deinit = deinit,
    .get_factory = getFactory,
};

#endif // PLUGIN_C