//! Params.zig
//! some delclarations for handling parameters & changes

const std = @import("std");
const Allocator = std.mem.Allocator;
const arbor = @import("arbor.zig");
const log = arbor.log;
const Plugin = arbor.Plugin;

pub const Parameter = struct {
    name: [:0]const u8,
    flags: packed struct {
        automatable: bool = true,
        modulatable: bool = false,
        stepped: bool = false,
        is_enum: bool = false,
        periodic: bool = false,
        hidden: bool = false,
        read_only: bool = false,
        bypass: bool = false,
        requires_process: bool = false,
    },
    min_value: f32,
    max_value: f32,
    default_value: f32,
    enum_choices: ?[]const [:0]const u8 = null,
};

/// create a parameter from a tuple of values
/// For a float or int param, pass min, max, and default in that order
/// For a choice/enum param, pass the default value
/// TODO: Support passing parameter flags to this function
pub fn create(comptime name: [:0]const u8, args: anytype) Parameter {
    const args_info = @typeInfo(@TypeOf(args));
    if (args_info != .Struct) @compileError("Expected tuple or struct, found " ++
        @typeName(@TypeOf(args)));

    const fields = args_info.Struct.fields;
    if (fields.len == 0) @compileError("Empty args not allowed, please define parameter values");

    switch (@typeInfo(fields[0].type)) {
        .Float, .ComptimeFloat => {
            if (fields.len > 3) @compileError("Too many arguments, expected 3");
            return .{
                .name = name,
                .min_value = @field(args, fields[0].name),
                .max_value = @field(args, fields[1].name),
                .default_value = @field(args, fields[2].name),
                .flags = .{},
            };
        },
        .Int, .ComptimeInt => {
            if (fields.len > 3) @compileError("Too many arguments, expected 3");
            return .{
                .name = name,
                .min_value = @floatFromInt(@field(args, fields[0].name)),
                .max_value = @floatFromInt(@field(args, fields[1].name)),
                .default_value = @floatFromInt(@field(args, fields[2].name)),
                .flags = .{ .stepped = true },
            };
        },
        .Enum => |info| {
            if (fields.len > 2) @compileError("Too many arguments, expected 2");
            const enum_fields = info.fields;
            const default = @field(args, fields[0].name);
            return .{
                .name = name,
                .min_value = @floatFromInt(enum_fields[0].value),
                .max_value = @floatFromInt(enum_fields[enum_fields.len - 1].value),
                .default_value = @floatFromInt(@intFromEnum(default)),
                .enum_choices = args[1], // assuming it's a tuple w/ 2 values
                .flags = .{ .stepped = true, .is_enum = true },
            };
        },
        .Bool => {
            if (fields.len > 1) @compileError("Too many arguments, expected 1");
            const default = @field(args, fields[0].name);
            return .{
                .name = name,
                .min_value = 0,
                .max_value = 1,
                .default_value = @floatFromInt(@intFromBool(default)),
                .flags = .{ .stepped = true },
            };
        },
        else => @compileError("Need float, int, or enum, got " ++ @typeName(fields[0].type)),
    }
}

/// Make a slice of all parameter values
/// Caller owns the returned memory
pub fn createSlice(allocator: std.mem.Allocator, params: []const Parameter) []f32 {
    var slice = allocator.alloc(f32, params.len) catch |e| log.fatal("Slice alloc failed: {}\n", .{e});
    for (params, 0..) |p, i| {
        slice[i] = p.default_value;
    }
    return slice;
}

// TODO: Refactor w/ above slice thing in mind
/// Key-value table for parameter lookup
pub fn Table(comptime UserPlugin: type) type {
    if (!@hasDecl(UserPlugin, "params"))
        @compileError("Expected params declaration");

    const allocator = if (@hasDecl(UserPlugin, "allocator"))
        UserPlugin.allocator
    else
        std.heap.c_allocator;

    const Map = std.StringArrayHashMap(f32);
    return struct {
        pub const Self = @This();
        map: Map = Map.init(allocator),
        params: []const Parameter = &UserPlugin.params,

        /// Can't call this at comptime bc map put uses an extern function
        pub fn init(self: *Self) void {
            for (self.params) |p| {
                self.map.put(p.name, p.default_value) catch |e|
                    log.fatal("Failed to put entry in params table: {}\n", .{e});
            }
        }

        pub fn deinit(self: *Self) void {
            self.map.deinit();
        }

        pub fn count(self: Self) usize {
            return self.map.count();
        }

        pub fn getParam(self: Self, comptime name: []const u8) *const Parameter {
            const id = self.map.getIndex(name) orelse
                log.fatal("Param {s} not found\n", .{name});
            return &self.params[id];
        }

        /// Get mutable ptr to float representation of param. If the base parameter
        /// type is an int or an enum, this float value can be directly cast without
        /// any normalization
        pub fn nameToValue(self: Self, comptime name: []const u8) *f32 {
            return self.map.getPtr(name) orelse
                log.fatal("Param {s} not found\n", .{name});
        }

        pub fn getNormalizedValue(self: Self, comptime name: []const u8) f32 {
            const value = self.map.get(name) orelse
                log.fatal("Param {s} not found\n", .{name});
            const param = self.getParam(name);
            return value / (param.max_value - param.min_value);
        }

        pub fn idToName(self: Self, id: u32) [:0]const u8 {
            std.debug.assert(id < self.count());
            return self.map.keys()[id];
        }

        /// id may be a u32 index or a string
        pub fn setValue(self: Self, comptime id: anytype, value: f32) void {
            switch (@typeInfo(id)) {
                std.builtin.Type.Int => {
                    self.map.values()[id].value = value;
                },
                std.builtin.Type.Array => {
                    if (self.map.getPtr(id)) |param|
                        param.value = value;
                },
            }
        }

        pub fn idToValue(self: Self, id: u32) f32 {
            std.debug.assert(id < self.count());
            return self.map.values()[id].value;
        }

        pub fn nameToID(self: Self, comptime name: []const u8) u32 {
            const keys = self.map.keys();
            inline for (keys, 0..) |k, i| {
                if (std.mem.eql(u8, k, name)) return i;
            }
        }
    };
}

pub fn BoolParam(default: bool) type {
    return struct {
        default: bool = default,
    };
}

pub fn ChoiceParam(comptime Choices: type, default: Choices) type {
    return struct {
        .choices = Choices,
        .default = @intFromEnum(default),
    };
}

// utils

/// clamp a float to a 0 - 1 range
pub fn float_clamp(x: anytype) @TypeOf(x) {
    return @min(1.0, @max(0, x));
}

test "Param table" {
    const Mode = enum {
        Vintage,
        Modern,
        Apocalypse,
    };

    const Chlugin = struct {
        const params = [_]Parameter{
            create("Gain", .{ 0.0, 10.0, 1.0 }),
            create("Freq", .{ 20.0, 20e3, 1e3 }),
            create("Mode", .{Mode.Vintage}),
        };
    };

    var table = Table(Chlugin){};
    table.init();
    defer table.deinit();
    const gain = table.map.get("Gain") orelse -1;
    try std.testing.expectEqual(1, gain);
    const freq = table.map.get("Freq") orelse -1;
    try std.testing.expectEqual(1e3, freq);

    const mode = table.map.get("Mode") orelse -1;
    const int: i32 = @intFromFloat(mode);
    const mode_enum = @as(Mode, @enumFromInt(int));
    try std.testing.expectEqual(Mode.Vintage, mode_enum);
}
