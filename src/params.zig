//! Params.zig
//! some delclarations for handling parameters & changes

const std = @import("std");
const Allocator = std.mem.Allocator;
const arbor = @import("arbor.zig");
const log = arbor.log;
const Plugin = arbor.Plugin;

pub const Parameter = struct {
    name: [:0]const u8,
    flags: Flags = .{},
    min_value: f32,
    max_value: f32,
    default_value: f32,

    enum_choices: ?[]const []const u8 = null,

    text_to_value: ?*const fn (text: []const u8) f32 = null,
    value_to_text: ?*const fn (value: f32, []u8) usize = null,

    pub const Flags = packed struct {
        automatable: bool = true,
        modulatable: bool = false,
        /// TODO: See Issue #13
        smoothed: bool = false,
        stepped: bool = false,
        is_enum: bool = false,
        periodic: bool = false,
        hidden: bool = false,
        read_only: bool = false,
        bypass: bool = false,
        requires_process: bool = false,
    };

    pub fn getNormalizedValue(self: Parameter, val: f32) f32 {
        return (val - self.min_value) / (self.max_value - self.min_value);
    }

    pub fn valueFromNormalized(self: Parameter, val: f32) f32 {
        return val * (self.max_value - self.min_value) + self.min_value;
    }
};

pub const Options = struct {
    /// set of flags used for configuring parameter
    flags: Parameter.Flags,
    /// function to convert text into parameter value
    text_to_value: ?*const fn (text: []const u8) f32 = null,
    /// function to convert parameter value into text
    value_to_text: ?*const fn (value: f32, []u8) usize = null,
    /// for choice params, an optional list of choice names
    enum_choices: ?[]const []const u8 = null,
};

pub fn Float(
    comptime name: [:0]const u8,
    min: anytype,
    max: anytype,
    default: anytype,
    options: Options,
) Parameter {
    return Parameter{
        .name = name,
        .min_value = min,
        .max_value = max,
        .default_value = default,
        .flags = options.flags,
        .text_to_value = options.text_to_value,
        .value_to_text = options.value_to_text,
    };
}

pub fn Int(
    comptime name: [:0]const u8,
    min: anytype,
    max: anytype,
    default: anytype,
    options: Options,
) Parameter {
    var f = options.flags;
    f.stepped = true;
    return Parameter{
        .name = name,
        .min_value = min,
        .max_value = max,
        .default_value = default,
        .flags = f,
        .text_to_value = options.text_to_value,
        .value_to_text = options.value_to_text,
    };
}

pub fn Choice(
    comptime name: [:0]const u8,
    comptime default: anytype,
    options: Options,
) Parameter {
    const T = @TypeOf(default);
    const info = @typeInfo(T);
    if (info != .Enum) @compileError("Expected an enum instance");

    const fields = info.Enum.fields;
    const choices = options.enum_choices orelse std.meta.fieldNames(T);

    var f = options.flags;
    f.is_enum = true;
    f.stepped = true;

    return Parameter{
        .name = name,
        .min_value = fields[0].value,
        .max_value = fields[fields.len - 1].value,
        .default_value = @floatFromInt(@intFromEnum(default)),
        .enum_choices = &choices.*,
        .flags = f,
        .text_to_value = options.text_to_value,
        .value_to_text = options.value_to_text,
    };
}

pub fn Bool(
    comptime name: [:0]const u8,
    default: bool,
    options: Options,
) Parameter {
    var f = options.flags;
    f.stepped = true;
    return Parameter{
        .name = name,
        .min_value = 0,
        .max_value = 1,
        .default_value = @floatFromInt(@intFromBool(default)),
        .flags = f,
        .text_to_value = options.text_to_value,
        .value_to_text = options.value_to_text,
    };
}

/// Make a slice of all parameter values
/// Caller owns the returned memory
pub fn createSlice(allocator: std.mem.Allocator, params: []const Parameter) []f32 {
    var slice = allocator.alloc(f32, params.len) catch |e| log.fatal("Slice alloc failed: {}\n", .{e}, @src());
    for (params, 0..) |p, i| {
        slice[i] = p.default_value;
    }
    return slice;
}

// utils

/// clamp a float to a 0 - 1 range
pub fn float_clamp(x: anytype) @TypeOf(x) {
    return @min(1.0, @max(0, x));
}
