const std = @import("std");
const arbor = @import("arbor.zig");

const clap = @import("clap_plugin.zig");
const vst2 = @import("vst2_plugin.zig");

const testing = std.testing;
const expect = testing.expect;
const expectEqual = testing.expectEqual;
const equalStrings = testing.expectEqualStrings;

const span = std.mem.span;

const allocator = testing.allocator;

const test_params = &[_]arbor.Parameter{
    arbor.param.Float("gain", 0, 10, 0, .{ .flags = .{} }),
};

export fn init() *arbor.Plugin {
    return arbor.init(allocator, test_params, .{
        .deinit = deinit,
        .prepare = prepare,
        .process = process,
    });
}

export fn gui_create(_: *arbor.Plugin, _: *arbor.Gui.Config) void {}

fn deinit(_: *arbor.Plugin) void {}

fn prepare(_: *arbor.Plugin, _: f32, _: u32) void {}

fn process(_: *arbor.Plugin, _: arbor.AudioBuffer(f32)) void {}

export fn gui_init(_: *arbor.Plugin) void {}

test "CLAP features" {
    const features: arbor.PluginFeatures = arbor.features.STEREO | arbor.features.SYNTH |
        arbor.features.EQ | arbor.features.EFFECT;

    try expect(features & arbor.features.EFFECT > 0);
    try expect(features & arbor.features.INSTRUMENT == 0);
    var parsed = try arbor.parseClapFeatures(features);

    var i: u32 = 0;
    while (i < parsed.constSlice().len) : (i += 1) {
        const feat = parsed.slice()[i];
        if (feat == null) break;
        if (i == 0)
            try equalStrings(span(feat.?), "stereo");
        if (i == 1)
            try equalStrings(span(feat.?), "audio-effect");
        if (i == 2)
            try equalStrings(span(feat.?), "equalizer");
        if (i == 3)
            try equalStrings(span(feat.?), "synthesizer");
    }
}

test "VST2" {
    const vint = try arbor.Vst2VersionInt("0.1.0");
    try expectEqual(100, vint);
    const update = try arbor.Vst2VersionInt("2.3.5");
    try expectEqual(2350, update);

    const config = arbor.config;
    if (config.format != .VST2) return;
    const api = arbor.vst2;
    const Host = struct {
        pub fn cb(
            _: ?*api.AEffect,
            op: i32,
            _: i32,
            _: isize,
            _: ?*anyopaque,
            _: f32,
        ) callconv(.C) isize {
            switch (@as(api.HostOpcodes, @enumFromInt(op))) {
                .GetSampleRate => return 44100,
                .GetNumFrames => return 256,
                else => return 0,
            }
        }
    };
    const aeffect = try vst2.init(allocator, Host.cb);
    const plug = vst2.plugCast(aeffect);
    defer plug.deinit(allocator);

    const Op = api.Opcode;
    const dispatch = aeffect.dispatcher orelse {
        try expect(false);
        return;
    };

    // pass invalid opcode
    try expectEqual(-1, dispatch(aeffect, -311, 42, 0, null, 0.423423423));

    // vendor name
    {
        var buf: [api.StringConstants.MaxVendorStrLen]u8 = undefined;
        try expectEqual(0, dispatch(aeffect, @intFromEnum(Op.GetVendorString), 0, 0, &buf, 0));
        const exp_len = config.plugin_desc.company.len;
        try equalStrings(config.plugin_desc.company, buf[0..exp_len]);
    }
    // plugin name
    {
        var buf: [api.StringConstants.MaxProductStrLen]u8 = undefined;
        try expectEqual(0, dispatch(aeffect, @intFromEnum(Op.GetProductString), 0, 0, &buf, 0));
        const exp_len = config.plugin_desc.name.len;
        try equalStrings(config.plugin_desc.name, buf[0..exp_len]);
    }

    // param name
    {
        var buf: [api.StringConstants.MaxParamStrLen]u8 = undefined;
        try expectEqual(0, dispatch(aeffect, @intFromEnum(Op.GetParamName), 0, 0, &buf, 0));
    }
    // param value to text
    {
        var buf: [api.StringConstants.MaxParamStrLen]u8 = undefined;
        try expectEqual(0, dispatch(aeffect, @intFromEnum(Op.ParamValueToText), 0, 0, &buf, 0));
    }

    // SR & block size
    try expectEqual(0, dispatch(aeffect, @intFromEnum(Op.SetSampleRate), 0, 0, null, 44100));
    try expectEqual(0, dispatch(aeffect, @intFromEnum(Op.SetBlockSize), 0, 512, null, 0));

    // Load/save state
    {
        const n_param = aeffect.num_params;
        const params = try allocator.alloc(f32, @intCast(n_param));
        defer allocator.free(params);
        const ref_params = try allocator.alloc(f32, @intCast(n_param));
        defer allocator.free(ref_params);

        const size_bytes = params.len * @sizeOf(f32);

        for (params, 0..) |*p, i| {
            if (aeffect.getParameter) |get| {
                p.* = get(aeffect, @intCast(i));
                std.debug.print("param {d}: {d}\n", .{ i, p.* });
            }
        }

        @memcpy(ref_params, params);

        try expectEqual(
            @as(isize, @intCast(size_bytes)),
            dispatch(aeffect, @intFromEnum(Op.GetChunk), 0, 0, params.ptr, 0),
        );

        for (params, ref_params) |p, *r| {
            try expectEqual(r.*, p);
            r.* = 0.666;
        }

        try expectEqual(0, dispatch(aeffect, @intFromEnum(Op.SetChunk), 0, 0, ref_params.ptr, 0));

        for (plug.plugin.params) |pp| {
            try expectEqual(0.666, pp);
        }
    }

    try expectEqual(0, dispatch(aeffect, @intFromEnum(Op.Open), 0, 0, null, 0));
}
