pub const __builtin_bswap16 = @import("std").zig.c_builtins.__builtin_bswap16;
pub const __builtin_bswap32 = @import("std").zig.c_builtins.__builtin_bswap32;
pub const __builtin_bswap64 = @import("std").zig.c_builtins.__builtin_bswap64;
pub const __builtin_signbit = @import("std").zig.c_builtins.__builtin_signbit;
pub const __builtin_signbitf = @import("std").zig.c_builtins.__builtin_signbitf;
pub const __builtin_popcount = @import("std").zig.c_builtins.__builtin_popcount;
pub const __builtin_ctz = @import("std").zig.c_builtins.__builtin_ctz;
pub const __builtin_clz = @import("std").zig.c_builtins.__builtin_clz;
pub const __builtin_sqrt = @import("std").zig.c_builtins.__builtin_sqrt;
pub const __builtin_sqrtf = @import("std").zig.c_builtins.__builtin_sqrtf;
pub const __builtin_sin = @import("std").zig.c_builtins.__builtin_sin;
pub const __builtin_sinf = @import("std").zig.c_builtins.__builtin_sinf;
pub const __builtin_cos = @import("std").zig.c_builtins.__builtin_cos;
pub const __builtin_cosf = @import("std").zig.c_builtins.__builtin_cosf;
pub const __builtin_exp = @import("std").zig.c_builtins.__builtin_exp;
pub const __builtin_expf = @import("std").zig.c_builtins.__builtin_expf;
pub const __builtin_exp2 = @import("std").zig.c_builtins.__builtin_exp2;
pub const __builtin_exp2f = @import("std").zig.c_builtins.__builtin_exp2f;
pub const __builtin_log = @import("std").zig.c_builtins.__builtin_log;
pub const __builtin_logf = @import("std").zig.c_builtins.__builtin_logf;
pub const __builtin_log2 = @import("std").zig.c_builtins.__builtin_log2;
pub const __builtin_log2f = @import("std").zig.c_builtins.__builtin_log2f;
pub const __builtin_log10 = @import("std").zig.c_builtins.__builtin_log10;
pub const __builtin_log10f = @import("std").zig.c_builtins.__builtin_log10f;
pub const __builtin_abs = @import("std").zig.c_builtins.__builtin_abs;
pub const __builtin_fabs = @import("std").zig.c_builtins.__builtin_fabs;
pub const __builtin_fabsf = @import("std").zig.c_builtins.__builtin_fabsf;
pub const __builtin_floor = @import("std").zig.c_builtins.__builtin_floor;
pub const __builtin_floorf = @import("std").zig.c_builtins.__builtin_floorf;
pub const __builtin_ceil = @import("std").zig.c_builtins.__builtin_ceil;
pub const __builtin_ceilf = @import("std").zig.c_builtins.__builtin_ceilf;
pub const __builtin_trunc = @import("std").zig.c_builtins.__builtin_trunc;
pub const __builtin_truncf = @import("std").zig.c_builtins.__builtin_truncf;
pub const __builtin_round = @import("std").zig.c_builtins.__builtin_round;
pub const __builtin_roundf = @import("std").zig.c_builtins.__builtin_roundf;
pub const __builtin_strlen = @import("std").zig.c_builtins.__builtin_strlen;
pub const __builtin_strcmp = @import("std").zig.c_builtins.__builtin_strcmp;
pub const __builtin_object_size = @import("std").zig.c_builtins.__builtin_object_size;
pub const __builtin___memset_chk = @import("std").zig.c_builtins.__builtin___memset_chk;
pub const __builtin_memset = @import("std").zig.c_builtins.__builtin_memset;
pub const __builtin___memcpy_chk = @import("std").zig.c_builtins.__builtin___memcpy_chk;
pub const __builtin_memcpy = @import("std").zig.c_builtins.__builtin_memcpy;
pub const __builtin_expect = @import("std").zig.c_builtins.__builtin_expect;
pub const __builtin_nanf = @import("std").zig.c_builtins.__builtin_nanf;
pub const __builtin_huge_valf = @import("std").zig.c_builtins.__builtin_huge_valf;
pub const __builtin_inff = @import("std").zig.c_builtins.__builtin_inff;
pub const __builtin_isnan = @import("std").zig.c_builtins.__builtin_isnan;
pub const __builtin_isinf = @import("std").zig.c_builtins.__builtin_isinf;
pub const __builtin_isinf_sign = @import("std").zig.c_builtins.__builtin_isinf_sign;
pub const __has_builtin = @import("std").zig.c_builtins.__has_builtin;
pub const __builtin_assume = @import("std").zig.c_builtins.__builtin_assume;
pub const __builtin_unreachable = @import("std").zig.c_builtins.__builtin_unreachable;
pub const __builtin_constant_p = @import("std").zig.c_builtins.__builtin_constant_p;
pub const __builtin_mul_overflow = @import("std").zig.c_builtins.__builtin_mul_overflow;
pub const int_least64_t = i64;
pub const uint_least64_t = u64;
pub const int_fast64_t = i64;
pub const uint_fast64_t = u64;
pub const int_least32_t = i32;
pub const uint_least32_t = u32;
pub const int_fast32_t = i32;
pub const uint_fast32_t = u32;
pub const int_least16_t = i16;
pub const uint_least16_t = u16;
pub const int_fast16_t = i16;
pub const uint_fast16_t = u16;
pub const int_least8_t = i8;
pub const uint_least8_t = u8;
pub const int_fast8_t = i8;
pub const uint_fast8_t = u8;
pub const intmax_t = c_longlong;
pub const uintmax_t = c_ulonglong;
pub const char16_t = i16;
pub const Steinberg_int8 = u8;
pub const Steinberg_uint8 = u8;
pub const Steinberg_uchar = u8;
pub const Steinberg_int16 = i16;
pub const Steinberg_uint16 = u16;
pub const Steinberg_int32 = i32;
pub const Steinberg_uint32 = u32;
pub const Steinberg_int64 = i64;
pub const Steinberg_uint64 = u64;
pub const Steinberg_TSize = Steinberg_int64;
pub const Steinberg_tresult = Steinberg_int32;
pub const Steinberg_TPtrInt = Steinberg_uint64;
pub const Steinberg_TBool = Steinberg_uint8;
pub const Steinberg_char8 = u8;
pub const Steinberg_char16 = char16_t;
pub const Steinberg_tchar = Steinberg_char16;
pub const Steinberg_CStringA = [*c]const Steinberg_char8;
pub const Steinberg_CStringW = [*c]const Steinberg_char16;
pub const Steinberg_CString = [*c]const Steinberg_tchar;
pub const Steinberg_FIDString = [*c]const Steinberg_char8;
pub const Steinberg_UCoord = Steinberg_int32;
pub const Steinberg_LARGE_INT = Steinberg_int64;
pub const Steinberg_TUID = [16]u8;
pub const Steinberg_Vst_TChar = Steinberg_char16;
pub const Steinberg_Vst_String128 = [128]Steinberg_Vst_TChar;
pub const Steinberg_Vst_CString = [*c]const Steinberg_char8;
pub const Steinberg_Vst_MediaType = Steinberg_int32;
pub const Steinberg_Vst_BusDirection = Steinberg_int32;
pub const Steinberg_Vst_BusType = Steinberg_int32;
pub const Steinberg_Vst_IoMode = Steinberg_int32;
pub const Steinberg_Vst_UnitID = Steinberg_int32;
pub const Steinberg_Vst_ParamValue = f64;
pub const Steinberg_Vst_ParamID = Steinberg_uint32;
pub const Steinberg_Vst_ProgramListID = Steinberg_int32;
pub const Steinberg_Vst_CtrlNumber = Steinberg_int16;
pub const Steinberg_Vst_TQuarterNotes = f64;
pub const Steinberg_Vst_TSamples = Steinberg_int64;
pub const Steinberg_Vst_ColorSpec = Steinberg_uint32;
pub const Steinberg_Vst_Sample32 = f32;
pub const Steinberg_Vst_Sample64 = f64;
pub const Steinberg_Vst_SampleRate = f64;
pub const Steinberg_Vst_SpeakerArrangement = Steinberg_uint64;
pub const Steinberg_Vst_Speaker = Steinberg_uint64;
pub const Steinberg_Vst_NoteExpressionTypeID = Steinberg_uint32;
pub const Steinberg_Vst_NoteExpressionValue = f64;
pub const Steinberg_Vst_KeyswitchTypeID = Steinberg_uint32;
pub const Steinberg_Vst_PhysicalUITypeID = Steinberg_uint32;
pub const Steinberg_Vst_KnobMode = Steinberg_int32;
pub const Steinberg_Vst_ChannelContext_ColorSpec = Steinberg_uint32;
pub const Steinberg_Vst_ChannelContext_ColorComponent = Steinberg_uint8;
pub const Steinberg_Vst_PrefetchableSupport = Steinberg_uint32;
pub const struct_Steinberg_FUnknownVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
};
pub const struct_Steinberg_FUnknown = extern struct {
    lpVtbl: [*c]struct_Steinberg_FUnknownVtbl,
};
pub const Steinberg_IPlugViewContentScaleSupport_ScaleFactor = f32;
pub const struct_Steinberg_IPlugViewContentScaleSupportVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    setContentScaleFactor: ?*const fn (?*anyopaque, Steinberg_IPlugViewContentScaleSupport_ScaleFactor) callconv(.C) Steinberg_tresult,
};
pub const struct_Steinberg_IPlugViewContentScaleSupport = extern struct {
    lpVtbl: [*c]struct_Steinberg_IPlugViewContentScaleSupportVtbl,
};
pub const struct_Steinberg_ViewRect = extern struct {
    left: Steinberg_int32,
    top: Steinberg_int32,
    right: Steinberg_int32,
    bottom: Steinberg_int32,
};
pub const struct_Steinberg_IPlugFrameVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    resizeView: ?*const fn (?*anyopaque, [*c]struct_Steinberg_IPlugView, [*c]struct_Steinberg_ViewRect) callconv(.C) Steinberg_tresult,
};
pub const struct_Steinberg_IPlugFrame = extern struct {
    lpVtbl: [*c]struct_Steinberg_IPlugFrameVtbl,
};
pub const struct_Steinberg_IPlugViewVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    isPlatformTypeSupported: ?*const fn (?*anyopaque, Steinberg_FIDString) callconv(.C) Steinberg_tresult,
    attached: ?*const fn (?*anyopaque, ?*anyopaque, Steinberg_FIDString) callconv(.C) Steinberg_tresult,
    removed: ?*const fn (?*anyopaque) callconv(.C) Steinberg_tresult,
    onWheel: ?*const fn (?*anyopaque, f32) callconv(.C) Steinberg_tresult,
    onKeyDown: ?*const fn (?*anyopaque, Steinberg_char16, Steinberg_int16, Steinberg_int16) callconv(.C) Steinberg_tresult,
    onKeyUp: ?*const fn (?*anyopaque, Steinberg_char16, Steinberg_int16, Steinberg_int16) callconv(.C) Steinberg_tresult,
    getSize: ?*const fn (?*anyopaque, [*c]struct_Steinberg_ViewRect) callconv(.C) Steinberg_tresult,
    onSize: ?*const fn (?*anyopaque, [*c]struct_Steinberg_ViewRect) callconv(.C) Steinberg_tresult,
    onFocus: ?*const fn (?*anyopaque, Steinberg_TBool) callconv(.C) Steinberg_tresult,
    setFrame: ?*const fn (?*anyopaque, [*c]struct_Steinberg_IPlugFrame) callconv(.C) Steinberg_tresult,
    canResize: ?*const fn (?*anyopaque) callconv(.C) Steinberg_tresult,
    checkSizeConstraint: ?*const fn (?*anyopaque, [*c]struct_Steinberg_ViewRect) callconv(.C) Steinberg_tresult,
};
pub const struct_Steinberg_IPlugView = extern struct {
    lpVtbl: [*c]struct_Steinberg_IPlugViewVtbl,
};
pub const struct_Steinberg_IBStreamVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    read: ?*const fn (?*anyopaque, ?*anyopaque, Steinberg_int32, [*c]Steinberg_int32) callconv(.C) Steinberg_tresult,
    write: ?*const fn (?*anyopaque, ?*anyopaque, Steinberg_int32, [*c]Steinberg_int32) callconv(.C) Steinberg_tresult,
    seek: ?*const fn (?*anyopaque, Steinberg_int64, Steinberg_int32, [*c]Steinberg_int64) callconv(.C) Steinberg_tresult,
    tell: ?*const fn (?*anyopaque, [*c]Steinberg_int64) callconv(.C) Steinberg_tresult,
};
pub const struct_Steinberg_IBStream = extern struct {
    lpVtbl: [*c]struct_Steinberg_IBStreamVtbl,
};
pub const struct_Steinberg_ISizeableStreamVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    getStreamSize: ?*const fn (?*anyopaque, [*c]Steinberg_int64) callconv(.C) Steinberg_tresult,
    setStreamSize: ?*const fn (?*anyopaque, Steinberg_int64) callconv(.C) Steinberg_tresult,
};
pub const struct_Steinberg_ISizeableStream = extern struct {
    lpVtbl: [*c]struct_Steinberg_ISizeableStreamVtbl,
};
pub const struct_Steinberg_Vst_NoteExpressionValueDescription = extern struct {
    defaultValue: Steinberg_Vst_NoteExpressionValue,
    minimum: Steinberg_Vst_NoteExpressionValue,
    maximum: Steinberg_Vst_NoteExpressionValue,
    stepCount: Steinberg_int32,
};
pub const struct_Steinberg_Vst_NoteExpressionTypeInfo = extern struct {
    typeId: Steinberg_Vst_NoteExpressionTypeID,
    title: Steinberg_Vst_String128,
    shortTitle: Steinberg_Vst_String128,
    units: Steinberg_Vst_String128,
    unitId: Steinberg_int32,
    valueDesc: struct_Steinberg_Vst_NoteExpressionValueDescription,
    associatedParameterId: Steinberg_Vst_ParamID,
    flags: Steinberg_int32,
};
pub const struct_Steinberg_Vst_INoteExpressionControllerVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    getNoteExpressionCount: ?*const fn (?*anyopaque, Steinberg_int32, Steinberg_int16) callconv(.C) Steinberg_int32,
    getNoteExpressionInfo: ?*const fn (?*anyopaque, Steinberg_int32, Steinberg_int16, Steinberg_int32, [*c]struct_Steinberg_Vst_NoteExpressionTypeInfo) callconv(.C) Steinberg_tresult,
    getNoteExpressionStringByValue: ?*const fn (?*anyopaque, Steinberg_int32, Steinberg_int16, Steinberg_Vst_NoteExpressionTypeID, Steinberg_Vst_NoteExpressionValue, [*c]Steinberg_Vst_TChar) callconv(.C) Steinberg_tresult,
    getNoteExpressionValueByString: ?*const fn (?*anyopaque, Steinberg_int32, Steinberg_int16, Steinberg_Vst_NoteExpressionTypeID, [*c]const Steinberg_Vst_TChar, [*c]Steinberg_Vst_NoteExpressionValue) callconv(.C) Steinberg_tresult,
};
pub const struct_Steinberg_Vst_INoteExpressionController = extern struct {
    lpVtbl: [*c]struct_Steinberg_Vst_INoteExpressionControllerVtbl,
};
pub const struct_Steinberg_Vst_KeyswitchInfo = extern struct {
    typeId: Steinberg_Vst_KeyswitchTypeID,
    title: Steinberg_Vst_String128,
    shortTitle: Steinberg_Vst_String128,
    keyswitchMin: Steinberg_int32,
    keyswitchMax: Steinberg_int32,
    keyRemapped: Steinberg_int32,
    unitId: Steinberg_int32,
    flags: Steinberg_int32,
};
pub const struct_Steinberg_Vst_IKeyswitchControllerVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    getKeyswitchCount: ?*const fn (?*anyopaque, Steinberg_int32, Steinberg_int16) callconv(.C) Steinberg_int32,
    getKeyswitchInfo: ?*const fn (?*anyopaque, Steinberg_int32, Steinberg_int16, Steinberg_int32, [*c]struct_Steinberg_Vst_KeyswitchInfo) callconv(.C) Steinberg_tresult,
};
pub const struct_Steinberg_Vst_IKeyswitchController = extern struct {
    lpVtbl: [*c]struct_Steinberg_Vst_IKeyswitchControllerVtbl,
};
pub const struct_Steinberg_Vst_PhysicalUIMap = extern struct {
    physicalUITypeID: Steinberg_Vst_PhysicalUITypeID,
    noteExpressionTypeID: Steinberg_Vst_NoteExpressionTypeID,
};
pub const struct_Steinberg_Vst_PhysicalUIMapList = extern struct {
    count: Steinberg_uint32,
    map: [*c]struct_Steinberg_Vst_PhysicalUIMap,
};
pub const struct_Steinberg_Vst_INoteExpressionPhysicalUIMappingVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    getPhysicalUIMapping: ?*const fn (?*anyopaque, Steinberg_int32, Steinberg_int16, [*c]struct_Steinberg_Vst_PhysicalUIMapList) callconv(.C) Steinberg_tresult,
};
pub const struct_Steinberg_Vst_INoteExpressionPhysicalUIMapping = extern struct {
    lpVtbl: [*c]struct_Steinberg_Vst_INoteExpressionPhysicalUIMappingVtbl,
};
pub const struct_Steinberg_IPluginBaseVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    initialize: ?*const fn (?*anyopaque, [*c]struct_Steinberg_FUnknown) callconv(.C) Steinberg_tresult,
    terminate: ?*const fn (?*anyopaque) callconv(.C) Steinberg_tresult,
};
pub const struct_Steinberg_IPluginBase = extern struct {
    lpVtbl: [*c]struct_Steinberg_IPluginBaseVtbl,
};
pub const struct_Steinberg_PFactoryInfo = extern struct {
    vendor: [64]Steinberg_char8,
    url: [256]Steinberg_char8,
    email: [128]Steinberg_char8,
    flags: Steinberg_int32,
};
pub const struct_Steinberg_PClassInfo = extern struct {
    cid: Steinberg_TUID,
    cardinality: Steinberg_int32,
    category: [32]Steinberg_char8,
    name: [64]Steinberg_char8,
};
pub const struct_Steinberg_IPluginFactoryVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    getFactoryInfo: ?*const fn (?*anyopaque, [*c]struct_Steinberg_PFactoryInfo) callconv(.C) Steinberg_tresult,
    countClasses: ?*const fn (?*anyopaque) callconv(.C) Steinberg_int32,
    getClassInfo: ?*const fn (?*anyopaque, Steinberg_int32, [*c]struct_Steinberg_PClassInfo) callconv(.C) Steinberg_tresult,
    createInstance: ?*const fn (?*anyopaque, Steinberg_FIDString, Steinberg_FIDString, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
};
pub const struct_Steinberg_IPluginFactory = extern struct {
    lpVtbl: [*c]struct_Steinberg_IPluginFactoryVtbl,
};
pub const struct_Steinberg_PClassInfo2 = extern struct {
    cid: Steinberg_TUID,
    cardinality: Steinberg_int32,
    category: [32]Steinberg_char8,
    name: [64]Steinberg_char8,
    classFlags: Steinberg_uint32,
    subCategories: [128]Steinberg_char8,
    vendor: [64]Steinberg_char8,
    version: [64]Steinberg_char8,
    sdkVersion: [64]Steinberg_char8,
};
pub const struct_Steinberg_IPluginFactory2Vtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    getFactoryInfo: ?*const fn (?*anyopaque, [*c]struct_Steinberg_PFactoryInfo) callconv(.C) Steinberg_tresult,
    countClasses: ?*const fn (?*anyopaque) callconv(.C) Steinberg_int32,
    getClassInfo: ?*const fn (?*anyopaque, Steinberg_int32, [*c]struct_Steinberg_PClassInfo) callconv(.C) Steinberg_tresult,
    createInstance: ?*const fn (?*anyopaque, Steinberg_FIDString, Steinberg_FIDString, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    getClassInfo2: ?*const fn (?*anyopaque, Steinberg_int32, [*c]struct_Steinberg_PClassInfo2) callconv(.C) Steinberg_tresult,
};
pub const struct_Steinberg_IPluginFactory2 = extern struct {
    lpVtbl: [*c]struct_Steinberg_IPluginFactory2Vtbl,
};
pub const struct_Steinberg_PClassInfoW = extern struct {
    cid: Steinberg_TUID,
    cardinality: Steinberg_int32,
    category: [32]Steinberg_char8,
    name: [64]Steinberg_char16,
    classFlags: Steinberg_uint32,
    subCategories: [128]Steinberg_char8,
    vendor: [64]Steinberg_char16,
    version: [64]Steinberg_char16,
    sdkVersion: [64]Steinberg_char16,
};
pub const struct_Steinberg_IPluginFactory3Vtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    getFactoryInfo: ?*const fn (?*anyopaque, [*c]struct_Steinberg_PFactoryInfo) callconv(.C) Steinberg_tresult,
    countClasses: ?*const fn (?*anyopaque) callconv(.C) Steinberg_int32,
    getClassInfo: ?*const fn (?*anyopaque, Steinberg_int32, [*c]struct_Steinberg_PClassInfo) callconv(.C) Steinberg_tresult,
    createInstance: ?*const fn (?*anyopaque, Steinberg_FIDString, Steinberg_FIDString, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    getClassInfo2: ?*const fn (?*anyopaque, Steinberg_int32, [*c]struct_Steinberg_PClassInfo2) callconv(.C) Steinberg_tresult,
    getClassInfoUnicode: ?*const fn (?*anyopaque, Steinberg_int32, [*c]struct_Steinberg_PClassInfoW) callconv(.C) Steinberg_tresult,
    setHostContext: ?*const fn (?*anyopaque, [*c]struct_Steinberg_FUnknown) callconv(.C) Steinberg_tresult,
};
pub const struct_Steinberg_IPluginFactory3 = extern struct {
    lpVtbl: [*c]struct_Steinberg_IPluginFactory3Vtbl,
};
pub const struct_Steinberg_Vst_BusInfo = extern struct {
    mediaType: Steinberg_Vst_MediaType,
    direction: Steinberg_Vst_BusDirection,
    channelCount: Steinberg_int32,
    name: Steinberg_Vst_String128,
    busType: Steinberg_Vst_BusType,
    flags: Steinberg_uint32,
};
pub const struct_Steinberg_Vst_RoutingInfo = extern struct {
    mediaType: Steinberg_Vst_MediaType,
    busIndex: Steinberg_int32,
    channel: Steinberg_int32,
};
pub const struct_Steinberg_Vst_IComponentVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    initialize: ?*const fn (?*anyopaque, [*c]struct_Steinberg_FUnknown) callconv(.C) Steinberg_tresult,
    terminate: ?*const fn (?*anyopaque) callconv(.C) Steinberg_tresult,
    getControllerClassId: ?*const fn (?*anyopaque, [*c]u8) callconv(.C) Steinberg_tresult,
    setIoMode: ?*const fn (?*anyopaque, Steinberg_Vst_IoMode) callconv(.C) Steinberg_tresult,
    getBusCount: ?*const fn (?*anyopaque, Steinberg_Vst_MediaType, Steinberg_Vst_BusDirection) callconv(.C) Steinberg_int32,
    getBusInfo: ?*const fn (?*anyopaque, Steinberg_Vst_MediaType, Steinberg_Vst_BusDirection, Steinberg_int32, [*c]struct_Steinberg_Vst_BusInfo) callconv(.C) Steinberg_tresult,
    getRoutingInfo: ?*const fn (?*anyopaque, [*c]struct_Steinberg_Vst_RoutingInfo, [*c]struct_Steinberg_Vst_RoutingInfo) callconv(.C) Steinberg_tresult,
    activateBus: ?*const fn (?*anyopaque, Steinberg_Vst_MediaType, Steinberg_Vst_BusDirection, Steinberg_int32, Steinberg_TBool) callconv(.C) Steinberg_tresult,
    setActive: ?*const fn (?*anyopaque, Steinberg_TBool) callconv(.C) Steinberg_tresult,
    setState: ?*const fn (?*anyopaque, [*c]struct_Steinberg_IBStream) callconv(.C) Steinberg_tresult,
    getState: ?*const fn (?*anyopaque, [*c]struct_Steinberg_IBStream) callconv(.C) Steinberg_tresult,
};
pub const struct_Steinberg_Vst_IComponent = extern struct {
    lpVtbl: [*c]struct_Steinberg_Vst_IComponentVtbl,
};
pub const Steinberg_Vst_IAttributeList_AttrID = [*c]const u8;
pub const struct_Steinberg_Vst_IAttributeListVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    setInt: ?*const fn (?*anyopaque, Steinberg_Vst_IAttributeList_AttrID, Steinberg_int64) callconv(.C) Steinberg_tresult,
    getInt: ?*const fn (?*anyopaque, Steinberg_Vst_IAttributeList_AttrID, [*c]Steinberg_int64) callconv(.C) Steinberg_tresult,
    setFloat: ?*const fn (?*anyopaque, Steinberg_Vst_IAttributeList_AttrID, f64) callconv(.C) Steinberg_tresult,
    getFloat: ?*const fn (?*anyopaque, Steinberg_Vst_IAttributeList_AttrID, [*c]f64) callconv(.C) Steinberg_tresult,
    setString: ?*const fn (?*anyopaque, Steinberg_Vst_IAttributeList_AttrID, [*c]const Steinberg_Vst_TChar) callconv(.C) Steinberg_tresult,
    getString: ?*const fn (?*anyopaque, Steinberg_Vst_IAttributeList_AttrID, [*c]Steinberg_Vst_TChar, Steinberg_uint32) callconv(.C) Steinberg_tresult,
    setBinary: ?*const fn (?*anyopaque, Steinberg_Vst_IAttributeList_AttrID, ?*const anyopaque, Steinberg_uint32) callconv(.C) Steinberg_tresult,
    getBinary: ?*const fn (?*anyopaque, Steinberg_Vst_IAttributeList_AttrID, [*c]?*const anyopaque, [*c]Steinberg_uint32) callconv(.C) Steinberg_tresult,
};
pub const struct_Steinberg_Vst_IAttributeList = extern struct {
    lpVtbl: [*c]struct_Steinberg_Vst_IAttributeListVtbl,
};
pub const struct_Steinberg_Vst_IStreamAttributesVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    getFileName: ?*const fn (?*anyopaque, [*c]Steinberg_Vst_TChar) callconv(.C) Steinberg_tresult,
    getAttributes: ?*const fn (?*anyopaque) callconv(.C) [*c]struct_Steinberg_Vst_IAttributeList,
};
pub const struct_Steinberg_Vst_IStreamAttributes = extern struct {
    lpVtbl: [*c]struct_Steinberg_Vst_IStreamAttributesVtbl,
};
pub const struct_Steinberg_Vst_IComponentHandlerVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    beginEdit: ?*const fn (?*anyopaque, Steinberg_Vst_ParamID) callconv(.C) Steinberg_tresult,
    performEdit: ?*const fn (?*anyopaque, Steinberg_Vst_ParamID, Steinberg_Vst_ParamValue) callconv(.C) Steinberg_tresult,
    endEdit: ?*const fn (?*anyopaque, Steinberg_Vst_ParamID) callconv(.C) Steinberg_tresult,
    restartComponent: ?*const fn (?*anyopaque, Steinberg_int32) callconv(.C) Steinberg_tresult,
};
pub const struct_Steinberg_Vst_IComponentHandler = extern struct {
    lpVtbl: [*c]struct_Steinberg_Vst_IComponentHandlerVtbl,
};
pub const struct_Steinberg_Vst_IComponentHandler2Vtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    setDirty: ?*const fn (?*anyopaque, Steinberg_TBool) callconv(.C) Steinberg_tresult,
    requestOpenEditor: ?*const fn (?*anyopaque, Steinberg_FIDString) callconv(.C) Steinberg_tresult,
    startGroupEdit: ?*const fn (?*anyopaque) callconv(.C) Steinberg_tresult,
    finishGroupEdit: ?*const fn (?*anyopaque) callconv(.C) Steinberg_tresult,
};
pub const struct_Steinberg_Vst_IComponentHandler2 = extern struct {
    lpVtbl: [*c]struct_Steinberg_Vst_IComponentHandler2Vtbl,
};
pub const struct_Steinberg_Vst_IComponentHandlerBusActivationVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    requestBusActivation: ?*const fn (?*anyopaque, Steinberg_Vst_MediaType, Steinberg_Vst_BusDirection, Steinberg_int32, Steinberg_TBool) callconv(.C) Steinberg_tresult,
};
pub const struct_Steinberg_Vst_IComponentHandlerBusActivation = extern struct {
    lpVtbl: [*c]struct_Steinberg_Vst_IComponentHandlerBusActivationVtbl,
};
pub const Steinberg_Vst_IProgress_ID = Steinberg_uint64;
pub const struct_Steinberg_Vst_IProgressVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    start: ?*const fn (?*anyopaque, Steinberg_Vst_IProgress_ProgressType, [*c]const Steinberg_tchar, [*c]Steinberg_Vst_IProgress_ID) callconv(.C) Steinberg_tresult,
    update: ?*const fn (?*anyopaque, Steinberg_Vst_IProgress_ID, Steinberg_Vst_ParamValue) callconv(.C) Steinberg_tresult,
    finish: ?*const fn (?*anyopaque, Steinberg_Vst_IProgress_ID) callconv(.C) Steinberg_tresult,
};
pub const struct_Steinberg_Vst_IProgress = extern struct {
    lpVtbl: [*c]struct_Steinberg_Vst_IProgressVtbl,
};
pub const struct_Steinberg_Vst_ParameterInfo = extern struct {
    id: Steinberg_Vst_ParamID,
    title: Steinberg_Vst_String128,
    shortTitle: Steinberg_Vst_String128,
    units: Steinberg_Vst_String128,
    stepCount: Steinberg_int32,
    defaultNormalizedValue: Steinberg_Vst_ParamValue,
    unitId: Steinberg_Vst_UnitID,
    flags: Steinberg_int32,
};
pub const struct_Steinberg_Vst_IEditControllerVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    initialize: ?*const fn (?*anyopaque, [*c]struct_Steinberg_FUnknown) callconv(.C) Steinberg_tresult,
    terminate: ?*const fn (?*anyopaque) callconv(.C) Steinberg_tresult,
    setComponentState: ?*const fn (?*anyopaque, [*c]struct_Steinberg_IBStream) callconv(.C) Steinberg_tresult,
    setState: ?*const fn (?*anyopaque, [*c]struct_Steinberg_IBStream) callconv(.C) Steinberg_tresult,
    getState: ?*const fn (?*anyopaque, [*c]struct_Steinberg_IBStream) callconv(.C) Steinberg_tresult,
    getParameterCount: ?*const fn (?*anyopaque) callconv(.C) Steinberg_int32,
    getParameterInfo: ?*const fn (?*anyopaque, Steinberg_int32, [*c]struct_Steinberg_Vst_ParameterInfo) callconv(.C) Steinberg_tresult,
    getParamStringByValue: ?*const fn (?*anyopaque, Steinberg_Vst_ParamID, Steinberg_Vst_ParamValue, [*c]Steinberg_Vst_TChar) callconv(.C) Steinberg_tresult,
    getParamValueByString: ?*const fn (?*anyopaque, Steinberg_Vst_ParamID, [*c]Steinberg_Vst_TChar, [*c]Steinberg_Vst_ParamValue) callconv(.C) Steinberg_tresult,
    normalizedParamToPlain: ?*const fn (?*anyopaque, Steinberg_Vst_ParamID, Steinberg_Vst_ParamValue) callconv(.C) Steinberg_Vst_ParamValue,
    plainParamToNormalized: ?*const fn (?*anyopaque, Steinberg_Vst_ParamID, Steinberg_Vst_ParamValue) callconv(.C) Steinberg_Vst_ParamValue,
    getParamNormalized: ?*const fn (?*anyopaque, Steinberg_Vst_ParamID) callconv(.C) Steinberg_Vst_ParamValue,
    setParamNormalized: ?*const fn (?*anyopaque, Steinberg_Vst_ParamID, Steinberg_Vst_ParamValue) callconv(.C) Steinberg_tresult,
    setComponentHandler: ?*const fn (?*anyopaque, [*c]struct_Steinberg_Vst_IComponentHandler) callconv(.C) Steinberg_tresult,
    createView: ?*const fn (?*anyopaque, Steinberg_FIDString) callconv(.C) [*c]struct_Steinberg_IPlugView,
};
pub const struct_Steinberg_Vst_IEditController = extern struct {
    lpVtbl: [*c]struct_Steinberg_Vst_IEditControllerVtbl,
};
pub const struct_Steinberg_Vst_IEditController2Vtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    setKnobMode: ?*const fn (?*anyopaque, Steinberg_Vst_KnobMode) callconv(.C) Steinberg_tresult,
    openHelp: ?*const fn (?*anyopaque, Steinberg_TBool) callconv(.C) Steinberg_tresult,
    openAboutBox: ?*const fn (?*anyopaque, Steinberg_TBool) callconv(.C) Steinberg_tresult,
};
pub const struct_Steinberg_Vst_IEditController2 = extern struct {
    lpVtbl: [*c]struct_Steinberg_Vst_IEditController2Vtbl,
};
pub const struct_Steinberg_Vst_IMidiMappingVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    getMidiControllerAssignment: ?*const fn (?*anyopaque, Steinberg_int32, Steinberg_int16, Steinberg_Vst_CtrlNumber, [*c]Steinberg_Vst_ParamID) callconv(.C) Steinberg_tresult,
};
pub const struct_Steinberg_Vst_IMidiMapping = extern struct {
    lpVtbl: [*c]struct_Steinberg_Vst_IMidiMappingVtbl,
};
pub const struct_Steinberg_Vst_IEditControllerHostEditingVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    beginEditFromHost: ?*const fn (?*anyopaque, Steinberg_Vst_ParamID) callconv(.C) Steinberg_tresult,
    endEditFromHost: ?*const fn (?*anyopaque, Steinberg_Vst_ParamID) callconv(.C) Steinberg_tresult,
};
pub const struct_Steinberg_Vst_IEditControllerHostEditing = extern struct {
    lpVtbl: [*c]struct_Steinberg_Vst_IEditControllerHostEditingVtbl,
};
pub const struct_Steinberg_Vst_NoteOnEvent = extern struct {
    channel: Steinberg_int16,
    pitch: Steinberg_int16,
    tuning: f32,
    velocity: f32,
    length: Steinberg_int32,
    noteId: Steinberg_int32,
};
pub const struct_Steinberg_Vst_NoteOffEvent = extern struct {
    channel: Steinberg_int16,
    pitch: Steinberg_int16,
    velocity: f32,
    noteId: Steinberg_int32,
    tuning: f32,
};
pub const struct_Steinberg_Vst_DataEvent = extern struct {
    size: Steinberg_uint32,
    type: Steinberg_uint32,
    bytes: [*c]const Steinberg_uint8,
};
pub const struct_Steinberg_Vst_PolyPressureEvent = extern struct {
    channel: Steinberg_int16,
    pitch: Steinberg_int16,
    pressure: f32,
    noteId: Steinberg_int32,
};
pub const struct_Steinberg_Vst_NoteExpressionValueEvent = extern struct {
    typeId: Steinberg_Vst_NoteExpressionTypeID,
    noteId: Steinberg_int32,
    value: Steinberg_Vst_NoteExpressionValue,
};
pub const struct_Steinberg_Vst_NoteExpressionTextEvent = extern struct {
    typeId: Steinberg_Vst_NoteExpressionTypeID,
    noteId: Steinberg_int32,
    textLen: Steinberg_uint32,
    text: [*c]const Steinberg_Vst_TChar,
};
pub const struct_Steinberg_Vst_ChordEvent = extern struct {
    root: Steinberg_int16,
    bassNote: Steinberg_int16,
    mask: Steinberg_int16,
    textLen: Steinberg_uint16,
    text: [*c]const Steinberg_Vst_TChar,
};
pub const struct_Steinberg_Vst_ScaleEvent = extern struct {
    root: Steinberg_int16,
    mask: Steinberg_int16,
    textLen: Steinberg_uint16,
    text: [*c]const Steinberg_Vst_TChar,
};
pub const struct_Steinberg_Vst_LegacyMIDICCOutEvent = extern struct {
    controlNumber: Steinberg_uint8,
    channel: Steinberg_int8,
    value: Steinberg_int8,
    value2: Steinberg_int8,
};
const union_unnamed_1 = extern union {
    Steinberg_Vst_Event_noteOn: struct_Steinberg_Vst_NoteOnEvent,
    Steinberg_Vst_Event_noteOff: struct_Steinberg_Vst_NoteOffEvent,
    Steinberg_Vst_Event_data: struct_Steinberg_Vst_DataEvent,
    Steinberg_Vst_Event_polyPressure: struct_Steinberg_Vst_PolyPressureEvent,
    Steinberg_Vst_Event_noteExpressionValue: struct_Steinberg_Vst_NoteExpressionValueEvent,
    Steinberg_Vst_Event_noteExpressionText: struct_Steinberg_Vst_NoteExpressionTextEvent,
    Steinberg_Vst_Event_chord: struct_Steinberg_Vst_ChordEvent,
    Steinberg_Vst_Event_scale: struct_Steinberg_Vst_ScaleEvent,
    Steinberg_Vst_Event_midiCCOut: struct_Steinberg_Vst_LegacyMIDICCOutEvent,
};
pub const struct_Steinberg_Vst_Event = extern struct {
    busIndex: Steinberg_int32,
    sampleOffset: Steinberg_int32,
    ppqPosition: Steinberg_Vst_TQuarterNotes,
    flags: Steinberg_uint16,
    type: Steinberg_uint16,
    unnamed_0: union_unnamed_1,
};
pub const struct_Steinberg_Vst_IEventListVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    getEventCount: ?*const fn (?*anyopaque) callconv(.C) Steinberg_int32,
    getEvent: ?*const fn (?*anyopaque, Steinberg_int32, [*c]struct_Steinberg_Vst_Event) callconv(.C) Steinberg_tresult,
    addEvent: ?*const fn (?*anyopaque, [*c]struct_Steinberg_Vst_Event) callconv(.C) Steinberg_tresult,
};
pub const struct_Steinberg_Vst_IEventList = extern struct {
    lpVtbl: [*c]struct_Steinberg_Vst_IEventListVtbl,
};
pub const struct_Steinberg_Vst_IMessageVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    getMessageID: ?*const fn (?*anyopaque) callconv(.C) Steinberg_FIDString,
    setMessageID: ?*const fn (?*anyopaque, Steinberg_FIDString) callconv(.C) void,
    getAttributes: ?*const fn (?*anyopaque) callconv(.C) [*c]struct_Steinberg_Vst_IAttributeList,
};
pub const struct_Steinberg_Vst_IMessage = extern struct {
    lpVtbl: [*c]struct_Steinberg_Vst_IMessageVtbl,
};
pub const struct_Steinberg_Vst_IConnectionPointVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    connect: ?*const fn (?*anyopaque, [*c]struct_Steinberg_Vst_IConnectionPoint) callconv(.C) Steinberg_tresult,
    disconnect: ?*const fn (?*anyopaque, [*c]struct_Steinberg_Vst_IConnectionPoint) callconv(.C) Steinberg_tresult,
    notify: ?*const fn (?*anyopaque, [*c]struct_Steinberg_Vst_IMessage) callconv(.C) Steinberg_tresult,
};
pub const struct_Steinberg_Vst_IConnectionPoint = extern struct {
    lpVtbl: [*c]struct_Steinberg_Vst_IConnectionPointVtbl,
};
pub const struct_Steinberg_Vst_RepresentationInfo = extern struct {
    vendor: [64]Steinberg_char8,
    name: [64]Steinberg_char8,
    version: [64]Steinberg_char8,
    host: [64]Steinberg_char8,
};
pub const struct_Steinberg_Vst_IXmlRepresentationControllerVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    getXmlRepresentationStream: ?*const fn (?*anyopaque, [*c]struct_Steinberg_Vst_RepresentationInfo, [*c]struct_Steinberg_IBStream) callconv(.C) Steinberg_tresult,
};
pub const struct_Steinberg_Vst_IXmlRepresentationController = extern struct {
    lpVtbl: [*c]struct_Steinberg_Vst_IXmlRepresentationControllerVtbl,
};
pub const struct_Steinberg_Vst_IContextMenuItem = extern struct {
    name: Steinberg_Vst_String128,
    tag: Steinberg_int32,
    flags: Steinberg_int32,
};
pub const Steinberg_Vst_IContextMenu_Item = struct_Steinberg_Vst_IContextMenuItem;
pub const struct_Steinberg_Vst_IContextMenuTargetVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    executeMenuItem: ?*const fn (?*anyopaque, Steinberg_int32) callconv(.C) Steinberg_tresult,
};
pub const struct_Steinberg_Vst_IContextMenuTarget = extern struct {
    lpVtbl: [*c]struct_Steinberg_Vst_IContextMenuTargetVtbl,
};
pub const struct_Steinberg_Vst_IContextMenuVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    getItemCount: ?*const fn (?*anyopaque) callconv(.C) Steinberg_int32,
    getItem: ?*const fn (?*anyopaque, Steinberg_int32, [*c]Steinberg_Vst_IContextMenu_Item, [*c][*c]struct_Steinberg_Vst_IContextMenuTarget) callconv(.C) Steinberg_tresult,
    addItem: ?*const fn (?*anyopaque, [*c]const Steinberg_Vst_IContextMenu_Item, [*c]struct_Steinberg_Vst_IContextMenuTarget) callconv(.C) Steinberg_tresult,
    removeItem: ?*const fn (?*anyopaque, [*c]const Steinberg_Vst_IContextMenu_Item, [*c]struct_Steinberg_Vst_IContextMenuTarget) callconv(.C) Steinberg_tresult,
    popup: ?*const fn (?*anyopaque, Steinberg_UCoord, Steinberg_UCoord) callconv(.C) Steinberg_tresult,
};
pub const struct_Steinberg_Vst_IContextMenu = extern struct {
    lpVtbl: [*c]struct_Steinberg_Vst_IContextMenuVtbl,
};
pub const struct_Steinberg_Vst_IComponentHandler3Vtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    createContextMenu: ?*const fn (?*anyopaque, [*c]struct_Steinberg_IPlugView, [*c]const Steinberg_Vst_ParamID) callconv(.C) [*c]struct_Steinberg_Vst_IContextMenu,
};
pub const struct_Steinberg_Vst_IComponentHandler3 = extern struct {
    lpVtbl: [*c]struct_Steinberg_Vst_IComponentHandler3Vtbl,
};
pub const struct_Steinberg_Vst_IMidiLearnVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    onLiveMIDIControllerInput: ?*const fn (?*anyopaque, Steinberg_int32, Steinberg_int16, Steinberg_Vst_CtrlNumber) callconv(.C) Steinberg_tresult,
};
pub const struct_Steinberg_Vst_IMidiLearn = extern struct {
    lpVtbl: [*c]struct_Steinberg_Vst_IMidiLearnVtbl,
};
pub const struct_Steinberg_Vst_ChannelContext_IInfoListenerVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    setChannelContextInfos: ?*const fn (?*anyopaque, [*c]struct_Steinberg_Vst_IAttributeList) callconv(.C) Steinberg_tresult,
};
pub const struct_Steinberg_Vst_ChannelContext_IInfoListener = extern struct {
    lpVtbl: [*c]struct_Steinberg_Vst_ChannelContext_IInfoListenerVtbl,
};
pub const struct_Steinberg_Vst_IPrefetchableSupportVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    getPrefetchableSupport: ?*const fn (?*anyopaque, [*c]Steinberg_Vst_PrefetchableSupport) callconv(.C) Steinberg_tresult,
};
pub const struct_Steinberg_Vst_IPrefetchableSupport = extern struct {
    lpVtbl: [*c]struct_Steinberg_Vst_IPrefetchableSupportVtbl,
};
pub const struct_Steinberg_Vst_IAutomationStateVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    setAutomationState: ?*const fn (?*anyopaque, Steinberg_int32) callconv(.C) Steinberg_tresult,
};
pub const struct_Steinberg_Vst_IAutomationState = extern struct {
    lpVtbl: [*c]struct_Steinberg_Vst_IAutomationStateVtbl,
};
pub const struct_Steinberg_Vst_IInterAppAudioPresetManagerVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    runLoadPresetBrowser: ?*const fn (?*anyopaque) callconv(.C) Steinberg_tresult,
    runSavePresetBrowser: ?*const fn (?*anyopaque) callconv(.C) Steinberg_tresult,
    loadNextPreset: ?*const fn (?*anyopaque) callconv(.C) Steinberg_tresult,
    loadPreviousPreset: ?*const fn (?*anyopaque) callconv(.C) Steinberg_tresult,
};
pub const struct_Steinberg_Vst_IInterAppAudioPresetManager = extern struct {
    lpVtbl: [*c]struct_Steinberg_Vst_IInterAppAudioPresetManagerVtbl,
};
pub const struct_Steinberg_Vst_IInterAppAudioHostVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    getScreenSize: ?*const fn (?*anyopaque, [*c]struct_Steinberg_ViewRect, [*c]f32) callconv(.C) Steinberg_tresult,
    connectedToHost: ?*const fn (?*anyopaque) callconv(.C) Steinberg_tresult,
    switchToHost: ?*const fn (?*anyopaque) callconv(.C) Steinberg_tresult,
    sendRemoteControlEvent: ?*const fn (?*anyopaque, Steinberg_uint32) callconv(.C) Steinberg_tresult,
    getHostIcon: ?*const fn (?*anyopaque, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    scheduleEventFromUI: ?*const fn (?*anyopaque, [*c]struct_Steinberg_Vst_Event) callconv(.C) Steinberg_tresult,
    createPresetManager: ?*const fn (?*anyopaque, [*c]const Steinberg_TUID) callconv(.C) [*c]struct_Steinberg_Vst_IInterAppAudioPresetManager,
    showSettingsView: ?*const fn (?*anyopaque) callconv(.C) Steinberg_tresult,
};
pub const struct_Steinberg_Vst_IInterAppAudioHost = extern struct {
    lpVtbl: [*c]struct_Steinberg_Vst_IInterAppAudioHostVtbl,
};
pub const struct_Steinberg_Vst_IInterAppAudioConnectionNotificationVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    onInterAppAudioConnectionStateChange: ?*const fn (?*anyopaque, Steinberg_TBool) callconv(.C) void,
};
pub const struct_Steinberg_Vst_IInterAppAudioConnectionNotification = extern struct {
    lpVtbl: [*c]struct_Steinberg_Vst_IInterAppAudioConnectionNotificationVtbl,
};
pub const struct_Steinberg_Vst_ProcessSetup = extern struct {
    processMode: Steinberg_int32,
    symbolicSampleSize: Steinberg_int32,
    maxSamplesPerBlock: Steinberg_int32,
    sampleRate: Steinberg_Vst_SampleRate,
};
const union_unnamed_2 = extern union {
    Steinberg_Vst_AudioBusBuffers_channelBuffers32: [*c][*c]Steinberg_Vst_Sample32,
    Steinberg_Vst_AudioBusBuffers_channelBuffers64: [*c][*c]Steinberg_Vst_Sample64,
};
pub const struct_Steinberg_Vst_AudioBusBuffers = extern struct {
    numChannels: Steinberg_int32,
    silenceFlags: Steinberg_uint64,
    unnamed_0: union_unnamed_2,
};
pub const struct_Steinberg_Vst_IParamValueQueueVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    getParameterId: ?*const fn (?*anyopaque) callconv(.C) Steinberg_Vst_ParamID,
    getPointCount: ?*const fn (?*anyopaque) callconv(.C) Steinberg_int32,
    getPoint: ?*const fn (?*anyopaque, Steinberg_int32, [*c]Steinberg_int32, [*c]Steinberg_Vst_ParamValue) callconv(.C) Steinberg_tresult,
    addPoint: ?*const fn (?*anyopaque, Steinberg_int32, Steinberg_Vst_ParamValue, [*c]Steinberg_int32) callconv(.C) Steinberg_tresult,
};
pub const struct_Steinberg_Vst_IParamValueQueue = extern struct {
    lpVtbl: [*c]struct_Steinberg_Vst_IParamValueQueueVtbl,
};
pub const struct_Steinberg_Vst_IParameterChangesVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    getParameterCount: ?*const fn (?*anyopaque) callconv(.C) Steinberg_int32,
    getParameterData: ?*const fn (?*anyopaque, Steinberg_int32) callconv(.C) [*c]struct_Steinberg_Vst_IParamValueQueue,
    addParameterData: ?*const fn (?*anyopaque, [*c]const Steinberg_Vst_ParamID, [*c]Steinberg_int32) callconv(.C) [*c]struct_Steinberg_Vst_IParamValueQueue,
};
pub const struct_Steinberg_Vst_IParameterChanges = extern struct {
    lpVtbl: [*c]struct_Steinberg_Vst_IParameterChangesVtbl,
};
pub const struct_Steinberg_Vst_Chord = extern struct {
    keyNote: Steinberg_uint8,
    rootNote: Steinberg_uint8,
    chordMask: Steinberg_int16,
};
pub const struct_Steinberg_Vst_FrameRate = extern struct {
    framesPerSecond: Steinberg_uint32,
    flags: Steinberg_uint32,
};
pub const struct_Steinberg_Vst_ProcessContext = extern struct {
    state: Steinberg_uint32,
    sampleRate: f64,
    projectTimeSamples: Steinberg_Vst_TSamples,
    systemTime: Steinberg_int64,
    continousTimeSamples: Steinberg_Vst_TSamples,
    projectTimeMusic: Steinberg_Vst_TQuarterNotes,
    barPositionMusic: Steinberg_Vst_TQuarterNotes,
    cycleStartMusic: Steinberg_Vst_TQuarterNotes,
    cycleEndMusic: Steinberg_Vst_TQuarterNotes,
    tempo: f64,
    timeSigNumerator: Steinberg_int32,
    timeSigDenominator: Steinberg_int32,
    chord: struct_Steinberg_Vst_Chord,
    smpteOffsetSubframes: Steinberg_int32,
    frameRate: struct_Steinberg_Vst_FrameRate,
    samplesToNextClock: Steinberg_int32,
};
pub const struct_Steinberg_Vst_ProcessData = extern struct {
    processMode: Steinberg_int32,
    symbolicSampleSize: Steinberg_int32,
    numSamples: Steinberg_int32,
    numInputs: Steinberg_int32,
    numOutputs: Steinberg_int32,
    inputs: [*c]struct_Steinberg_Vst_AudioBusBuffers,
    outputs: [*c]struct_Steinberg_Vst_AudioBusBuffers,
    inputParameterChanges: [*c]struct_Steinberg_Vst_IParameterChanges,
    outputParameterChanges: [*c]struct_Steinberg_Vst_IParameterChanges,
    inputEvents: [*c]struct_Steinberg_Vst_IEventList,
    outputEvents: [*c]struct_Steinberg_Vst_IEventList,
    processContext: [*c]struct_Steinberg_Vst_ProcessContext,
};
pub const struct_Steinberg_Vst_IAudioProcessorVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    setBusArrangements: ?*const fn (?*anyopaque, [*c]Steinberg_Vst_SpeakerArrangement, Steinberg_int32, [*c]Steinberg_Vst_SpeakerArrangement, Steinberg_int32) callconv(.C) Steinberg_tresult,
    getBusArrangement: ?*const fn (?*anyopaque, Steinberg_Vst_BusDirection, Steinberg_int32, [*c]Steinberg_Vst_SpeakerArrangement) callconv(.C) Steinberg_tresult,
    canProcessSampleSize: ?*const fn (?*anyopaque, Steinberg_int32) callconv(.C) Steinberg_tresult,
    getLatencySamples: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    setupProcessing: ?*const fn (?*anyopaque, [*c]struct_Steinberg_Vst_ProcessSetup) callconv(.C) Steinberg_tresult,
    setProcessing: ?*const fn (?*anyopaque, Steinberg_TBool) callconv(.C) Steinberg_tresult,
    process: ?*const fn (?*anyopaque, [*c]struct_Steinberg_Vst_ProcessData) callconv(.C) Steinberg_tresult,
    getTailSamples: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
};
pub const struct_Steinberg_Vst_IAudioProcessor = extern struct {
    lpVtbl: [*c]struct_Steinberg_Vst_IAudioProcessorVtbl,
};
pub const struct_Steinberg_Vst_IAudioPresentationLatencyVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    setAudioPresentationLatencySamples: ?*const fn (?*anyopaque, Steinberg_Vst_BusDirection, Steinberg_int32, Steinberg_uint32) callconv(.C) Steinberg_tresult,
};
pub const struct_Steinberg_Vst_IAudioPresentationLatency = extern struct {
    lpVtbl: [*c]struct_Steinberg_Vst_IAudioPresentationLatencyVtbl,
};
pub const struct_Steinberg_Vst_IProcessContextRequirementsVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    getProcessContextRequirements: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
};
pub const struct_Steinberg_Vst_IProcessContextRequirements = extern struct {
    lpVtbl: [*c]struct_Steinberg_Vst_IProcessContextRequirementsVtbl,
};
pub const struct_Steinberg_Vst_IHostApplicationVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    getName: ?*const fn (?*anyopaque, [*c]Steinberg_Vst_TChar) callconv(.C) Steinberg_tresult,
    createInstance: ?*const fn (?*anyopaque, [*c]u8, [*c]u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
};
pub const struct_Steinberg_Vst_IHostApplication = extern struct {
    lpVtbl: [*c]struct_Steinberg_Vst_IHostApplicationVtbl,
};
pub const struct_Steinberg_Vst_IVst3ToVst2WrapperVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
};
pub const struct_Steinberg_Vst_IVst3ToVst2Wrapper = extern struct {
    lpVtbl: [*c]struct_Steinberg_Vst_IVst3ToVst2WrapperVtbl,
};
pub const struct_Steinberg_Vst_IVst3ToAUWrapperVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
};
pub const struct_Steinberg_Vst_IVst3ToAUWrapper = extern struct {
    lpVtbl: [*c]struct_Steinberg_Vst_IVst3ToAUWrapperVtbl,
};
pub const struct_Steinberg_Vst_IVst3ToAAXWrapperVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
};
pub const struct_Steinberg_Vst_IVst3ToAAXWrapper = extern struct {
    lpVtbl: [*c]struct_Steinberg_Vst_IVst3ToAAXWrapperVtbl,
};
pub const struct_Steinberg_Vst_IVst3WrapperMPESupportVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    enableMPEInputProcessing: ?*const fn (?*anyopaque, Steinberg_TBool) callconv(.C) Steinberg_tresult,
    setMPEInputDeviceSettings: ?*const fn (?*anyopaque, Steinberg_int32, Steinberg_int32, Steinberg_int32) callconv(.C) Steinberg_tresult,
};
pub const struct_Steinberg_Vst_IVst3WrapperMPESupport = extern struct {
    lpVtbl: [*c]struct_Steinberg_Vst_IVst3WrapperMPESupportVtbl,
};
pub const struct_Steinberg_Vst_IParameterFinderVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    findParameter: ?*const fn (?*anyopaque, Steinberg_int32, Steinberg_int32, [*c]Steinberg_Vst_ParamID) callconv(.C) Steinberg_tresult,
};
pub const struct_Steinberg_Vst_IParameterFinder = extern struct {
    lpVtbl: [*c]struct_Steinberg_Vst_IParameterFinderVtbl,
};
pub const struct_Steinberg_Vst_IUnitHandlerVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    notifyUnitSelection: ?*const fn (?*anyopaque, Steinberg_Vst_UnitID) callconv(.C) Steinberg_tresult,
    notifyProgramListChange: ?*const fn (?*anyopaque, Steinberg_Vst_ProgramListID, Steinberg_int32) callconv(.C) Steinberg_tresult,
};
pub const struct_Steinberg_Vst_IUnitHandler = extern struct {
    lpVtbl: [*c]struct_Steinberg_Vst_IUnitHandlerVtbl,
};
pub const struct_Steinberg_Vst_IUnitHandler2Vtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    notifyUnitByBusChange: ?*const fn (?*anyopaque) callconv(.C) Steinberg_tresult,
};
pub const struct_Steinberg_Vst_IUnitHandler2 = extern struct {
    lpVtbl: [*c]struct_Steinberg_Vst_IUnitHandler2Vtbl,
};
pub const struct_Steinberg_Vst_UnitInfo = extern struct {
    id: Steinberg_Vst_UnitID,
    parentUnitId: Steinberg_Vst_UnitID,
    name: Steinberg_Vst_String128,
    programListId: Steinberg_Vst_ProgramListID,
};
pub const struct_Steinberg_Vst_ProgramListInfo = extern struct {
    id: Steinberg_Vst_ProgramListID,
    name: Steinberg_Vst_String128,
    programCount: Steinberg_int32,
};
pub const struct_Steinberg_Vst_IUnitInfoVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    getUnitCount: ?*const fn (?*anyopaque) callconv(.C) Steinberg_int32,
    getUnitInfo: ?*const fn (?*anyopaque, Steinberg_int32, [*c]struct_Steinberg_Vst_UnitInfo) callconv(.C) Steinberg_tresult,
    getProgramListCount: ?*const fn (?*anyopaque) callconv(.C) Steinberg_int32,
    getProgramListInfo: ?*const fn (?*anyopaque, Steinberg_int32, [*c]struct_Steinberg_Vst_ProgramListInfo) callconv(.C) Steinberg_tresult,
    getProgramName: ?*const fn (?*anyopaque, Steinberg_Vst_ProgramListID, Steinberg_int32, [*c]Steinberg_Vst_TChar) callconv(.C) Steinberg_tresult,
    getProgramInfo: ?*const fn (?*anyopaque, Steinberg_Vst_ProgramListID, Steinberg_int32, Steinberg_Vst_CString, [*c]Steinberg_Vst_TChar) callconv(.C) Steinberg_tresult,
    hasProgramPitchNames: ?*const fn (?*anyopaque, Steinberg_Vst_ProgramListID, Steinberg_int32) callconv(.C) Steinberg_tresult,
    getProgramPitchName: ?*const fn (?*anyopaque, Steinberg_Vst_ProgramListID, Steinberg_int32, Steinberg_int16, [*c]Steinberg_Vst_TChar) callconv(.C) Steinberg_tresult,
    getSelectedUnit: ?*const fn (?*anyopaque) callconv(.C) Steinberg_Vst_UnitID,
    selectUnit: ?*const fn (?*anyopaque, Steinberg_Vst_UnitID) callconv(.C) Steinberg_tresult,
    getUnitByBus: ?*const fn (?*anyopaque, Steinberg_Vst_MediaType, Steinberg_Vst_BusDirection, Steinberg_int32, Steinberg_int32, [*c]Steinberg_Vst_UnitID) callconv(.C) Steinberg_tresult,
    setUnitProgramData: ?*const fn (?*anyopaque, Steinberg_int32, Steinberg_int32, [*c]struct_Steinberg_IBStream) callconv(.C) Steinberg_tresult,
};
pub const struct_Steinberg_Vst_IUnitInfo = extern struct {
    lpVtbl: [*c]struct_Steinberg_Vst_IUnitInfoVtbl,
};
pub const struct_Steinberg_Vst_IProgramListDataVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    programDataSupported: ?*const fn (?*anyopaque, Steinberg_Vst_ProgramListID) callconv(.C) Steinberg_tresult,
    getProgramData: ?*const fn (?*anyopaque, Steinberg_Vst_ProgramListID, Steinberg_int32, [*c]struct_Steinberg_IBStream) callconv(.C) Steinberg_tresult,
    setProgramData: ?*const fn (?*anyopaque, Steinberg_Vst_ProgramListID, Steinberg_int32, [*c]struct_Steinberg_IBStream) callconv(.C) Steinberg_tresult,
};
pub const struct_Steinberg_Vst_IProgramListData = extern struct {
    lpVtbl: [*c]struct_Steinberg_Vst_IProgramListDataVtbl,
};
pub const struct_Steinberg_Vst_IUnitDataVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    unitDataSupported: ?*const fn (?*anyopaque, Steinberg_Vst_UnitID) callconv(.C) Steinberg_tresult,
    getUnitData: ?*const fn (?*anyopaque, Steinberg_Vst_UnitID, [*c]struct_Steinberg_IBStream) callconv(.C) Steinberg_tresult,
    setUnitData: ?*const fn (?*anyopaque, Steinberg_Vst_UnitID, [*c]struct_Steinberg_IBStream) callconv(.C) Steinberg_tresult,
};
pub const struct_Steinberg_Vst_IUnitData = extern struct {
    lpVtbl: [*c]struct_Steinberg_Vst_IUnitDataVtbl,
};
pub const struct_Steinberg_Vst_IPlugInterfaceSupportVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    isPlugInterfaceSupported: ?*const fn (?*anyopaque, [*c]const u8) callconv(.C) Steinberg_tresult,
};
pub const struct_Steinberg_Vst_IPlugInterfaceSupport = extern struct {
    lpVtbl: [*c]struct_Steinberg_Vst_IPlugInterfaceSupportVtbl,
};
pub const struct_Steinberg_Vst_IParameterFunctionNameVtbl = extern struct {
    queryInterface: ?*const fn (?*anyopaque, [*c]const u8, [*c]?*anyopaque) callconv(.C) Steinberg_tresult,
    addRef: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    release: ?*const fn (?*anyopaque) callconv(.C) Steinberg_uint32,
    getParameterIDFromFunctionName: ?*const fn (?*anyopaque, Steinberg_Vst_UnitID, Steinberg_FIDString, [*c]Steinberg_Vst_ParamID) callconv(.C) Steinberg_tresult,
};
pub const struct_Steinberg_Vst_IParameterFunctionName = extern struct {
    lpVtbl: [*c]struct_Steinberg_Vst_IParameterFunctionNameVtbl,
};
pub const Steinberg_kNoInterface: Steinberg_tresult = @bitCast(Steinberg_tresult, @truncate(c_uint, @as(c_ulong, 2147500034)));
pub const Steinberg_kResultOk: Steinberg_tresult = 0;
pub const Steinberg_kResultTrue: Steinberg_tresult = 0;
pub const Steinberg_kResultFalse: Steinberg_tresult = 1;
pub const Steinberg_kInvalidArgument: Steinberg_tresult = @bitCast(Steinberg_tresult, @truncate(c_uint, @as(c_ulong, 2147942487)));
pub const Steinberg_kNotImplemented: Steinberg_tresult = @bitCast(Steinberg_tresult, @truncate(c_uint, @as(c_ulong, 2147500033)));
pub const Steinberg_kInternalError: Steinberg_tresult = @bitCast(Steinberg_tresult, @truncate(c_uint, @as(c_ulong, 2147500037)));
pub const Steinberg_kNotInitialized: Steinberg_tresult = @bitCast(Steinberg_tresult, @truncate(c_uint, @as(c_ulong, 2147549183)));
pub const Steinberg_kOutOfMemory: Steinberg_tresult = @bitCast(Steinberg_tresult, @truncate(c_uint, @as(c_ulong, 2147942414)));
pub const Steinberg_IBStream_IStreamSeekMode_kIBSeekSet: c_int = 0;
pub const Steinberg_IBStream_IStreamSeekMode_kIBSeekCur: c_int = 1;
pub const Steinberg_IBStream_IStreamSeekMode_kIBSeekEnd: c_int = 2;
pub const Steinberg_IBStream_IStreamSeekMode = c_uint;
pub const Steinberg_Vst_NoteExpressionTypeIDs_kVolumeTypeID: c_int = 0;
pub const Steinberg_Vst_NoteExpressionTypeIDs_kPanTypeID: c_int = 1;
pub const Steinberg_Vst_NoteExpressionTypeIDs_kTuningTypeID: c_int = 2;
pub const Steinberg_Vst_NoteExpressionTypeIDs_kVibratoTypeID: c_int = 3;
pub const Steinberg_Vst_NoteExpressionTypeIDs_kExpressionTypeID: c_int = 4;
pub const Steinberg_Vst_NoteExpressionTypeIDs_kBrightnessTypeID: c_int = 5;
pub const Steinberg_Vst_NoteExpressionTypeIDs_kTextTypeID: c_int = 6;
pub const Steinberg_Vst_NoteExpressionTypeIDs_kPhonemeTypeID: c_int = 7;
pub const Steinberg_Vst_NoteExpressionTypeIDs_kCustomStart: c_int = 100000;
pub const Steinberg_Vst_NoteExpressionTypeIDs_kCustomEnd: c_int = 200000;
pub const Steinberg_Vst_NoteExpressionTypeIDs_kInvalidTypeID: c_uint = 4294967295;
pub const Steinberg_Vst_NoteExpressionTypeIDs = c_uint;
pub const Steinberg_Vst_NoteExpressionTypeInfo_NoteExpressionTypeFlags_kIsBipolar: c_int = 1;
pub const Steinberg_Vst_NoteExpressionTypeInfo_NoteExpressionTypeFlags_kIsOneShot: c_int = 2;
pub const Steinberg_Vst_NoteExpressionTypeInfo_NoteExpressionTypeFlags_kIsAbsolute: c_int = 4;
pub const Steinberg_Vst_NoteExpressionTypeInfo_NoteExpressionTypeFlags_kAssociatedParameterIDValid: c_int = 8;
pub const Steinberg_Vst_NoteExpressionTypeInfo_NoteExpressionTypeFlags = c_uint;
pub const Steinberg_Vst_KeyswitchTypeIDs_kNoteOnKeyswitchTypeID: c_int = 0;
pub const Steinberg_Vst_KeyswitchTypeIDs_kOnTheFlyKeyswitchTypeID: c_int = 1;
pub const Steinberg_Vst_KeyswitchTypeIDs_kOnReleaseKeyswitchTypeID: c_int = 2;
pub const Steinberg_Vst_KeyswitchTypeIDs_kKeyRangeTypeID: c_int = 3;
pub const Steinberg_Vst_KeyswitchTypeIDs = c_uint;
pub const Steinberg_Vst_PhysicalUITypeIDs_kPUIXMovement: c_int = 0;
pub const Steinberg_Vst_PhysicalUITypeIDs_kPUIYMovement: c_int = 1;
pub const Steinberg_Vst_PhysicalUITypeIDs_kPUIPressure: c_int = 2;
pub const Steinberg_Vst_PhysicalUITypeIDs_kPUITypeCount: c_int = 3;
pub const Steinberg_Vst_PhysicalUITypeIDs_kInvalidPUITypeID: c_uint = 4294967295;
pub const Steinberg_Vst_PhysicalUITypeIDs = c_uint;
pub const Steinberg_PFactoryInfo_FactoryFlags_kNoFlags: c_int = 0;
pub const Steinberg_PFactoryInfo_FactoryFlags_kClassesDiscardable: c_int = 1;
pub const Steinberg_PFactoryInfo_FactoryFlags_kLicenseCheck: c_int = 2;
pub const Steinberg_PFactoryInfo_FactoryFlags_kComponentNonDiscardable: c_int = 8;
pub const Steinberg_PFactoryInfo_FactoryFlags_kUnicode: c_int = 16;
pub const Steinberg_PFactoryInfo_FactoryFlags = c_uint;
pub const Steinberg_PClassInfo_ClassCardinality_kManyInstances: c_int = 2147483647;
pub const Steinberg_PClassInfo_ClassCardinality = c_uint;
pub const Steinberg_Vst_MediaTypes_kAudio: c_int = 0;
pub const Steinberg_Vst_MediaTypes_kEvent: c_int = 1;
pub const Steinberg_Vst_MediaTypes_kNumMediaTypes: c_int = 2;
pub const Steinberg_Vst_MediaTypes = c_uint;
pub const Steinberg_Vst_BusDirections_kInput: c_int = 0;
pub const Steinberg_Vst_BusDirections_kOutput: c_int = 1;
pub const Steinberg_Vst_BusDirections = c_uint;
pub const Steinberg_Vst_BusTypes_kMain: c_int = 0;
pub const Steinberg_Vst_BusTypes_kAux: c_int = 1;
pub const Steinberg_Vst_BusTypes = c_uint;
pub const Steinberg_Vst_BusInfo_BusFlags_kDefaultActive: c_int = 1;
pub const Steinberg_Vst_BusInfo_BusFlags_kIsControlVoltage: c_int = 2;
pub const Steinberg_Vst_BusInfo_BusFlags = c_uint;
pub const Steinberg_Vst_IoModes_kSimple: c_int = 0;
pub const Steinberg_Vst_IoModes_kAdvanced: c_int = 1;
pub const Steinberg_Vst_IoModes_kOfflineProcessing: c_int = 2;
pub const Steinberg_Vst_IoModes = c_uint;
pub const Steinberg_Vst_ParameterInfo_ParameterFlags_kNoFlags: c_int = 0;
pub const Steinberg_Vst_ParameterInfo_ParameterFlags_kCanAutomate: c_int = 1;
pub const Steinberg_Vst_ParameterInfo_ParameterFlags_kIsReadOnly: c_int = 2;
pub const Steinberg_Vst_ParameterInfo_ParameterFlags_kIsWrapAround: c_int = 4;
pub const Steinberg_Vst_ParameterInfo_ParameterFlags_kIsList: c_int = 8;
pub const Steinberg_Vst_ParameterInfo_ParameterFlags_kIsHidden: c_int = 16;
pub const Steinberg_Vst_ParameterInfo_ParameterFlags_kIsProgramChange: c_int = 32768;
pub const Steinberg_Vst_ParameterInfo_ParameterFlags_kIsBypass: c_int = 65536;
pub const Steinberg_Vst_ParameterInfo_ParameterFlags = c_uint;
pub const Steinberg_Vst_RestartFlags_kReloadComponent: c_int = 1;
pub const Steinberg_Vst_RestartFlags_kIoChanged: c_int = 2;
pub const Steinberg_Vst_RestartFlags_kParamValuesChanged: c_int = 4;
pub const Steinberg_Vst_RestartFlags_kLatencyChanged: c_int = 8;
pub const Steinberg_Vst_RestartFlags_kParamTitlesChanged: c_int = 16;
pub const Steinberg_Vst_RestartFlags_kMidiCCAssignmentChanged: c_int = 32;
pub const Steinberg_Vst_RestartFlags_kNoteExpressionChanged: c_int = 64;
pub const Steinberg_Vst_RestartFlags_kIoTitlesChanged: c_int = 128;
pub const Steinberg_Vst_RestartFlags_kPrefetchableSupportChanged: c_int = 256;
pub const Steinberg_Vst_RestartFlags_kRoutingInfoChanged: c_int = 512;
pub const Steinberg_Vst_RestartFlags_kKeyswitchChanged: c_int = 1024;
pub const Steinberg_Vst_RestartFlags = c_uint;
pub const Steinberg_Vst_IProgress_ProgressType_AsyncStateRestoration: c_int = 0;
pub const Steinberg_Vst_IProgress_ProgressType_UIBackgroundTask: c_int = 1;
pub const Steinberg_Vst_IProgress_ProgressType = c_uint;
pub const Steinberg_Vst_KnobModes_kCircularMode: c_int = 0;
pub const Steinberg_Vst_KnobModes_kRelativCircularMode: c_int = 1;
pub const Steinberg_Vst_KnobModes_kLinearMode: c_int = 2;
pub const Steinberg_Vst_KnobModes = c_uint;
pub const Steinberg_Vst_FrameRate_FrameRateFlags_kPullDownRate: c_int = 1;
pub const Steinberg_Vst_FrameRate_FrameRateFlags_kDropRate: c_int = 2;
pub const Steinberg_Vst_FrameRate_FrameRateFlags = c_uint;
pub const Steinberg_Vst_Chord_Masks_kChordMask: c_int = 4095;
pub const Steinberg_Vst_Chord_Masks_kReservedMask: c_int = 61440;
pub const Steinberg_Vst_Chord_Masks = c_uint;
pub const Steinberg_Vst_ProcessContext_StatesAndFlags_kPlaying: c_int = 2;
pub const Steinberg_Vst_ProcessContext_StatesAndFlags_kCycleActive: c_int = 4;
pub const Steinberg_Vst_ProcessContext_StatesAndFlags_kRecording: c_int = 8;
pub const Steinberg_Vst_ProcessContext_StatesAndFlags_kSystemTimeValid: c_int = 256;
pub const Steinberg_Vst_ProcessContext_StatesAndFlags_kContTimeValid: c_int = 131072;
pub const Steinberg_Vst_ProcessContext_StatesAndFlags_kProjectTimeMusicValid: c_int = 512;
pub const Steinberg_Vst_ProcessContext_StatesAndFlags_kBarPositionValid: c_int = 2048;
pub const Steinberg_Vst_ProcessContext_StatesAndFlags_kCycleValid: c_int = 4096;
pub const Steinberg_Vst_ProcessContext_StatesAndFlags_kTempoValid: c_int = 1024;
pub const Steinberg_Vst_ProcessContext_StatesAndFlags_kTimeSigValid: c_int = 8192;
pub const Steinberg_Vst_ProcessContext_StatesAndFlags_kChordValid: c_int = 262144;
pub const Steinberg_Vst_ProcessContext_StatesAndFlags_kSmpteValid: c_int = 16384;
pub const Steinberg_Vst_ProcessContext_StatesAndFlags_kClockValid: c_int = 32768;
pub const Steinberg_Vst_ProcessContext_StatesAndFlags = c_uint;
pub const Steinberg_Vst_NoteIDUserRange_kNoteIDUserRangeLowerBound: c_int = -10000;
pub const Steinberg_Vst_NoteIDUserRange_kNoteIDUserRangeUpperBound: c_int = -1000;
pub const Steinberg_Vst_NoteIDUserRange = c_int;
pub const Steinberg_Vst_DataEvent_DataTypes_kMidiSysEx: c_int = 0;
pub const Steinberg_Vst_DataEvent_DataTypes = c_uint;
pub const Steinberg_Vst_Event_EventFlags_kIsLive: c_int = 1;
pub const Steinberg_Vst_Event_EventFlags_kUserReserved1: c_int = 16384;
pub const Steinberg_Vst_Event_EventFlags_kUserReserved2: c_int = 32768;
pub const Steinberg_Vst_Event_EventFlags = c_uint;
pub const Steinberg_Vst_Event_EventTypes_kNoteOnEvent: c_int = 0;
pub const Steinberg_Vst_Event_EventTypes_kNoteOffEvent: c_int = 1;
pub const Steinberg_Vst_Event_EventTypes_kDataEvent: c_int = 2;
pub const Steinberg_Vst_Event_EventTypes_kPolyPressureEvent: c_int = 3;
pub const Steinberg_Vst_Event_EventTypes_kNoteExpressionValueEvent: c_int = 4;
pub const Steinberg_Vst_Event_EventTypes_kNoteExpressionTextEvent: c_int = 5;
pub const Steinberg_Vst_Event_EventTypes_kChordEvent: c_int = 6;
pub const Steinberg_Vst_Event_EventTypes_kScaleEvent: c_int = 7;
pub const Steinberg_Vst_Event_EventTypes_kLegacyMIDICCOutEvent: c_int = 65535;
pub const Steinberg_Vst_Event_EventTypes = c_uint;
pub const Steinberg_Vst_IContextMenuItem_Flags_kIsSeparator: c_int = 1;
pub const Steinberg_Vst_IContextMenuItem_Flags_kIsDisabled: c_int = 2;
pub const Steinberg_Vst_IContextMenuItem_Flags_kIsChecked: c_int = 4;
pub const Steinberg_Vst_IContextMenuItem_Flags_kIsGroupStart: c_int = 10;
pub const Steinberg_Vst_IContextMenuItem_Flags_kIsGroupEnd: c_int = 17;
pub const Steinberg_Vst_IContextMenuItem_Flags = c_uint;
pub const Steinberg_Vst_ControllerNumbers_kCtrlBankSelectMSB: c_int = 0;
pub const Steinberg_Vst_ControllerNumbers_kCtrlModWheel: c_int = 1;
pub const Steinberg_Vst_ControllerNumbers_kCtrlBreath: c_int = 2;
pub const Steinberg_Vst_ControllerNumbers_kCtrlFoot: c_int = 4;
pub const Steinberg_Vst_ControllerNumbers_kCtrlPortaTime: c_int = 5;
pub const Steinberg_Vst_ControllerNumbers_kCtrlDataEntryMSB: c_int = 6;
pub const Steinberg_Vst_ControllerNumbers_kCtrlVolume: c_int = 7;
pub const Steinberg_Vst_ControllerNumbers_kCtrlBalance: c_int = 8;
pub const Steinberg_Vst_ControllerNumbers_kCtrlPan: c_int = 10;
pub const Steinberg_Vst_ControllerNumbers_kCtrlExpression: c_int = 11;
pub const Steinberg_Vst_ControllerNumbers_kCtrlEffect1: c_int = 12;
pub const Steinberg_Vst_ControllerNumbers_kCtrlEffect2: c_int = 13;
pub const Steinberg_Vst_ControllerNumbers_kCtrlGPC1: c_int = 16;
pub const Steinberg_Vst_ControllerNumbers_kCtrlGPC2: c_int = 17;
pub const Steinberg_Vst_ControllerNumbers_kCtrlGPC3: c_int = 18;
pub const Steinberg_Vst_ControllerNumbers_kCtrlGPC4: c_int = 19;
pub const Steinberg_Vst_ControllerNumbers_kCtrlBankSelectLSB: c_int = 32;
pub const Steinberg_Vst_ControllerNumbers_kCtrlDataEntryLSB: c_int = 38;
pub const Steinberg_Vst_ControllerNumbers_kCtrlSustainOnOff: c_int = 64;
pub const Steinberg_Vst_ControllerNumbers_kCtrlPortaOnOff: c_int = 65;
pub const Steinberg_Vst_ControllerNumbers_kCtrlSustenutoOnOff: c_int = 66;
pub const Steinberg_Vst_ControllerNumbers_kCtrlSoftPedalOnOff: c_int = 67;
pub const Steinberg_Vst_ControllerNumbers_kCtrlLegatoFootSwOnOff: c_int = 68;
pub const Steinberg_Vst_ControllerNumbers_kCtrlHold2OnOff: c_int = 69;
pub const Steinberg_Vst_ControllerNumbers_kCtrlSoundVariation: c_int = 70;
pub const Steinberg_Vst_ControllerNumbers_kCtrlFilterCutoff: c_int = 71;
pub const Steinberg_Vst_ControllerNumbers_kCtrlReleaseTime: c_int = 72;
pub const Steinberg_Vst_ControllerNumbers_kCtrlAttackTime: c_int = 73;
pub const Steinberg_Vst_ControllerNumbers_kCtrlFilterResonance: c_int = 74;
pub const Steinberg_Vst_ControllerNumbers_kCtrlDecayTime: c_int = 75;
pub const Steinberg_Vst_ControllerNumbers_kCtrlVibratoRate: c_int = 76;
pub const Steinberg_Vst_ControllerNumbers_kCtrlVibratoDepth: c_int = 77;
pub const Steinberg_Vst_ControllerNumbers_kCtrlVibratoDelay: c_int = 78;
pub const Steinberg_Vst_ControllerNumbers_kCtrlSoundCtrler10: c_int = 79;
pub const Steinberg_Vst_ControllerNumbers_kCtrlGPC5: c_int = 80;
pub const Steinberg_Vst_ControllerNumbers_kCtrlGPC6: c_int = 81;
pub const Steinberg_Vst_ControllerNumbers_kCtrlGPC7: c_int = 82;
pub const Steinberg_Vst_ControllerNumbers_kCtrlGPC8: c_int = 83;
pub const Steinberg_Vst_ControllerNumbers_kCtrlPortaControl: c_int = 84;
pub const Steinberg_Vst_ControllerNumbers_kCtrlEff1Depth: c_int = 91;
pub const Steinberg_Vst_ControllerNumbers_kCtrlEff2Depth: c_int = 92;
pub const Steinberg_Vst_ControllerNumbers_kCtrlEff3Depth: c_int = 93;
pub const Steinberg_Vst_ControllerNumbers_kCtrlEff4Depth: c_int = 94;
pub const Steinberg_Vst_ControllerNumbers_kCtrlEff5Depth: c_int = 95;
pub const Steinberg_Vst_ControllerNumbers_kCtrlDataIncrement: c_int = 96;
pub const Steinberg_Vst_ControllerNumbers_kCtrlDataDecrement: c_int = 97;
pub const Steinberg_Vst_ControllerNumbers_kCtrlNRPNSelectLSB: c_int = 98;
pub const Steinberg_Vst_ControllerNumbers_kCtrlNRPNSelectMSB: c_int = 99;
pub const Steinberg_Vst_ControllerNumbers_kCtrlRPNSelectLSB: c_int = 100;
pub const Steinberg_Vst_ControllerNumbers_kCtrlRPNSelectMSB: c_int = 101;
pub const Steinberg_Vst_ControllerNumbers_kCtrlAllSoundsOff: c_int = 120;
pub const Steinberg_Vst_ControllerNumbers_kCtrlResetAllCtrlers: c_int = 121;
pub const Steinberg_Vst_ControllerNumbers_kCtrlLocalCtrlOnOff: c_int = 122;
pub const Steinberg_Vst_ControllerNumbers_kCtrlAllNotesOff: c_int = 123;
pub const Steinberg_Vst_ControllerNumbers_kCtrlOmniModeOff: c_int = 124;
pub const Steinberg_Vst_ControllerNumbers_kCtrlOmniModeOn: c_int = 125;
pub const Steinberg_Vst_ControllerNumbers_kCtrlPolyModeOnOff: c_int = 126;
pub const Steinberg_Vst_ControllerNumbers_kCtrlPolyModeOn: c_int = 127;
pub const Steinberg_Vst_ControllerNumbers_kAfterTouch: c_int = 128;
pub const Steinberg_Vst_ControllerNumbers_kPitchBend: c_int = 129;
pub const Steinberg_Vst_ControllerNumbers_kCountCtrlNumber: c_int = 130;
pub const Steinberg_Vst_ControllerNumbers_kCtrlProgramChange: c_int = 130;
pub const Steinberg_Vst_ControllerNumbers_kCtrlPolyPressure: c_int = 131;
pub const Steinberg_Vst_ControllerNumbers_kCtrlQuarterFrame: c_int = 132;
pub const Steinberg_Vst_ControllerNumbers = c_uint;
pub const Steinberg_Vst_ChannelContext_ChannelPluginLocation_kPreVolumeFader: c_int = 0;
pub const Steinberg_Vst_ChannelContext_ChannelPluginLocation_kPostVolumeFader: c_int = 1;
pub const Steinberg_Vst_ChannelContext_ChannelPluginLocation_kUsedAsPanner: c_int = 2;
pub const Steinberg_Vst_ChannelContext_ChannelPluginLocation = c_uint;
pub const Steinberg_Vst_ePrefetchableSupport_kIsNeverPrefetchable: c_int = 0;
pub const Steinberg_Vst_ePrefetchableSupport_kIsYetPrefetchable: c_int = 1;
pub const Steinberg_Vst_ePrefetchableSupport_kIsNotYetPrefetchable: c_int = 2;
pub const Steinberg_Vst_ePrefetchableSupport_kNumPrefetchableSupport: c_int = 3;
pub const Steinberg_Vst_ePrefetchableSupport = c_uint;
pub const Steinberg_Vst_IAutomationState_AutomationStates_kNoAutomation: c_int = 0;
pub const Steinberg_Vst_IAutomationState_AutomationStates_kReadState: c_int = 1;
pub const Steinberg_Vst_IAutomationState_AutomationStates_kWriteState: c_int = 2;
pub const Steinberg_Vst_IAutomationState_AutomationStates_kReadWriteState: c_int = 3;
pub const Steinberg_Vst_IAutomationState_AutomationStates = c_uint;
pub const Steinberg_Vst_ComponentFlags_kDistributable: c_int = 1;
pub const Steinberg_Vst_ComponentFlags_kSimpleModeSupported: c_int = 2;
pub const Steinberg_Vst_ComponentFlags = c_uint;
pub const Steinberg_Vst_SymbolicSampleSizes_kSample32: c_int = 0;
pub const Steinberg_Vst_SymbolicSampleSizes_kSample64: c_int = 1;
pub const Steinberg_Vst_SymbolicSampleSizes = c_uint;
pub const Steinberg_Vst_ProcessModes_kRealtime: c_int = 0;
pub const Steinberg_Vst_ProcessModes_kPrefetch: c_int = 1;
pub const Steinberg_Vst_ProcessModes_kOffline: c_int = 2;
pub const Steinberg_Vst_ProcessModes = c_uint;
pub const Steinberg_Vst_IProcessContextRequirements_Flags_kNeedSystemTime: c_int = 1;
pub const Steinberg_Vst_IProcessContextRequirements_Flags_kNeedContinousTimeSamples: c_int = 2;
pub const Steinberg_Vst_IProcessContextRequirements_Flags_kNeedProjectTimeMusic: c_int = 4;
pub const Steinberg_Vst_IProcessContextRequirements_Flags_kNeedBarPositionMusic: c_int = 8;
pub const Steinberg_Vst_IProcessContextRequirements_Flags_kNeedCycleMusic: c_int = 16;
pub const Steinberg_Vst_IProcessContextRequirements_Flags_kNeedSamplesToNextClock: c_int = 32;
pub const Steinberg_Vst_IProcessContextRequirements_Flags_kNeedTempo: c_int = 64;
pub const Steinberg_Vst_IProcessContextRequirements_Flags_kNeedTimeSignature: c_int = 128;
pub const Steinberg_Vst_IProcessContextRequirements_Flags_kNeedChord: c_int = 256;
pub const Steinberg_Vst_IProcessContextRequirements_Flags_kNeedFrameRate: c_int = 512;
pub const Steinberg_Vst_IProcessContextRequirements_Flags_kNeedTransportState: c_int = 1024;
pub const Steinberg_Vst_IProcessContextRequirements_Flags = c_uint;
pub const Steinberg_kMaxInt32: Steinberg_int32 = 2147483647;
pub const Steinberg_kMinInt32: Steinberg_int32 = -@as(c_int, 2147483647) - @as(c_int, 1);
pub const Steinberg_kMaxLong: Steinberg_int32 = 2147483647;
pub const Steinberg_kMinLong: Steinberg_int32 = -@as(c_int, 2147483647) - @as(c_int, 1);
pub const Steinberg_kMaxInt32u: Steinberg_uint32 = 4294967295;
pub const Steinberg_kMaxInt64: Steinberg_int64 = 9223372036854775807;
pub const Steinberg_kMinInt64: Steinberg_int64 = -@as(c_longlong, 9223372036854775807) - @bitCast(c_longlong, @as(c_longlong, @as(c_int, 1)));
pub const Steinberg_kMaxInt64u: Steinberg_uint64 = 18446744073709551615;
pub const Steinberg_kPlatformStringWin: Steinberg_FIDString = "WIN";
pub const Steinberg_kPlatformStringMac: Steinberg_FIDString = "MAC";
pub const Steinberg_kPlatformStringIOS: Steinberg_FIDString = "IOS";
pub const Steinberg_kPlatformStringLinux: Steinberg_FIDString = "Linux";
pub const Steinberg_kPlatformString: Steinberg_FIDString = "MAC";
pub const Steinberg_kMaxCoord: Steinberg_UCoord = @bitCast(Steinberg_UCoord, @as(c_int, 2147483647));
pub const Steinberg_kMinCoord: Steinberg_UCoord = @bitCast(Steinberg_UCoord, -@as(c_int, 2147483647));
pub const Steinberg_kPlatformTypeHWND: Steinberg_FIDString = "HWND";
pub const Steinberg_kPlatformTypeHIView: Steinberg_FIDString = "HIView";
pub const Steinberg_kPlatformTypeNSView: Steinberg_FIDString = "NSView";
pub const Steinberg_kPlatformTypeUIView: Steinberg_FIDString = "UIView";
pub const Steinberg_kPlatformTypeX11EmbedWindowID: Steinberg_FIDString = "X11EmbedWindowID";
pub const Steinberg_kPrintfBufferSize: Steinberg_uint32 = @bitCast(Steinberg_uint32, @as(c_int, 4096));
pub const Steinberg_Vst_kNoParamId: Steinberg_Vst_ParamID = 4294967295;
pub const Steinberg_Vst_SDKVersionString: Steinberg_FIDString = "VST 3.7.8";
pub const Steinberg_Vst_SDKVersionMajor: Steinberg_uint32 = 3;
pub const Steinberg_Vst_SDKVersionMinor: Steinberg_uint32 = 7;
pub const Steinberg_Vst_SDKVersionSub: Steinberg_uint32 = 8;
pub const Steinberg_Vst_SDKVersion: Steinberg_uint32 = @bitCast(Steinberg_uint32, ((@as(c_int, 3) << @intCast(@import("std").math.Log2Int(c_int), 16)) | (@as(c_int, 7) << @intCast(@import("std").math.Log2Int(c_int), 8))) | @as(c_int, 8));
pub const Steinberg_Vst_SDKVersion_3_7_7: Steinberg_uint32 = @bitCast(Steinberg_uint32, @as(c_int, 198407));
pub const Steinberg_Vst_SDKVersion_3_7_6: Steinberg_uint32 = @bitCast(Steinberg_uint32, @as(c_int, 198406));
pub const Steinberg_Vst_SDKVersion_3_7_5: Steinberg_uint32 = @bitCast(Steinberg_uint32, @as(c_int, 198405));
pub const Steinberg_Vst_SDKVersion_3_7_4: Steinberg_uint32 = @bitCast(Steinberg_uint32, @as(c_int, 198404));
pub const Steinberg_Vst_SDKVersion_3_7_3: Steinberg_uint32 = @bitCast(Steinberg_uint32, @as(c_int, 198403));
pub const Steinberg_Vst_SDKVersion_3_7_2: Steinberg_uint32 = @bitCast(Steinberg_uint32, @as(c_int, 198402));
pub const Steinberg_Vst_SDKVersion_3_7_1: Steinberg_uint32 = @bitCast(Steinberg_uint32, @as(c_int, 198401));
pub const Steinberg_Vst_SDKVersion_3_7_0: Steinberg_uint32 = @bitCast(Steinberg_uint32, @as(c_int, 198400));
pub const Steinberg_Vst_SDKVersion_3_6_14: Steinberg_uint32 = @bitCast(Steinberg_uint32, @as(c_int, 198158));
pub const Steinberg_Vst_SDKVersion_3_6_13: Steinberg_uint32 = @bitCast(Steinberg_uint32, @as(c_int, 198157));
pub const Steinberg_Vst_SDKVersion_3_6_12: Steinberg_uint32 = @bitCast(Steinberg_uint32, @as(c_int, 198156));
pub const Steinberg_Vst_SDKVersion_3_6_11: Steinberg_uint32 = @bitCast(Steinberg_uint32, @as(c_int, 198155));
pub const Steinberg_Vst_SDKVersion_3_6_10: Steinberg_uint32 = @bitCast(Steinberg_uint32, @as(c_int, 198154));
pub const Steinberg_Vst_SDKVersion_3_6_9: Steinberg_uint32 = @bitCast(Steinberg_uint32, @as(c_int, 198153));
pub const Steinberg_Vst_SDKVersion_3_6_8: Steinberg_uint32 = @bitCast(Steinberg_uint32, @as(c_int, 198152));
pub const Steinberg_Vst_SDKVersion_3_6_7: Steinberg_uint32 = @bitCast(Steinberg_uint32, @as(c_int, 198151));
pub const Steinberg_Vst_SDKVersion_3_6_6: Steinberg_uint32 = @bitCast(Steinberg_uint32, @as(c_int, 198150));
pub const Steinberg_Vst_SDKVersion_3_6_5: Steinberg_uint32 = @bitCast(Steinberg_uint32, @as(c_int, 198149));
pub const Steinberg_Vst_SDKVersion_3_6_0: Steinberg_uint32 = @bitCast(Steinberg_uint32, @as(c_int, 198144));
pub const Steinberg_Vst_SDKVersion_3_5_0: Steinberg_uint32 = @bitCast(Steinberg_uint32, @as(c_int, 197888));
pub const Steinberg_Vst_SDKVersion_3_1_0: Steinberg_uint32 = @bitCast(Steinberg_uint32, @as(c_int, 196864));
pub const Steinberg_Vst_SDKVersion_3_0_0: Steinberg_uint32 = @bitCast(Steinberg_uint32, @as(c_int, 196608));
pub const Steinberg_Vst_kDefaultFactoryFlags: Steinberg_int32 = @as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4);
pub const Steinberg_Vst_PresetAttributes_kPlugInName: Steinberg_Vst_CString = "PlugInName";
pub const Steinberg_Vst_PresetAttributes_kPlugInCategory: Steinberg_Vst_CString = "PlugInCategory";
pub const Steinberg_Vst_PresetAttributes_kInstrument: Steinberg_Vst_CString = "MusicalInstrument";
pub const Steinberg_Vst_PresetAttributes_kStyle: Steinberg_Vst_CString = "MusicalStyle";
pub const Steinberg_Vst_PresetAttributes_kCharacter: Steinberg_Vst_CString = "MusicalCharacter";
pub const Steinberg_Vst_PresetAttributes_kStateType: Steinberg_Vst_CString = "StateType";
pub const Steinberg_Vst_PresetAttributes_kFilePathStringType: Steinberg_Vst_CString = "FilePathString";
pub const Steinberg_Vst_PresetAttributes_kName: Steinberg_Vst_CString = "Name";
pub const Steinberg_Vst_PresetAttributes_kFileName: Steinberg_Vst_CString = "FileName";
pub const Steinberg_Vst_StateType_kProject: Steinberg_Vst_CString = "Project";
pub const Steinberg_Vst_StateType_kDefault: Steinberg_Vst_CString = "Default";
pub const Steinberg_Vst_MusicalInstrument_kAccordion: Steinberg_Vst_CString = "Accordion";
pub const Steinberg_Vst_MusicalInstrument_kAccordionAccordion: Steinberg_Vst_CString = "Accordion|Accordion";
pub const Steinberg_Vst_MusicalInstrument_kAccordionHarmonica: Steinberg_Vst_CString = "Accordion|Harmonica";
pub const Steinberg_Vst_MusicalInstrument_kAccordionOther: Steinberg_Vst_CString = "Accordion|Other";
pub const Steinberg_Vst_MusicalInstrument_kBass: Steinberg_Vst_CString = "Bass";
pub const Steinberg_Vst_MusicalInstrument_kBassABass: Steinberg_Vst_CString = "Bass|A. Bass";
pub const Steinberg_Vst_MusicalInstrument_kBassEBass: Steinberg_Vst_CString = "Bass|E. Bass";
pub const Steinberg_Vst_MusicalInstrument_kBassSynthBass: Steinberg_Vst_CString = "Bass|Synth Bass";
pub const Steinberg_Vst_MusicalInstrument_kBassOther: Steinberg_Vst_CString = "Bass|Other";
pub const Steinberg_Vst_MusicalInstrument_kBrass: Steinberg_Vst_CString = "Brass";
pub const Steinberg_Vst_MusicalInstrument_kBrassFrenchHorn: Steinberg_Vst_CString = "Brass|French Horn";
pub const Steinberg_Vst_MusicalInstrument_kBrassTrumpet: Steinberg_Vst_CString = "Brass|Trumpet";
pub const Steinberg_Vst_MusicalInstrument_kBrassTrombone: Steinberg_Vst_CString = "Brass|Trombone";
pub const Steinberg_Vst_MusicalInstrument_kBrassTuba: Steinberg_Vst_CString = "Brass|Tuba";
pub const Steinberg_Vst_MusicalInstrument_kBrassSection: Steinberg_Vst_CString = "Brass|Section";
pub const Steinberg_Vst_MusicalInstrument_kBrassSynth: Steinberg_Vst_CString = "Brass|Synth";
pub const Steinberg_Vst_MusicalInstrument_kBrassOther: Steinberg_Vst_CString = "Brass|Other";
pub const Steinberg_Vst_MusicalInstrument_kChromaticPerc: Steinberg_Vst_CString = "Chromatic Perc";
pub const Steinberg_Vst_MusicalInstrument_kChromaticPercBell: Steinberg_Vst_CString = "Chromatic Perc|Bell";
pub const Steinberg_Vst_MusicalInstrument_kChromaticPercMallett: Steinberg_Vst_CString = "Chromatic Perc|Mallett";
pub const Steinberg_Vst_MusicalInstrument_kChromaticPercWood: Steinberg_Vst_CString = "Chromatic Perc|Wood";
pub const Steinberg_Vst_MusicalInstrument_kChromaticPercPercussion: Steinberg_Vst_CString = "Chromatic Perc|Percussion";
pub const Steinberg_Vst_MusicalInstrument_kChromaticPercTimpani: Steinberg_Vst_CString = "Chromatic Perc|Timpani";
pub const Steinberg_Vst_MusicalInstrument_kChromaticPercOther: Steinberg_Vst_CString = "Chromatic Perc|Other";
pub const Steinberg_Vst_MusicalInstrument_kDrumPerc: Steinberg_Vst_CString = "Drum&Perc";
pub const Steinberg_Vst_MusicalInstrument_kDrumPercDrumsetGM: Steinberg_Vst_CString = "Drum&Perc|Drumset GM";
pub const Steinberg_Vst_MusicalInstrument_kDrumPercDrumset: Steinberg_Vst_CString = "Drum&Perc|Drumset";
pub const Steinberg_Vst_MusicalInstrument_kDrumPercDrumMenues: Steinberg_Vst_CString = "Drum&Perc|Drum Menues";
pub const Steinberg_Vst_MusicalInstrument_kDrumPercBeats: Steinberg_Vst_CString = "Drum&Perc|Beats";
pub const Steinberg_Vst_MusicalInstrument_kDrumPercPercussion: Steinberg_Vst_CString = "Drum&Perc|Percussion";
pub const Steinberg_Vst_MusicalInstrument_kDrumPercKickDrum: Steinberg_Vst_CString = "Drum&Perc|Kick Drum";
pub const Steinberg_Vst_MusicalInstrument_kDrumPercSnareDrum: Steinberg_Vst_CString = "Drum&Perc|Snare Drum";
pub const Steinberg_Vst_MusicalInstrument_kDrumPercToms: Steinberg_Vst_CString = "Drum&Perc|Toms";
pub const Steinberg_Vst_MusicalInstrument_kDrumPercHiHats: Steinberg_Vst_CString = "Drum&Perc|HiHats";
pub const Steinberg_Vst_MusicalInstrument_kDrumPercCymbals: Steinberg_Vst_CString = "Drum&Perc|Cymbals";
pub const Steinberg_Vst_MusicalInstrument_kDrumPercOther: Steinberg_Vst_CString = "Drum&Perc|Other";
pub const Steinberg_Vst_MusicalInstrument_kEthnic: Steinberg_Vst_CString = "Ethnic";
pub const Steinberg_Vst_MusicalInstrument_kEthnicAsian: Steinberg_Vst_CString = "Ethnic|Asian";
pub const Steinberg_Vst_MusicalInstrument_kEthnicAfrican: Steinberg_Vst_CString = "Ethnic|African";
pub const Steinberg_Vst_MusicalInstrument_kEthnicEuropean: Steinberg_Vst_CString = "Ethnic|European";
pub const Steinberg_Vst_MusicalInstrument_kEthnicLatin: Steinberg_Vst_CString = "Ethnic|Latin";
pub const Steinberg_Vst_MusicalInstrument_kEthnicAmerican: Steinberg_Vst_CString = "Ethnic|American";
pub const Steinberg_Vst_MusicalInstrument_kEthnicAlien: Steinberg_Vst_CString = "Ethnic|Alien";
pub const Steinberg_Vst_MusicalInstrument_kEthnicOther: Steinberg_Vst_CString = "Ethnic|Other";
pub const Steinberg_Vst_MusicalInstrument_kGuitar: Steinberg_Vst_CString = "Guitar/Plucked";
pub const Steinberg_Vst_MusicalInstrument_kGuitarAGuitar: Steinberg_Vst_CString = "Guitar/Plucked|A. Guitar";
pub const Steinberg_Vst_MusicalInstrument_kGuitarEGuitar: Steinberg_Vst_CString = "Guitar/Plucked|E. Guitar";
pub const Steinberg_Vst_MusicalInstrument_kGuitarHarp: Steinberg_Vst_CString = "Guitar/Plucked|Harp";
pub const Steinberg_Vst_MusicalInstrument_kGuitarEthnic: Steinberg_Vst_CString = "Guitar/Plucked|Ethnic";
pub const Steinberg_Vst_MusicalInstrument_kGuitarOther: Steinberg_Vst_CString = "Guitar/Plucked|Other";
pub const Steinberg_Vst_MusicalInstrument_kKeyboard: Steinberg_Vst_CString = "Keyboard";
pub const Steinberg_Vst_MusicalInstrument_kKeyboardClavi: Steinberg_Vst_CString = "Keyboard|Clavi";
pub const Steinberg_Vst_MusicalInstrument_kKeyboardEPiano: Steinberg_Vst_CString = "Keyboard|E. Piano";
pub const Steinberg_Vst_MusicalInstrument_kKeyboardHarpsichord: Steinberg_Vst_CString = "Keyboard|Harpsichord";
pub const Steinberg_Vst_MusicalInstrument_kKeyboardOther: Steinberg_Vst_CString = "Keyboard|Other";
pub const Steinberg_Vst_MusicalInstrument_kMusicalFX: Steinberg_Vst_CString = "Musical FX";
pub const Steinberg_Vst_MusicalInstrument_kMusicalFXHitsStabs: Steinberg_Vst_CString = "Musical FX|Hits&Stabs";
pub const Steinberg_Vst_MusicalInstrument_kMusicalFXMotion: Steinberg_Vst_CString = "Musical FX|Motion";
pub const Steinberg_Vst_MusicalInstrument_kMusicalFXSweeps: Steinberg_Vst_CString = "Musical FX|Sweeps";
pub const Steinberg_Vst_MusicalInstrument_kMusicalFXBeepsBlips: Steinberg_Vst_CString = "Musical FX|Beeps&Blips";
pub const Steinberg_Vst_MusicalInstrument_kMusicalFXScratches: Steinberg_Vst_CString = "Musical FX|Scratches";
pub const Steinberg_Vst_MusicalInstrument_kMusicalFXOther: Steinberg_Vst_CString = "Musical FX|Other";
pub const Steinberg_Vst_MusicalInstrument_kOrgan: Steinberg_Vst_CString = "Organ";
pub const Steinberg_Vst_MusicalInstrument_kOrganElectric: Steinberg_Vst_CString = "Organ|Electric";
pub const Steinberg_Vst_MusicalInstrument_kOrganPipe: Steinberg_Vst_CString = "Organ|Pipe";
pub const Steinberg_Vst_MusicalInstrument_kOrganOther: Steinberg_Vst_CString = "Organ|Other";
pub const Steinberg_Vst_MusicalInstrument_kPiano: Steinberg_Vst_CString = "Piano";
pub const Steinberg_Vst_MusicalInstrument_kPianoAPiano: Steinberg_Vst_CString = "Piano|A. Piano";
pub const Steinberg_Vst_MusicalInstrument_kPianoEGrand: Steinberg_Vst_CString = "Piano|E. Grand";
pub const Steinberg_Vst_MusicalInstrument_kPianoOther: Steinberg_Vst_CString = "Piano|Other";
pub const Steinberg_Vst_MusicalInstrument_kSoundFX: Steinberg_Vst_CString = "Sound FX";
pub const Steinberg_Vst_MusicalInstrument_kSoundFXNature: Steinberg_Vst_CString = "Sound FX|Nature";
pub const Steinberg_Vst_MusicalInstrument_kSoundFXMechanical: Steinberg_Vst_CString = "Sound FX|Mechanical";
pub const Steinberg_Vst_MusicalInstrument_kSoundFXSynthetic: Steinberg_Vst_CString = "Sound FX|Synthetic";
pub const Steinberg_Vst_MusicalInstrument_kSoundFXOther: Steinberg_Vst_CString = "Sound FX|Other";
pub const Steinberg_Vst_MusicalInstrument_kStrings: Steinberg_Vst_CString = "Strings";
pub const Steinberg_Vst_MusicalInstrument_kStringsViolin: Steinberg_Vst_CString = "Strings|Violin";
pub const Steinberg_Vst_MusicalInstrument_kStringsViola: Steinberg_Vst_CString = "Strings|Viola";
pub const Steinberg_Vst_MusicalInstrument_kStringsCello: Steinberg_Vst_CString = "Strings|Cello";
pub const Steinberg_Vst_MusicalInstrument_kStringsBass: Steinberg_Vst_CString = "Strings|Bass";
pub const Steinberg_Vst_MusicalInstrument_kStringsSection: Steinberg_Vst_CString = "Strings|Section";
pub const Steinberg_Vst_MusicalInstrument_kStringsSynth: Steinberg_Vst_CString = "Strings|Synth";
pub const Steinberg_Vst_MusicalInstrument_kStringsOther: Steinberg_Vst_CString = "Strings|Other";
pub const Steinberg_Vst_MusicalInstrument_kSynthLead: Steinberg_Vst_CString = "Synth Lead";
pub const Steinberg_Vst_MusicalInstrument_kSynthLeadAnalog: Steinberg_Vst_CString = "Synth Lead|Analog";
pub const Steinberg_Vst_MusicalInstrument_kSynthLeadDigital: Steinberg_Vst_CString = "Synth Lead|Digital";
pub const Steinberg_Vst_MusicalInstrument_kSynthLeadArpeggio: Steinberg_Vst_CString = "Synth Lead|Arpeggio";
pub const Steinberg_Vst_MusicalInstrument_kSynthLeadOther: Steinberg_Vst_CString = "Synth Lead|Other";
pub const Steinberg_Vst_MusicalInstrument_kSynthPad: Steinberg_Vst_CString = "Synth Pad";
pub const Steinberg_Vst_MusicalInstrument_kSynthPadSynthChoir: Steinberg_Vst_CString = "Synth Pad|Synth Choir";
pub const Steinberg_Vst_MusicalInstrument_kSynthPadAnalog: Steinberg_Vst_CString = "Synth Pad|Analog";
pub const Steinberg_Vst_MusicalInstrument_kSynthPadDigital: Steinberg_Vst_CString = "Synth Pad|Digital";
pub const Steinberg_Vst_MusicalInstrument_kSynthPadMotion: Steinberg_Vst_CString = "Synth Pad|Motion";
pub const Steinberg_Vst_MusicalInstrument_kSynthPadOther: Steinberg_Vst_CString = "Synth Pad|Other";
pub const Steinberg_Vst_MusicalInstrument_kSynthComp: Steinberg_Vst_CString = "Synth Comp";
pub const Steinberg_Vst_MusicalInstrument_kSynthCompAnalog: Steinberg_Vst_CString = "Synth Comp|Analog";
pub const Steinberg_Vst_MusicalInstrument_kSynthCompDigital: Steinberg_Vst_CString = "Synth Comp|Digital";
pub const Steinberg_Vst_MusicalInstrument_kSynthCompOther: Steinberg_Vst_CString = "Synth Comp|Other";
pub const Steinberg_Vst_MusicalInstrument_kVocal: Steinberg_Vst_CString = "Vocal";
pub const Steinberg_Vst_MusicalInstrument_kVocalLeadVocal: Steinberg_Vst_CString = "Vocal|Lead Vocal";
pub const Steinberg_Vst_MusicalInstrument_kVocalAdlibs: Steinberg_Vst_CString = "Vocal|Adlibs";
pub const Steinberg_Vst_MusicalInstrument_kVocalChoir: Steinberg_Vst_CString = "Vocal|Choir";
pub const Steinberg_Vst_MusicalInstrument_kVocalSolo: Steinberg_Vst_CString = "Vocal|Solo";
pub const Steinberg_Vst_MusicalInstrument_kVocalFX: Steinberg_Vst_CString = "Vocal|FX";
pub const Steinberg_Vst_MusicalInstrument_kVocalSpoken: Steinberg_Vst_CString = "Vocal|Spoken";
pub const Steinberg_Vst_MusicalInstrument_kVocalOther: Steinberg_Vst_CString = "Vocal|Other";
pub const Steinberg_Vst_MusicalInstrument_kWoodwinds: Steinberg_Vst_CString = "Woodwinds";
pub const Steinberg_Vst_MusicalInstrument_kWoodwindsEthnic: Steinberg_Vst_CString = "Woodwinds|Ethnic";
pub const Steinberg_Vst_MusicalInstrument_kWoodwindsFlute: Steinberg_Vst_CString = "Woodwinds|Flute";
pub const Steinberg_Vst_MusicalInstrument_kWoodwindsOboe: Steinberg_Vst_CString = "Woodwinds|Oboe";
pub const Steinberg_Vst_MusicalInstrument_kWoodwindsEnglHorn: Steinberg_Vst_CString = "Woodwinds|Engl. Horn";
pub const Steinberg_Vst_MusicalInstrument_kWoodwindsClarinet: Steinberg_Vst_CString = "Woodwinds|Clarinet";
pub const Steinberg_Vst_MusicalInstrument_kWoodwindsSaxophone: Steinberg_Vst_CString = "Woodwinds|Saxophone";
pub const Steinberg_Vst_MusicalInstrument_kWoodwindsBassoon: Steinberg_Vst_CString = "Woodwinds|Bassoon";
pub const Steinberg_Vst_MusicalInstrument_kWoodwindsOther: Steinberg_Vst_CString = "Woodwinds|Other";
pub const Steinberg_Vst_MusicalStyle_kAlternativeIndie: Steinberg_Vst_CString = "Alternative/Indie";
pub const Steinberg_Vst_MusicalStyle_kAlternativeIndieGothRock: Steinberg_Vst_CString = "Alternative/Indie|Goth Rock";
pub const Steinberg_Vst_MusicalStyle_kAlternativeIndieGrunge: Steinberg_Vst_CString = "Alternative/Indie|Grunge";
pub const Steinberg_Vst_MusicalStyle_kAlternativeIndieNewWave: Steinberg_Vst_CString = "Alternative/Indie|New Wave";
pub const Steinberg_Vst_MusicalStyle_kAlternativeIndiePunk: Steinberg_Vst_CString = "Alternative/Indie|Punk";
pub const Steinberg_Vst_MusicalStyle_kAlternativeIndieCollegeRock: Steinberg_Vst_CString = "Alternative/Indie|College Rock";
pub const Steinberg_Vst_MusicalStyle_kAlternativeIndieDarkWave: Steinberg_Vst_CString = "Alternative/Indie|Dark Wave";
pub const Steinberg_Vst_MusicalStyle_kAlternativeIndieHardcore: Steinberg_Vst_CString = "Alternative/Indie|Hardcore";
pub const Steinberg_Vst_MusicalStyle_kAmbientChillOut: Steinberg_Vst_CString = "Ambient/ChillOut";
pub const Steinberg_Vst_MusicalStyle_kAmbientChillOutNewAgeMeditation: Steinberg_Vst_CString = "Ambient/ChillOut|New Age/Meditation";
pub const Steinberg_Vst_MusicalStyle_kAmbientChillOutDarkAmbient: Steinberg_Vst_CString = "Ambient/ChillOut|Dark Ambient";
pub const Steinberg_Vst_MusicalStyle_kAmbientChillOutDowntempo: Steinberg_Vst_CString = "Ambient/ChillOut|Downtempo";
pub const Steinberg_Vst_MusicalStyle_kAmbientChillOutLounge: Steinberg_Vst_CString = "Ambient/ChillOut|Lounge";
pub const Steinberg_Vst_MusicalStyle_kBlues: Steinberg_Vst_CString = "Blues";
pub const Steinberg_Vst_MusicalStyle_kBluesAcousticBlues: Steinberg_Vst_CString = "Blues|Acoustic Blues";
pub const Steinberg_Vst_MusicalStyle_kBluesCountryBlues: Steinberg_Vst_CString = "Blues|Country Blues";
pub const Steinberg_Vst_MusicalStyle_kBluesElectricBlues: Steinberg_Vst_CString = "Blues|Electric Blues";
pub const Steinberg_Vst_MusicalStyle_kBluesChicagoBlues: Steinberg_Vst_CString = "Blues|Chicago Blues";
pub const Steinberg_Vst_MusicalStyle_kClassical: Steinberg_Vst_CString = "Classical";
pub const Steinberg_Vst_MusicalStyle_kClassicalBaroque: Steinberg_Vst_CString = "Classical|Baroque";
pub const Steinberg_Vst_MusicalStyle_kClassicalChamberMusic: Steinberg_Vst_CString = "Classical|Chamber Music";
pub const Steinberg_Vst_MusicalStyle_kClassicalMedieval: Steinberg_Vst_CString = "Classical|Medieval";
pub const Steinberg_Vst_MusicalStyle_kClassicalModernComposition: Steinberg_Vst_CString = "Classical|Modern Composition";
pub const Steinberg_Vst_MusicalStyle_kClassicalOpera: Steinberg_Vst_CString = "Classical|Opera";
pub const Steinberg_Vst_MusicalStyle_kClassicalGregorian: Steinberg_Vst_CString = "Classical|Gregorian";
pub const Steinberg_Vst_MusicalStyle_kClassicalRenaissance: Steinberg_Vst_CString = "Classical|Renaissance";
pub const Steinberg_Vst_MusicalStyle_kClassicalClassic: Steinberg_Vst_CString = "Classical|Classic";
pub const Steinberg_Vst_MusicalStyle_kClassicalRomantic: Steinberg_Vst_CString = "Classical|Romantic";
pub const Steinberg_Vst_MusicalStyle_kClassicalSoundtrack: Steinberg_Vst_CString = "Classical|Soundtrack";
pub const Steinberg_Vst_MusicalStyle_kCountry: Steinberg_Vst_CString = "Country";
pub const Steinberg_Vst_MusicalStyle_kCountryCountryWestern: Steinberg_Vst_CString = "Country|Country/Western";
pub const Steinberg_Vst_MusicalStyle_kCountryHonkyTonk: Steinberg_Vst_CString = "Country|Honky Tonk";
pub const Steinberg_Vst_MusicalStyle_kCountryUrbanCowboy: Steinberg_Vst_CString = "Country|Urban Cowboy";
pub const Steinberg_Vst_MusicalStyle_kCountryBluegrass: Steinberg_Vst_CString = "Country|Bluegrass";
pub const Steinberg_Vst_MusicalStyle_kCountryAmericana: Steinberg_Vst_CString = "Country|Americana";
pub const Steinberg_Vst_MusicalStyle_kCountrySquaredance: Steinberg_Vst_CString = "Country|Squaredance";
pub const Steinberg_Vst_MusicalStyle_kCountryNorthAmericanFolk: Steinberg_Vst_CString = "Country|North American Folk";
pub const Steinberg_Vst_MusicalStyle_kElectronicaDance: Steinberg_Vst_CString = "Electronica/Dance";
pub const Steinberg_Vst_MusicalStyle_kElectronicaDanceMinimal: Steinberg_Vst_CString = "Electronica/Dance|Minimal";
pub const Steinberg_Vst_MusicalStyle_kElectronicaDanceClassicHouse: Steinberg_Vst_CString = "Electronica/Dance|Classic House";
pub const Steinberg_Vst_MusicalStyle_kElectronicaDanceElektroHouse: Steinberg_Vst_CString = "Electronica/Dance|Elektro House";
pub const Steinberg_Vst_MusicalStyle_kElectronicaDanceFunkyHouse: Steinberg_Vst_CString = "Electronica/Dance|Funky House";
pub const Steinberg_Vst_MusicalStyle_kElectronicaDanceIndustrial: Steinberg_Vst_CString = "Electronica/Dance|Industrial";
pub const Steinberg_Vst_MusicalStyle_kElectronicaDanceElectronicBodyMusic: Steinberg_Vst_CString = "Electronica/Dance|Electronic Body Music";
pub const Steinberg_Vst_MusicalStyle_kElectronicaDanceTripHop: Steinberg_Vst_CString = "Electronica/Dance|Trip Hop";
pub const Steinberg_Vst_MusicalStyle_kElectronicaDanceTechno: Steinberg_Vst_CString = "Electronica/Dance|Techno";
pub const Steinberg_Vst_MusicalStyle_kElectronicaDanceDrumNBassJungle: Steinberg_Vst_CString = "Electronica/Dance|Drum'n'Bass/Jungle";
pub const Steinberg_Vst_MusicalStyle_kElectronicaDanceElektro: Steinberg_Vst_CString = "Electronica/Dance|Elektro";
pub const Steinberg_Vst_MusicalStyle_kElectronicaDanceTrance: Steinberg_Vst_CString = "Electronica/Dance|Trance";
pub const Steinberg_Vst_MusicalStyle_kElectronicaDanceDub: Steinberg_Vst_CString = "Electronica/Dance|Dub";
pub const Steinberg_Vst_MusicalStyle_kElectronicaDanceBigBeats: Steinberg_Vst_CString = "Electronica/Dance|Big Beats";
pub const Steinberg_Vst_MusicalStyle_kExperimental: Steinberg_Vst_CString = "Experimental";
pub const Steinberg_Vst_MusicalStyle_kExperimentalNewMusic: Steinberg_Vst_CString = "Experimental|New Music";
pub const Steinberg_Vst_MusicalStyle_kExperimentalFreeImprovisation: Steinberg_Vst_CString = "Experimental|Free Improvisation";
pub const Steinberg_Vst_MusicalStyle_kExperimentalElectronicArtMusic: Steinberg_Vst_CString = "Experimental|Electronic Art Music";
pub const Steinberg_Vst_MusicalStyle_kExperimentalNoise: Steinberg_Vst_CString = "Experimental|Noise";
pub const Steinberg_Vst_MusicalStyle_kJazz: Steinberg_Vst_CString = "Jazz";
pub const Steinberg_Vst_MusicalStyle_kJazzNewOrleansJazz: Steinberg_Vst_CString = "Jazz|New Orleans Jazz";
pub const Steinberg_Vst_MusicalStyle_kJazzTraditionalJazz: Steinberg_Vst_CString = "Jazz|Traditional Jazz";
pub const Steinberg_Vst_MusicalStyle_kJazzOldtimeJazzDixiland: Steinberg_Vst_CString = "Jazz|Oldtime Jazz/Dixiland";
pub const Steinberg_Vst_MusicalStyle_kJazzFusion: Steinberg_Vst_CString = "Jazz|Fusion";
pub const Steinberg_Vst_MusicalStyle_kJazzAvantgarde: Steinberg_Vst_CString = "Jazz|Avantgarde";
pub const Steinberg_Vst_MusicalStyle_kJazzLatinJazz: Steinberg_Vst_CString = "Jazz|Latin Jazz";
pub const Steinberg_Vst_MusicalStyle_kJazzFreeJazz: Steinberg_Vst_CString = "Jazz|Free Jazz";
pub const Steinberg_Vst_MusicalStyle_kJazzRagtime: Steinberg_Vst_CString = "Jazz|Ragtime";
pub const Steinberg_Vst_MusicalStyle_kPop: Steinberg_Vst_CString = "Pop";
pub const Steinberg_Vst_MusicalStyle_kPopBritpop: Steinberg_Vst_CString = "Pop|Britpop";
pub const Steinberg_Vst_MusicalStyle_kPopRock: Steinberg_Vst_CString = "Pop|Pop/Rock";
pub const Steinberg_Vst_MusicalStyle_kPopTeenPop: Steinberg_Vst_CString = "Pop|Teen Pop";
pub const Steinberg_Vst_MusicalStyle_kPopChartDance: Steinberg_Vst_CString = "Pop|Chart Dance";
pub const Steinberg_Vst_MusicalStyle_kPop80sPop: Steinberg_Vst_CString = "Pop|80's Pop";
pub const Steinberg_Vst_MusicalStyle_kPopDancehall: Steinberg_Vst_CString = "Pop|Dancehall";
pub const Steinberg_Vst_MusicalStyle_kPopDisco: Steinberg_Vst_CString = "Pop|Disco";
pub const Steinberg_Vst_MusicalStyle_kRockMetal: Steinberg_Vst_CString = "Rock/Metal";
pub const Steinberg_Vst_MusicalStyle_kRockMetalBluesRock: Steinberg_Vst_CString = "Rock/Metal|Blues Rock";
pub const Steinberg_Vst_MusicalStyle_kRockMetalClassicRock: Steinberg_Vst_CString = "Rock/Metal|Classic Rock";
pub const Steinberg_Vst_MusicalStyle_kRockMetalHardRock: Steinberg_Vst_CString = "Rock/Metal|Hard Rock";
pub const Steinberg_Vst_MusicalStyle_kRockMetalRockRoll: Steinberg_Vst_CString = "Rock/Metal|Rock &amp; Roll";
pub const Steinberg_Vst_MusicalStyle_kRockMetalSingerSongwriter: Steinberg_Vst_CString = "Rock/Metal|Singer/Songwriter";
pub const Steinberg_Vst_MusicalStyle_kRockMetalHeavyMetal: Steinberg_Vst_CString = "Rock/Metal|Heavy Metal";
pub const Steinberg_Vst_MusicalStyle_kRockMetalDeathBlackMetal: Steinberg_Vst_CString = "Rock/Metal|Death/Black Metal";
pub const Steinberg_Vst_MusicalStyle_kRockMetalNuMetal: Steinberg_Vst_CString = "Rock/Metal|NuMetal";
pub const Steinberg_Vst_MusicalStyle_kRockMetalReggae: Steinberg_Vst_CString = "Rock/Metal|Reggae";
pub const Steinberg_Vst_MusicalStyle_kRockMetalBallad: Steinberg_Vst_CString = "Rock/Metal|Ballad";
pub const Steinberg_Vst_MusicalStyle_kRockMetalAlternativeRock: Steinberg_Vst_CString = "Rock/Metal|Alternative Rock";
pub const Steinberg_Vst_MusicalStyle_kRockMetalRockabilly: Steinberg_Vst_CString = "Rock/Metal|Rockabilly";
pub const Steinberg_Vst_MusicalStyle_kRockMetalThrashMetal: Steinberg_Vst_CString = "Rock/Metal|Thrash Metal";
pub const Steinberg_Vst_MusicalStyle_kRockMetalProgressiveRock: Steinberg_Vst_CString = "Rock/Metal|Progressive Rock";
pub const Steinberg_Vst_MusicalStyle_kUrbanHipHopRB: Steinberg_Vst_CString = "Urban (Hip-Hop / R&B)";
pub const Steinberg_Vst_MusicalStyle_kUrbanHipHopRBClassic: Steinberg_Vst_CString = "Urban (Hip-Hop / R&B)|Classic R&B";
pub const Steinberg_Vst_MusicalStyle_kUrbanHipHopRBModern: Steinberg_Vst_CString = "Urban (Hip-Hop / R&B)|Modern R&B";
pub const Steinberg_Vst_MusicalStyle_kUrbanHipHopRBPop: Steinberg_Vst_CString = "Urban (Hip-Hop / R&B)|R&B Pop";
pub const Steinberg_Vst_MusicalStyle_kUrbanHipHopRBWestCoastHipHop: Steinberg_Vst_CString = "Urban (Hip-Hop / R&B)|WestCoast Hip-Hop";
pub const Steinberg_Vst_MusicalStyle_kUrbanHipHopRBEastCoastHipHop: Steinberg_Vst_CString = "Urban (Hip-Hop / R&B)|EastCoast Hip-Hop";
pub const Steinberg_Vst_MusicalStyle_kUrbanHipHopRBRapHipHop: Steinberg_Vst_CString = "Urban (Hip-Hop / R&B)|Rap/Hip Hop";
pub const Steinberg_Vst_MusicalStyle_kUrbanHipHopRBSoul: Steinberg_Vst_CString = "Urban (Hip-Hop / R&B)|Soul";
pub const Steinberg_Vst_MusicalStyle_kUrbanHipHopRBFunk: Steinberg_Vst_CString = "Urban (Hip-Hop / R&B)|Funk";
pub const Steinberg_Vst_MusicalStyle_kWorldEthnic: Steinberg_Vst_CString = "World/Ethnic";
pub const Steinberg_Vst_MusicalStyle_kWorldEthnicAfrica: Steinberg_Vst_CString = "World/Ethnic|Africa";
pub const Steinberg_Vst_MusicalStyle_kWorldEthnicAsia: Steinberg_Vst_CString = "World/Ethnic|Asia";
pub const Steinberg_Vst_MusicalStyle_kWorldEthnicCeltic: Steinberg_Vst_CString = "World/Ethnic|Celtic";
pub const Steinberg_Vst_MusicalStyle_kWorldEthnicEurope: Steinberg_Vst_CString = "World/Ethnic|Europe";
pub const Steinberg_Vst_MusicalStyle_kWorldEthnicKlezmer: Steinberg_Vst_CString = "World/Ethnic|Klezmer";
pub const Steinberg_Vst_MusicalStyle_kWorldEthnicScandinavia: Steinberg_Vst_CString = "World/Ethnic|Scandinavia";
pub const Steinberg_Vst_MusicalStyle_kWorldEthnicEasternEurope: Steinberg_Vst_CString = "World/Ethnic|Eastern Europe";
pub const Steinberg_Vst_MusicalStyle_kWorldEthnicIndiaOriental: Steinberg_Vst_CString = "World/Ethnic|India/Oriental";
pub const Steinberg_Vst_MusicalStyle_kWorldEthnicNorthAmerica: Steinberg_Vst_CString = "World/Ethnic|North America";
pub const Steinberg_Vst_MusicalStyle_kWorldEthnicSouthAmerica: Steinberg_Vst_CString = "World/Ethnic|South America";
pub const Steinberg_Vst_MusicalStyle_kWorldEthnicAustralia: Steinberg_Vst_CString = "World/Ethnic|Australia";
pub const Steinberg_Vst_MusicalCharacter_kMono: Steinberg_Vst_CString = "Mono";
pub const Steinberg_Vst_MusicalCharacter_kPoly: Steinberg_Vst_CString = "Poly";
pub const Steinberg_Vst_MusicalCharacter_kSplit: Steinberg_Vst_CString = "Split";
pub const Steinberg_Vst_MusicalCharacter_kLayer: Steinberg_Vst_CString = "Layer";
pub const Steinberg_Vst_MusicalCharacter_kGlide: Steinberg_Vst_CString = "Glide";
pub const Steinberg_Vst_MusicalCharacter_kGlissando: Steinberg_Vst_CString = "Glissando";
pub const Steinberg_Vst_MusicalCharacter_kMajor: Steinberg_Vst_CString = "Major";
pub const Steinberg_Vst_MusicalCharacter_kMinor: Steinberg_Vst_CString = "Minor";
pub const Steinberg_Vst_MusicalCharacter_kSingle: Steinberg_Vst_CString = "Single";
pub const Steinberg_Vst_MusicalCharacter_kEnsemble: Steinberg_Vst_CString = "Ensemble";
pub const Steinberg_Vst_MusicalCharacter_kAcoustic: Steinberg_Vst_CString = "Acoustic";
pub const Steinberg_Vst_MusicalCharacter_kElectric: Steinberg_Vst_CString = "Electric";
pub const Steinberg_Vst_MusicalCharacter_kAnalog: Steinberg_Vst_CString = "Analog";
pub const Steinberg_Vst_MusicalCharacter_kDigital: Steinberg_Vst_CString = "Digital";
pub const Steinberg_Vst_MusicalCharacter_kVintage: Steinberg_Vst_CString = "Vintage";
pub const Steinberg_Vst_MusicalCharacter_kModern: Steinberg_Vst_CString = "Modern";
pub const Steinberg_Vst_MusicalCharacter_kOld: Steinberg_Vst_CString = "Old";
pub const Steinberg_Vst_MusicalCharacter_kNew: Steinberg_Vst_CString = "New";
pub const Steinberg_Vst_MusicalCharacter_kClean: Steinberg_Vst_CString = "Clean";
pub const Steinberg_Vst_MusicalCharacter_kDistorted: Steinberg_Vst_CString = "Distorted";
pub const Steinberg_Vst_MusicalCharacter_kDry: Steinberg_Vst_CString = "Dry";
pub const Steinberg_Vst_MusicalCharacter_kProcessed: Steinberg_Vst_CString = "Processed";
pub const Steinberg_Vst_MusicalCharacter_kHarmonic: Steinberg_Vst_CString = "Harmonic";
pub const Steinberg_Vst_MusicalCharacter_kDissonant: Steinberg_Vst_CString = "Dissonant";
pub const Steinberg_Vst_MusicalCharacter_kClear: Steinberg_Vst_CString = "Clear";
pub const Steinberg_Vst_MusicalCharacter_kNoisy: Steinberg_Vst_CString = "Noisy";
pub const Steinberg_Vst_MusicalCharacter_kThin: Steinberg_Vst_CString = "Thin";
pub const Steinberg_Vst_MusicalCharacter_kRich: Steinberg_Vst_CString = "Rich";
pub const Steinberg_Vst_MusicalCharacter_kDark: Steinberg_Vst_CString = "Dark";
pub const Steinberg_Vst_MusicalCharacter_kBright: Steinberg_Vst_CString = "Bright";
pub const Steinberg_Vst_MusicalCharacter_kCold: Steinberg_Vst_CString = "Cold";
pub const Steinberg_Vst_MusicalCharacter_kWarm: Steinberg_Vst_CString = "Warm";
pub const Steinberg_Vst_MusicalCharacter_kMetallic: Steinberg_Vst_CString = "Metallic";
pub const Steinberg_Vst_MusicalCharacter_kWooden: Steinberg_Vst_CString = "Wooden";
pub const Steinberg_Vst_MusicalCharacter_kGlass: Steinberg_Vst_CString = "Glass";
pub const Steinberg_Vst_MusicalCharacter_kPlastic: Steinberg_Vst_CString = "Plastic";
pub const Steinberg_Vst_MusicalCharacter_kPercussive: Steinberg_Vst_CString = "Percussive";
pub const Steinberg_Vst_MusicalCharacter_kSoft: Steinberg_Vst_CString = "Soft";
pub const Steinberg_Vst_MusicalCharacter_kFast: Steinberg_Vst_CString = "Fast";
pub const Steinberg_Vst_MusicalCharacter_kSlow: Steinberg_Vst_CString = "Slow";
pub const Steinberg_Vst_MusicalCharacter_kShort: Steinberg_Vst_CString = "Short";
pub const Steinberg_Vst_MusicalCharacter_kLong: Steinberg_Vst_CString = "Long";
pub const Steinberg_Vst_MusicalCharacter_kAttack: Steinberg_Vst_CString = "Attack";
pub const Steinberg_Vst_MusicalCharacter_kRelease: Steinberg_Vst_CString = "Release";
pub const Steinberg_Vst_MusicalCharacter_kDecay: Steinberg_Vst_CString = "Decay";
pub const Steinberg_Vst_MusicalCharacter_kSustain: Steinberg_Vst_CString = "Sustain";
pub const Steinberg_Vst_MusicalCharacter_kFastAttack: Steinberg_Vst_CString = "Fast Attack";
pub const Steinberg_Vst_MusicalCharacter_kSlowAttack: Steinberg_Vst_CString = "Slow Attack";
pub const Steinberg_Vst_MusicalCharacter_kShortRelease: Steinberg_Vst_CString = "Short Release";
pub const Steinberg_Vst_MusicalCharacter_kLongRelease: Steinberg_Vst_CString = "Long Release";
pub const Steinberg_Vst_MusicalCharacter_kStatic: Steinberg_Vst_CString = "Static";
pub const Steinberg_Vst_MusicalCharacter_kMoving: Steinberg_Vst_CString = "Moving";
pub const Steinberg_Vst_MusicalCharacter_kLoop: Steinberg_Vst_CString = "Loop";
pub const Steinberg_Vst_MusicalCharacter_kOneShot: Steinberg_Vst_CString = "One Shot";
pub const Steinberg_Vst_ViewType_kEditor: Steinberg_Vst_CString = "editor";
pub const Steinberg_Vst_kSpeakerL: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)));
pub const Steinberg_Vst_kSpeakerR: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1)));
pub const Steinberg_Vst_kSpeakerC: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2)));
pub const Steinberg_Vst_kSpeakerLfe: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3)));
pub const Steinberg_Vst_kSpeakerLs: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4)));
pub const Steinberg_Vst_kSpeakerRs: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5)));
pub const Steinberg_Vst_kSpeakerLc: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 6)));
pub const Steinberg_Vst_kSpeakerRc: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 7)));
pub const Steinberg_Vst_kSpeakerS: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 8)));
pub const Steinberg_Vst_kSpeakerCs: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 8)));
pub const Steinberg_Vst_kSpeakerSl: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 9)));
pub const Steinberg_Vst_kSpeakerSr: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 10)));
pub const Steinberg_Vst_kSpeakerTc: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 11)));
pub const Steinberg_Vst_kSpeakerTfl: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12)));
pub const Steinberg_Vst_kSpeakerTfc: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 13)));
pub const Steinberg_Vst_kSpeakerTfr: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14)));
pub const Steinberg_Vst_kSpeakerTrl: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15)));
pub const Steinberg_Vst_kSpeakerTrc: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 16)));
pub const Steinberg_Vst_kSpeakerTrr: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17)));
pub const Steinberg_Vst_kSpeakerLfe2: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 18)));
pub const Steinberg_Vst_kSpeakerM: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 19)));
pub const Steinberg_Vst_kSpeakerACN0: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 20);
pub const Steinberg_Vst_kSpeakerACN1: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 21);
pub const Steinberg_Vst_kSpeakerACN2: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 22);
pub const Steinberg_Vst_kSpeakerACN3: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 23);
pub const Steinberg_Vst_kSpeakerACN4: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 38);
pub const Steinberg_Vst_kSpeakerACN5: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 39);
pub const Steinberg_Vst_kSpeakerACN6: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 40);
pub const Steinberg_Vst_kSpeakerACN7: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 41);
pub const Steinberg_Vst_kSpeakerACN8: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 42);
pub const Steinberg_Vst_kSpeakerACN9: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 43);
pub const Steinberg_Vst_kSpeakerACN10: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 44);
pub const Steinberg_Vst_kSpeakerACN11: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 45);
pub const Steinberg_Vst_kSpeakerACN12: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 46);
pub const Steinberg_Vst_kSpeakerACN13: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 47);
pub const Steinberg_Vst_kSpeakerACN14: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 48);
pub const Steinberg_Vst_kSpeakerACN15: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 49);
pub const Steinberg_Vst_kSpeakerACN16: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 50);
pub const Steinberg_Vst_kSpeakerACN17: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 51);
pub const Steinberg_Vst_kSpeakerACN18: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 52);
pub const Steinberg_Vst_kSpeakerACN19: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 53);
pub const Steinberg_Vst_kSpeakerACN20: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 54);
pub const Steinberg_Vst_kSpeakerACN21: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 55);
pub const Steinberg_Vst_kSpeakerACN22: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 56);
pub const Steinberg_Vst_kSpeakerACN23: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 57);
pub const Steinberg_Vst_kSpeakerACN24: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 58);
pub const Steinberg_Vst_kSpeakerTsl: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 24);
pub const Steinberg_Vst_kSpeakerTsr: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 25);
pub const Steinberg_Vst_kSpeakerLcs: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 26);
pub const Steinberg_Vst_kSpeakerRcs: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 27);
pub const Steinberg_Vst_kSpeakerBfl: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 28);
pub const Steinberg_Vst_kSpeakerBfc: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 29);
pub const Steinberg_Vst_kSpeakerBfr: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 30);
pub const Steinberg_Vst_kSpeakerPl: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 31);
pub const Steinberg_Vst_kSpeakerPr: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 32);
pub const Steinberg_Vst_kSpeakerBsl: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 33);
pub const Steinberg_Vst_kSpeakerBsr: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 34);
pub const Steinberg_Vst_kSpeakerBrl: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 35);
pub const Steinberg_Vst_kSpeakerBrc: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 36);
pub const Steinberg_Vst_kSpeakerBrr: Steinberg_Vst_Speaker = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 37);
pub const Steinberg_Vst_SpeakerArr_kEmpty: Steinberg_Vst_SpeakerArrangement = 0;
pub const Steinberg_Vst_SpeakerArr_kMono: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, @as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 19)));
pub const Steinberg_Vst_SpeakerArr_kStereo: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))));
pub const Steinberg_Vst_SpeakerArr_kStereoSurround: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))));
pub const Steinberg_Vst_SpeakerArr_kStereoCenter: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 6)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 7))));
pub const Steinberg_Vst_SpeakerArr_kStereoSide: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 9)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 10))));
pub const Steinberg_Vst_SpeakerArr_kStereoCLfe: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3))));
pub const Steinberg_Vst_SpeakerArr_kStereoTF: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))));
pub const Steinberg_Vst_SpeakerArr_kStereoTS: Steinberg_Vst_SpeakerArrangement = (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 24)) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 25));
pub const Steinberg_Vst_SpeakerArr_kStereoTR: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17))));
pub const Steinberg_Vst_SpeakerArr_kStereoBF: Steinberg_Vst_SpeakerArrangement = (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 28)) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 30));
pub const Steinberg_Vst_SpeakerArr_kCineFront: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, ((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 6))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 7))));
pub const Steinberg_Vst_SpeakerArr_k30Cine: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, ((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))));
pub const Steinberg_Vst_SpeakerArr_k31Cine: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, (((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3))));
pub const Steinberg_Vst_SpeakerArr_k30Music: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, ((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 8))));
pub const Steinberg_Vst_SpeakerArr_k31Music: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, (((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 8))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3))));
pub const Steinberg_Vst_SpeakerArr_k40Cine: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, (((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 8))));
pub const Steinberg_Vst_SpeakerArr_k41Cine: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, ((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 8))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3))));
pub const Steinberg_Vst_SpeakerArr_k40Music: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, (((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))));
pub const Steinberg_Vst_SpeakerArr_k41Music: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, ((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3))));
pub const Steinberg_Vst_SpeakerArr_k50: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, ((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))));
pub const Steinberg_Vst_SpeakerArr_k51: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, (((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3))));
pub const Steinberg_Vst_SpeakerArr_k60Cine: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, (((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 8))));
pub const Steinberg_Vst_SpeakerArr_k61Cine: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, ((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 8))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3))));
pub const Steinberg_Vst_SpeakerArr_k60Music: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, (((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 9))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 10))));
pub const Steinberg_Vst_SpeakerArr_k61Music: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, ((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 9))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 10))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3))));
pub const Steinberg_Vst_SpeakerArr_k70Cine: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, ((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 6))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 7))));
pub const Steinberg_Vst_SpeakerArr_k71Cine: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, (((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 6))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 7))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3))));
pub const Steinberg_Vst_SpeakerArr_k71CineFullFront: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, (((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 6))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 7))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3))));
pub const Steinberg_Vst_SpeakerArr_k70Music: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, ((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 9))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 10))));
pub const Steinberg_Vst_SpeakerArr_k71Music: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, (((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 9))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 10))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3))));
pub const Steinberg_Vst_SpeakerArr_k71CineFullRear: Steinberg_Vst_SpeakerArrangement = (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, (((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5)))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 26))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 27));
pub const Steinberg_Vst_SpeakerArr_k71CineSideFill: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, (((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 9))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 10))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3))));
pub const Steinberg_Vst_SpeakerArr_k71Proximity: Steinberg_Vst_SpeakerArrangement = (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, (((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5)))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 31))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 32));
pub const Steinberg_Vst_SpeakerArr_k80Cine: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, (((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 6))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 7))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 8))));
pub const Steinberg_Vst_SpeakerArr_k81Cine: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, ((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 6))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 7))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 8))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3))));
pub const Steinberg_Vst_SpeakerArr_k80Music: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, (((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 8))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 9))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 10))));
pub const Steinberg_Vst_SpeakerArr_k81Music: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, ((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 8))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 9))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 10))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3))));
pub const Steinberg_Vst_SpeakerArr_k90Cine: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, ((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 6))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 7))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 9))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 10))));
pub const Steinberg_Vst_SpeakerArr_k91Cine: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, (((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 6))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 7))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 9))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 10))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3))));
pub const Steinberg_Vst_SpeakerArr_k100Cine: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, (((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 6))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 7))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 8))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 9))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 10))));
pub const Steinberg_Vst_SpeakerArr_k101Cine: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, ((((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 6))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 7))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 8))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 9))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 10))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3))));
pub const Steinberg_Vst_SpeakerArr_kAmbi1stOrderACN: Steinberg_Vst_SpeakerArrangement = (((@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 20)) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 21))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 22))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 23));
pub const Steinberg_Vst_SpeakerArr_kAmbi2cdOrderACN: Steinberg_Vst_SpeakerArrangement = ((((((((@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 20)) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 21))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 22))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 23))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 38))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 39))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 40))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 41))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 42));
pub const Steinberg_Vst_SpeakerArr_kAmbi3rdOrderACN: Steinberg_Vst_SpeakerArrangement = (((((((((((((((@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 20)) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 21))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 22))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 23))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 38))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 39))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 40))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 41))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 42))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 43))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 44))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 45))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 46))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 47))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 48))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 49));
pub const Steinberg_Vst_SpeakerArr_kAmbi4thOrderACN: Steinberg_Vst_SpeakerArrangement = ((((((((((((((((((((((((@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 20)) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 21))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 22))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 23))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 38))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 39))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 40))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 41))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 42))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 43))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 44))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 45))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 46))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 47))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 48))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 49))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 50))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 51))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 52))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 53))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 54))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 55))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 56))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 57))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 58));
pub const Steinberg_Vst_SpeakerArr_kAmbi5thOrderACN: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, 68719476735));
pub const Steinberg_Vst_SpeakerArr_kAmbi6thOrderACN: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, 562949953421311));
pub const Steinberg_Vst_SpeakerArr_kAmbi7thOrderACN: Steinberg_Vst_SpeakerArrangement = 18446744073709551615;
pub const Steinberg_Vst_SpeakerArr_k80Cube: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, (((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17))));
pub const Steinberg_Vst_SpeakerArr_k40_4: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, (((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17))));
pub const Steinberg_Vst_SpeakerArr_k71CineTopCenter: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, (((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 8))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 11))));
pub const Steinberg_Vst_SpeakerArr_k71CineCenterHigh: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, (((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 8))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 13))));
pub const Steinberg_Vst_SpeakerArr_k70CineFrontHigh: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, ((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))));
pub const Steinberg_Vst_SpeakerArr_k70MPEG3D: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, ((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))));
pub const Steinberg_Vst_SpeakerArr_k50_2: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, ((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))));
pub const Steinberg_Vst_SpeakerArr_k71CineFrontHigh: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, (((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3))));
pub const Steinberg_Vst_SpeakerArr_k71MPEG3D: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, (((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3))));
pub const Steinberg_Vst_SpeakerArr_k51_2: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, (((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3))));
pub const Steinberg_Vst_SpeakerArr_k70CineSideHigh: Steinberg_Vst_SpeakerArrangement = (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, ((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5)))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 24))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 25));
pub const Steinberg_Vst_SpeakerArr_k50_2_TS: Steinberg_Vst_SpeakerArrangement = (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, ((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5)))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 24))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 25));
pub const Steinberg_Vst_SpeakerArr_k71CineSideHigh: Steinberg_Vst_SpeakerArrangement = ((@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, ((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5)))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 24))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 25))) | @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3)));
pub const Steinberg_Vst_SpeakerArr_k51_2_TS: Steinberg_Vst_SpeakerArrangement = ((@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, ((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5)))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 24))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 25))) | @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3)));
pub const Steinberg_Vst_SpeakerArr_k81MPEG3D: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, (((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 13))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14)))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 29));
pub const Steinberg_Vst_SpeakerArr_k41_4_1: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, (((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 13))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14)))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 29));
pub const Steinberg_Vst_SpeakerArr_k90: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, ((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17))));
pub const Steinberg_Vst_SpeakerArr_k50_4: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, ((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17))));
pub const Steinberg_Vst_SpeakerArr_k91: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, (((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3))));
pub const Steinberg_Vst_SpeakerArr_k51_4: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, (((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3))));
pub const Steinberg_Vst_SpeakerArr_k50_4_1: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, ((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17)))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 29));
pub const Steinberg_Vst_SpeakerArr_k51_4_1: Steinberg_Vst_SpeakerArrangement = (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, ((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17)))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 29))) | @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3)));
pub const Steinberg_Vst_SpeakerArr_k70_2: Steinberg_Vst_SpeakerArrangement = (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, ((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 9))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 10)))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 24))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 25));
pub const Steinberg_Vst_SpeakerArr_k71_2: Steinberg_Vst_SpeakerArrangement = ((@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, ((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 9))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 10)))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 24))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 25))) | @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3)));
pub const Steinberg_Vst_SpeakerArr_k91Atmos: Steinberg_Vst_SpeakerArrangement = ((@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, ((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 9))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 10)))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 24))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 25))) | @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3)));
pub const Steinberg_Vst_SpeakerArr_k70_3: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, (((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 9))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 10))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 16))));
pub const Steinberg_Vst_SpeakerArr_k72_3: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, (((((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 9))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 10))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 16))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 18))));
pub const Steinberg_Vst_SpeakerArr_k70_4: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, ((((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 9))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 10))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17))));
pub const Steinberg_Vst_SpeakerArr_k71_4: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, (((((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 9))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 10))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3))));
pub const Steinberg_Vst_SpeakerArr_k111MPEG3D: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, (((((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 9))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 10))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3))));
pub const Steinberg_Vst_SpeakerArr_k70_6: Steinberg_Vst_SpeakerArrangement = (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, ((((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 9))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 10))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17)))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 24))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 25));
pub const Steinberg_Vst_SpeakerArr_k71_6: Steinberg_Vst_SpeakerArrangement = ((@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, ((((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 9))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 10))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17)))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 24))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 25))) | @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3)));
pub const Steinberg_Vst_SpeakerArr_k90_4: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, ((((((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 6))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 7))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 9))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 10))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17))));
pub const Steinberg_Vst_SpeakerArr_k91_4: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, (((((((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 6))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 7))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 9))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 10))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3))));
pub const Steinberg_Vst_SpeakerArr_k90_6: Steinberg_Vst_SpeakerArrangement = (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, ((((((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 6))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 7))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 9))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 10))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17)))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 24))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 25));
pub const Steinberg_Vst_SpeakerArr_k91_6: Steinberg_Vst_SpeakerArrangement = ((@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, ((((((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 6))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 7))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 9))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 10))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17)))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 24))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 25))) | @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3)));
pub const Steinberg_Vst_SpeakerArr_k100: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, (((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 11))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17))));
pub const Steinberg_Vst_SpeakerArr_k50_5: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, (((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 11))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17))));
pub const Steinberg_Vst_SpeakerArr_k101: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, ((((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 11))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3))));
pub const Steinberg_Vst_SpeakerArr_k101MPEG3D: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, ((((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 11))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3))));
pub const Steinberg_Vst_SpeakerArr_k51_5: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, ((((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 11))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3))));
pub const Steinberg_Vst_SpeakerArr_k102: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, (((((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 13))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 18))));
pub const Steinberg_Vst_SpeakerArr_k52_5: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, (((((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 13))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 18))));
pub const Steinberg_Vst_SpeakerArr_k110: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, ((((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 11))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 13))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17))));
pub const Steinberg_Vst_SpeakerArr_k50_6: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, ((((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 11))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 13))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17))));
pub const Steinberg_Vst_SpeakerArr_k111: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, (((((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 11))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 13))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3))));
pub const Steinberg_Vst_SpeakerArr_k51_6: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, (((((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 11))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 13))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3))));
pub const Steinberg_Vst_SpeakerArr_k122: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, (((((((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 6))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 7))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 13))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 18))));
pub const Steinberg_Vst_SpeakerArr_k72_5: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, (((((((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 6))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 7))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 13))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 18))));
pub const Steinberg_Vst_SpeakerArr_k130: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, ((((((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 9))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 10))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 11))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 13))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17))));
pub const Steinberg_Vst_SpeakerArr_k131: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, (((((((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 9))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 10))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 11))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 13))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3))));
pub const Steinberg_Vst_SpeakerArr_k140: Steinberg_Vst_SpeakerArrangement = (((@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, (((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 9))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 10))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17)))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 28))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 30))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 35))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 37));
pub const Steinberg_Vst_SpeakerArr_k60_4_4: Steinberg_Vst_SpeakerArrangement = (((@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, (((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 9))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 10))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17)))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 28))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 30))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 35))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 37));
pub const Steinberg_Vst_SpeakerArr_k220: Steinberg_Vst_SpeakerArrangement = ((((@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, ((((((((((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 6))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 7))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 8))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 9))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 10))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 11))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 13))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 16))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17)))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 24))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 25))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 28))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 29))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 30));
pub const Steinberg_Vst_SpeakerArr_k100_9_3: Steinberg_Vst_SpeakerArrangement = ((((@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, ((((((((((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 6))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 7))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 8))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 9))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 10))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 11))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 13))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 16))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17)))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 24))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 25))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 28))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 29))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 30));
pub const Steinberg_Vst_SpeakerArr_k222: Steinberg_Vst_SpeakerArrangement = ((((@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, ((((((((((((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 6))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 7))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 8))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 9))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 10))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 11))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 13))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 16))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 18)))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 24))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 25))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 28))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 29))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 30));
pub const Steinberg_Vst_SpeakerArr_k102_9_3: Steinberg_Vst_SpeakerArrangement = ((((@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, ((((((((((((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 6))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 7))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 8))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 9))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 10))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 11))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 13))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 16))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 18)))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 24))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 25))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 28))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 29))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 30));
pub const Steinberg_Vst_SpeakerArr_k50_5_3: Steinberg_Vst_SpeakerArrangement = ((@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, (((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 13))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17)))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 28))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 29))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 30));
pub const Steinberg_Vst_SpeakerArr_k51_5_3: Steinberg_Vst_SpeakerArrangement = (((@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, (((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 13))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17)))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 28))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 29))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 30))) | @bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 3)));
pub const Steinberg_Vst_SpeakerArr_k50_2_2: Steinberg_Vst_SpeakerArrangement = (((@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, ((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5)))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 24))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 25))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 28))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 30));
pub const Steinberg_Vst_SpeakerArr_k50_4_2: Steinberg_Vst_SpeakerArrangement = (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, ((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17)))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 28))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 30));
pub const Steinberg_Vst_SpeakerArr_k70_4_2: Steinberg_Vst_SpeakerArrangement = (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, ((((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 9))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 10))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17)))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 28))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 30));
pub const Steinberg_Vst_SpeakerArr_k50_5_Sony: Steinberg_Vst_SpeakerArrangement = @bitCast(Steinberg_Vst_SpeakerArrangement, @as(c_longlong, (((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 13))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17))));
pub const Steinberg_Vst_SpeakerArr_k40_2_2: Steinberg_Vst_SpeakerArrangement = (((@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, (((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 9))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 10))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 8)))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 24))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 25))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 33))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 34));
pub const Steinberg_Vst_SpeakerArr_k40_4_2: Steinberg_Vst_SpeakerArrangement = (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, (((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17)))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 28))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 30));
pub const Steinberg_Vst_SpeakerArr_k50_3_2: Steinberg_Vst_SpeakerArrangement = (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, (((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 13))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14)))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 28))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 30));
pub const Steinberg_Vst_SpeakerArr_k30_5_2: Steinberg_Vst_SpeakerArrangement = (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, (((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 13))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17)))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 28))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 30));
pub const Steinberg_Vst_SpeakerArr_k40_4_4: Steinberg_Vst_SpeakerArrangement = (((@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, (((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17)))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 28))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 30))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 35))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 37));
pub const Steinberg_Vst_SpeakerArr_k50_4_4: Steinberg_Vst_SpeakerArrangement = (((@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, ((((((((@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 0)) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 1))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 2))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 4))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 5))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 12))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 14))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 15))) | (@as(c_int, 1) << @intCast(@import("std").math.Log2Int(c_int), 17)))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 28))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 30))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 35))) | (@bitCast(Steinberg_Vst_Speaker, @as(c_longlong, @as(c_int, 1))) << @intCast(@import("std").math.Log2Int(Steinberg_Vst_Speaker), 37));
pub const Steinberg_Vst_SpeakerArr_kStringEmpty: Steinberg_Vst_CString = "";
pub const Steinberg_Vst_SpeakerArr_kStringMono: Steinberg_Vst_CString = "Mono";
pub const Steinberg_Vst_SpeakerArr_kStringStereo: Steinberg_Vst_CString = "Stereo";
pub const Steinberg_Vst_SpeakerArr_kStringStereoR: Steinberg_Vst_CString = "Stereo (Ls Rs)";
pub const Steinberg_Vst_SpeakerArr_kStringStereoC: Steinberg_Vst_CString = "Stereo (Lc Rc)";
pub const Steinberg_Vst_SpeakerArr_kStringStereoSide: Steinberg_Vst_CString = "Stereo (Sl Sr)";
pub const Steinberg_Vst_SpeakerArr_kStringStereoCLfe: Steinberg_Vst_CString = "Stereo (C LFE)";
pub const Steinberg_Vst_SpeakerArr_kStringStereoTF: Steinberg_Vst_CString = "Stereo (Tfl Tfr)";
pub const Steinberg_Vst_SpeakerArr_kStringStereoTS: Steinberg_Vst_CString = "Stereo (Tsl Tsr)";
pub const Steinberg_Vst_SpeakerArr_kStringStereoTR: Steinberg_Vst_CString = "Stereo (Trl Trr)";
pub const Steinberg_Vst_SpeakerArr_kStringStereoBF: Steinberg_Vst_CString = "Stereo (Bfl Bfr)";
pub const Steinberg_Vst_SpeakerArr_kStringCineFront: Steinberg_Vst_CString = "Cine Front";
pub const Steinberg_Vst_SpeakerArr_kString30Cine: Steinberg_Vst_CString = "LRC";
pub const Steinberg_Vst_SpeakerArr_kString30Music: Steinberg_Vst_CString = "LRS";
pub const Steinberg_Vst_SpeakerArr_kString31Cine: Steinberg_Vst_CString = "LRC+LFE";
pub const Steinberg_Vst_SpeakerArr_kString31Music: Steinberg_Vst_CString = "LRS+LFE";
pub const Steinberg_Vst_SpeakerArr_kString40Cine: Steinberg_Vst_CString = "LRCS";
pub const Steinberg_Vst_SpeakerArr_kString40Music: Steinberg_Vst_CString = "Quadro";
pub const Steinberg_Vst_SpeakerArr_kString41Cine: Steinberg_Vst_CString = "LRCS+LFE";
pub const Steinberg_Vst_SpeakerArr_kString41Music: Steinberg_Vst_CString = "Quadro+LFE";
pub const Steinberg_Vst_SpeakerArr_kString50: Steinberg_Vst_CString = "5.0";
pub const Steinberg_Vst_SpeakerArr_kString51: Steinberg_Vst_CString = "5.1";
pub const Steinberg_Vst_SpeakerArr_kString60Cine: Steinberg_Vst_CString = "6.0 Cine";
pub const Steinberg_Vst_SpeakerArr_kString60Music: Steinberg_Vst_CString = "6.0 Music";
pub const Steinberg_Vst_SpeakerArr_kString61Cine: Steinberg_Vst_CString = "6.1 Cine";
pub const Steinberg_Vst_SpeakerArr_kString61Music: Steinberg_Vst_CString = "6.1 Music";
pub const Steinberg_Vst_SpeakerArr_kString70Cine: Steinberg_Vst_CString = "7.0 SDDS";
pub const Steinberg_Vst_SpeakerArr_kString70CineOld: Steinberg_Vst_CString = "7.0 Cine (SDDS)";
pub const Steinberg_Vst_SpeakerArr_kString70Music: Steinberg_Vst_CString = "7.0";
pub const Steinberg_Vst_SpeakerArr_kString70MusicOld: Steinberg_Vst_CString = "7.0 Music (Dolby)";
pub const Steinberg_Vst_SpeakerArr_kString71Cine: Steinberg_Vst_CString = "7.1 SDDS";
pub const Steinberg_Vst_SpeakerArr_kString71CineOld: Steinberg_Vst_CString = "7.1 Cine (SDDS)";
pub const Steinberg_Vst_SpeakerArr_kString71Music: Steinberg_Vst_CString = "7.1";
pub const Steinberg_Vst_SpeakerArr_kString71MusicOld: Steinberg_Vst_CString = "7.1 Music (Dolby)";
pub const Steinberg_Vst_SpeakerArr_kString71CineTopCenter: Steinberg_Vst_CString = "7.1 Cine Top Center";
pub const Steinberg_Vst_SpeakerArr_kString71CineCenterHigh: Steinberg_Vst_CString = "7.1 Cine Center High";
pub const Steinberg_Vst_SpeakerArr_kString71CineFullRear: Steinberg_Vst_CString = "7.1 Cine Full Rear";
pub const Steinberg_Vst_SpeakerArr_kString51_2: Steinberg_Vst_CString = "5.1.2";
pub const Steinberg_Vst_SpeakerArr_kString50_2: Steinberg_Vst_CString = "5.0.2";
pub const Steinberg_Vst_SpeakerArr_kString50_2TopSide: Steinberg_Vst_CString = "5.0.2 Top Side";
pub const Steinberg_Vst_SpeakerArr_kString51_2TopSide: Steinberg_Vst_CString = "5.1.2 Top Side";
pub const Steinberg_Vst_SpeakerArr_kString71Proximity: Steinberg_Vst_CString = "7.1 Proximity";
pub const Steinberg_Vst_SpeakerArr_kString80Cine: Steinberg_Vst_CString = "8.0 Cine";
pub const Steinberg_Vst_SpeakerArr_kString80Music: Steinberg_Vst_CString = "8.0 Music";
pub const Steinberg_Vst_SpeakerArr_kString40_4: Steinberg_Vst_CString = "8.0 Cube";
pub const Steinberg_Vst_SpeakerArr_kString81Cine: Steinberg_Vst_CString = "8.1 Cine";
pub const Steinberg_Vst_SpeakerArr_kString81Music: Steinberg_Vst_CString = "8.1 Music";
pub const Steinberg_Vst_SpeakerArr_kString90Cine: Steinberg_Vst_CString = "9.0 Cine";
pub const Steinberg_Vst_SpeakerArr_kString91Cine: Steinberg_Vst_CString = "9.1 Cine";
pub const Steinberg_Vst_SpeakerArr_kString100Cine: Steinberg_Vst_CString = "10.0 Cine";
pub const Steinberg_Vst_SpeakerArr_kString101Cine: Steinberg_Vst_CString = "10.1 Cine";
pub const Steinberg_Vst_SpeakerArr_kString52_5: Steinberg_Vst_CString = "5.2.5";
pub const Steinberg_Vst_SpeakerArr_kString72_5: Steinberg_Vst_CString = "12.2";
pub const Steinberg_Vst_SpeakerArr_kString50_4: Steinberg_Vst_CString = "5.0.4";
pub const Steinberg_Vst_SpeakerArr_kString51_4: Steinberg_Vst_CString = "5.1.4";
pub const Steinberg_Vst_SpeakerArr_kString50_4_1: Steinberg_Vst_CString = "5.0.4.1";
pub const Steinberg_Vst_SpeakerArr_kString51_4_1: Steinberg_Vst_CString = "5.1.4.1";
pub const Steinberg_Vst_SpeakerArr_kString70_2: Steinberg_Vst_CString = "7.0.2";
pub const Steinberg_Vst_SpeakerArr_kString71_2: Steinberg_Vst_CString = "7.1.2";
pub const Steinberg_Vst_SpeakerArr_kString70_3: Steinberg_Vst_CString = "7.0.3";
pub const Steinberg_Vst_SpeakerArr_kString72_3: Steinberg_Vst_CString = "7.2.3";
pub const Steinberg_Vst_SpeakerArr_kString70_4: Steinberg_Vst_CString = "7.0.4";
pub const Steinberg_Vst_SpeakerArr_kString71_4: Steinberg_Vst_CString = "7.1.4";
pub const Steinberg_Vst_SpeakerArr_kString70_6: Steinberg_Vst_CString = "7.0.6";
pub const Steinberg_Vst_SpeakerArr_kString71_6: Steinberg_Vst_CString = "7.1.6";
pub const Steinberg_Vst_SpeakerArr_kString90_4: Steinberg_Vst_CString = "9.0.4";
pub const Steinberg_Vst_SpeakerArr_kString91_4: Steinberg_Vst_CString = "9.1.4";
pub const Steinberg_Vst_SpeakerArr_kString90_6: Steinberg_Vst_CString = "9.0.6";
pub const Steinberg_Vst_SpeakerArr_kString91_6: Steinberg_Vst_CString = "9.1.6";
pub const Steinberg_Vst_SpeakerArr_kString50_5: Steinberg_Vst_CString = "10.0 Auro-3D";
pub const Steinberg_Vst_SpeakerArr_kString51_5: Steinberg_Vst_CString = "10.1 Auro-3D";
pub const Steinberg_Vst_SpeakerArr_kString50_6: Steinberg_Vst_CString = "11.0 Auro-3D";
pub const Steinberg_Vst_SpeakerArr_kString51_6: Steinberg_Vst_CString = "11.1 Auro-3D";
pub const Steinberg_Vst_SpeakerArr_kString130: Steinberg_Vst_CString = "13.0 Auro-3D";
pub const Steinberg_Vst_SpeakerArr_kString131: Steinberg_Vst_CString = "13.1 Auro-3D";
pub const Steinberg_Vst_SpeakerArr_kString41_4_1: Steinberg_Vst_CString = "8.1 MPEG";
pub const Steinberg_Vst_SpeakerArr_kString60_4_4: Steinberg_Vst_CString = "14.0";
pub const Steinberg_Vst_SpeakerArr_kString220: Steinberg_Vst_CString = "22.0";
pub const Steinberg_Vst_SpeakerArr_kString222: Steinberg_Vst_CString = "22.2";
pub const Steinberg_Vst_SpeakerArr_kString50_5_3: Steinberg_Vst_CString = "5.0.5.3";
pub const Steinberg_Vst_SpeakerArr_kString51_5_3: Steinberg_Vst_CString = "5.1.5.3";
pub const Steinberg_Vst_SpeakerArr_kString50_2_2: Steinberg_Vst_CString = "5.0.2.2";
pub const Steinberg_Vst_SpeakerArr_kString50_4_2: Steinberg_Vst_CString = "5.0.4.2";
pub const Steinberg_Vst_SpeakerArr_kString70_4_2: Steinberg_Vst_CString = "7.0.4.2";
pub const Steinberg_Vst_SpeakerArr_kString50_5_Sony: Steinberg_Vst_CString = "5.0.5 Sony";
pub const Steinberg_Vst_SpeakerArr_kString40_2_2: Steinberg_Vst_CString = "4.0.3.2";
pub const Steinberg_Vst_SpeakerArr_kString40_4_2: Steinberg_Vst_CString = "4.0.4.2";
pub const Steinberg_Vst_SpeakerArr_kString50_3_2: Steinberg_Vst_CString = "5.0.3.2";
pub const Steinberg_Vst_SpeakerArr_kString30_5_2: Steinberg_Vst_CString = "3.0.5.2";
pub const Steinberg_Vst_SpeakerArr_kString40_4_4: Steinberg_Vst_CString = "4.0.4.4";
pub const Steinberg_Vst_SpeakerArr_kString50_4_4: Steinberg_Vst_CString = "5.0.4.4";
pub const Steinberg_Vst_SpeakerArr_kStringAmbi1stOrder: Steinberg_Vst_CString = "1st Order Ambisonics";
pub const Steinberg_Vst_SpeakerArr_kStringAmbi2cdOrder: Steinberg_Vst_CString = "2nd Order Ambisonics";
pub const Steinberg_Vst_SpeakerArr_kStringAmbi3rdOrder: Steinberg_Vst_CString = "3rd Order Ambisonics";
pub const Steinberg_Vst_SpeakerArr_kStringAmbi4thOrder: Steinberg_Vst_CString = "4th Order Ambisonics";
pub const Steinberg_Vst_SpeakerArr_kStringAmbi5thOrder: Steinberg_Vst_CString = "5th Order Ambisonics";
pub const Steinberg_Vst_SpeakerArr_kStringAmbi6thOrder: Steinberg_Vst_CString = "6th Order Ambisonics";
pub const Steinberg_Vst_SpeakerArr_kStringAmbi7thOrder: Steinberg_Vst_CString = "7th Order Ambisonics";
pub const Steinberg_Vst_SpeakerArr_kStringMonoS: Steinberg_Vst_CString = "M";
pub const Steinberg_Vst_SpeakerArr_kStringStereoS: Steinberg_Vst_CString = "L R";
pub const Steinberg_Vst_SpeakerArr_kStringStereoRS: Steinberg_Vst_CString = "Ls Rs";
pub const Steinberg_Vst_SpeakerArr_kStringStereoCS: Steinberg_Vst_CString = "Lc Rc";
pub const Steinberg_Vst_SpeakerArr_kStringStereoSS: Steinberg_Vst_CString = "Sl Sr";
pub const Steinberg_Vst_SpeakerArr_kStringStereoCLfeS: Steinberg_Vst_CString = "C LFE";
pub const Steinberg_Vst_SpeakerArr_kStringStereoTFS: Steinberg_Vst_CString = "Tfl Tfr";
pub const Steinberg_Vst_SpeakerArr_kStringStereoTSS: Steinberg_Vst_CString = "Tsl Tsr";
pub const Steinberg_Vst_SpeakerArr_kStringStereoTRS: Steinberg_Vst_CString = "Trl Trr";
pub const Steinberg_Vst_SpeakerArr_kStringStereoBFS: Steinberg_Vst_CString = "Bfl Bfr";
pub const Steinberg_Vst_SpeakerArr_kStringCineFrontS: Steinberg_Vst_CString = "L R C Lc Rc";
pub const Steinberg_Vst_SpeakerArr_kString30CineS: Steinberg_Vst_CString = "L R C";
pub const Steinberg_Vst_SpeakerArr_kString30MusicS: Steinberg_Vst_CString = "L R S";
pub const Steinberg_Vst_SpeakerArr_kString31CineS: Steinberg_Vst_CString = "L R C LFE";
pub const Steinberg_Vst_SpeakerArr_kString31MusicS: Steinberg_Vst_CString = "L R LFE S";
pub const Steinberg_Vst_SpeakerArr_kString40CineS: Steinberg_Vst_CString = "L R C S";
pub const Steinberg_Vst_SpeakerArr_kString40MusicS: Steinberg_Vst_CString = "L R Ls Rs";
pub const Steinberg_Vst_SpeakerArr_kString41CineS: Steinberg_Vst_CString = "L R C LFE S";
pub const Steinberg_Vst_SpeakerArr_kString41MusicS: Steinberg_Vst_CString = "L R LFE Ls Rs";
pub const Steinberg_Vst_SpeakerArr_kString50S: Steinberg_Vst_CString = "L R C Ls Rs";
pub const Steinberg_Vst_SpeakerArr_kString51S: Steinberg_Vst_CString = "L R C LFE Ls Rs";
pub const Steinberg_Vst_SpeakerArr_kString60CineS: Steinberg_Vst_CString = "L R C Ls Rs Cs";
pub const Steinberg_Vst_SpeakerArr_kString60MusicS: Steinberg_Vst_CString = "L R Ls Rs Sl Sr";
pub const Steinberg_Vst_SpeakerArr_kString61CineS: Steinberg_Vst_CString = "L R C LFE Ls Rs Cs";
pub const Steinberg_Vst_SpeakerArr_kString61MusicS: Steinberg_Vst_CString = "L R LFE Ls Rs Sl Sr";
pub const Steinberg_Vst_SpeakerArr_kString70CineS: Steinberg_Vst_CString = "L R C Ls Rs Lc Rc";
pub const Steinberg_Vst_SpeakerArr_kString70MusicS: Steinberg_Vst_CString = "L R C Ls Rs Sl Sr";
pub const Steinberg_Vst_SpeakerArr_kString71CineS: Steinberg_Vst_CString = "L R C LFE Ls Rs Lc Rc";
pub const Steinberg_Vst_SpeakerArr_kString71MusicS: Steinberg_Vst_CString = "L R C LFE Ls Rs Sl Sr";
pub const Steinberg_Vst_SpeakerArr_kString80CineS: Steinberg_Vst_CString = "L R C Ls Rs Lc Rc Cs";
pub const Steinberg_Vst_SpeakerArr_kString80MusicS: Steinberg_Vst_CString = "L R C Ls Rs Cs Sl Sr";
pub const Steinberg_Vst_SpeakerArr_kString81CineS: Steinberg_Vst_CString = "L R C LFE Ls Rs Lc Rc Cs";
pub const Steinberg_Vst_SpeakerArr_kString81MusicS: Steinberg_Vst_CString = "L R C LFE Ls Rs Cs Sl Sr";
pub const Steinberg_Vst_SpeakerArr_kString40_4S: Steinberg_Vst_CString = "L R Ls Rs Tfl Tfr Trl Trr";
pub const Steinberg_Vst_SpeakerArr_kString71CineTopCenterS: Steinberg_Vst_CString = "L R C LFE Ls Rs Cs Tc";
pub const Steinberg_Vst_SpeakerArr_kString71CineCenterHighS: Steinberg_Vst_CString = "L R C LFE Ls Rs Cs Tfc";
pub const Steinberg_Vst_SpeakerArr_kString71CineFullRearS: Steinberg_Vst_CString = "L R C LFE Ls Rs Lcs Rcs";
pub const Steinberg_Vst_SpeakerArr_kString50_2S: Steinberg_Vst_CString = "L R C Ls Rs Tfl Tfr";
pub const Steinberg_Vst_SpeakerArr_kString51_2S: Steinberg_Vst_CString = "L R C LFE Ls Rs Tfl Tfr";
pub const Steinberg_Vst_SpeakerArr_kString50_2TopSideS: Steinberg_Vst_CString = "L R C Ls Rs Tsl Tsr";
pub const Steinberg_Vst_SpeakerArr_kString51_2TopSideS: Steinberg_Vst_CString = "L R C LFE Ls Rs Tsl Tsr";
pub const Steinberg_Vst_SpeakerArr_kString71ProximityS: Steinberg_Vst_CString = "L R C LFE Ls Rs Pl Pr";
pub const Steinberg_Vst_SpeakerArr_kString90CineS: Steinberg_Vst_CString = "L R C Ls Rs Lc Rc Sl Sr";
pub const Steinberg_Vst_SpeakerArr_kString91CineS: Steinberg_Vst_CString = "L R C LFE Ls Rs Lc Rc Sl Sr";
pub const Steinberg_Vst_SpeakerArr_kString100CineS: Steinberg_Vst_CString = "L R C Ls Rs Lc Rc Cs Sl Sr";
pub const Steinberg_Vst_SpeakerArr_kString101CineS: Steinberg_Vst_CString = "L R C LFE Ls Rs Lc Rc Cs Sl Sr";
pub const Steinberg_Vst_SpeakerArr_kString50_4S: Steinberg_Vst_CString = "L R C Ls Rs Tfl Tfr Trl Trr";
pub const Steinberg_Vst_SpeakerArr_kString51_4S: Steinberg_Vst_CString = "L R C LFE Ls Rs Tfl Tfr Trl Trr";
pub const Steinberg_Vst_SpeakerArr_kString50_4_1S: Steinberg_Vst_CString = "L R C Ls Rs Tfl Tfr Trl Trr Bfc";
pub const Steinberg_Vst_SpeakerArr_kString51_4_1S: Steinberg_Vst_CString = "L R C LFE Ls Rs Tfl Tfr Trl Trr Bfc";
pub const Steinberg_Vst_SpeakerArr_kString70_2S: Steinberg_Vst_CString = "L R C Ls Rs Sl Sr Tsl Tsr";
pub const Steinberg_Vst_SpeakerArr_kString71_2S: Steinberg_Vst_CString = "L R C LFE Ls Rs Sl Sr Tsl Tsr";
pub const Steinberg_Vst_SpeakerArr_kString70_3S: Steinberg_Vst_CString = "L R C Ls Rs Sl Sr Tfl Tfr Trc";
pub const Steinberg_Vst_SpeakerArr_kString72_3S: Steinberg_Vst_CString = "L R C LFE Ls Rs Sl Sr Tfl Tfr Trc LFE2";
pub const Steinberg_Vst_SpeakerArr_kString70_4S: Steinberg_Vst_CString = "L R C Ls Rs Sl Sr Tfl Tfr Trl Trr";
pub const Steinberg_Vst_SpeakerArr_kString71_4S: Steinberg_Vst_CString = "L R C LFE Ls Rs Sl Sr Tfl Tfr Trl Trr";
pub const Steinberg_Vst_SpeakerArr_kString70_6S: Steinberg_Vst_CString = "L R C Ls Rs Sl Sr Tfl Tfr Trl Trr Tsl Tsr";
pub const Steinberg_Vst_SpeakerArr_kString71_6S: Steinberg_Vst_CString = "L R C LFE Ls Rs Sl Sr Tfl Tfr Trl Trr Tsl Tsr";
pub const Steinberg_Vst_SpeakerArr_kString90_4S: Steinberg_Vst_CString = "L R C Ls Rs Lc Rc Sl Sr Tfl Tfr Trl Trr";
pub const Steinberg_Vst_SpeakerArr_kString91_4S: Steinberg_Vst_CString = "L R C LFE Ls Rs Lc Rc Sl Sr Tfl Tfr Trl Trr";
pub const Steinberg_Vst_SpeakerArr_kString90_6S: Steinberg_Vst_CString = "L R C Ls Rs Lc Rc Sl Sr Tfl Tfr Trl Trr Tsl Tsr";
pub const Steinberg_Vst_SpeakerArr_kString91_6S: Steinberg_Vst_CString = "L R C LFE Ls Rs Lc Rc Sl Sr Tfl Tfr Trl Trr Tsl Tsr";
pub const Steinberg_Vst_SpeakerArr_kString50_5S: Steinberg_Vst_CString = "L R C Ls Rs Tc Tfl Tfr Trl Trr";
pub const Steinberg_Vst_SpeakerArr_kString51_5S: Steinberg_Vst_CString = "L R C LFE Ls Rs Tc Tfl Tfr Trl Trr";
pub const Steinberg_Vst_SpeakerArr_kString50_5_SonyS: Steinberg_Vst_CString = "L R C Ls Rs Tfl Tfc Tfr Trl Trr";
pub const Steinberg_Vst_SpeakerArr_kString50_6S: Steinberg_Vst_CString = "L R C Ls Rs Tc Tfl Tfc Tfr Trl Trr";
pub const Steinberg_Vst_SpeakerArr_kString51_6S: Steinberg_Vst_CString = "L R C LFE Ls Rs Tc Tfl Tfc Tfr Trl Trr";
pub const Steinberg_Vst_SpeakerArr_kString130S: Steinberg_Vst_CString = "L R C Ls Rs Sl Sr Tc Tfl Tfc Tfr Trl Trr";
pub const Steinberg_Vst_SpeakerArr_kString131S: Steinberg_Vst_CString = "L R C LFE Ls Rs Sl Sr Tc Tfl Tfc Tfr Trl Trr";
pub const Steinberg_Vst_SpeakerArr_kString52_5S: Steinberg_Vst_CString = "L R C LFE Ls Rs Tfl Tfc Tfr Trl Trr LFE2";
pub const Steinberg_Vst_SpeakerArr_kString72_5S: Steinberg_Vst_CString = "L R C LFE Ls Rs Lc Rc Tfl Tfc Tfr Trl Trr LFE2";
pub const Steinberg_Vst_SpeakerArr_kString41_4_1S: Steinberg_Vst_CString = "L R LFE Ls Rs Tfl Tfc Tfr Bfc";
pub const Steinberg_Vst_SpeakerArr_kString30_5_2S: Steinberg_Vst_CString = "L R C Tfl Tfc Tfr Trl Trr Bfl Bfr";
pub const Steinberg_Vst_SpeakerArr_kString40_2_2S: Steinberg_Vst_CString = "C Sl Sr Cs Tfc Tsl Tsr Trc";
pub const Steinberg_Vst_SpeakerArr_kString40_4_2S: Steinberg_Vst_CString = "L R Ls Rs Tfl Tfr Trl Trr Bfl Bfr";
pub const Steinberg_Vst_SpeakerArr_kString40_4_4S: Steinberg_Vst_CString = "L R Ls Rs Tfl Tfr Trl Trr Bfl Bfr Brl Brr";
pub const Steinberg_Vst_SpeakerArr_kString50_4_4S: Steinberg_Vst_CString = "L R C Ls Rs Tfl Tfr Trl Trr Bfl Bfr Brl Brr";
pub const Steinberg_Vst_SpeakerArr_kString60_4_4S: Steinberg_Vst_CString = "L R Ls Rs Sl Sr Tfl Tfr Trl Trr Bfl Bfr Brl Brr";
pub const Steinberg_Vst_SpeakerArr_kString50_5_3S: Steinberg_Vst_CString = "L R C Ls Rs Tfl Tfc Tfr Trl Trr Bfl Bfc Bfr";
pub const Steinberg_Vst_SpeakerArr_kString51_5_3S: Steinberg_Vst_CString = "L R C LFE Ls Rs Tfl Tfc Tfr Trl Trr Bfl Bfc Bfr";
pub const Steinberg_Vst_SpeakerArr_kString50_2_2S: Steinberg_Vst_CString = "L R C Ls Rs Tsl Tsr Bfl Bfr";
pub const Steinberg_Vst_SpeakerArr_kString50_3_2S: Steinberg_Vst_CString = "L R C Ls Rs Tfl Tfc Tfr Bfl Bfr";
pub const Steinberg_Vst_SpeakerArr_kString50_4_2S: Steinberg_Vst_CString = "L R C Ls Rs Tfl Tfr Trl Trr Bfl Bfr";
pub const Steinberg_Vst_SpeakerArr_kString70_4_2S: Steinberg_Vst_CString = "L R C Ls Rs Sl Sr Tfl Tfr Trl Trr Bfl Bfr";
pub const Steinberg_Vst_SpeakerArr_kString222S: Steinberg_Vst_CString = "L R C LFE Ls Rs Lc Rc Cs Sl Sr Tc Tfl Tfc Tfr Trl Trc Trr LFE2 Tsl Tsr Bfl Bfc Bfr";
pub const Steinberg_Vst_SpeakerArr_kString220S: Steinberg_Vst_CString = "L R C Ls Rs Lc Rc Cs Sl Sr Tc Tfl Tfc Tfr Trl Trc Trr Tsl Tsr Bfl Bfc Bfr";
pub const Steinberg_Vst_SpeakerArr_kStringAmbi1stOrderS: Steinberg_Vst_CString = "0 1 2 3";
pub const Steinberg_Vst_SpeakerArr_kStringAmbi2cdOrderS: Steinberg_Vst_CString = "0 1 2 3 4 5 6 7 8";
pub const Steinberg_Vst_SpeakerArr_kStringAmbi3rdOrderS: Steinberg_Vst_CString = "0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15";
pub const Steinberg_Vst_SpeakerArr_kStringAmbi4thOrderS: Steinberg_Vst_CString = "0..24";
pub const Steinberg_Vst_SpeakerArr_kStringAmbi5thOrderS: Steinberg_Vst_CString = "0..35";
pub const Steinberg_Vst_SpeakerArr_kStringAmbi6thOrderS: Steinberg_Vst_CString = "0..48";
pub const Steinberg_Vst_SpeakerArr_kStringAmbi7thOrderS: Steinberg_Vst_CString = "0..63";
pub const Steinberg_Vst_CurveType_kSegment: Steinberg_Vst_CString = "segment";
pub const Steinberg_Vst_CurveType_kValueList: Steinberg_Vst_CString = "valueList";
pub const Steinberg_Vst_Attributes_kStyle: Steinberg_Vst_CString = "style";
pub const Steinberg_Vst_Attributes_kLEDStyle: Steinberg_Vst_CString = "ledStyle";
pub const Steinberg_Vst_Attributes_kSwitchStyle: Steinberg_Vst_CString = "switchStyle";
pub const Steinberg_Vst_Attributes_kKnobTurnsPerFullRange: Steinberg_Vst_CString = "turnsPerFullRange";
pub const Steinberg_Vst_Attributes_kFunction: Steinberg_Vst_CString = "function";
pub const Steinberg_Vst_Attributes_kFlags: Steinberg_Vst_CString = "flags";
pub const Steinberg_Vst_AttributesFunction_kPanPosCenterXFunc: Steinberg_Vst_CString = "PanPosCenterX";
pub const Steinberg_Vst_AttributesFunction_kPanPosCenterYFunc: Steinberg_Vst_CString = "PanPosCenterY";
pub const Steinberg_Vst_AttributesFunction_kPanPosFrontLeftXFunc: Steinberg_Vst_CString = "PanPosFrontLeftX";
pub const Steinberg_Vst_AttributesFunction_kPanPosFrontLeftYFunc: Steinberg_Vst_CString = "PanPosFrontLeftY";
pub const Steinberg_Vst_AttributesFunction_kPanPosFrontRightXFunc: Steinberg_Vst_CString = "PanPosFrontRightX";
pub const Steinberg_Vst_AttributesFunction_kPanPosFrontRightYFunc: Steinberg_Vst_CString = "PanPosFrontRightY";
pub const Steinberg_Vst_AttributesFunction_kPanRotationFunc: Steinberg_Vst_CString = "PanRotation";
pub const Steinberg_Vst_AttributesFunction_kPanLawFunc: Steinberg_Vst_CString = "PanLaw";
pub const Steinberg_Vst_AttributesFunction_kPanMirrorModeFunc: Steinberg_Vst_CString = "PanMirrorMode";
pub const Steinberg_Vst_AttributesFunction_kPanLfeGainFunc: Steinberg_Vst_CString = "PanLfeGain";
pub const Steinberg_Vst_AttributesFunction_kGainReductionFunc: Steinberg_Vst_CString = "GainReduction";
pub const Steinberg_Vst_AttributesFunction_kSoloFunc: Steinberg_Vst_CString = "Solo";
pub const Steinberg_Vst_AttributesFunction_kMuteFunc: Steinberg_Vst_CString = "Mute";
pub const Steinberg_Vst_AttributesFunction_kVolumeFunc: Steinberg_Vst_CString = "Volume";
pub const Steinberg_Vst_AttributesStyle_kInverseStyle: Steinberg_Vst_CString = "inverse";
pub const Steinberg_Vst_AttributesStyle_kLEDWrapLeftStyle: Steinberg_Vst_CString = "wrapLeft";
pub const Steinberg_Vst_AttributesStyle_kLEDWrapRightStyle: Steinberg_Vst_CString = "wrapRight";
pub const Steinberg_Vst_AttributesStyle_kLEDSpreadStyle: Steinberg_Vst_CString = "spread";
pub const Steinberg_Vst_AttributesStyle_kLEDBoostCutStyle: Steinberg_Vst_CString = "boostCut";
pub const Steinberg_Vst_AttributesStyle_kLEDSingleDotStyle: Steinberg_Vst_CString = "singleDot";
pub const Steinberg_Vst_AttributesStyle_kSwitchPushStyle: Steinberg_Vst_CString = "push";
pub const Steinberg_Vst_AttributesStyle_kSwitchPushIncLoopedStyle: Steinberg_Vst_CString = "pushIncLooped";
pub const Steinberg_Vst_AttributesStyle_kSwitchPushDecLoopedStyle: Steinberg_Vst_CString = "pushDecLooped";
pub const Steinberg_Vst_AttributesStyle_kSwitchPushIncStyle: Steinberg_Vst_CString = "pushInc";
pub const Steinberg_Vst_AttributesStyle_kSwitchPushDecStyle: Steinberg_Vst_CString = "pushDec";
pub const Steinberg_Vst_AttributesStyle_kSwitchLatchStyle: Steinberg_Vst_CString = "latch";
pub const Steinberg_Vst_AttributesFlags_kHideableFlag: Steinberg_Vst_CString = "hideable";
pub const Steinberg_Vst_ChannelContext_kChannelUIDKey: Steinberg_Vst_CString = "channel uid";
pub const Steinberg_Vst_ChannelContext_kChannelUIDLengthKey: Steinberg_Vst_CString = "channel uid length";
pub const Steinberg_Vst_ChannelContext_kChannelNameKey: Steinberg_Vst_CString = "channel name";
pub const Steinberg_Vst_ChannelContext_kChannelNameLengthKey: Steinberg_Vst_CString = "channel name length";
pub const Steinberg_Vst_ChannelContext_kChannelColorKey: Steinberg_Vst_CString = "channel color";
pub const Steinberg_Vst_ChannelContext_kChannelIndexKey: Steinberg_Vst_CString = "channel index";
pub const Steinberg_Vst_ChannelContext_kChannelIndexNamespaceOrderKey: Steinberg_Vst_CString = "channel index namespace order";
pub const Steinberg_Vst_ChannelContext_kChannelIndexNamespaceKey: Steinberg_Vst_CString = "channel index namespace";
pub const Steinberg_Vst_ChannelContext_kChannelIndexNamespaceLengthKey: Steinberg_Vst_CString = "channel index namespace length";
pub const Steinberg_Vst_ChannelContext_kChannelImageKey: Steinberg_Vst_CString = "channel image";
pub const Steinberg_Vst_ChannelContext_kChannelPluginLocationKey: Steinberg_Vst_CString = "channel plugin location";
pub const Steinberg_Vst_PlugType_kFx: Steinberg_Vst_CString = "Fx";
pub const Steinberg_Vst_PlugType_kFxAnalyzer: Steinberg_Vst_CString = "Fx|Analyzer";
pub const Steinberg_Vst_PlugType_kFxDelay: Steinberg_Vst_CString = "Fx|Delay";
pub const Steinberg_Vst_PlugType_kFxDistortion: Steinberg_Vst_CString = "Fx|Distortion";
pub const Steinberg_Vst_PlugType_kFxDynamics: Steinberg_Vst_CString = "Fx|Dynamics";
pub const Steinberg_Vst_PlugType_kFxEQ: Steinberg_Vst_CString = "Fx|EQ";
pub const Steinberg_Vst_PlugType_kFxFilter: Steinberg_Vst_CString = "Fx|Filter";
pub const Steinberg_Vst_PlugType_kFxGenerator: Steinberg_Vst_CString = "Fx|Generator";
pub const Steinberg_Vst_PlugType_kFxInstrument: Steinberg_Vst_CString = "Fx|Instrument";
pub const Steinberg_Vst_PlugType_kFxInstrumentExternal: Steinberg_Vst_CString = "Fx|Instrument|External";
pub const Steinberg_Vst_PlugType_kFxMastering: Steinberg_Vst_CString = "Fx|Mastering";
pub const Steinberg_Vst_PlugType_kFxModulation: Steinberg_Vst_CString = "Fx|Modulation";
pub const Steinberg_Vst_PlugType_kFxNetwork: Steinberg_Vst_CString = "Fx|Network";
pub const Steinberg_Vst_PlugType_kFxPitchShift: Steinberg_Vst_CString = "Fx|Pitch Shift";
pub const Steinberg_Vst_PlugType_kFxRestoration: Steinberg_Vst_CString = "Fx|Restoration";
pub const Steinberg_Vst_PlugType_kFxReverb: Steinberg_Vst_CString = "Fx|Reverb";
pub const Steinberg_Vst_PlugType_kFxSpatial: Steinberg_Vst_CString = "Fx|Spatial";
pub const Steinberg_Vst_PlugType_kFxSurround: Steinberg_Vst_CString = "Fx|Surround";
pub const Steinberg_Vst_PlugType_kFxTools: Steinberg_Vst_CString = "Fx|Tools";
pub const Steinberg_Vst_PlugType_kFxVocals: Steinberg_Vst_CString = "Fx|Vocals";
pub const Steinberg_Vst_PlugType_kInstrument: Steinberg_Vst_CString = "Instrument";
pub const Steinberg_Vst_PlugType_kInstrumentDrum: Steinberg_Vst_CString = "Instrument|Drum";
pub const Steinberg_Vst_PlugType_kInstrumentExternal: Steinberg_Vst_CString = "Instrument|External";
pub const Steinberg_Vst_PlugType_kInstrumentPiano: Steinberg_Vst_CString = "Instrument|Piano";
pub const Steinberg_Vst_PlugType_kInstrumentSampler: Steinberg_Vst_CString = "Instrument|Sampler";
pub const Steinberg_Vst_PlugType_kInstrumentSynth: Steinberg_Vst_CString = "Instrument|Synth";
pub const Steinberg_Vst_PlugType_kInstrumentSynthSampler: Steinberg_Vst_CString = "Instrument|Synth|Sampler";
pub const Steinberg_Vst_PlugType_kAmbisonics: Steinberg_Vst_CString = "Ambisonics";
pub const Steinberg_Vst_PlugType_kAnalyzer: Steinberg_Vst_CString = "Analyzer";
pub const Steinberg_Vst_PlugType_kNoOfflineProcess: Steinberg_Vst_CString = "NoOfflineProcess";
pub const Steinberg_Vst_PlugType_kOnlyARA: Steinberg_Vst_CString = "OnlyARA";
pub const Steinberg_Vst_PlugType_kOnlyOfflineProcess: Steinberg_Vst_CString = "OnlyOfflineProcess";
pub const Steinberg_Vst_PlugType_kOnlyRealTime: Steinberg_Vst_CString = "OnlyRT";
pub const Steinberg_Vst_PlugType_kSpatial: Steinberg_Vst_CString = "Spatial";
pub const Steinberg_Vst_PlugType_kSpatialFx: Steinberg_Vst_CString = "Spatial|Fx";
pub const Steinberg_Vst_PlugType_kUpDownMix: Steinberg_Vst_CString = "Up-Downmix";
pub const Steinberg_Vst_PlugType_kMono: Steinberg_Vst_CString = "Mono";
pub const Steinberg_Vst_PlugType_kStereo: Steinberg_Vst_CString = "Stereo";
pub const Steinberg_Vst_PlugType_kSurround: Steinberg_Vst_CString = "Surround";
pub const Steinberg_Vst_kNoTail: Steinberg_uint32 = 0;
pub const Steinberg_Vst_kInfiniteTail: Steinberg_uint32 = 4294967295;
pub const Steinberg_Vst_kRootUnitId: Steinberg_Vst_UnitID = 0;
pub const Steinberg_Vst_kNoParentUnitId: Steinberg_Vst_UnitID = -@as(c_int, 1);
pub const Steinberg_Vst_kNoProgramListId: Steinberg_Vst_ProgramListID = -@as(c_int, 1);
pub const Steinberg_Vst_kAllProgramInvalid: Steinberg_int32 = -@as(c_int, 1);
pub const Steinberg_Vst_FunctionNameType_kCompGainReduction: Steinberg_Vst_CString = "Comp:GainReduction";
pub const Steinberg_Vst_FunctionNameType_kCompGainReductionMax: Steinberg_Vst_CString = "Comp:GainReductionMax";
pub const Steinberg_Vst_FunctionNameType_kCompGainReductionPeakHold: Steinberg_Vst_CString = "Comp:GainReductionPeakHold";
pub const Steinberg_Vst_FunctionNameType_kCompResetGainReductionMax: Steinberg_Vst_CString = "Comp:ResetGainReductionMax";
pub const Steinberg_Vst_FunctionNameType_kLowLatencyMode: Steinberg_Vst_CString = "LowLatencyMode";
pub const Steinberg_Vst_FunctionNameType_kDryWetMix: Steinberg_Vst_CString = "DryWetMix";
pub const Steinberg_Vst_FunctionNameType_kRandomize: Steinberg_Vst_CString = "Randomize";
pub const Steinberg_Vst_FunctionNameType_kPanPosCenterX: Steinberg_Vst_CString = "PanPosCenterX";
pub const Steinberg_Vst_FunctionNameType_kPanPosCenterY: Steinberg_Vst_CString = "PanPosCenterY";
pub const Steinberg_Vst_FunctionNameType_kPanPosCenterZ: Steinberg_Vst_CString = "PanPosCenterZ";
pub const Steinberg_FUnknownVtbl = struct_Steinberg_FUnknownVtbl;
pub const Steinberg_FUnknown = struct_Steinberg_FUnknown;
pub const Steinberg_FUnknown_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 0)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 0)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 0)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 0)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 0)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 0)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 0)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 0)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3221225472)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3221225472)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3221225472)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3221225472)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 70)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 70)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 70)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 70)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_IPlugViewContentScaleSupportVtbl = struct_Steinberg_IPlugViewContentScaleSupportVtbl;
pub const Steinberg_IPlugViewContentScaleSupport = struct_Steinberg_IPlugViewContentScaleSupport;
pub const Steinberg_IPlugViewContentScaleSupport_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 1710069392)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1710069392)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1710069392)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1710069392)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2328118565)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2328118565)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2328118565)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2328118565)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2326654842)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2326654842)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2326654842)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2326654842)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1927966783)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1927966783)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1927966783)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 1927966783)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_IPlugViewVtbl = struct_Steinberg_IPlugViewVtbl;
pub const Steinberg_IPlugView = struct_Steinberg_IPlugView;
pub const Steinberg_IPlugView_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 1539515655)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1539515655)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1539515655)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1539515655)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3495971306)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3495971306)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3495971306)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3495971306)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2786401106)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2786401106)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2786401106)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2786401106)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 729111337)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 729111337)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 729111337)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 729111337)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_IPlugFrameVtbl = struct_Steinberg_IPlugFrameVtbl;
pub const Steinberg_IPlugFrame = struct_Steinberg_IPlugFrame;
pub const Steinberg_IPlugFrame_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 914337537)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 914337537)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 914337537)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 914337537)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2947106451)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2947106451)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2947106451)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2947106451)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2370675360)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2370675360)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2370675360)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2370675360)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3976757923)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3976757923)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3976757923)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3976757923)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_IBStreamVtbl = struct_Steinberg_IBStreamVtbl;
pub const Steinberg_IBStream = struct_Steinberg_IBStream;
pub const Steinberg_IBStream_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3284102818)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3284102818)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3284102818)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3284102818)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 815351634)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 815351634)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 815351634)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 815351634)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2607544720)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2607544720)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2607544720)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2607544720)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 518209179)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 518209179)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 518209179)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 518209179)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_ISizeableStreamVtbl = struct_Steinberg_ISizeableStreamVtbl;
pub const Steinberg_ISizeableStream = struct_Steinberg_ISizeableStream;
pub const Steinberg_ISizeableStream_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 83448990)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 83448990)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 83448990)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 83448990)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3761196654)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3761196654)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3761196654)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3761196654)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2280155783)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2280155783)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2280155783)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2280155783)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1207230847)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1207230847)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1207230847)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 1207230847)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_Vst_INoteExpressionControllerVtbl = struct_Steinberg_Vst_INoteExpressionControllerVtbl;
pub const Steinberg_Vst_INoteExpressionController = struct_Steinberg_Vst_INoteExpressionController;
pub const Steinberg_Vst_INoteExpressionController_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3086547033)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3086547033)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3086547033)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3086547033)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1092831346)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1092831346)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 1092831346)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1092831346)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2434176385)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2434176385)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2434176385)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2434176385)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1329013155)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1329013155)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1329013155)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 1329013155)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_Vst_IKeyswitchControllerVtbl = struct_Steinberg_Vst_IKeyswitchControllerVtbl;
pub const Steinberg_Vst_IKeyswitchController = struct_Steinberg_Vst_IKeyswitchController;
pub const Steinberg_Vst_IKeyswitchController_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 523204307)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 523204307)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 523204307)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 523204307)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3220917142)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3220917142)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3220917142)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3220917142)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3113559973)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3113559973)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3113559973)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3113559973)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1589432052)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1589432052)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1589432052)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 1589432052)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_Vst_INoteExpressionPhysicalUIMappingVtbl = struct_Steinberg_Vst_INoteExpressionPhysicalUIMappingVtbl;
pub const Steinberg_Vst_INoteExpressionPhysicalUIMapping = struct_Steinberg_Vst_INoteExpressionPhysicalUIMapping;
pub const Steinberg_Vst_INoteExpressionPhysicalUIMapping_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2955966719)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2955966719)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2955966719)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2955966719)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2496809672)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2496809672)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2496809672)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2496809672)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2429342467)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2429342467)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2429342467)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2429342467)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3558028068)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3558028068)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3558028068)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3558028068)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_IPluginBaseVtbl = struct_Steinberg_IPluginBaseVtbl;
pub const Steinberg_IPluginBase = struct_Steinberg_IPluginBase;
pub const Steinberg_IPluginBase_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 579374555)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 579374555)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 579374555)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 579374555)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 359548334)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 359548334)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 359548334)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 359548334)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2203628360)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2203628360)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2203628360)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2203628360)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 135857701)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 135857701)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 135857701)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 135857701)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_IPluginFactoryVtbl = struct_Steinberg_IPluginFactoryVtbl;
pub const Steinberg_IPluginFactory = struct_Steinberg_IPluginFactory;
pub const Steinberg_IPluginFactory_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 2051899676)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 2051899676)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 2051899676)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 2051899676)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1376864799)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1376864799)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 1376864799)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1376864799)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2933510894)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2933510894)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2933510894)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2933510894)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 188989343)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 188989343)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 188989343)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 188989343)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_IPluginFactory2Vtbl = struct_Steinberg_IPluginFactory2Vtbl;
pub const Steinberg_IPluginFactory2 = struct_Steinberg_IPluginFactory2;
pub const Steinberg_IPluginFactory2_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 505424)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 505424)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 505424)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 505424)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 4065020939)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 4065020939)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 4065020939)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 4065020939)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2758077881)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2758077881)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2758077881)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2758077881)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 4027263675)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 4027263675)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 4027263675)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 4027263675)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_IPluginFactory3Vtbl = struct_Steinberg_IPluginFactory3Vtbl;
pub const Steinberg_IPluginFactory3 = struct_Steinberg_IPluginFactory3;
pub const Steinberg_IPluginFactory3_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 1163240107)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1163240107)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1163240107)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1163240107)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3240316503)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3240316503)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3240316503)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3240316503)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2601658640)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2601658640)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2601658640)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2601658640)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 914852145)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 914852145)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 914852145)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 914852145)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_Vst_IComponentVtbl = struct_Steinberg_Vst_IComponentVtbl;
pub const Steinberg_Vst_IComponent = struct_Steinberg_Vst_IComponent;
pub const Steinberg_Vst_IComponent_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3895590705)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3895590705)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3895590705)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3895590705)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 4074062593)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 4074062593)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 4074062593)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 4074062593)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2458827758)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2458827758)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2458827758)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2458827758)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 627668994)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 627668994)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 627668994)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 627668994)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_Vst_IAttributeListVtbl = struct_Steinberg_Vst_IAttributeListVtbl;
pub const Steinberg_Vst_IAttributeList = struct_Steinberg_Vst_IAttributeList;
pub const Steinberg_Vst_IAttributeList_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 509545195)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 509545195)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 509545195)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 509545195)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3430892851)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3430892851)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3430892851)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3430892851)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2723430417)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2723430417)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2723430417)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2723430417)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 950886116)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 950886116)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 950886116)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 950886116)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_Vst_IStreamAttributesVtbl = struct_Steinberg_Vst_IStreamAttributesVtbl;
pub const Steinberg_Vst_IStreamAttributes = struct_Steinberg_Vst_IStreamAttributes;
pub const Steinberg_Vst_IStreamAttributes_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3603836924)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3603836924)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3603836924)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3603836924)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 4021242764)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 4021242764)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 4021242764)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 4021242764)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2658464187)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2658464187)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2658464187)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2658464187)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 316294324)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 316294324)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 316294324)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 316294324)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_Vst_IComponentHandlerVtbl = struct_Steinberg_Vst_IComponentHandlerVtbl;
pub const Steinberg_Vst_IComponentHandler = struct_Steinberg_Vst_IComponentHandler;
pub const Steinberg_Vst_IComponentHandler_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2476785315)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2476785315)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2476785315)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2476785315)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 198198747)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 198198747)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 198198747)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 198198747)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2391345932)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2391345932)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2391345932)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2391345932)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3252972230)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3252972230)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3252972230)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3252972230)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_Vst_IComponentHandler2Vtbl = struct_Steinberg_Vst_IComponentHandler2Vtbl;
pub const Steinberg_Vst_IComponentHandler2 = struct_Steinberg_Vst_IComponentHandler2;
pub const Steinberg_Vst_IComponentHandler2_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 4030772403)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 4030772403)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 4030772403)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 4030772403)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2740995564)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2740995564)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2740995564)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2740995564)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2882388037)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2882388037)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2882388037)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2882388037)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3033899724)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3033899724)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3033899724)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3033899724)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_Vst_IComponentHandlerBusActivationVtbl = struct_Steinberg_Vst_IComponentHandlerBusActivationVtbl;
pub const Steinberg_Vst_IComponentHandlerBusActivation = struct_Steinberg_Vst_IComponentHandlerBusActivation;
pub const Steinberg_Vst_IComponentHandlerBusActivation_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 108856001)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 108856001)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 108856001)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 108856001)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1531848525)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1531848525)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 1531848525)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1531848525)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2838335741)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2838335741)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2838335741)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2838335741)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1856991808)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1856991808)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1856991808)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 1856991808)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_Vst_IProgressVtbl = struct_Steinberg_Vst_IProgressVtbl;
pub const Steinberg_Vst_IProgress = struct_Steinberg_Vst_IProgress;
pub const Steinberg_Vst_IProgress_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 13229147)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 13229147)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 13229147)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 13229147)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2643477076)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2643477076)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2643477076)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2643477076)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2443413704)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2443413704)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2443413704)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2443413704)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3035175785)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3035175785)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3035175785)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3035175785)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_Vst_IEditControllerVtbl = struct_Steinberg_Vst_IEditControllerVtbl;
pub const Steinberg_Vst_IEditController = struct_Steinberg_Vst_IEditController;
pub const Steinberg_Vst_IEditController_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3705125859)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3705125859)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3705125859)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3705125859)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 2000831629)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 2000831629)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 2000831629)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 2000831629)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2826218188)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2826218188)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2826218188)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2826218188)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2543613342)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2543613342)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2543613342)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2543613342)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_Vst_IEditController2Vtbl = struct_Steinberg_Vst_IEditController2Vtbl;
pub const Steinberg_Vst_IEditController2 = struct_Steinberg_Vst_IEditController2;
pub const Steinberg_Vst_IEditController2_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 2135883353)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 2135883353)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 2135883353)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 2135883353)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 4078979431)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 4078979431)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 4078979431)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 4078979431)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2888278958)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2888278958)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2888278958)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2888278958)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2947952696)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2947952696)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2947952696)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2947952696)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_Vst_IMidiMappingVtbl = struct_Steinberg_Vst_IMidiMappingVtbl;
pub const Steinberg_Vst_IMidiMapping = struct_Steinberg_Vst_IMidiMapping;
pub const Steinberg_Vst_IMidiMapping_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3742366199)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3742366199)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3742366199)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3742366199)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1236747881)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1236747881)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 1236747881)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1236747881)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3057301298)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3057301298)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3057301298)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3057301298)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 2061235685)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 2061235685)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 2061235685)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 2061235685)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_Vst_IEditControllerHostEditingVtbl = struct_Steinberg_Vst_IEditControllerHostEditingVtbl;
pub const Steinberg_Vst_IEditControllerHostEditing = struct_Steinberg_Vst_IEditControllerHostEditing;
pub const Steinberg_Vst_IEditControllerHostEditing_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3240563208)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3240563208)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3240563208)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3240563208)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1884897432)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1884897432)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 1884897432)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1884897432)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3118281907)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3118281907)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3118281907)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3118281907)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1806702942)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1806702942)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1806702942)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 1806702942)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_Vst_IEventListVtbl = struct_Steinberg_Vst_IEventListVtbl;
pub const Steinberg_Vst_IEventList = struct_Steinberg_Vst_IEventList;
pub const Steinberg_Vst_IEventList_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 975979028)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 975979028)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 975979028)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 975979028)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 878922238)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 878922238)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 878922238)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 878922238)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2999251863)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2999251863)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2999251863)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2999251863)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3110689348)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3110689348)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3110689348)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3110689348)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_Vst_IMessageVtbl = struct_Steinberg_Vst_IMessageVtbl;
pub const Steinberg_Vst_IMessage = struct_Steinberg_Vst_IMessage;
pub const Steinberg_Vst_IMessage_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2473526075)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2473526075)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2473526075)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2473526075)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3334490075)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3334490075)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3334490075)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3334490075)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3137897208)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3137897208)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3137897208)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3137897208)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 331474451)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 331474451)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 331474451)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 331474451)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_Vst_IConnectionPointVtbl = struct_Steinberg_Vst_IConnectionPointVtbl;
pub const Steinberg_Vst_IConnectionPoint = struct_Steinberg_Vst_IConnectionPoint;
pub const Steinberg_Vst_IConnectionPoint_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 1889801583)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1889801583)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1889801583)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1889801583)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1852719142)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1852719142)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 1852719142)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1852719142)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2559658175)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2559658175)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2559658175)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2559658175)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2858473681)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2858473681)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2858473681)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2858473681)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_Vst_IXmlRepresentationControllerVtbl = struct_Steinberg_Vst_IXmlRepresentationControllerVtbl;
pub const Steinberg_Vst_IXmlRepresentationController = struct_Steinberg_Vst_IXmlRepresentationController;
pub const Steinberg_Vst_IXmlRepresentationController_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2820277361)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2820277361)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2820277361)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2820277361)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1220758980)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1220758980)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 1220758980)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1220758980)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2888878561)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2888878561)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2888878561)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2888878561)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1015256021)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1015256021)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1015256021)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 1015256021)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_Vst_IComponentHandler3Vtbl = struct_Steinberg_Vst_IComponentHandler3Vtbl;
pub const Steinberg_Vst_IComponentHandler3 = struct_Steinberg_Vst_IComponentHandler3;
pub const Steinberg_Vst_IComponentHandler3_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 1777407511)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1777407511)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1777407511)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1777407511)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3530244109)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3530244109)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3530244109)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3530244109)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2763438436)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2763438436)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2763438436)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2763438436)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 2070854571)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 2070854571)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 2070854571)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 2070854571)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_Vst_IContextMenuTargetVtbl = struct_Steinberg_Vst_IContextMenuTargetVtbl;
pub const Steinberg_Vst_IContextMenuTarget = struct_Steinberg_Vst_IContextMenuTarget;
pub const Steinberg_Vst_IContextMenuTarget_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 1021259381)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1021259381)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1021259381)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1021259381)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2245214532)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2245214532)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2245214532)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2245214532)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3213284203)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3213284203)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3213284203)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3213284203)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3619981645)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3619981645)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3619981645)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3619981645)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_Vst_IContextMenuVtbl = struct_Steinberg_Vst_IContextMenuVtbl;
pub const Steinberg_Vst_IContextMenu = struct_Steinberg_Vst_IContextMenu;
pub const Steinberg_Vst_IContextMenu_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 781437027)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 781437027)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 781437027)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 781437027)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 211568008)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 211568008)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 211568008)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 211568008)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2547772661)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2547772661)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2547772661)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2547772661)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2903998845)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2903998845)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2903998845)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2903998845)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_Vst_IMidiLearnVtbl = struct_Steinberg_Vst_IMidiLearnVtbl;
pub const Steinberg_Vst_IMidiLearn = struct_Steinberg_Vst_IMidiLearn;
pub const Steinberg_Vst_IMidiLearn_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 1797540300)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1797540300)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1797540300)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1797540300)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1100431541)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1100431541)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 1100431541)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1100431541)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2872867290)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2872867290)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2872867290)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2872867290)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3321781382)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3321781382)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3321781382)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3321781382)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_Vst_ChannelContext_IInfoListenerVtbl = struct_Steinberg_Vst_ChannelContext_IInfoListenerVtbl;
pub const Steinberg_Vst_ChannelContext_IInfoListener = struct_Steinberg_Vst_ChannelContext_IInfoListener;
pub const Steinberg_Vst_ChannelContext_IInfoListener_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 253314945)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 253314945)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 253314945)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 253314945)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2375568090)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2375568090)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2375568090)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2375568090)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3147874799)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3147874799)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3147874799)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3147874799)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3222395088)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3222395088)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3222395088)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3222395088)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_Vst_IPrefetchableSupportVtbl = struct_Steinberg_Vst_IPrefetchableSupportVtbl;
pub const Steinberg_Vst_IPrefetchableSupport = struct_Steinberg_Vst_IPrefetchableSupport;
pub const Steinberg_Vst_IPrefetchableSupport_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2330283994)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2330283994)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2330283994)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2330283994)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3912255161)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3912255161)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3912255161)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3912255161)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2726647228)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2726647228)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2726647228)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2726647228)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3701006878)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3701006878)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3701006878)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3701006878)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_Vst_IAutomationStateVtbl = struct_Steinberg_Vst_IAutomationStateVtbl;
pub const Steinberg_Vst_IAutomationState = struct_Steinberg_Vst_IAutomationState;
pub const Steinberg_Vst_IAutomationState_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3035113599)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3035113599)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3035113599)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3035113599)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 464733866)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 464733866)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 464733866)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 464733866)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2208589415)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2208589415)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2208589415)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2208589415)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1754495915)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1754495915)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1754495915)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 1754495915)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_Vst_IInterAppAudioHostVtbl = struct_Steinberg_Vst_IInterAppAudioHostVtbl;
pub const Steinberg_Vst_IInterAppAudioHost = struct_Steinberg_Vst_IInterAppAudioHost;
pub const Steinberg_Vst_IInterAppAudioHost_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 216364093)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 216364093)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 216364093)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 216364093)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1759461726)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1759461726)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 1759461726)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1759461726)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2921880532)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2921880532)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2921880532)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2921880532)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3805137149)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3805137149)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3805137149)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3805137149)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_Vst_IInterAppAudioConnectionNotificationVtbl = struct_Steinberg_Vst_IInterAppAudioConnectionNotificationVtbl;
pub const Steinberg_Vst_IInterAppAudioConnectionNotification = struct_Steinberg_Vst_IInterAppAudioConnectionNotification;
pub const Steinberg_Vst_IInterAppAudioConnectionNotification_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 1612760877)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1612760877)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1612760877)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1612760877)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1606568609)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1606568609)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 1606568609)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1606568609)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2962558389)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2962558389)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2962558389)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2962558389)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3621180879)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3621180879)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3621180879)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3621180879)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_Vst_IInterAppAudioPresetManagerVtbl = struct_Steinberg_Vst_IInterAppAudioPresetManagerVtbl;
pub const Steinberg_Vst_IInterAppAudioPresetManager = struct_Steinberg_Vst_IInterAppAudioPresetManager;
pub const Steinberg_Vst_IInterAppAudioPresetManager_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2917596356)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2917596356)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2917596356)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2917596356)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1187597853)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1187597853)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 1187597853)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1187597853)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3014957696)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3014957696)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3014957696)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3014957696)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3376410589)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3376410589)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3376410589)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3376410589)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_Vst_IAudioProcessorVtbl = struct_Steinberg_Vst_IAudioProcessorVtbl;
pub const Steinberg_Vst_IAudioProcessor = struct_Steinberg_Vst_IAudioProcessor;
pub const Steinberg_Vst_IAudioProcessor_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 1107574681)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1107574681)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1107574681)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1107574681)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3084535100)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3084535100)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3084535100)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3084535100)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2775181213)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2775181213)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2775181213)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2775181213)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2595144509)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2595144509)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2595144509)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2595144509)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_Vst_IAudioPresentationLatencyVtbl = struct_Steinberg_Vst_IAudioPresentationLatencyVtbl;
pub const Steinberg_Vst_IAudioPresentationLatency = struct_Steinberg_Vst_IAudioPresentationLatency;
pub const Steinberg_Vst_IAudioPresentationLatency_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 815713912)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 815713912)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 815713912)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 815713912)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3950858158)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3950858158)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3950858158)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3950858158)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2334270937)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2334270937)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2334270937)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2334270937)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 167577782)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 167577782)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 167577782)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 167577782)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_Vst_IProcessContextRequirementsVtbl = struct_Steinberg_Vst_IProcessContextRequirementsVtbl;
pub const Steinberg_Vst_IProcessContextRequirements = struct_Steinberg_Vst_IProcessContextRequirements;
pub const Steinberg_Vst_IProcessContextRequirements_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 711279363)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 711279363)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 711279363)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 711279363)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 4017507901)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 4017507901)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 4017507901)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 4017507901)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2511732355)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2511732355)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2511732355)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2511732355)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1930360528)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1930360528)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1930360528)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 1930360528)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_Vst_IHostApplicationVtbl = struct_Steinberg_Vst_IHostApplicationVtbl;
pub const Steinberg_Vst_IHostApplication = struct_Steinberg_Vst_IHostApplication;
pub const Steinberg_Vst_IHostApplication_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 1491441100)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1491441100)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1491441100)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1491441100)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3677178217)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3677178217)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3677178217)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3677178217)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2339024780)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2339024780)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2339024780)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2339024780)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 916874469)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 916874469)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 916874469)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 916874469)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_Vst_IVst3ToVst2WrapperVtbl = struct_Steinberg_Vst_IVst3ToVst2WrapperVtbl;
pub const Steinberg_Vst_IVst3ToVst2Wrapper = struct_Steinberg_Vst_IVst3ToVst2Wrapper;
pub const Steinberg_Vst_IVst3ToVst2Wrapper_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 694369004)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 694369004)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 694369004)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 694369004)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 488392674)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 488392674)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 488392674)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 488392674)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3146103163)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3146103163)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3146103163)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3146103163)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3547245665)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3547245665)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3547245665)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3547245665)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_Vst_IVst3ToAUWrapperVtbl = struct_Steinberg_Vst_IVst3ToAUWrapperVtbl;
pub const Steinberg_Vst_IVst3ToAUWrapper = struct_Steinberg_Vst_IVst3ToAUWrapper;
pub const Steinberg_Vst_IVst3ToAUWrapper_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2746795717)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2746795717)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2746795717)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2746795717)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3231008392)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3231008392)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3231008392)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3231008392)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2962321163)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2962321163)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2962321163)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2962321163)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3063392836)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3063392836)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3063392836)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3063392836)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_Vst_IVst3ToAAXWrapperVtbl = struct_Steinberg_Vst_IVst3ToAAXWrapperVtbl;
pub const Steinberg_Vst_IVst3ToAAXWrapper = struct_Steinberg_Vst_IVst3ToAAXWrapper;
pub const Steinberg_Vst_IVst3ToAAXWrapper_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 1831968198)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1831968198)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1831968198)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1831968198)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1623548482)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1623548482)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 1623548482)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1623548482)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3006043419)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3006043419)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3006043419)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3006043419)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2478765254)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2478765254)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2478765254)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2478765254)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_Vst_IVst3WrapperMPESupportVtbl = struct_Steinberg_Vst_IVst3WrapperMPESupportVtbl;
pub const Steinberg_Vst_IVst3WrapperMPESupport = struct_Steinberg_Vst_IVst3WrapperMPESupport;
pub const Steinberg_Vst_IVst3WrapperMPESupport_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 1142198375)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1142198375)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1142198375)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1142198375)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1120881657)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1120881657)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 1120881657)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1120881657)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2281748304)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2281748304)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2281748304)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2281748304)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 4147486691)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 4147486691)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 4147486691)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 4147486691)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_Vst_IParameterFinderVtbl = struct_Steinberg_Vst_IParameterFinderVtbl;
pub const Steinberg_Vst_IParameterFinder = struct_Steinberg_Vst_IParameterFinder;
pub const Steinberg_Vst_IParameterFinder_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 258048770)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 258048770)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 258048770)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 258048770)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 559760775)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 559760775)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 559760775)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 559760775)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2769422140)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2769422140)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2769422140)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2769422140)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 2008667011)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 2008667011)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 2008667011)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 2008667011)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_Vst_IUnitHandlerVtbl = struct_Steinberg_Vst_IUnitHandlerVtbl;
pub const Steinberg_Vst_IUnitHandler = struct_Steinberg_Vst_IUnitHandler;
pub const Steinberg_Vst_IUnitHandler_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 1263618040)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1263618040)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1263618040)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1263618040)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1179928683)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1179928683)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 1179928683)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1179928683)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2376806586)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2376806586)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2376806586)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2376806586)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 372915286)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 372915286)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 372915286)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 372915286)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_Vst_IUnitHandler2Vtbl = struct_Steinberg_Vst_IUnitHandler2Vtbl;
pub const Steinberg_Vst_IUnitHandler2 = struct_Steinberg_Vst_IUnitHandler2;
pub const Steinberg_Vst_IUnitHandler2_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 4171205855)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 4171205855)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 4171205855)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 4171205855)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1771981733)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1771981733)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 1771981733)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1771981733)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2527775140)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2527775140)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2527775140)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2527775140)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2168793857)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2168793857)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2168793857)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2168793857)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_Vst_IUnitInfoVtbl = struct_Steinberg_Vst_IUnitInfoVtbl;
pub const Steinberg_Vst_IUnitInfo = struct_Steinberg_Vst_IUnitInfo;
pub const Steinberg_Vst_IUnitInfo_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 1028380341)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1028380341)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1028380341)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1028380341)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2436517842)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2436517842)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2436517842)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2436517842)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2827413352)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2827413352)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2827413352)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2827413352)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2783679169)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2783679169)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2783679169)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2783679169)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_Vst_IProgramListDataVtbl = struct_Steinberg_Vst_IProgramListDataVtbl;
pub const Steinberg_Vst_IProgramListData = struct_Steinberg_Vst_IProgramListData;
pub const Steinberg_Vst_IProgramListData_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2256777247)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2256777247)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2256777247)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2256777247)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 2067091312)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 2067091312)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 2067091312)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 2067091312)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2724535788)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2724535788)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2724535788)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2724535788)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 893056255)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 893056255)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 893056255)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 893056255)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_Vst_IUnitDataVtbl = struct_Steinberg_Vst_IUnitDataVtbl;
pub const Steinberg_Vst_IUnitData = struct_Steinberg_Vst_IUnitData;
pub const Steinberg_Vst_IUnitData_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 1815647761)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1815647761)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1815647761)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1815647761)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3549513053)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3549513053)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3549513053)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3549513053)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3094394931)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3094394931)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3094394931)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3094394931)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2493575133)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2493575133)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2493575133)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2493575133)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_Vst_IPlugInterfaceSupportVtbl = struct_Steinberg_Vst_IPlugInterfaceSupportVtbl;
pub const Steinberg_Vst_IPlugInterfaceSupport = struct_Steinberg_Vst_IPlugInterfaceSupport;
pub const Steinberg_Vst_IPlugInterfaceSupport_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 1337297822)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1337297822)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1337297822)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1337297822)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2661961231)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2661961231)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2661961231)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2661961231)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2872450076)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2872450076)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2872450076)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2872450076)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3434442730)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3434442730)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3434442730)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3434442730)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_Vst_IParameterFunctionNameVtbl = struct_Steinberg_Vst_IParameterFunctionNameVtbl;
pub const Steinberg_Vst_IParameterFunctionName = struct_Steinberg_Vst_IParameterFunctionName;
pub const Steinberg_Vst_IParameterFunctionName_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 1830937052)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1830937052)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1830937052)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1830937052)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2434374987)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2434374987)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2434374987)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2434374987)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2728407023)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2728407023)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2728407023)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2728407023)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1813701980)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1813701980)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1813701980)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 1813701980)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_Vst_IParamValueQueueVtbl = struct_Steinberg_Vst_IParamValueQueueVtbl;
pub const Steinberg_Vst_IParamValueQueue = struct_Steinberg_Vst_IParamValueQueue;
pub const Steinberg_Vst_IParamValueQueue_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 19282456)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 19282456)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 19282456)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 19282456)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3976679279)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3976679279)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3976679279)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3976679279)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2563363670)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2563363670)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2563363670)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2563363670)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1183250874)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1183250874)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1183250874)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 1183250874)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const Steinberg_Vst_IParameterChangesVtbl = struct_Steinberg_Vst_IParameterChangesVtbl;
pub const Steinberg_Vst_IParameterChanges = struct_Steinberg_Vst_IParameterChanges;
pub const Steinberg_Vst_IParameterChanges_iid: Steinberg_TUID = [16]u8{
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 2759300707)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2759300707)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2759300707)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 2759300707)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 196495958)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 196495958)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 196495958)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 196495958)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3024323752)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3024323752)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_uint, 3024323752)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_uint, 3024323752)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1181739933)) & @as(c_uint, 4278190080)) >> @intCast(@import("std").math.Log2Int(c_uint), 24))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1181739933)) & @bitCast(Steinberg_uint32, @as(c_int, 16711680))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 16))),
    @bitCast(Steinberg_int8, @truncate(u8, (@bitCast(Steinberg_uint32, @as(c_int, 1181739933)) & @bitCast(Steinberg_uint32, @as(c_int, 65280))) >> @intCast(@import("std").math.Log2Int(Steinberg_uint32), 8))),
    @bitCast(Steinberg_int8, @truncate(u8, @bitCast(Steinberg_uint32, @as(c_int, 1181739933)) & @bitCast(Steinberg_uint32, @as(c_int, 255)))),
};
pub const __INTMAX_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `LL`"); // (no file):79:9
pub const __UINTMAX_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `ULL`"); // (no file):85:9
pub const __FLT16_DENORM_MIN__ = @compileError("unable to translate C expr: unexpected token 'IntegerLiteral'"); // (no file):108:9
pub const __FLT16_EPSILON__ = @compileError("unable to translate C expr: unexpected token 'IntegerLiteral'"); // (no file):112:9
pub const __FLT16_MAX__ = @compileError("unable to translate C expr: unexpected token 'IntegerLiteral'"); // (no file):118:9
pub const __FLT16_MIN__ = @compileError("unable to translate C expr: unexpected token 'IntegerLiteral'"); // (no file):121:9
pub const __INT64_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `LL`"); // (no file):183:9
pub const __UINT32_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `U`"); // (no file):205:9
pub const __UINT64_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `ULL`"); // (no file):213:9
pub const __seg_gs = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // (no file):341:9
pub const __seg_fs = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // (no file):342:9
pub const __declspec = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // (no file):408:9
pub const _cdecl = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // (no file):409:9
pub const __cdecl = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // (no file):410:9
pub const _stdcall = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // (no file):411:9
pub const __stdcall = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // (no file):412:9
pub const _fastcall = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // (no file):413:9
pub const __fastcall = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // (no file):414:9
pub const _thiscall = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // (no file):415:9
pub const __thiscall = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // (no file):416:9
pub const _pascal = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // (no file):417:9
pub const __pascal = @compileError("unable to translate macro: undefined identifier `__attribute__`"); // (no file):418:9
pub const __stdint_join3 = @compileError("unable to translate C expr: unexpected token '##'"); // C:\Users\Alex\zig\lib\include/stdint.h:287:9
pub const __int_c_join = @compileError("unable to translate C expr: unexpected token '##'"); // C:\Users\Alex\zig\lib\include/stdint.h:324:9
pub const __uint_c = @compileError("unable to translate macro: undefined identifier `U`"); // C:\Users\Alex\zig\lib\include/stdint.h:326:9
pub const __INTN_MIN = @compileError("unable to translate macro: undefined identifier `INT`"); // C:\Users\Alex\zig\lib\include/stdint.h:894:10
pub const __INTN_MAX = @compileError("unable to translate macro: undefined identifier `INT`"); // C:\Users\Alex\zig\lib\include/stdint.h:895:10
pub const __UINTN_MAX = @compileError("unable to translate macro: undefined identifier `UINT`"); // C:\Users\Alex\zig\lib\include/stdint.h:896:9
pub const __INTN_C = @compileError("unable to translate macro: undefined identifier `INT`"); // C:\Users\Alex\zig\lib\include/stdint.h:897:10
pub const __UINTN_C = @compileError("unable to translate macro: undefined identifier `UINT`"); // C:\Users\Alex\zig\lib\include/stdint.h:898:9
pub const SMTG_INLINE_UID = @compileError("unable to translate C expr: unexpected token '{'"); // vst3_c_api.h:28:9
pub const __llvm__ = @as(c_int, 1);
pub const __clang__ = @as(c_int, 1);
pub const __clang_major__ = @as(c_int, 16);
pub const __clang_minor__ = @as(c_int, 0);
pub const __clang_patchlevel__ = @as(c_int, 1);
pub const __clang_version__ = "16.0.1 (https://github.com/ziglang/zig-bootstrap 710c5d12660235bc4eac103a8c6677c61f0a9ded)";
pub const __GNUC__ = @as(c_int, 4);
pub const __GNUC_MINOR__ = @as(c_int, 2);
pub const __GNUC_PATCHLEVEL__ = @as(c_int, 1);
pub const __GXX_ABI_VERSION = @as(c_int, 1002);
pub const __ATOMIC_RELAXED = @as(c_int, 0);
pub const __ATOMIC_CONSUME = @as(c_int, 1);
pub const __ATOMIC_ACQUIRE = @as(c_int, 2);
pub const __ATOMIC_RELEASE = @as(c_int, 3);
pub const __ATOMIC_ACQ_REL = @as(c_int, 4);
pub const __ATOMIC_SEQ_CST = @as(c_int, 5);
pub const __OPENCL_MEMORY_SCOPE_WORK_ITEM = @as(c_int, 0);
pub const __OPENCL_MEMORY_SCOPE_WORK_GROUP = @as(c_int, 1);
pub const __OPENCL_MEMORY_SCOPE_DEVICE = @as(c_int, 2);
pub const __OPENCL_MEMORY_SCOPE_ALL_SVM_DEVICES = @as(c_int, 3);
pub const __OPENCL_MEMORY_SCOPE_SUB_GROUP = @as(c_int, 4);
pub const __PRAGMA_REDEFINE_EXTNAME = @as(c_int, 1);
pub const __VERSION__ = "Clang 16.0.1 (https://github.com/ziglang/zig-bootstrap 710c5d12660235bc4eac103a8c6677c61f0a9ded)";
pub const __OBJC_BOOL_IS_BOOL = @as(c_int, 0);
pub const __CONSTANT_CFSTRINGS__ = @as(c_int, 1);
pub const __SEH__ = @as(c_int, 1);
pub const __clang_literal_encoding__ = "UTF-8";
pub const __clang_wide_literal_encoding__ = "UTF-16";
pub const __ORDER_LITTLE_ENDIAN__ = @as(c_int, 1234);
pub const __ORDER_BIG_ENDIAN__ = @as(c_int, 4321);
pub const __ORDER_PDP_ENDIAN__ = @as(c_int, 3412);
pub const __BYTE_ORDER__ = __ORDER_LITTLE_ENDIAN__;
pub const __LITTLE_ENDIAN__ = @as(c_int, 1);
pub const __CHAR_BIT__ = @as(c_int, 8);
pub const __BOOL_WIDTH__ = @as(c_int, 8);
pub const __SHRT_WIDTH__ = @as(c_int, 16);
pub const __INT_WIDTH__ = @as(c_int, 32);
pub const __LONG_WIDTH__ = @as(c_int, 32);
pub const __LLONG_WIDTH__ = @as(c_int, 64);
pub const __BITINT_MAXWIDTH__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 8388608, .decimal);
pub const __SCHAR_MAX__ = @as(c_int, 127);
pub const __SHRT_MAX__ = @as(c_int, 32767);
pub const __INT_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __LONG_MAX__ = @as(c_long, 2147483647);
pub const __LONG_LONG_MAX__ = @as(c_longlong, 9223372036854775807);
pub const __WCHAR_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 65535, .decimal);
pub const __WCHAR_WIDTH__ = @as(c_int, 16);
pub const __WINT_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 65535, .decimal);
pub const __WINT_WIDTH__ = @as(c_int, 16);
pub const __INTMAX_MAX__ = @as(c_longlong, 9223372036854775807);
pub const __INTMAX_WIDTH__ = @as(c_int, 64);
pub const __SIZE_MAX__ = @as(c_ulonglong, 18446744073709551615);
pub const __SIZE_WIDTH__ = @as(c_int, 64);
pub const __UINTMAX_MAX__ = @as(c_ulonglong, 18446744073709551615);
pub const __UINTMAX_WIDTH__ = @as(c_int, 64);
pub const __PTRDIFF_MAX__ = @as(c_longlong, 9223372036854775807);
pub const __PTRDIFF_WIDTH__ = @as(c_int, 64);
pub const __INTPTR_MAX__ = @as(c_longlong, 9223372036854775807);
pub const __INTPTR_WIDTH__ = @as(c_int, 64);
pub const __UINTPTR_MAX__ = @as(c_ulonglong, 18446744073709551615);
pub const __UINTPTR_WIDTH__ = @as(c_int, 64);
pub const __SIZEOF_DOUBLE__ = @as(c_int, 8);
pub const __SIZEOF_FLOAT__ = @as(c_int, 4);
pub const __SIZEOF_INT__ = @as(c_int, 4);
pub const __SIZEOF_LONG__ = @as(c_int, 4);
pub const __SIZEOF_LONG_DOUBLE__ = @as(c_int, 16);
pub const __SIZEOF_LONG_LONG__ = @as(c_int, 8);
pub const __SIZEOF_POINTER__ = @as(c_int, 8);
pub const __SIZEOF_SHORT__ = @as(c_int, 2);
pub const __SIZEOF_PTRDIFF_T__ = @as(c_int, 8);
pub const __SIZEOF_SIZE_T__ = @as(c_int, 8);
pub const __SIZEOF_WCHAR_T__ = @as(c_int, 2);
pub const __SIZEOF_WINT_T__ = @as(c_int, 2);
pub const __SIZEOF_INT128__ = @as(c_int, 16);
pub const __INTMAX_TYPE__ = c_longlong;
pub const __INTMAX_FMTd__ = "lld";
pub const __INTMAX_FMTi__ = "lli";
pub const __UINTMAX_TYPE__ = c_ulonglong;
pub const __UINTMAX_FMTo__ = "llo";
pub const __UINTMAX_FMTu__ = "llu";
pub const __UINTMAX_FMTx__ = "llx";
pub const __UINTMAX_FMTX__ = "llX";
pub const __PTRDIFF_TYPE__ = c_longlong;
pub const __PTRDIFF_FMTd__ = "lld";
pub const __PTRDIFF_FMTi__ = "lli";
pub const __INTPTR_TYPE__ = c_longlong;
pub const __INTPTR_FMTd__ = "lld";
pub const __INTPTR_FMTi__ = "lli";
pub const __SIZE_TYPE__ = c_ulonglong;
pub const __SIZE_FMTo__ = "llo";
pub const __SIZE_FMTu__ = "llu";
pub const __SIZE_FMTx__ = "llx";
pub const __SIZE_FMTX__ = "llX";
pub const __WCHAR_TYPE__ = c_ushort;
pub const __WINT_TYPE__ = c_ushort;
pub const __SIG_ATOMIC_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __SIG_ATOMIC_WIDTH__ = @as(c_int, 32);
pub const __CHAR16_TYPE__ = c_ushort;
pub const __CHAR32_TYPE__ = c_uint;
pub const __UINTPTR_TYPE__ = c_ulonglong;
pub const __UINTPTR_FMTo__ = "llo";
pub const __UINTPTR_FMTu__ = "llu";
pub const __UINTPTR_FMTx__ = "llx";
pub const __UINTPTR_FMTX__ = "llX";
pub const __FLT16_HAS_DENORM__ = @as(c_int, 1);
pub const __FLT16_DIG__ = @as(c_int, 3);
pub const __FLT16_DECIMAL_DIG__ = @as(c_int, 5);
pub const __FLT16_HAS_INFINITY__ = @as(c_int, 1);
pub const __FLT16_HAS_QUIET_NAN__ = @as(c_int, 1);
pub const __FLT16_MANT_DIG__ = @as(c_int, 11);
pub const __FLT16_MAX_10_EXP__ = @as(c_int, 4);
pub const __FLT16_MAX_EXP__ = @as(c_int, 16);
pub const __FLT16_MIN_10_EXP__ = -@as(c_int, 4);
pub const __FLT16_MIN_EXP__ = -@as(c_int, 13);
pub const __FLT_DENORM_MIN__ = @as(f32, 1.40129846e-45);
pub const __FLT_HAS_DENORM__ = @as(c_int, 1);
pub const __FLT_DIG__ = @as(c_int, 6);
pub const __FLT_DECIMAL_DIG__ = @as(c_int, 9);
pub const __FLT_EPSILON__ = @as(f32, 1.19209290e-7);
pub const __FLT_HAS_INFINITY__ = @as(c_int, 1);
pub const __FLT_HAS_QUIET_NAN__ = @as(c_int, 1);
pub const __FLT_MANT_DIG__ = @as(c_int, 24);
pub const __FLT_MAX_10_EXP__ = @as(c_int, 38);
pub const __FLT_MAX_EXP__ = @as(c_int, 128);
pub const __FLT_MAX__ = @as(f32, 3.40282347e+38);
pub const __FLT_MIN_10_EXP__ = -@as(c_int, 37);
pub const __FLT_MIN_EXP__ = -@as(c_int, 125);
pub const __FLT_MIN__ = @as(f32, 1.17549435e-38);
pub const __DBL_DENORM_MIN__ = @as(f64, 4.9406564584124654e-324);
pub const __DBL_HAS_DENORM__ = @as(c_int, 1);
pub const __DBL_DIG__ = @as(c_int, 15);
pub const __DBL_DECIMAL_DIG__ = @as(c_int, 17);
pub const __DBL_EPSILON__ = @as(f64, 2.2204460492503131e-16);
pub const __DBL_HAS_INFINITY__ = @as(c_int, 1);
pub const __DBL_HAS_QUIET_NAN__ = @as(c_int, 1);
pub const __DBL_MANT_DIG__ = @as(c_int, 53);
pub const __DBL_MAX_10_EXP__ = @as(c_int, 308);
pub const __DBL_MAX_EXP__ = @as(c_int, 1024);
pub const __DBL_MAX__ = @as(f64, 1.7976931348623157e+308);
pub const __DBL_MIN_10_EXP__ = -@as(c_int, 307);
pub const __DBL_MIN_EXP__ = -@as(c_int, 1021);
pub const __DBL_MIN__ = @as(f64, 2.2250738585072014e-308);
pub const __LDBL_DENORM_MIN__ = @as(c_longdouble, 3.64519953188247460253e-4951);
pub const __LDBL_HAS_DENORM__ = @as(c_int, 1);
pub const __LDBL_DIG__ = @as(c_int, 18);
pub const __LDBL_DECIMAL_DIG__ = @as(c_int, 21);
pub const __LDBL_EPSILON__ = @as(c_longdouble, 1.08420217248550443401e-19);
pub const __LDBL_HAS_INFINITY__ = @as(c_int, 1);
pub const __LDBL_HAS_QUIET_NAN__ = @as(c_int, 1);
pub const __LDBL_MANT_DIG__ = @as(c_int, 64);
pub const __LDBL_MAX_10_EXP__ = @as(c_int, 4932);
pub const __LDBL_MAX_EXP__ = @as(c_int, 16384);
pub const __LDBL_MAX__ = @as(c_longdouble, 1.18973149535723176502e+4932);
pub const __LDBL_MIN_10_EXP__ = -@as(c_int, 4931);
pub const __LDBL_MIN_EXP__ = -@as(c_int, 16381);
pub const __LDBL_MIN__ = @as(c_longdouble, 3.36210314311209350626e-4932);
pub const __POINTER_WIDTH__ = @as(c_int, 64);
pub const __BIGGEST_ALIGNMENT__ = @as(c_int, 16);
pub const __WCHAR_UNSIGNED__ = @as(c_int, 1);
pub const __WINT_UNSIGNED__ = @as(c_int, 1);
pub const __INT8_TYPE__ = i8;
pub const __INT8_FMTd__ = "hhd";
pub const __INT8_FMTi__ = "hhi";
pub const __INT8_C_SUFFIX__ = "";
pub const __INT16_TYPE__ = c_short;
pub const __INT16_FMTd__ = "hd";
pub const __INT16_FMTi__ = "hi";
pub const __INT16_C_SUFFIX__ = "";
pub const __INT32_TYPE__ = c_int;
pub const __INT32_FMTd__ = "d";
pub const __INT32_FMTi__ = "i";
pub const __INT32_C_SUFFIX__ = "";
pub const __INT64_TYPE__ = c_longlong;
pub const __INT64_FMTd__ = "lld";
pub const __INT64_FMTi__ = "lli";
pub const __UINT8_TYPE__ = u8;
pub const __UINT8_FMTo__ = "hho";
pub const __UINT8_FMTu__ = "hhu";
pub const __UINT8_FMTx__ = "hhx";
pub const __UINT8_FMTX__ = "hhX";
pub const __UINT8_C_SUFFIX__ = "";
pub const __UINT8_MAX__ = @as(c_int, 255);
pub const __INT8_MAX__ = @as(c_int, 127);
pub const __UINT16_TYPE__ = c_ushort;
pub const __UINT16_FMTo__ = "ho";
pub const __UINT16_FMTu__ = "hu";
pub const __UINT16_FMTx__ = "hx";
pub const __UINT16_FMTX__ = "hX";
pub const __UINT16_C_SUFFIX__ = "";
pub const __UINT16_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 65535, .decimal);
pub const __INT16_MAX__ = @as(c_int, 32767);
pub const __UINT32_TYPE__ = c_uint;
pub const __UINT32_FMTo__ = "o";
pub const __UINT32_FMTu__ = "u";
pub const __UINT32_FMTx__ = "x";
pub const __UINT32_FMTX__ = "X";
pub const __UINT32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const __INT32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __UINT64_TYPE__ = c_ulonglong;
pub const __UINT64_FMTo__ = "llo";
pub const __UINT64_FMTu__ = "llu";
pub const __UINT64_FMTx__ = "llx";
pub const __UINT64_FMTX__ = "llX";
pub const __UINT64_MAX__ = @as(c_ulonglong, 18446744073709551615);
pub const __INT64_MAX__ = @as(c_longlong, 9223372036854775807);
pub const __INT_LEAST8_TYPE__ = i8;
pub const __INT_LEAST8_MAX__ = @as(c_int, 127);
pub const __INT_LEAST8_WIDTH__ = @as(c_int, 8);
pub const __INT_LEAST8_FMTd__ = "hhd";
pub const __INT_LEAST8_FMTi__ = "hhi";
pub const __UINT_LEAST8_TYPE__ = u8;
pub const __UINT_LEAST8_MAX__ = @as(c_int, 255);
pub const __UINT_LEAST8_FMTo__ = "hho";
pub const __UINT_LEAST8_FMTu__ = "hhu";
pub const __UINT_LEAST8_FMTx__ = "hhx";
pub const __UINT_LEAST8_FMTX__ = "hhX";
pub const __INT_LEAST16_TYPE__ = c_short;
pub const __INT_LEAST16_MAX__ = @as(c_int, 32767);
pub const __INT_LEAST16_WIDTH__ = @as(c_int, 16);
pub const __INT_LEAST16_FMTd__ = "hd";
pub const __INT_LEAST16_FMTi__ = "hi";
pub const __UINT_LEAST16_TYPE__ = c_ushort;
pub const __UINT_LEAST16_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 65535, .decimal);
pub const __UINT_LEAST16_FMTo__ = "ho";
pub const __UINT_LEAST16_FMTu__ = "hu";
pub const __UINT_LEAST16_FMTx__ = "hx";
pub const __UINT_LEAST16_FMTX__ = "hX";
pub const __INT_LEAST32_TYPE__ = c_int;
pub const __INT_LEAST32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __INT_LEAST32_WIDTH__ = @as(c_int, 32);
pub const __INT_LEAST32_FMTd__ = "d";
pub const __INT_LEAST32_FMTi__ = "i";
pub const __UINT_LEAST32_TYPE__ = c_uint;
pub const __UINT_LEAST32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const __UINT_LEAST32_FMTo__ = "o";
pub const __UINT_LEAST32_FMTu__ = "u";
pub const __UINT_LEAST32_FMTx__ = "x";
pub const __UINT_LEAST32_FMTX__ = "X";
pub const __INT_LEAST64_TYPE__ = c_longlong;
pub const __INT_LEAST64_MAX__ = @as(c_longlong, 9223372036854775807);
pub const __INT_LEAST64_WIDTH__ = @as(c_int, 64);
pub const __INT_LEAST64_FMTd__ = "lld";
pub const __INT_LEAST64_FMTi__ = "lli";
pub const __UINT_LEAST64_TYPE__ = c_ulonglong;
pub const __UINT_LEAST64_MAX__ = @as(c_ulonglong, 18446744073709551615);
pub const __UINT_LEAST64_FMTo__ = "llo";
pub const __UINT_LEAST64_FMTu__ = "llu";
pub const __UINT_LEAST64_FMTx__ = "llx";
pub const __UINT_LEAST64_FMTX__ = "llX";
pub const __INT_FAST8_TYPE__ = i8;
pub const __INT_FAST8_MAX__ = @as(c_int, 127);
pub const __INT_FAST8_WIDTH__ = @as(c_int, 8);
pub const __INT_FAST8_FMTd__ = "hhd";
pub const __INT_FAST8_FMTi__ = "hhi";
pub const __UINT_FAST8_TYPE__ = u8;
pub const __UINT_FAST8_MAX__ = @as(c_int, 255);
pub const __UINT_FAST8_FMTo__ = "hho";
pub const __UINT_FAST8_FMTu__ = "hhu";
pub const __UINT_FAST8_FMTx__ = "hhx";
pub const __UINT_FAST8_FMTX__ = "hhX";
pub const __INT_FAST16_TYPE__ = c_short;
pub const __INT_FAST16_MAX__ = @as(c_int, 32767);
pub const __INT_FAST16_WIDTH__ = @as(c_int, 16);
pub const __INT_FAST16_FMTd__ = "hd";
pub const __INT_FAST16_FMTi__ = "hi";
pub const __UINT_FAST16_TYPE__ = c_ushort;
pub const __UINT_FAST16_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 65535, .decimal);
pub const __UINT_FAST16_FMTo__ = "ho";
pub const __UINT_FAST16_FMTu__ = "hu";
pub const __UINT_FAST16_FMTx__ = "hx";
pub const __UINT_FAST16_FMTX__ = "hX";
pub const __INT_FAST32_TYPE__ = c_int;
pub const __INT_FAST32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __INT_FAST32_WIDTH__ = @as(c_int, 32);
pub const __INT_FAST32_FMTd__ = "d";
pub const __INT_FAST32_FMTi__ = "i";
pub const __UINT_FAST32_TYPE__ = c_uint;
pub const __UINT_FAST32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const __UINT_FAST32_FMTo__ = "o";
pub const __UINT_FAST32_FMTu__ = "u";
pub const __UINT_FAST32_FMTx__ = "x";
pub const __UINT_FAST32_FMTX__ = "X";
pub const __INT_FAST64_TYPE__ = c_longlong;
pub const __INT_FAST64_MAX__ = @as(c_longlong, 9223372036854775807);
pub const __INT_FAST64_WIDTH__ = @as(c_int, 64);
pub const __INT_FAST64_FMTd__ = "lld";
pub const __INT_FAST64_FMTi__ = "lli";
pub const __UINT_FAST64_TYPE__ = c_ulonglong;
pub const __UINT_FAST64_MAX__ = @as(c_ulonglong, 18446744073709551615);
pub const __UINT_FAST64_FMTo__ = "llo";
pub const __UINT_FAST64_FMTu__ = "llu";
pub const __UINT_FAST64_FMTx__ = "llx";
pub const __UINT_FAST64_FMTX__ = "llX";
pub const __USER_LABEL_PREFIX__ = "";
pub const __FINITE_MATH_ONLY__ = @as(c_int, 0);
pub const __GNUC_STDC_INLINE__ = @as(c_int, 1);
pub const __GCC_ATOMIC_TEST_AND_SET_TRUEVAL = @as(c_int, 1);
pub const __CLANG_ATOMIC_BOOL_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_CHAR_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_CHAR16_T_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_CHAR32_T_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_WCHAR_T_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_SHORT_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_INT_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_LONG_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_LLONG_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_POINTER_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_BOOL_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_CHAR_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_CHAR16_T_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_CHAR32_T_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_WCHAR_T_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_SHORT_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_INT_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_LONG_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_LLONG_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_POINTER_LOCK_FREE = @as(c_int, 2);
pub const __NO_INLINE__ = @as(c_int, 1);
pub const __PIC__ = @as(c_int, 2);
pub const __pic__ = @as(c_int, 2);
pub const __FLT_RADIX__ = @as(c_int, 2);
pub const __DECIMAL_DIG__ = __LDBL_DECIMAL_DIG__;
pub const __GCC_ASM_FLAG_OUTPUTS__ = @as(c_int, 1);
pub const __code_model_small__ = @as(c_int, 1);
pub const __amd64__ = @as(c_int, 1);
pub const __amd64 = @as(c_int, 1);
pub const __x86_64 = @as(c_int, 1);
pub const __x86_64__ = @as(c_int, 1);
pub const __SEG_GS = @as(c_int, 1);
pub const __SEG_FS = @as(c_int, 1);
pub const __znver1 = @as(c_int, 1);
pub const __znver1__ = @as(c_int, 1);
pub const __tune_znver1__ = @as(c_int, 1);
pub const __REGISTER_PREFIX__ = "";
pub const __NO_MATH_INLINES = @as(c_int, 1);
pub const __AES__ = @as(c_int, 1);
pub const __PCLMUL__ = @as(c_int, 1);
pub const __LAHF_SAHF__ = @as(c_int, 1);
pub const __LZCNT__ = @as(c_int, 1);
pub const __RDRND__ = @as(c_int, 1);
pub const __FSGSBASE__ = @as(c_int, 1);
pub const __BMI__ = @as(c_int, 1);
pub const __BMI2__ = @as(c_int, 1);
pub const __POPCNT__ = @as(c_int, 1);
pub const __PRFCHW__ = @as(c_int, 1);
pub const __RDSEED__ = @as(c_int, 1);
pub const __ADX__ = @as(c_int, 1);
pub const __MWAITX__ = @as(c_int, 1);
pub const __MOVBE__ = @as(c_int, 1);
pub const __SSE4A__ = @as(c_int, 1);
pub const __FMA__ = @as(c_int, 1);
pub const __F16C__ = @as(c_int, 1);
pub const __SHA__ = @as(c_int, 1);
pub const __FXSR__ = @as(c_int, 1);
pub const __XSAVE__ = @as(c_int, 1);
pub const __XSAVEOPT__ = @as(c_int, 1);
pub const __XSAVEC__ = @as(c_int, 1);
pub const __XSAVES__ = @as(c_int, 1);
pub const __CLFLUSHOPT__ = @as(c_int, 1);
pub const __CLWB__ = @as(c_int, 1);
pub const __WBNOINVD__ = @as(c_int, 1);
pub const __CLZERO__ = @as(c_int, 1);
pub const __RDPID__ = @as(c_int, 1);
pub const __CRC32__ = @as(c_int, 1);
pub const __AVX2__ = @as(c_int, 1);
pub const __AVX__ = @as(c_int, 1);
pub const __SSE4_2__ = @as(c_int, 1);
pub const __SSE4_1__ = @as(c_int, 1);
pub const __SSSE3__ = @as(c_int, 1);
pub const __SSE3__ = @as(c_int, 1);
pub const __SSE2__ = @as(c_int, 1);
pub const __SSE2_MATH__ = @as(c_int, 1);
pub const __SSE__ = @as(c_int, 1);
pub const __SSE_MATH__ = @as(c_int, 1);
pub const __MMX__ = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_1 = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_2 = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_4 = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_8 = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_16 = @as(c_int, 1);
pub const __SIZEOF_FLOAT128__ = @as(c_int, 16);
pub const _WIN32 = @as(c_int, 1);
pub const _WIN64 = @as(c_int, 1);
pub const WIN32 = @as(c_int, 1);
pub const __WIN32 = @as(c_int, 1);
pub const __WIN32__ = @as(c_int, 1);
pub const WINNT = @as(c_int, 1);
pub const __WINNT = @as(c_int, 1);
pub const __WINNT__ = @as(c_int, 1);
pub const WIN64 = @as(c_int, 1);
pub const __WIN64 = @as(c_int, 1);
pub const __WIN64__ = @as(c_int, 1);
pub const __MINGW64__ = @as(c_int, 1);
pub const __MSVCRT__ = @as(c_int, 1);
pub const __MINGW32__ = @as(c_int, 1);
pub const __STDC__ = @as(c_int, 1);
pub const __STDC_HOSTED__ = @as(c_int, 1);
pub const __STDC_VERSION__ = @as(c_long, 201710);
pub const __STDC_UTF_16__ = @as(c_int, 1);
pub const __STDC_UTF_32__ = @as(c_int, 1);
pub const _DEBUG = @as(c_int, 1);
pub const __CLANG_STDINT_H = "";
pub const __int_least64_t = i64;
pub const __uint_least64_t = u64;
pub const __int_least32_t = i64;
pub const __uint_least32_t = u64;
pub const __int_least16_t = i64;
pub const __uint_least16_t = u64;
pub const __int_least8_t = i64;
pub const __uint_least8_t = u64;
pub const __uint32_t_defined = "";
pub const __int8_t_defined = "";
pub const __intptr_t_defined = "";
pub const _INTPTR_T = "";
pub const _UINTPTR_T = "";
pub inline fn __int_c(v: anytype, suffix: anytype) @TypeOf(__int_c_join(v, suffix)) {
    return __int_c_join(v, suffix);
}
pub const __int64_c_suffix = __INT64_C_SUFFIX__;
pub const __int32_c_suffix = __INT64_C_SUFFIX__;
pub const __int16_c_suffix = __INT64_C_SUFFIX__;
pub const __int8_c_suffix = __INT64_C_SUFFIX__;
pub inline fn INT64_C(v: anytype) @TypeOf(__int_c(v, __int64_c_suffix)) {
    return __int_c(v, __int64_c_suffix);
}
pub inline fn UINT64_C(v: anytype) @TypeOf(__uint_c(v, __int64_c_suffix)) {
    return __uint_c(v, __int64_c_suffix);
}
pub inline fn INT32_C(v: anytype) @TypeOf(__int_c(v, __int32_c_suffix)) {
    return __int_c(v, __int32_c_suffix);
}
pub inline fn UINT32_C(v: anytype) @TypeOf(__uint_c(v, __int32_c_suffix)) {
    return __uint_c(v, __int32_c_suffix);
}
pub inline fn INT16_C(v: anytype) @TypeOf(__int_c(v, __int16_c_suffix)) {
    return __int_c(v, __int16_c_suffix);
}
pub inline fn UINT16_C(v: anytype) @TypeOf(__uint_c(v, __int16_c_suffix)) {
    return __uint_c(v, __int16_c_suffix);
}
pub inline fn INT8_C(v: anytype) @TypeOf(__int_c(v, __int8_c_suffix)) {
    return __int_c(v, __int8_c_suffix);
}
pub inline fn UINT8_C(v: anytype) @TypeOf(__uint_c(v, __int8_c_suffix)) {
    return __uint_c(v, __int8_c_suffix);
}
pub const INT64_MAX = INT64_C(@import("std").zig.c_translation.promoteIntLiteral(c_int, 9223372036854775807, .decimal));
pub const INT64_MIN = -INT64_C(@import("std").zig.c_translation.promoteIntLiteral(c_int, 9223372036854775807, .decimal)) - @as(c_int, 1);
pub const UINT64_MAX = UINT64_C(@import("std").zig.c_translation.promoteIntLiteral(c_int, 18446744073709551615, .decimal));
pub const __INT_LEAST64_MIN = INT64_MIN;
pub const __INT_LEAST64_MAX = INT64_MAX;
pub const __UINT_LEAST64_MAX = UINT64_MAX;
pub const __INT_LEAST32_MIN = INT64_MIN;
pub const __INT_LEAST32_MAX = INT64_MAX;
pub const __UINT_LEAST32_MAX = UINT64_MAX;
pub const __INT_LEAST16_MIN = INT64_MIN;
pub const __INT_LEAST16_MAX = INT64_MAX;
pub const __UINT_LEAST16_MAX = UINT64_MAX;
pub const __INT_LEAST8_MIN = INT64_MIN;
pub const __INT_LEAST8_MAX = INT64_MAX;
pub const __UINT_LEAST8_MAX = UINT64_MAX;
pub const INT_LEAST64_MIN = __INT_LEAST64_MIN;
pub const INT_LEAST64_MAX = __INT_LEAST64_MAX;
pub const UINT_LEAST64_MAX = __UINT_LEAST64_MAX;
pub const INT_FAST64_MIN = __INT_LEAST64_MIN;
pub const INT_FAST64_MAX = __INT_LEAST64_MAX;
pub const UINT_FAST64_MAX = __UINT_LEAST64_MAX;
pub const INT32_MAX = INT32_C(@import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal));
pub const INT32_MIN = -INT32_C(@import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal)) - @as(c_int, 1);
pub const UINT32_MAX = UINT32_C(@import("std").zig.c_translation.promoteIntLiteral(c_int, 4294967295, .decimal));
pub const INT_LEAST32_MIN = __INT_LEAST32_MIN;
pub const INT_LEAST32_MAX = __INT_LEAST32_MAX;
pub const UINT_LEAST32_MAX = __UINT_LEAST32_MAX;
pub const INT_FAST32_MIN = __INT_LEAST32_MIN;
pub const INT_FAST32_MAX = __INT_LEAST32_MAX;
pub const UINT_FAST32_MAX = __UINT_LEAST32_MAX;
pub const INT16_MAX = INT16_C(@as(c_int, 32767));
pub const INT16_MIN = -INT16_C(@as(c_int, 32767)) - @as(c_int, 1);
pub const UINT16_MAX = UINT16_C(@import("std").zig.c_translation.promoteIntLiteral(c_int, 65535, .decimal));
pub const INT_LEAST16_MIN = __INT_LEAST16_MIN;
pub const INT_LEAST16_MAX = __INT_LEAST16_MAX;
pub const UINT_LEAST16_MAX = __UINT_LEAST16_MAX;
pub const INT_FAST16_MIN = __INT_LEAST16_MIN;
pub const INT_FAST16_MAX = __INT_LEAST16_MAX;
pub const UINT_FAST16_MAX = __UINT_LEAST16_MAX;
pub const INT8_MAX = INT8_C(@as(c_int, 127));
pub const INT8_MIN = -INT8_C(@as(c_int, 127)) - @as(c_int, 1);
pub const UINT8_MAX = UINT8_C(@as(c_int, 255));
pub const INT_LEAST8_MIN = __INT_LEAST8_MIN;
pub const INT_LEAST8_MAX = __INT_LEAST8_MAX;
pub const UINT_LEAST8_MAX = __UINT_LEAST8_MAX;
pub const INT_FAST8_MIN = __INT_LEAST8_MIN;
pub const INT_FAST8_MAX = __INT_LEAST8_MAX;
pub const UINT_FAST8_MAX = __UINT_LEAST8_MAX;
pub const INTPTR_MIN = -__INTPTR_MAX__ - @as(c_int, 1);
pub const INTPTR_MAX = __INTPTR_MAX__;
pub const UINTPTR_MAX = __UINTPTR_MAX__;
pub const PTRDIFF_MIN = -__PTRDIFF_MAX__ - @as(c_int, 1);
pub const PTRDIFF_MAX = __PTRDIFF_MAX__;
pub const SIZE_MAX = __SIZE_MAX__;
pub const INTMAX_MIN = -__INTMAX_MAX__ - @as(c_int, 1);
pub const INTMAX_MAX = __INTMAX_MAX__;
pub const UINTMAX_MAX = __UINTMAX_MAX__;
pub const SIG_ATOMIC_MIN = __INTN_MIN(__SIG_ATOMIC_WIDTH__);
pub const SIG_ATOMIC_MAX = __INTN_MAX(__SIG_ATOMIC_WIDTH__);
pub const WINT_MIN = __UINTN_C(__WINT_WIDTH__, @as(c_int, 0));
pub const WINT_MAX = __UINTN_MAX(__WINT_WIDTH__);
pub const WCHAR_MAX = __WCHAR_MAX__;
pub const WCHAR_MIN = __UINTN_C(__WCHAR_WIDTH__, @as(c_int, 0));
pub inline fn INTMAX_C(v: anytype) @TypeOf(__int_c(v, __INTMAX_C_SUFFIX__)) {
    return __int_c(v, __INTMAX_C_SUFFIX__);
}
pub inline fn UINTMAX_C(v: anytype) @TypeOf(__int_c(v, __UINTMAX_C_SUFFIX__)) {
    return __int_c(v, __UINTMAX_C_SUFFIX__);
}
pub const SMTG_STDMETHODCALLTYPE = __stdcall;
pub const SMTG_COM_COMPATIBLE = @as(c_int, 1);
pub const Steinberg_ViewRect = struct_Steinberg_ViewRect;
pub const Steinberg_Vst_NoteExpressionValueDescription = struct_Steinberg_Vst_NoteExpressionValueDescription;
pub const Steinberg_Vst_NoteExpressionTypeInfo = struct_Steinberg_Vst_NoteExpressionTypeInfo;
pub const Steinberg_Vst_KeyswitchInfo = struct_Steinberg_Vst_KeyswitchInfo;
pub const Steinberg_Vst_PhysicalUIMap = struct_Steinberg_Vst_PhysicalUIMap;
pub const Steinberg_Vst_PhysicalUIMapList = struct_Steinberg_Vst_PhysicalUIMapList;
pub const Steinberg_PFactoryInfo = struct_Steinberg_PFactoryInfo;
pub const Steinberg_PClassInfo = struct_Steinberg_PClassInfo;
pub const Steinberg_PClassInfo2 = struct_Steinberg_PClassInfo2;
pub const Steinberg_PClassInfoW = struct_Steinberg_PClassInfoW;
pub const Steinberg_Vst_BusInfo = struct_Steinberg_Vst_BusInfo;
pub const Steinberg_Vst_RoutingInfo = struct_Steinberg_Vst_RoutingInfo;
pub const Steinberg_Vst_ParameterInfo = struct_Steinberg_Vst_ParameterInfo;
pub const Steinberg_Vst_NoteOnEvent = struct_Steinberg_Vst_NoteOnEvent;
pub const Steinberg_Vst_NoteOffEvent = struct_Steinberg_Vst_NoteOffEvent;
pub const Steinberg_Vst_DataEvent = struct_Steinberg_Vst_DataEvent;
pub const Steinberg_Vst_PolyPressureEvent = struct_Steinberg_Vst_PolyPressureEvent;
pub const Steinberg_Vst_NoteExpressionValueEvent = struct_Steinberg_Vst_NoteExpressionValueEvent;
pub const Steinberg_Vst_NoteExpressionTextEvent = struct_Steinberg_Vst_NoteExpressionTextEvent;
pub const Steinberg_Vst_ChordEvent = struct_Steinberg_Vst_ChordEvent;
pub const Steinberg_Vst_ScaleEvent = struct_Steinberg_Vst_ScaleEvent;
pub const Steinberg_Vst_LegacyMIDICCOutEvent = struct_Steinberg_Vst_LegacyMIDICCOutEvent;
pub const Steinberg_Vst_Event = struct_Steinberg_Vst_Event;
pub const Steinberg_Vst_RepresentationInfo = struct_Steinberg_Vst_RepresentationInfo;
pub const Steinberg_Vst_IContextMenuItem = struct_Steinberg_Vst_IContextMenuItem;
pub const Steinberg_Vst_ProcessSetup = struct_Steinberg_Vst_ProcessSetup;
pub const Steinberg_Vst_AudioBusBuffers = struct_Steinberg_Vst_AudioBusBuffers;
pub const Steinberg_Vst_Chord = struct_Steinberg_Vst_Chord;
pub const Steinberg_Vst_FrameRate = struct_Steinberg_Vst_FrameRate;
pub const Steinberg_Vst_ProcessContext = struct_Steinberg_Vst_ProcessContext;
pub const Steinberg_Vst_ProcessData = struct_Steinberg_Vst_ProcessData;
pub const Steinberg_Vst_UnitInfo = struct_Steinberg_Vst_UnitInfo;
pub const Steinberg_Vst_ProgramListInfo = struct_Steinberg_Vst_ProgramListInfo;
