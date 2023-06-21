//! vst3_plugin.zig
//! Definition of VST3 implementation

const std = @import("std");
const c_cast = std.zig.c_translation.cast;
const sb = @import("vst3_api.zig");
const tresult = sb.Steinberg_tresult;
const Plugin = @import("Plugin.zig");
const plugin_name = Plugin.Description.plugin_name;
const vendor = Plugin.Description.vendor_name;
const version = Plugin.Description.version;
const url = Plugin.Description.url;
const email = Plugin.Description.contact_address;
const uid = Plugin.Description.vst3_desc.uid;
const category = Plugin.Description.vst3_desc.category;
const sdk_version = Plugin.Description.vst3_desc.sdk_version;

const gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

const PluginFactory = struct {
    fn queryInterface(this: ?*anyopaque, _iid: [*c]const u8, obj: [*c]?*anyopaque) callconv(.C) tresult {
        _ = obj;
        _ = _iid;
        _ = this;
        return sb.Steinberg_kResultOk;
    }
    fn addRef(this: ?*anyopaque) callconv(.C) u32 {
        _ = this;
        return 1;
    }
    fn release(this: ?*anyopaque) callconv(.C) u32 {
        _ = this;
        return 0;
    }
    fn getFactoryInfo(this: ?*anyopaque, info: [*c]sb.struct_Steinberg_PFactoryInfo) callconv(.C) tresult {
        _ = this;
        @memcpy(info.*.vendor[0..vendor.len], vendor);
        @memcpy(info.*.url[0..url.len], url);
        @memcpy(info.*.email[0..email.len], email);
        info.*.flags = sb.Steinberg_PFactoryInfo_FactoryFlags_kUnicode;
        return sb.Steinberg_kResultOk;
    }
    fn countClasses(this: ?*anyopaque) callconv(.C) i32 {
        _ = this;
        return 1;
    }
    fn getClassInfo(this: ?*anyopaque, index: i32, info: [*c]sb.struct_Steinberg_PClassInfo) callconv(.C) tresult {
        _ = this;
        if (index != 0) return sb.Steinberg_kInvalidArgument;
        @memcpy(info.*.cid[0..uid.len], uid);
        info.*.cardinality = sb.Steinberg_PClassInfo_ClassCardinality_kManyInstances;
        @memcpy(info.*.name[0..plugin_name.len], plugin_name);
        @memcpy(info.*.category[0..category.len], category);
        return sb.Steinberg_kResultOk;
    }
    fn createInstance(this: ?*anyopaque, cid: sb.Steinberg_FIDString, _iid: sb.Steinberg_FIDString, obj: [*c]?*anyopaque) callconv(.C) tresult {
        _ = cid;
        // if (!std.mem.eql(u8, cid, uid))
        //     return sb.Steinberg_kInvalidArgument;
        const result = queryInterface(this, _iid, obj);
        if (result == sb.Steinberg_kResultOk)
            _ = release(this);
        return sb.Steinberg_kResultOk;
    }
    fn getClassInfo2(this: ?*anyopaque, index: i32, info: [*c]sb.struct_Steinberg_PClassInfo2) callconv(.C) tresult {
        _ = this;
        if (index != 0) return sb.Steinberg_kInvalidArgument;
        @memcpy(info.*.cid[0..uid.len], uid);
        info.*.cardinality = sb.Steinberg_PClassInfo_ClassCardinality_kManyInstances;
        @memcpy(info.*.category[0..category.len], category);
        @memcpy(info.*.name[0..plugin_name.len], plugin_name);
        info.*.classFlags = 1 << 1;
        info.*.subCategories = joinSubcategories(Plugin.Description.vst3_desc.features);
        @memcpy(info.*.vendor[0..vendor.len], vendor);
        @memcpy(info.*.version[0..version.len], version);
        @memcpy(info.*.sdkVersion[0..sdk_version.len], sdk_version);
        return sb.Steinberg_kResultOk;
    }
    fn getClassInfoUnicode(this: ?*anyopaque, index: i32, info: [*c]sb.struct_Steinberg_PClassInfoW) callconv(.C) tresult {
        _ = info;
        _ = this;
        if (index != 0) return sb.Steinberg_kInvalidArgument;
        // Steinb0rg's 16-bit chars are i16
        // ...can we get away with u16?
        // @memcpy(info.*.cid[0..uid.len], uid);
        // info.*.cardinality = sb.Steinberg_PClassInfo_ClassCardinality_kManyInstances;
        // @memcpy(info.*.category[0..category.len], category);
        // @memcpy(info.*.name[0..plugin_name.len], plugin_name);
        // info.*.subCategories = joinSubcategories(Plugin.Description.vst3_desc.features);
        // @memcpy(info.*.vendor[0..vendor.len], vendor);
        // @memcpy(info.*.version[0..version.len], version);
        // @memcpy(info.*.sdkVersion[0..sdk_version.len], sdk_version);

        return sb.Steinberg_kResultOk;
    }
    fn setHostContext(this: ?*anyopaque, context: [*c]sb.struct_Steinberg_FUnknown) callconv(.C) tresult {
        _ = context;
        _ = this;
        return sb.Steinberg_kResultOk;
    }

    pub const Data = sb.Steinberg_IPluginFactory3Vtbl{
        .queryInterface = queryInterface,
        .addRef = addRef,
        .release = release,
        .getFactoryInfo = getFactoryInfo,
        .countClasses = countClasses,
        .getClassInfo = getClassInfo,
        .createInstance = createInstance,
        .getClassInfo2 = getClassInfo2,
        .getClassInfoUnicode = getClassInfoUnicode,
        .setHostContext = setHostContext,
    };
};

// Entry point
export fn GetPluginFactory() callconv(.C) [*c]sb.Steinberg_IPluginFactory3 {
    const factory: sb.Steinberg_IPluginFactory3 = .{ .lpVtbl = c_cast([*c]sb.Steinberg_IPluginFactory3Vtbl, &PluginFactory.Data) };

    return c_cast([*c]sb.Steinberg_IPluginFactory3, &factory);
}

fn joinSubcategories(subcategories: []const []const u8) [128]u8 {
    var buf: [128]u8 = undefined;
    var i: usize = 0;
    for (subcategories, 0..) |f, n| {
        @memcpy(buf[i .. f.len + i], f);
        i += f.len;
        if (n + 1 < subcategories.len) {
            @memcpy(buf[i .. i + 1], "|");
            i += 1;
        }
    }
    return buf;
}

test "Join subcategories" {
    const categ = &[_][]const u8{ "Fx", "Reverb", "Stereo" };
    const expect = "Fx|Reverb|Stereo";
    const result = joinSubcategories(categ);
    try std.testing.expect(std.mem.eql(u8, result[0..expect.len], expect));
}
