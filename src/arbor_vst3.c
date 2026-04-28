#include "../vst3/vst3.h"
#include "arbor.h"

static inline bool tuid_match(const Steinberg_TUID a, const Steinberg_TUID b) {
    return memcmp(a, b, sizeof(Steinberg_TUID)) == 0;
}

static const Steinberg_TUID class_tuid = SMTG_INLINE_UID('C' ^ 'A', 'l' ^ 'F', 'a' ^ 'V', 's' ^ '3');
static const Steinberg_TUID component_tuid = SMTG_INLINE_UID('C' ^ 'A', 'o' ^ 'F', 'm' ^ 'V', 'p' ^ '3');
static const Steinberg_TUID controller_tuid = SMTG_INLINE_UID('C' ^ 'A', 't' ^ 'F', 'r' ^ 'V', 'l' ^ '3');

// WTF is this crap?
static const char audio_class_info_category[] = "Audio Module Class";
static const char component_class_info_category[] = "Component Module Class";

static u32 hash_plugin_id() {
    u32 hash = 0x311311;
    int len = string_len(plugin_config.desc.id);
    for (int i = 0; i < len; ++i) {
        hash = (hash ^ plugin_config.desc.id[i]) * 0x01000193;
    }

    return hash;
}

typedef volatile int RefCount;

typedef struct {
    Steinberg_Vst_IAudioProcessorVtbl *vtable;
    Steinberg_Vst_IProcessContextRequirementsVtbl *req;
    RefCount ref_count;
} Vst3AudioProcessor;

typedef struct {
    Steinberg_Vst_IComponentVtbl *vtable;
    RefCount ref_count;
} Vst3Component;

typedef struct {
    Steinberg_Vst_IEditControllerVtbl *vtable;
    Steinberg_Vst_IComponentHandler *handler;
    RefCount ref_count;
} Vst3Controller;


typedef struct {
    bool valid;
    u32 id;
    u32 offset;
    double value;
} ParamChange;

typedef struct {
    Vst3AudioProcessor processor;
    Vst3Component component;
    Vst3Controller controller;

#define PARAM_QUEUE_SIZE 512
    ParamChange param_changes[PARAM_QUEUE_SIZE];
    uint param_change_head;

    Plugin *plugin;
} Vst3Plugin;

#define vst3_from_ptr(ptr, field) (Vst3Plugin*)((char*)(ptr) - offsetof(Vst3Plugin, field))

static int compare_param_change_offset(const void *a, const void *b) {
    ParamChange *change_a = (ParamChange*)a;
    ParamChange *change_b = (ParamChange*)b;

    return change_a->offset - change_b->offset;
}

static void sort_param_changes(Vst3Plugin *vst3) {
    qsort(vst3->param_changes, vst3->param_change_head, sizeof(ParamChange), compare_param_change_offset);
}

// TODO Figure out when plugin is actually destroyed, based on accumulated refs

// AUDIO PROCESSOR:
// Despite being pretty related to `Component`, this is a separate interface
// which handles some audio-specific tasks, like getting info about audio busses
// and processing audio.

static Steinberg_tresult audio_processor_query_interface (void* thisInterface, const Steinberg_TUID iid, void** obj) {
    Vst3AudioProcessor *proc = (Vst3AudioProcessor*)thisInterface;
    if (tuid_match(iid, Steinberg_FUnknown_iid) || tuid_match(iid, Steinberg_Vst_IAudioProcessor_iid)) {
        if (obj) {
            dbg("AudioProcessor: query OK");
            proc->ref_count += 1;
            *obj = proc;
            return Steinberg_kResultOk;
        }
    } else if (tuid_match(iid, Steinberg_Vst_IProcessContextRequirements_iid)) {
        if (obj) {
            dbg("AudioProcessor: ProcessContextRequirements query OK");
            *obj = &proc->req;
            return Steinberg_kResultOk;
        }
    }

    return Steinberg_kNoInterface;
}

static Steinberg_uint32 audio_processor_add_ref (void* thisInterface) {
    Vst3AudioProcessor *proc = (Vst3AudioProcessor*)thisInterface;
    int count = ++proc->ref_count;
    dbg("AudioProcessor: adding ref (%d)", count);
    return count;
}

static Steinberg_uint32 audio_processor_release (void* thisInterface) {
    Vst3AudioProcessor *proc = (Vst3AudioProcessor*)thisInterface;
    int count = --proc->ref_count;
    dbg("AudioProcessor: releasing ref (%d)", count);
    if (count > 0) {
        return count;
    }

    dbg("AudioProcessor: all refs released");

    return 0;
}

static Steinberg_tresult audio_processor_set_bus_arrangements (void* thisInterface,
    Steinberg_Vst_SpeakerArrangement* inputs, Steinberg_int32 numIns,
    Steinberg_Vst_SpeakerArrangement* outputs, Steinberg_int32 numOuts) {
    dbg();
    return Steinberg_kResultOk;
}

static Steinberg_tresult audio_processor_get_bus_arrangement (void* thisInterface,
    Steinberg_Vst_BusDirection dir, Steinberg_int32 index,
    Steinberg_Vst_SpeakerArrangement* arr) {
    dbg();
    return Steinberg_kResultOk;
}

static Steinberg_tresult audio_processor_query_sample_size (void* thisInterface, Steinberg_int32 symbolicSampleSize) {
    dbg();
    if (symbolicSampleSize == Steinberg_Vst_SymbolicSampleSizes_kSample32)
        return Steinberg_kResultTrue;

    return Steinberg_kResultFalse;
}

static Steinberg_uint32 audio_processor_get_latency_samples (void* thisInterface) {
    dbg();
    Vst3Plugin *vst3 = vst3_from_ptr(thisInterface, processor);
    Plugin *plugin = vst3->plugin;
    return plugin->latency;
}

static Steinberg_tresult audio_processor_setup_processing (void* thisInterface, struct Steinberg_Vst_ProcessSetup* setup) {
    dbg();
    Vst3Plugin *vst3 = vst3_from_ptr(thisInterface, processor);
    Plugin *plugin = vst3->plugin;
    plugin->user_iface.prepare_cb(plugin, setup->sampleRate, setup->maxSamplesPerBlock);
    return Steinberg_kResultOk;
}

static Steinberg_tresult audio_processor_set_processing (void* thisInterface, Steinberg_TBool state) {
    dbg();
    return Steinberg_kResultOk;
}

static Steinberg_tresult audio_processor_process (void* thisInterface, struct Steinberg_Vst_ProcessData* data) {
    Vst3Plugin *vst3 = vst3_from_ptr(thisInterface, processor);
    Plugin *plugin = vst3->plugin;
    u32 num_frames = data->numSamples;
    u32 next_event_frame = num_frames;

    int param_change_count = data->inputParameterChanges->lpVtbl->getParameterCount(data->inputParameterChanges);
    memset(vst3->param_changes, 0, sizeof(vst3->param_changes));
    vst3->param_change_head = 0;
    for (int i = 0; i < param_change_count; ++i) {
        struct Steinberg_Vst_IParamValueQueue *queue = data->inputParameterChanges->lpVtbl->getParameterData(data->inputParameterChanges, i);
        u32 id = queue->lpVtbl->getParameterId(queue);
        int point_count = queue->lpVtbl->getPointCount(queue);
        for (int p = 0; p < point_count; ++p) {
            int offset;
            double value;
            if (queue->lpVtbl->getPoint(queue, p, &offset, &value) == Steinberg_kResultOk) {
                f32 normalized = get_parameter_from_normalized(plugin, id, (f32)value);
                dbg("normalized: %d = %.2f", id, normalized);
                vst3->param_changes[vst3->param_change_head] = (ParamChange){
                    .valid = true,
                    .id = id,
                    .offset = offset,
                    .value = normalized,
                };
                vst3->param_change_head++;
            }
        }
    }

    if (param_change_count > 0) {
        sort_param_changes(vst3);
        if (vst3->param_changes->valid) {
            next_event_frame = vst3->param_changes->offset;
        }
    }

    u32 i = 0;
    u32 event_id = 0;
    while (i < num_frames) {
        if (next_event_frame == i) {
            ParamChange change = vst3->param_changes[event_id];
            assert(change.offset == i);
            set_parameter(plugin, change.id, change.value);
            event_id++;
            if (vst3->param_changes[event_id].valid) {
                next_event_frame = vst3->param_changes[event_id].offset;
            } else {
               next_event_frame = num_frames;
            }
            assert(next_event_frame <= num_frames);
        }

        u32 frames_to_process = next_event_frame - i;

        AudioBuffer32 in_buf = {
            .data = data->inputs->Steinberg_Vst_AudioBusBuffers_channelBuffers32,
            .num_frames = frames_to_process,
            .num_ch = data->inputs->numChannels,
        };
        for (int ch = 0; ch < in_buf.num_ch; ++ch) {
            in_buf.data[ch] += i;
        }

        AudioBuffer32 out_buf = {
            .data = data->outputs->Steinberg_Vst_AudioBusBuffers_channelBuffers32,
            .num_frames = frames_to_process,
            .num_ch = data->outputs->numChannels,
        };
        for (int ch = 0; ch < out_buf.num_ch; ++ch) {
            out_buf.data[ch] += i;
        }

        plugin->user_iface.process_cb(plugin, in_buf, out_buf, (MidiBuffer){
                                          .events = plugin->midi.buffer,
                                          .length = plugin->midi.head,
                                      });

        i += frames_to_process;
    }

    // sync main params to audio params
    memcpy(plugin->params->main, plugin->params->audio, sizeof(plugin->params->audio));

    return Steinberg_kResultOk;
}

static Steinberg_uint32 audio_processor_get_tail_length (void* thisInterface) {
    dbg();
    return 0;
}

static Steinberg_tresult proc_req_query_interface(void *thisInterface, const Steinberg_TUID iid, void **obj) {
    if (tuid_match(iid, Steinberg_FUnknown_iid) || tuid_match(iid, Steinberg_Vst_IProcessContextRequirements_iid)) {
        dbg("ProcContextRequirements: query OK");
        *obj = thisInterface;
        return Steinberg_kResultOk;
    }

    return Steinberg_kNoInterface;
}

static Steinberg_uint32 proc_req_add_ref(void *thisInterface) {
    return 1;
}

static Steinberg_uint32 proc_req_release(void *thisInterface) {
    return 0;
}

static Steinberg_Vst_IProcessContextRequirements_Flags proc_req_get_requirements(void *thisInterface) {
    return Steinberg_Vst_IProcessContextRequirements_Flags_kNeedContinousTimeSamples;
}

// COMPONENT:
// The basic interface comprising an audio plugin. Despite handling tasks related
// to audio busses and the state of the plugin, this class is not responsible
// for processing audio or handling parameters, for *some* reason.

static Steinberg_tresult component_query_interface (void* thisInterface, const Steinberg_TUID iid, void** obj) {
    Vst3Component *comp = (Vst3Component*)thisInterface;
    Vst3Plugin *vst3 = vst3_from_ptr(comp, component);
    if (tuid_match(iid, Steinberg_FUnknown_iid) || tuid_match(iid, Steinberg_IPluginBase_iid) ||
        tuid_match(iid, Steinberg_Vst_IComponent_iid)) {
        if (obj) {
            dbg("Component: query OK");
            comp->ref_count++;
            *obj = comp;
            return Steinberg_kResultOk;
        }
    }
    if (tuid_match(iid, Steinberg_Vst_IAudioProcessor_iid)) {
        if (obj) {
            dbg("Component: query Audio Processor OK");
            vst3->processor.ref_count++;
            *obj = &vst3->processor;
            return Steinberg_kResultOk;
        }
    }
    if (tuid_match(iid, Steinberg_Vst_IEditController_iid)) {
        if (obj) {
            dbg("Component: query Controller OK");
            vst3->controller.ref_count++;
            *obj = &vst3->controller;
            return Steinberg_kResultOk;
        }
    }

    dbg("Component: unsupported interface (%s)", iid);

    *obj = NULL;
    return Steinberg_kNoInterface;
}

static Steinberg_uint32 component_add_ref (void* thisInterface) {
    Vst3Component *comp = (Vst3Component*)thisInterface;
    int count = ++comp->ref_count;
    dbg("Component: adding ref (%d)", count);
    return count;
}

static Steinberg_uint32 component_release (void* thisInterface) {
    Vst3Component *comp = (Vst3Component*)thisInterface;
    int count = --comp->ref_count;
    dbg("Component: releasing ref (%d)", count);
    if (count > 0) {
        return count;
    }

    dbg("Component: all refs released");

    return 0;
}

static Steinberg_tresult component_initialize (void* thisInterface, struct Steinberg_FUnknown* context) {
    dbg();
    return Steinberg_kResultOk;
}

static Steinberg_tresult component_terminate (void* thisInterface) {
    dbg();
    return Steinberg_kResultOk;
}

static Steinberg_tresult component_get_controller_id (void* thisInterface, Steinberg_TUID classId) {
    dbg();
    memcpy(classId, controller_tuid, sizeof(Steinberg_TUID));
    return Steinberg_kResultOk;
}

static Steinberg_tresult component_set_io_mode (void* thisInterface, Steinberg_Vst_IoMode mode) {
    dbg();
    return Steinberg_kNotImplemented;
}

static Steinberg_int32 component_get_bus_count (void* thisInterface, Steinberg_Vst_MediaType type,
                                         Steinberg_Vst_BusDirection dir) {
    dbg();
    if (type == Steinberg_Vst_MediaTypes_kAudio) {
        return 1;
    }

    return 0;
}

static Steinberg_tresult component_get_bus_info (void* thisInterface, Steinberg_Vst_MediaType type,
                                          Steinberg_Vst_BusDirection dir, Steinberg_int32 index,
                                          struct Steinberg_Vst_BusInfo* bus) {
    dbg();
    if (!bus) {
        return Steinberg_kInvalidArgument;
    }
    Vst3Plugin *vst3 = vst3_from_ptr(thisInterface, component);
    Plugin *plugin = vst3->plugin;
    if (type == Steinberg_Vst_MediaTypes_kAudio) {
        if (dir == Steinberg_Vst_BusDirections_kInput) {
            *bus = (struct Steinberg_Vst_BusInfo){
                .mediaType = type,
                .busType = Steinberg_Vst_BusTypes_kMain,
                .channelCount = plugin->audio_input_count,
                .direction = dir,
                .flags = Steinberg_Vst_BusInfo_BusFlags_kDefaultActive,
            };
            String16 name = string16_from_utf8(plugin_allocator(plugin), "Audio Input");
            memcpy(bus->name, name.data, name.len * sizeof(u16));
        } else {
            *bus = (struct Steinberg_Vst_BusInfo){
                .mediaType = type,
                .busType = Steinberg_Vst_BusTypes_kMain,
                .channelCount = plugin->audio_output_count,
                .direction = dir,
                .flags = Steinberg_Vst_BusInfo_BusFlags_kDefaultActive,
            };
            String16 name = string16_from_utf8(plugin_allocator(plugin), "Audio Output");
            memcpy(bus->name, name.data, name.len * sizeof(u16));
        }
        return Steinberg_kResultOk;
    }

    return Steinberg_kNotImplemented;
}

static Steinberg_tresult component_get_routing_info (void* thisInterface, struct Steinberg_Vst_RoutingInfo* inInfo,
                                              struct Steinberg_Vst_RoutingInfo* outInfo) {
    dbg();
    return Steinberg_kNotImplemented;
}

static Steinberg_tresult component_activate_bus (void* thisInterface, Steinberg_Vst_MediaType type,
                                          Steinberg_Vst_BusDirection dir, Steinberg_int32 index,
                                          Steinberg_TBool state) {
    dbg();
    if (type == Steinberg_Vst_MediaTypes_kAudio) {
        return Steinberg_kResultOk;
    }

    return Steinberg_kNotImplemented;
}

static Steinberg_tresult component_set_active (void* thisInterface, Steinberg_TBool state) {
    dbg();
    return Steinberg_kResultOk;
}

static Steinberg_tresult component_set_state (void* thisInterface, struct Steinberg_IBStream* state) {
    dbg();
    return Steinberg_kNotImplemented;
}

static Steinberg_tresult component_get_state (void* thisInterface, struct Steinberg_IBStream* state) {
    dbg();
    return Steinberg_kNotImplemented;
}

// CONTROLLER:
// A very special interface which manages plugin state (upstream from `Component`?) and contains
// helper functions for converting parameter values. Also spawns UI for some reason.
// This contains a reference to a `ComponentHandler` interface which manages the
// apparently sufficiently-unique task of *performing* edits to the plugin's state.

static Steinberg_tresult controller_query_interface (void* thisInterface, const Steinberg_TUID iid, void** obj) {
    Vst3Controller *ctrl = (Vst3Controller*)thisInterface;
    if (tuid_match(iid, Steinberg_FUnknown_iid) || tuid_match(iid, Steinberg_Vst_IEditController_iid)) {
        if (obj) {
            dbg("Controller: query OK");
            ctrl->ref_count++;
            *obj = ctrl;
            return Steinberg_kResultOk;
        }
    }

    dbg("Controller: unsupported TUID (%s)", iid);
    return Steinberg_kNoInterface;
}

static Steinberg_uint32 controller_add_ref (void* thisInterface) {
    Vst3Controller *ctrl = (Vst3Controller*)thisInterface;
    int count = ++ctrl->ref_count;
    dbg("Controller: adding ref (%d)", count);
    return count;
}

static Steinberg_uint32 controller_release (void* thisInterface) {
    Vst3Controller *ctrl = (Vst3Controller*)thisInterface;
    int count = --ctrl->ref_count;
    dbg("Controller: releasing ref (%d)", count);
    if (count > 0) {
        return count;
    }

    dbg("Controller: all refs released");

    return 0;
}

static Steinberg_tresult controller_initialize (void* thisInterface, struct Steinberg_FUnknown* context) {
    dbg();
    return Steinberg_kResultOk;
}

static Steinberg_tresult controller_terminate (void* thisInterface) {
    dbg();
    return Steinberg_kResultOk;
}

static Steinberg_tresult controller_set_component_state (void* thisInterface, struct Steinberg_IBStream* state) {
    dbg();
    return Steinberg_kResultOk;
}

static Steinberg_tresult controller_set_state (void* thisInterface, struct Steinberg_IBStream* state) {
    dbg();
    return Steinberg_kResultOk;
}

static Steinberg_tresult controller_get_state (void* thisInterface, struct Steinberg_IBStream* state) {
    dbg();
    return Steinberg_kResultOk;
}

static Steinberg_int32 controller_get_parameter_count (void* thisInterface) {
    return Param_Count;
}

static Steinberg_tresult controller_get_parameter_info (void* thisInterface, Steinberg_int32 paramIndex,
                                                 struct Steinberg_Vst_ParameterInfo* info) {
    dbg();

    Vst3Plugin *vst3 = vst3_from_ptr(thisInterface, controller);
    Plugin *plugin = vst3->plugin;
    const Parameter *param = get_parameter_info(plugin, paramIndex);
    if (!param) {
        return Steinberg_kInvalidArgument;
    }
    *info = (struct Steinberg_Vst_ParameterInfo){
        .id = paramIndex,
        .defaultNormalizedValue = get_parameter_normalized(plugin, paramIndex, param->default_value),
    };
    switch (param->type) {
    case ParameterType_Float:
    case ParameterType_Int:
    case ParameterType_Bool:
        info->flags = Steinberg_Vst_ParameterInfo_ParameterFlags_kCanAutomate;
        break;
    case ParameterType_Choice:
        info->flags = Steinberg_Vst_ParameterInfo_ParameterFlags_kCanAutomate |
                      Steinberg_Vst_ParameterInfo_ParameterFlags_kIsList;
        break;
    }

    if (param->is_bypass) {
        info->flags |= Steinberg_Vst_ParameterInfo_ParameterFlags_kIsBypass;
    }

    // NOTE: Is it a problem that we're using unsigned 16-bit characters...?
    String16 name = string16_from_string(plugin_allocator(plugin), param->name);
    memcpy(info->title, name.data, name.len * sizeof(u16));
    memcpy(info->shortTitle, name.data, name.len * sizeof(u16));

    return Steinberg_kResultOk;
}

static Steinberg_tresult controller_param_string_by_value (void* thisInterface, Steinberg_Vst_ParamID id,
                                                    Steinberg_Vst_ParamValue valueNormalized,
                                                    Steinberg_Vst_String128 string) {
    dbg();
    Vst3Plugin *vst3 = vst3_from_ptr(thisInterface, controller);
    Plugin *plugin = vst3->plugin;
    const Parameter *param = get_parameter_info(plugin, id);
    if (!param) {
        return Steinberg_kInvalidArgument;
    }

    memset(string, 0, sizeof(*string) * 128);

    if (param->value_to_text) {
        char buf[128] = {0};
        param->value_to_text(param, get_parameter_from_normalized(plugin, id, valueNormalized), buf, 128);

        String16 unicode = string16_from_utf8(plugin_allocator(plugin), buf);
        memcpy(string, unicode.data, unicode.len * sizeof(u16));
        return Steinberg_kResultOk;
    }

    return Steinberg_kNotImplemented;
}

static Steinberg_tresult controller_param_value_by_string (void* thisInterface, Steinberg_Vst_ParamID id,
                                                    Steinberg_Vst_TChar* string,
                                                    Steinberg_Vst_ParamValue* valueNormalized) {
    dbg();
    return Steinberg_kNotImplemented;
}

static Steinberg_Vst_ParamValue controller_normalized_param_to_plain (void* thisInterface, Steinberg_Vst_ParamID id,
                                                               Steinberg_Vst_ParamValue valueNormalized) {
    dbg();
    Vst3Plugin *vst3 = vst3_from_ptr(thisInterface, controller);
    Plugin *plugin = vst3->plugin;
    return get_parameter_from_normalized(plugin, id, valueNormalized);
}

static Steinberg_Vst_ParamValue controller_plain_param_to_normalized (void* thisInterface, Steinberg_Vst_ParamID id,
                                                               Steinberg_Vst_ParamValue plainValue) {
    dbg();
    Vst3Plugin *vst3 = vst3_from_ptr(thisInterface, controller);
    Plugin *plugin = vst3->plugin;
    return get_parameter_normalized(plugin, id, plainValue);
}

static Steinberg_Vst_ParamValue controller_get_param_normalized (void* thisInterface, Steinberg_Vst_ParamID id) {
    dbg();
    Vst3Plugin *vst3 = vst3_from_ptr(thisInterface, controller);
    Plugin *plugin = vst3->plugin;
    if (id >= Param_Count) {
        err("Invalid param ID\n");
        return 0;
    }

    f32 value = get_parameter_main(plugin, id);
    return get_parameter_normalized(plugin, id, value);
}

static Steinberg_tresult controller_set_param_normalized (void* thisInterface, Steinberg_Vst_ParamID id,
                                                   Steinberg_Vst_ParamValue value) {
    dbg();
    Vst3Plugin *vst3 = vst3_from_ptr(thisInterface, controller);
    Plugin *plugin = vst3->plugin;
    if (id >= Param_Count) {
        err("Invalid param ID\n");
        return Steinberg_kInvalidArgument;
    }
    f32 v = get_parameter_from_normalized(plugin, id, value);
    set_parameter(plugin, id, v);
    return Steinberg_kResultOk;
}

static Steinberg_tresult controller_set_component_handler (void* thisInterface, struct Steinberg_Vst_IComponentHandler* handler) {
    dbg();
    if (handler) {
        Vst3Controller *ctrl = (Vst3Controller*)thisInterface;
        if (ctrl->handler) {
            ctrl->handler->lpVtbl->release(ctrl->handler);
        }
        ctrl->handler = handler;
        return Steinberg_kResultOk;
    }

    return Steinberg_kInvalidArgument;
}

static struct Steinberg_IPlugView* controller_create_view (void* thisInterface, Steinberg_FIDString name) {
    dbg();
    return NULL;
}

static Vst3Plugin *vst3_plugin_create() {
    dbg();
    Vst3Plugin *vst3 = new(Vst3Plugin);
    vst3->processor.vtable = new(Steinberg_Vst_IAudioProcessorVtbl);
    vst3->processor.req = new(Steinberg_Vst_IProcessContextRequirementsVtbl);
    *vst3->processor.vtable = (Steinberg_Vst_IAudioProcessorVtbl){
        .queryInterface = audio_processor_query_interface,
        .addRef = audio_processor_add_ref,
        .release = audio_processor_release,
        .setBusArrangements = audio_processor_set_bus_arrangements,
        .getBusArrangement = audio_processor_get_bus_arrangement,
        .canProcessSampleSize = audio_processor_query_sample_size,
        .getLatencySamples = audio_processor_get_latency_samples,
        .setupProcessing = audio_processor_setup_processing,
        .setProcessing = audio_processor_set_processing,
        .process = audio_processor_process,
        .getTailSamples = audio_processor_get_tail_length,
    };
    *vst3->processor.req = (Steinberg_Vst_IProcessContextRequirementsVtbl){
        .queryInterface = proc_req_query_interface,
        .addRef = proc_req_add_ref,
        .release = proc_req_release,
        .getProcessContextRequirements = proc_req_get_requirements,
    };
    vst3->processor.ref_count = 1;

    vst3->component.vtable = new(Steinberg_Vst_IComponentVtbl);
    *vst3->component.vtable = (Steinberg_Vst_IComponentVtbl){
        .queryInterface = component_query_interface,
        .addRef = component_add_ref,
        .release = component_release,
        .initialize = component_initialize,
        .terminate = component_terminate,
        .getControllerClassId = component_get_controller_id,
        .setIoMode = component_set_io_mode,
        .getBusCount = component_get_bus_count,
        .getBusInfo = component_get_bus_info,
        .getRoutingInfo = component_get_routing_info,
        .activateBus = component_activate_bus,
        .setActive = component_set_active,
        .setState = component_set_state,
        .getState = component_get_state,
    };
    vst3->component.ref_count = 1;

    vst3->controller.vtable = new(Steinberg_Vst_IEditControllerVtbl);
    *vst3->controller.vtable = (Steinberg_Vst_IEditControllerVtbl){
        .queryInterface = controller_query_interface,
        .addRef = controller_add_ref,
        .release = controller_release,
        .initialize = controller_initialize,
        .terminate = controller_terminate,
        .setComponentState = controller_set_component_state,
        .setState = controller_set_state,
        .getState = controller_get_state,
        .getParameterCount = controller_get_parameter_count,
        .getParameterInfo = controller_get_parameter_info,
        .getParamStringByValue = controller_param_string_by_value,
        .getParamValueByString = controller_param_value_by_string,
        .normalizedParamToPlain = controller_normalized_param_to_plain,
        .plainParamToNormalized = controller_plain_param_to_normalized,
        .getParamNormalized = controller_get_param_normalized,
        .setParamNormalized = controller_set_param_normalized,
        .setComponentHandler = controller_set_component_handler,
        .createView = controller_create_view,
    };
    vst3->controller.ref_count = 1;

    vst3->plugin = new(Plugin);

    if (!_plugin_init(vst3->plugin, vst3, NULL))
        return NULL;

    return vst3;
}

// FACTORY

typedef struct {
    Steinberg_IPluginFactory3Vtbl *vtable;
    Steinberg_Vst_IHostApplication *host;
    RefCount ref_count;
} Vst3Factory;

static Steinberg_tresult factory_query_interface (void* thisInterface, const Steinberg_TUID iid, void** obj) {
    if (tuid_match(iid, Steinberg_FUnknown_iid) ||
        tuid_match(iid, Steinberg_IPluginFactory_iid) || tuid_match(iid, Steinberg_IPluginFactory2_iid) ||
        tuid_match(iid, Steinberg_IPluginFactory3_iid)) {
        Vst3Factory *factory = (Vst3Factory*)thisInterface;
        if (obj) {
            dbg("Factory: query OK");
            factory->ref_count++;
            *obj = factory;
            return Steinberg_kResultOk;
        }
    }

    dbg("Factory: unsupported TUID (%s)", iid);
    return Steinberg_kNoInterface;
}

static Steinberg_uint32 factory_add_ref (void* thisInterface) {
    dbg();
    Vst3Factory *factory = (Vst3Factory*)thisInterface;
    int count = ++factory->ref_count;
    dbg("Factory: adding ref (%d)", count);
    return count;
}

static Steinberg_uint32 factory_release (void* thisInterface) {
    dbg();
    Vst3Factory *factory = (Vst3Factory*)thisInterface;
    int count = --factory->ref_count;
    dbg("Factory: releasing ref (%d)", count);
    if (count > 0)
        return count;

    dbg("Factory: all refs released");
    return 0;
}

static Steinberg_tresult factory_get_info (void* thisInterface, struct Steinberg_PFactoryInfo* info) {
    dbg();
    if (info) {
        info->flags = Steinberg_PFactoryInfo_FactoryFlags_kUnicode;
        if (plugin_config.desc.contact)
            memcpy(info->email, plugin_config.desc.contact, string_len(plugin_config.desc.contact));
        if (plugin_config.desc.url)
            memcpy(info->url, plugin_config.desc.url, string_len(plugin_config.desc.url));
        memcpy(info->vendor, plugin_config.desc.company, string_len(plugin_config.desc.company));
        return Steinberg_kResultOk;
    }
    return Steinberg_kInvalidArgument;
}

static Steinberg_int32 factory_count_classes (void* thisInterface) {
    dbg();
    return 1;
}

static Steinberg_tresult factory_get_class_info (void* thisInterface, Steinberg_int32 index,
                                          struct Steinberg_PClassInfo* info) {
    dbg();
    if (info) {
        info->cardinality = Steinberg_PClassInfo_ClassCardinality_kManyInstances;
        memcpy(info->name, plugin_config.desc.name, string_len(plugin_config.desc.name));
        // if (index == 0) {
            memcpy(info->cid, class_tuid, sizeof(Steinberg_TUID));
            memcpy(info->category, audio_class_info_category, sizeof(audio_class_info_category));
        // } else {
        //     memcpy(info->cid, component_tuid, sizeof(Steinberg_TUID));
        //     memcpy(info->category, component_class_info_category, sizeof(component_class_info_category));
        // }
        return Steinberg_kResultOk;
    }
    return Steinberg_kInvalidArgument;
}

static Steinberg_tresult factory_create_instance (void* thisInterface, Steinberg_FIDString cid,
                                           Steinberg_FIDString iid, void** obj) {
    dbg("cid: %s | iid %s\n", cid, iid);
    if (tuid_match(cid, class_tuid) &&
        (tuid_match(iid, Steinberg_FUnknown_iid) ||
        tuid_match(iid, Steinberg_IPluginBase_iid) ||
        tuid_match(iid, Steinberg_Vst_IComponent_iid))) {
        if (obj) {
            dbg("Factory: query Component OK\n");
            Vst3Plugin *plugin = vst3_plugin_create();
            if (!plugin) {
                *obj = NULL;
                return Steinberg_kInternalError;
            }
            *obj = &plugin->component;
            return Steinberg_kResultOk;
        }

        return Steinberg_kInvalidArgument;
    }

    dbg("Factory: no interface for IID: %s\n", iid);
    return Steinberg_kNoInterface;
}

static Steinberg_tresult factory_get_class_info2 (void* thisInterface, Steinberg_int32 index,
                                           struct Steinberg_PClassInfo2* info) {
    dbg();
    if (info) {
        info->cardinality = Steinberg_PClassInfo_ClassCardinality_kManyInstances;
        info->classFlags = Steinberg_PFactoryInfo_FactoryFlags_kUnicode;
        memcpy(info->name, plugin_config.desc.name, string_len(plugin_config.desc.name));
        memcpy(info->vendor, plugin_config.desc.company, string_len(plugin_config.desc.company));
        memcpy(info->version, plugin_config.desc.version, string_len(plugin_config.desc.version));
        if (plugin_config.features & Feature_Effect) {
            const char category[] = "Fx";
            memcpy(info->subCategories, category, sizeof(category));
        } else if ((plugin_config.features & Feature_Instrument) || (plugin_config.features & Feature_Synth)) {
            const char category[] = "Instrument";
            memcpy(info->subCategories, category, sizeof(category));
        }
        memcpy(info->sdkVersion, Steinberg_Vst_SDKVersionString, string_len(Steinberg_Vst_SDKVersionString));
        // if (index == 0) {
            memcpy(info->cid, class_tuid, sizeof(Steinberg_TUID));
            memcpy(info->category, audio_class_info_category, sizeof(audio_class_info_category));
        // } else {
        //     memcpy(info->cid, component_tuid, sizeof(Steinberg_TUID));
        //     memcpy(info->category, component_class_info_category, sizeof(component_class_info_category));
        // }
        return Steinberg_kResultOk;
    }
    return Steinberg_kInvalidArgument;
}

static Steinberg_tresult factory_get_class_info_unicode (void* thisInterface, Steinberg_int32 index,
                                                  struct Steinberg_PClassInfoW* info) {
    dbg();
    if (info) {
        info->cardinality = Steinberg_PClassInfo_ClassCardinality_kManyInstances;
        info->classFlags = Steinberg_PFactoryInfo_FactoryFlags_kUnicode;
        String16 name = string16_from_utf8(&global_arena.allocator, plugin_config.desc.name);
        memcpy(info->name, name.data, name.len * sizeof(u16));
        String16 version = string16_from_utf8(&global_arena.allocator, plugin_config.desc.version);
        memcpy(info->version, version.data, version.len * sizeof(u16));
        String16 vendor = string16_from_utf8(&global_arena.allocator, plugin_config.desc.company);
        memcpy(info->vendor, vendor.data, vendor.len * sizeof(u16));

        String16 sdk_version = string16_from_utf8(&global_arena.allocator, Steinberg_Vst_SDKVersionString);
        memcpy(info->sdkVersion, sdk_version.data, sdk_version.len * sizeof(u16));
        // if (index == 0) {
            memcpy(info->cid, class_tuid, sizeof(Steinberg_TUID));
            memcpy(info->category, audio_class_info_category, sizeof(audio_class_info_category));
        // } else {
        //     memcpy(info->cid, component_tuid, sizeof(Steinberg_TUID));
        //     memcpy(info->category, component_class_info_category, sizeof(component_class_info_category));
        // }

        return Steinberg_kResultOk;
    }
    return Steinberg_kInvalidArgument;
}

static Steinberg_tresult factory_set_host_context (void* thisInterface, struct Steinberg_FUnknown* context) {
    dbg();
    Vst3Factory *factory = (Vst3Factory*)thisInterface;
    if (context) {
        if (context->lpVtbl->queryInterface(context, Steinberg_Vst_IHostApplication_iid,
                                            (void*)&factory->host) == Steinberg_kResultOk) {
            dbg("Host Context: query OK\n");
            return Steinberg_kResultOk;
        }

        return Steinberg_kInternalError;
    }

    return Steinberg_kInvalidArgument;
}

void *GetPluginFactory() {
    dbg();
    Vst3Factory *factory = new(Vst3Factory);
    *factory = (Vst3Factory){
        .vtable = new(Steinberg_IPluginFactory3Vtbl)
    };
    *factory->vtable = (Steinberg_IPluginFactory3Vtbl){
        .queryInterface = factory_query_interface,
        .addRef = factory_add_ref,
        .release = factory_release,
        .getFactoryInfo = factory_get_info,
        .countClasses = factory_count_classes,
        .getClassInfo = factory_get_class_info,
        .createInstance = factory_create_instance,
        .getClassInfo2 = factory_get_class_info2,
        .getClassInfoUnicode = factory_get_class_info_unicode,
        .setHostContext = factory_set_host_context,
    };
    factory->ref_count = 1;

    return factory;
}

bool bundleEntry(void *ctx) {
    dbg();
    global_arena = arena_init(4096);
    return true;
}

bool bundleExit(void *ctx) {
    dbg();
    arena_deinit(&global_arena);
    return true;
}

bool ModuleEntry(void *ctx) {
    dbg();
    return true;
}

bool ModuleExit(void *ctx) {
    dbg();
    return true;
}
