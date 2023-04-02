//! Params.zig
//! some delclarations for handling parameters & changes

const std = @import("std");
const Plugin = @import("Plugin.zig");
pub const clap = @cImport({
    @cInclude("clap/clap.h");
});

const c_cast = std.zig.c_translation.cast;

const Self = @This();

/// clamp a float to a 0 - 1 range
pub fn FloatClamp01(x: anytype) type {
    return if (x >= 1.0) 1.0 else if (x <= 0) 0 else x;
}

/// structure for plugin parameters
const Values = struct {
    volume: f64 = 1.0,
};

values: Values = Values{},

const ParamInfo = struct {
    id: u32,
    name: []const u8,
    minValue: f64,
    maxValue: f64,
};

const list = [std.meta.fields(Values).len]ParamInfo{
    .{ .id = 0, .name = "Volume", .minValue = 0.0, .maxValue = 20.0 },
};

fn count(plugin: [*c]const clap.clap_plugin_t) callconv(.C) u32 {
    _ = plugin;
    return std.meta.fields(Values).len;
}

fn getInfo(plugin: [*c]const clap.clap_plugin_t, index: u32, info: [*c]clap.clap_param_info_t) callconv(.C) bool {
    _ = plugin;
    switch (index) {
        (index == 0) => {
            info.* = .{
                .id = index,
                .flags = clap.CLAP_PARAM_IS_AUTOMATABLE | clap.CLAP_PARAM_IS_MODULATABLE,
                .min_value = 0.0,
                .max_value = 1.0,
                .default_value = 0.5,
            };
            std.mem.copy(u8, &info.*.name, list[index].name);
            return true;
        },
        else => return false,
    }
}

fn idToValue(self: Self, id: u32) !f64 {
    const values = std.meta.fields(Values);
    inline for (values, 0..) |v, i| {
        if (list[i] == id) {
            return @field(self.values, v.name);
        }
    }
    return error.CantFindValue;
}

fn getValue(self: *Self, plugin: [*c]const clap.clap_plugin_t, id: clap.clap_id, value: [*c]f64) callconv(.C) bool {
    _ = plugin;
    const paramValues = std.meta.fields(self.Value);
    const i = c_cast(u32, id);
    if (i >= paramValues.len)
        return false;
    value.* = idToValue(i);
    return true;
}

fn setValue(self: *Self, param_id: u32, value: f64) void {
    const values = std.meta.fields(Values);
    var valuePtr: *f64 = undefined;
    inline for (values, 0..) |v, i| {
        if (self.list[i].id == param_id) {
            valuePtr = &@field(self.Values, v.name);
            valuePtr.* = value;
        } else unreachable;
    }
}

fn valueToText(plugin: [*c]const clap.clap_plugin_t, id: clap.clap_id, value: f64, display: [*c]const u8, size: u32) callconv(.C) bool {
    _ = size;
    _ = plugin;
    const i = c_cast(u32, id);
    if (i >= std.meta.fields(Values)) return false;
    // std.log.info("{s}: {d}", .{ display, value });
    _ = std.fmt.bufPrintZ(display, "{d:.2}", .{value}) catch unreachable;
    return true;
}

fn textToValue(plugin: [*c]const clap.clap_plugin_t, param_id: clap.clap_id, display: [*c]const u8, value: [*c]f64) callconv(.C) bool {
    _ = value;
    _ = display;
    _ = param_id;
    _ = plugin;
    return false;
}

fn flush(plugin: [*c]const clap.clap_plugin_t, in: [*c]const clap.clap_input_events_t, out: [*c]const clap.clap_output_events_t) callconv(.C) void {
    var plug = c_cast(*Plugin, plugin.*.plugin_data);
    const eventCount = in.*.size.?(in);
    plug.syncMainToAudio(out);

    var eventIndex: u32 = 0;
    while (eventIndex < eventCount) : (eventIndex += 1) {
        plug.processEvent(plug, in.*.get.?(in, eventIndex));
    }
}

const Data = clap.clap_plugin_params_t{
    .count = count,
    .get_info = getInfo,
    .get_value = getValue,
    .value_to_text = valueToText,
    .text_to_value = textToValue,
    .flush = flush,
};
