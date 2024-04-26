// //! Plugin.zig
// //! This is where you will define the properties of your plugin
// const std = @import("std");
// const arbor = @import("arbor.zig");
// const log = arbor.log;
// const clap = arbor.clap;
// const param = arbor.param;

// pub const Description = struct {
//     pub const format_desc = switch (format) {
//         .CLAP => FormatDesc.clap_desc,
//         .VST3 => FormatDesc.vst3_desc,
//         else => {},
//     };

//     // TODO: Make a clean way to define features, ideally
//     // one that will have you define just once features shared btw
//     // CLAP & VST, and the format-specific features can be defined separately
//     // PROBABLY: Should just define different enums for format features
//     pub const FormatDesc = struct {
//         const vst3_desc: VST3Description = .{
//             .uid = "AAu.ZigVerb.vst3",
//             .category = "Audio Module Class",
//             .features = &[_][]const u8{ "Fx", "Reverb" },
//             .sdk_version = "3.7.8",
//         };
//     };

//     const VST3Description = struct {
//         uid: []const u8,
//         features: []const []const u8,
//         category: []const u8,
//         sdk_version: []const u8,
//     };
// };

// TODO: This might not really be necessary. Try just building a plugin and
// putting most of the init logic in the plugin's init() function. Call arbor.init()
// from within there instead of arbor.config() in the build func and see what you can do.
// pub fn Plugin(comptime PluginType: type) type {
//     return struct {
//         params: []const param.Parameter = &PluginType.params,
//         // gui: ?*Gui = if (@hasField(plugin, "gui")) plugin.gui else null,
//     };
// }

// test "Generic plugin" {
//     const Plug = struct {
//         var arena = std.heap.ArenaAllocator.init(std.heap.c_allocator);
//         // if not pub, results in invalid free
//         pub const allocator = arena.allocator();
//         pub const Desc = arbor.PluginDescription{
//             .id = "com.ArborealAudio.ZigVerb",
//             .name = "Example Distortion",
//             .company = "Arboreal Audio",
//             .version = "0.1",
//             .url = "https://arborealaudio.com",
//             .contact = "contact@arborealaudio.com",
//             .manual = "www.website.com/manual",
//             .description = "Basic distortion plugin",
//         };

//         pub const Mode = enum {
//             Vintage,
//             Modern,
//         };

//         pub const params = [_]param.Parameter{
//             param.create("Gain", .{ 1.0, 12.0, 1.0 }),
//             param.create("Mode", .{Mode.Vintage}),
//         };
//     };
//     defer Plug.arena.deinit();

//     const plug = Plugin(Plug){};
//     var config = arbor.Config(Plug){};
//     config.init();
//     defer config.deinit();
//     const gain_ptr = config.plugin_params[0];
//     try std.testing.expectEqual(plug.params[0].default_value, gain_ptr.*);
// }

// /// function called on plugin creation
// pub fn init(allocator: std.mem.Allocator) *Plugin {
//     var plugin = allocator.create(Plugin) catch |e| {
//         std.log.err("{}\n", .{e});
//         std.process.exit(1);
//     };
//     plugin.* = .{ .reverb = .{ .plugin = plugin, .feedback_param = &plugin.params.values.feedback } };
//     return plugin;
// }

// /// setup plugin for processing
// pub fn prepare(self: *Plugin, allocator: std.mem.Allocator, sample_rate: f64, max_frames: u32) !void {
//     self.sample_rate = sample_rate;
//     self.maxNumSamples = max_frames;
//     self.reverb.prepare(allocator, self.sample_rate, @floatCast(0.125 * self.sample_rate)) catch |e| {
//         std.log.err("Failed to initialize reverb: {}\n", .{e});
//         std.process.exit(1);
//     };
// }

// pub fn deinit(self: *Plugin, allocator: std.mem.Allocator) void {
//     self.reverb.deinit(allocator);
//     allocator.destroy(self);
// }

// pub fn processAudio(self: *Plugin, in: [*][*]f32, out: [*][*]f32, num_frames: usize) void {
//     const mix = self.params.values.mix;
//     for (0..num_frames) |i| {
//         const rev_out = self.reverb.processSample([_]f32{ in[0][i], in[1][i] });

//         const wet_level = if (mix < 0.5) mix * 2.0 else 1.0;
//         const dry_level = if (mix < 0.5) 1.0 else (1.0 - mix) * 2.0;

//         const outL = (rev_out[0] * wet_level) + (in[0][i] * dry_level);
//         const outR = (rev_out[1] * wet_level) + (in[1][i] * dry_level);

//         // write output
//         out[0][i] = @floatCast(outL);
//         out[1][i] = @floatCast(outR);
//     }
// }
