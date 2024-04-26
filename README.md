# Arbor

## For the future of plugin development

## Goals

* Dead-simple plugin development. Write <= 100 lines of code and have a runnable
blank-slate plugin.

* Ideally only require Zig as a toolchain dependency, not as a programming
language. You should be able to write plugins in C/C++/whatever and easily link
that code to Arbor using the Zig build system.

	* Could also have a `get_zig.sh` that will download latest stable Zig if you
	don't already have it

* Easy cross-compilation. Compile to Mac/Linux/Windows from Mac/Linux/Windows,
batteries included.

* Cross-platform graphics. A simple software renderer, but also native graphics
programming, ideally using something like [sokol](https://github.com/floooh/sokol.git)
for cross-platform graphics abstraction.

* Simple, declarative UI design. Probably using a custom CSS-like syntax (or
[Ziggy](https://github.com/kristoff-it/ziggy.git)) to declare, arrange, and
style UI widgets at **runtime** or **compile-time**, all compiling to native
code--not running in some god-forsaken web browser embedded in a plugin UI 🤮

## TODO:

* Output plugin bundles (you'll have to suck it up and use the Zig build system
for this)

* Make the framework a proper module that can be imported thru Zig build and used
as such

* VST3 API

* AUv2 API

* Simple cross-platform rendering

	[x] Got basic shapes using Olivec software renderer

	* Make text drawing more robust and complete

	* Make some basic widgets for building UI:

		* Slider
		
		* Knob
		
		* Button
		
		* Label

* Actually do stuff with MIDI (I'm a guitar guy not a synth guy)

## Usage

### 100 LOC Or Less

This is what starting up a project with Arbor *should* look like:
(NOTE: This is a WIP and won't always reflect how the API actually works.
I will try to update to be in sync with changes.)

In top-level build.zig:

```zig
const std = @import("std");
const arbor = @import("arbor/build.zig");
const Plugin = @import("src/plugin.zig");

pub fn build(b: *std.Build) void {
	const target = b.standardTargetOptions(.{});
	const optimize = b.standardOptimizeOption(.{});
	// your plugin is a static lib linked to the shared plugin lib
	const plugin = b.addStaticLibrary(.{
		.name = plugin_name,
		.root_source_file = b.path("src/plugin.zig"),
		.target = target,
		.optimize = optimize,
	});
	plugin.addImport("arbor", arbor.build(b, plugin, target, optimize));
}
```

In plugin.zig:

```zig
const arbor = @import("arbor");

export const plugin_desc = arbor.createFormatDescription(
	.id = "com.Plug-O.Evil",
	.name = "My Evil Plugin",
	.company = "Plug-O Corp, Ltd.",
	.version = "0.1",
	.url = "https://plug-o-corp.biz",
	.contact = "contact@plug-o-corp.biz",
	.manual = "https://plug-o-corp.biz/Evil/manual.pdf", // CLAP needs this
	.description = "Vintage Analog Warmth",
	// etc...
);

const params = &[_]arbor.Parameter{
	arbor.param.create(
		"Gain", // name
		.{ 0.0, // min
		10.0, // max
		0.666 }, // default
	);
	arbor.param.create("Mode", .{Mode.Vintage});
};

const Plugin = @This();

// specify an allocator if you want
const allocator = std.heap.c_allocator;

// initialize plugin 
export fn init() *arbor.Plugin {
	const plugin = arbor.configure(allocator, params);
	const user_plugin = allocator.create(Plugin) catch |err| // catch allocation error
		arbor.log.fatal("Plugin create failed: {}\n", .{err});

	user_plugin.* = .{}; // init our plugin to default
	plugin.user = user_plugin; // set user context pointer
		
	return plugin;
}

// process audio
export fn process(self: *Plugin, buffer: arbor.AudioBuffer) void {

	// load an audio parameter
	// NOTE: Doesn't work like this yet
	const gain_param = arbor.getParam("Gain");
	
	for (buffer.input[0..buffer.num_ch], 0..) |channel_data, ch_num| {
	  	for (channel_data[0..buffer.num_samples], 0..) |sample, i| {
			buffer.output[ch_num][i] = sample * gain_param;
		}
	}
}


const Mode = enum {
	Vintage,
	Modern,
	Apocalypse,
};

// TODO: Demo how UI would work

```

To build:

```sh
zig build
# You can add -Dformat=[VST2/VST3/CLAP/AU]
# Not providing a format will compile all formats available on your platform
# Cross compile by adding -Dtarget=aarch64-macos/x86_64-windows/etc...
# Build modes: -Doptimize=Debug/ReleaseSmall/ReleaseSafe/ReleaseFast
```
