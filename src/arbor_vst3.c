#include "vst3/vst3.h"
#include "arbor.h"

static inline bool32 tuid_match(const Steinberg_TUID a, const Steinberg_TUID b) {
    return memcmp(a, b, sizeof(Steinberg_TUID)) == 0;
}

static const Steinberg_TUID class_tuid_base = SMTG_INLINE_UID('C' ^ 'A', 'l' ^ 'F', 'a' ^ 'V', 's' ^ '3');
static const Steinberg_TUID component_tuid_base = SMTG_INLINE_UID('C' ^ 'A', 'o' ^ 'F', 'm' ^ 'V', 'p' ^ '3');
static const Steinberg_TUID controller_tuid = SMTG_INLINE_UID('C' ^ 'A', 't' ^ 'F', 'r' ^ 'V', 'l' ^ '3');

static const Steinberg_TUID vst3_class_id = SMTG_INLINE_UID(class_tuid_base[0] | PLUGIN_ID_HASH, class_tuid_base[1] | PLUGIN_ID_HASH, class_tuid_base[2] | PLUGIN_ID_HASH, class_tuid_base[3] | PLUGIN_ID_HASH);
static const Steinberg_TUID vst3_comp_id = SMTG_INLINE_UID(component_tuid_base[0] | PLUGIN_ID_HASH, component_tuid_base[1] | PLUGIN_ID_HASH, component_tuid_base[2] | PLUGIN_ID_HASH, component_tuid_base[3] | PLUGIN_ID_HASH);

// WTF is this crap?
static const char audio_class_info_category[] = "Audio Module Class";
static const char component_class_info_category[] = "Component Controller Class";

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
    Steinberg_IPlugViewVtbl *vtable;
    RefCount ref_count;
    bool32 active;
} Vst3View;

typedef struct {
    bool32 valid;
    u32 id;
    u32 offset;
    double value;
} ParamChange;

typedef struct {
    Vst3AudioProcessor processor;
    Vst3Component component;
    Vst3Controller controller;
    Vst3View view;

#define PARAM_QUEUE_SIZE 512
    ParamChange param_changes[PARAM_QUEUE_SIZE];
    uint param_change_head;

    Plugin *plugin;
} Vst3Plugin;

#define vst3_from_ptr(ptr, field) (Vst3Plugin*)((char*)(ptr) - offsetof(Vst3Plugin, field))

static int _compare_param_change_offset(const void *a, const void *b) {
    ParamChange *change_a = (ParamChange*)a;
    ParamChange *change_b = (ParamChange*)b;

    return change_a->offset - change_b->offset;
}

static void _sort_param_changes(Vst3Plugin *vst3) {
    qsort(vst3->param_changes, vst3->param_change_head, sizeof(ParamChange), _compare_param_change_offset);
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

    _plugin_prepare(plugin, setup->sampleRate, 1, (u32)setup->maxSamplesPerBlock);
    return Steinberg_kResultOk;
}

static Steinberg_tresult audio_processor_set_processing (void* thisInterface, Steinberg_TBool state) {
    dbg("state: %d", state);
    return Steinberg_kResultOk;
}

static bool32 _buffer_is_valid(struct Steinberg_Vst_AudioBusBuffers *buf) {
    return buf->numChannels > 0 && (buf->Steinberg_Vst_AudioBusBuffers_channelBuffers32 != 0 || buf->Steinberg_Vst_AudioBusBuffers_channelBuffers64 != 0);
}

static Steinberg_tresult audio_processor_process (void* thisInterface, struct Steinberg_Vst_ProcessData* data) {
    Vst3Plugin *vst3 = vst3_from_ptr(thisInterface, processor);
    Plugin *plugin = vst3->plugin;
    u32 num_frames = data->numSamples;
    u32 next_event_frame = num_frames;

    // Sync audio params to any changes in main
    memcpy(plugin->params->audio, plugin->params->main, sizeof(plugin->params->main));

    // Sometimes we get crazy numbers of channels
    if (data->inputs)
        assert(data->inputs->numChannels <= plugin->audio_input_count);
    if (data->outputs)
        assert(data->outputs->numChannels <= plugin->audio_output_count);

    int param_change_count = 0;
    if (data->inputParameterChanges) {
        param_change_count = data->inputParameterChanges->lpVtbl->getParameterCount(data->inputParameterChanges);
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
                    vst3->param_changes[vst3->param_change_head] = (ParamChange){
                        .valid = TRUE,
                        .id = id,
                        .offset = offset,
                        .value = normalized,
                    };
                    vst3->param_change_head++;
                }
            }
        }
    }

    if (param_change_count > 0) {
        _sort_param_changes(vst3);
        if (vst3->param_changes->valid) {
            next_event_frame = vst3->param_changes->offset;
        }
    }

    u32 i = 0;
    u32 event_id = 0;
    while (i < num_frames) {
        while (next_event_frame == i) {
            ParamChange change = vst3->param_changes[event_id];
            assert(change.offset == i);
            _plugin_update_param(plugin, change.id, change.value);
            event_id++;
            if (vst3->param_changes[event_id].valid) {
                next_event_frame = vst3->param_changes[event_id].offset;
            } else {
               next_event_frame = num_frames;
            }
            assert(next_event_frame <= num_frames);
        }

        u32 frames_to_process = next_event_frame - i;

        if (_buffer_is_valid(data->inputs) && _buffer_is_valid(data->outputs)) {
            AudioBuffer32 in_buf = {
                .data = data->inputs->Steinberg_Vst_AudioBusBuffers_channelBuffers32,
                .num_frames = frames_to_process,
                .num_ch = data->inputs->numChannels, // ISSUE sometimes we're getting absurd numbers here like 12??
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

            plugin->user_iface.process_cb(plugin, in_buf, out_buf, plugin->midi);
        }

        _midi_clear(plugin);
        _plugin_reset_param_changes(plugin);
        i += frames_to_process;
    }

    // sync main params from audio params
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
    if (tuid_match(iid, Steinberg_IPlugView_iid)) {
        if (obj) {
            dbg("Component: query View OK");
            vst3->view.ref_count += 1;
            *obj = &vst3->view;
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

    Vst3Plugin *vst3 = vst3_from_ptr(comp, component);
    _plugin_deinit(vst3->plugin);

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
    memcpy(classId, vst3_comp_id, sizeof(Steinberg_TUID));
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
    return Steinberg_kNotImplemented;
}

static Steinberg_tresult controller_set_state (void* thisInterface, struct Steinberg_IBStream* state) {
    dbg();
    return Steinberg_kNotImplemented;
}

static Steinberg_tresult controller_get_state (void* thisInterface, struct Steinberg_IBStream* state) {
    dbg();
    return Steinberg_kNotImplemented;
}

static Steinberg_int32 controller_get_parameter_count (void* thisInterface) {
    return Param_Count;
}

static Steinberg_tresult controller_get_parameter_info (void* thisInterface, Steinberg_int32 paramIndex,
                                                 struct Steinberg_Vst_ParameterInfo* info) {
    dbg();

    Vst3Plugin *vst3 = vst3_from_ptr(thisInterface, controller);
    Plugin *plugin = vst3->plugin;
    const ParameterInfo *param = get_parameter_info(plugin, paramIndex);
    if (!param) {
        return Steinberg_kInvalidArgument;
    }
    *info = (struct Steinberg_Vst_ParameterInfo){
        .id = paramIndex,
        .defaultNormalizedValue = get_parameter_normalized(plugin, paramIndex, param->default_value),
    };
    info->flags = Steinberg_Vst_ParameterInfo_ParameterFlags_kCanAutomate;
    switch (param->type) {
    case ParameterType_Float: break;
    case ParameterType_Bool:
        info->stepCount = 1;
        break;
    case ParameterType_Choice:
        info->flags |= Steinberg_Vst_ParameterInfo_ParameterFlags_kIsList;
    case ParameterType_Int:
        info->stepCount = (int)param->max_value - (int)param->min_value;
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
    const ParameterInfo *param = get_parameter_info(plugin, id);
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

    f32 value = get_parameter(plugin, id);
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

    Vst3Plugin *vst3 = vst3_from_ptr(thisInterface, controller);
    if (!_visual_init(vst3->plugin))
        return NULL;
    return (Steinberg_IPlugView*)&vst3->view;
}

// VIEW:
// Interface which manages UI functionality

#if __APPLE__
#define VST3_GUI_PLATFORM "NSView"
#endif

static Steinberg_tresult view_query_interface (void* thisInterface, const Steinberg_TUID iid, void** obj) {
    Vst3View *view = (Vst3View*)thisInterface;
    if (tuid_match(iid, Steinberg_IPlugView_iid) || tuid_match(iid, Steinberg_FUnknown_iid)) {
        if (obj) {
            dbg("Query OK: View");
            view->ref_count += 1;
            *obj = view;
            return Steinberg_kResultOk;
        } else {
            return Steinberg_kInvalidArgument;
        }
    }

    dbg("View: unsupported TUID (%s)", iid);
    *obj = NULL;
    return Steinberg_kNoInterface;
}

static Steinberg_uint32 view_add_ref (void* thisInterface) {
    Vst3View *view = (Vst3View*)thisInterface;
    int count = ++view->ref_count;
    dbg("View: adding ref (%d)", count);
    return count;
}

static Steinberg_uint32 view_release (void* thisInterface) {
    Vst3View *view = (Vst3View*)thisInterface;
    Vst3Plugin *vst3 = vst3_from_ptr(view, view);
    int count = --view->ref_count;
    dbg("View: releasing ref (%d)", count);
    if (count > 0)
        return count;

    dbg("View: all refs released");
    Plugin *plugin = vst3->plugin;
    if (plugin->gui.active) {
        dbg("view_removed wasn't called");
        _visual_close(plugin);
    }

    _visual_deinit(plugin);

    return 0;
}

static Steinberg_tresult view_is_platform_type_supported (void* thisInterface, Steinberg_FIDString type) {
    dbg("Type: %s", type);
    if (string_match(STR_LIT(VST3_GUI_PLATFORM), string(type))) {
        return Steinberg_kResultTrue;
    }

    return Steinberg_kResultFalse;
}

static Steinberg_tresult view_attached (void* thisInterface, void* parent, Steinberg_FIDString type) {
    dbg("Type: %s", type);

    Vst3Plugin *vst3 = vst3_from_ptr(thisInterface, view);
    // Set GUI parent
    _visual_set_parent(vst3->plugin, parent);
    _visual_open(vst3->plugin);

    return Steinberg_kResultOk;
}

static Steinberg_tresult view_removed (void* thisInterface) {
    dbg();
    Vst3Plugin *vst3 = vst3_from_ptr(thisInterface, view);
    _visual_close(vst3->plugin);
    return Steinberg_kResultOk;
}

static Steinberg_tresult view_on_wheel (void* thisInterface, float distance) {
    return Steinberg_kNotImplemented;
}

static Steinberg_tresult view_on_key_down (void* thisInterface, Steinberg_char16 key,
    Steinberg_int16 keyCode, Steinberg_int16 modifiers) {
    return Steinberg_kNotImplemented;
}

static Steinberg_tresult view_on_key_up (void* thisInterface, Steinberg_char16 key,
    Steinberg_int16 keyCode, Steinberg_int16 modifiers) {
    return Steinberg_kNotImplemented;
}

// Size of platform view
static Steinberg_tresult view_get_size (void* thisInterface, struct Steinberg_ViewRect* size) {
    dbg();
    return Steinberg_kResultOk;
}

// Resize the platform view
static Steinberg_tresult view_on_size (void* thisInterface, struct Steinberg_ViewRect* newSize) {
    dbg();
    return Steinberg_kResultOk;
}

static Steinberg_tresult view_on_focus (void* thisInterface, Steinberg_TBool state) {
    dbg("State: %d", state);
    return Steinberg_kResultOk;
}

// Attach a Frame interface to notify host about resizing
static Steinberg_tresult view_set_frame (void* thisInterface, struct Steinberg_IPlugFrame* frame) {
    dbg();
    return Steinberg_kResultOk;
}

static Steinberg_tresult view_can_resize (void* thisInterface) {
    return Steinberg_kResultFalse;
}

static Steinberg_tresult view_check_size_constraint (void* thisInterface, struct Steinberg_ViewRect* rect) {
    dbg();
    return Steinberg_kResultOk;
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

    vst3->view.vtable = new(Steinberg_IPlugViewVtbl);
    *vst3->view.vtable = (Steinberg_IPlugViewVtbl){
        .queryInterface = view_query_interface,
        .addRef = view_add_ref,
        .release = view_release,
        .isPlatformTypeSupported = view_is_platform_type_supported,
        .attached = view_attached,
        .removed = view_removed,
        .onWheel = view_on_wheel,
        .onKeyDown = view_on_key_down,
        .onKeyUp = view_on_key_up,
        .getSize = view_get_size,
        .onSize = view_on_size,
        .onFocus = view_on_focus,
        .setFrame = view_set_frame,
        .canResize = view_can_resize,
        .checkSizeConstraint = view_check_size_constraint,
    };
    vst3->view.ref_count = 1;
    vst3->view.active = FALSE;

    vst3->plugin = new(Plugin);

    if (!_plugin_init(vst3->plugin, vst3, NULL))
        return NULL;

    vst3->plugin->user_iface.init_cb(vst3->plugin);

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
        memset(info, 0, sizeof(*info));
        info->cardinality = Steinberg_PClassInfo_ClassCardinality_kManyInstances;
        memcpy(info->name, plugin_config.desc.name, string_len(plugin_config.desc.name));
        if (index == 0) {
            memcpy(info->cid, vst3_class_id, sizeof(Steinberg_TUID));
        } else {
            memcpy(info->cid, vst3_comp_id, sizeof(Steinberg_TUID));
        }
        memcpy(info->category, audio_class_info_category, sizeof(audio_class_info_category));
        return Steinberg_kResultOk;
    }
    return Steinberg_kInvalidArgument;
}

static Steinberg_tresult factory_create_instance (void* thisInterface, Steinberg_FIDString cid,
                                           Steinberg_FIDString iid, void** obj) {
    dbg("cid: %s | iid %s\n", cid, iid);
    if (tuid_match(cid, vst3_class_id) &&
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
        memset(info, 0, sizeof(*info));
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
        if (index == 0) {
            memcpy(info->cid, vst3_class_id, sizeof(Steinberg_TUID));
        } else {
            memcpy(info->cid, vst3_comp_id, sizeof(Steinberg_TUID));
        }
        memcpy(info->category, audio_class_info_category, sizeof(audio_class_info_category));
        return Steinberg_kResultOk;
    }
    return Steinberg_kInvalidArgument;
}

static Steinberg_tresult factory_get_class_info_unicode (void* thisInterface, Steinberg_int32 index,
                                                  struct Steinberg_PClassInfoW* info) {
    dbg();
    if (info) {
        memset(info, 0, sizeof(*info));
        info->cardinality = Steinberg_PClassInfo_ClassCardinality_kManyInstances;
        info->classFlags = Steinberg_PFactoryInfo_FactoryFlags_kUnicode;
        String16 name = string16_from_utf8(&global_arena->allocator, plugin_config.desc.name);
        memcpy(info->name, name.data, name.len * sizeof(u16));
        String16 version = string16_from_utf8(&global_arena->allocator, plugin_config.desc.version);
        memcpy(info->version, version.data, version.len * sizeof(u16));
        String16 vendor = string16_from_utf8(&global_arena->allocator, plugin_config.desc.company);
        memcpy(info->vendor, vendor.data, vendor.len * sizeof(u16));

        if (plugin_config.features & Feature_Effect) {
            const char category[] = "Fx";
            memcpy(info->subCategories, category, sizeof(category));
        } else if ((plugin_config.features & Feature_Instrument) || (plugin_config.features & Feature_Synth)) {
            const char category[] = "Instrument";
            memcpy(info->subCategories, category, sizeof(category));
        }

        String16 sdk_version = string16_from_utf8(&global_arena->allocator, Steinberg_Vst_SDKVersionString);
        memcpy(info->sdkVersion, sdk_version.data, sdk_version.len * sizeof(u16));
        if (index == 0) {
            memcpy(info->cid, vst3_class_id, sizeof(Steinberg_TUID));
        } else {
            memcpy(info->cid, vst3_comp_id, sizeof(Steinberg_TUID));
        }
        memcpy(info->category, audio_class_info_category, sizeof(audio_class_info_category));

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

bool32 bundleEntry(void *ctx) {
    dbg();
    global_arena = arena_init();
    return TRUE;
}

bool32 bundleExit(void *ctx) {
    dbg();
    arena_deinit(global_arena);
    return TRUE;
}

bool32 ModuleEntry(void *ctx) {
    dbg();
    return TRUE;
}

bool32 ModuleExit(void *ctx) {
    dbg();
    return TRUE;
}
