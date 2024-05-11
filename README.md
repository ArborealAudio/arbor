# arbor

## For the future of plugin development

## Goals

* Dead-simple plugin development. Write <= 100 lines of code and have a runnable
blank-slate plugin.

* Ideally only require Zig as a toolchain dependency, not as a programming
language. You should be able to write plugins in C/C++/whatever and easily link
that code to Arbor via a C API and the Zig build system.

	* Could also have a `get_zig.sh` that will download latest stable Zig if you
	don't already have it

* Easy cross-compilation. Compile to Mac/Linux/Windows from Mac/Linux/Windows,
batteries included.

* Cross-platform graphics. A simple software renderer (like Olivec), but also
native graphics programming, potentially using something like [sokol](https://github.com/floooh/sokol.git), or making a thin wrapper around Direct2D/CoreGraphics for
cross-platform graphics abstraction, giving the programmer a simple choice with
little-to-no platform-specific considerations.

* Simple, declarative UI design. Possibly with the option of using a custom
CSS-like syntax (or [Ziggy](https://github.com/kristoff-it/ziggy.git)) to
declare, arrange, and style UI widgets at **runtime** or **compile-time**, all
compiling to native code--not running in some god-forsaken web browser embedded
in a plugin UI 🤮

## Have:

* A nice abstraction layer over plugin APIs which should lend itself nicely to
extending support to other APIs

* Easy comptime parameter generation

* Basic CLAP audio plugin supporting different types of parameters, sample-accurate automation

* A janky VST2 implementation that works in Reaper and mostly works in other DAWs

* Simple, portable software rendering using [Olivec](https://github.com/tsoding/olive.c) and a custom
text rendering function with a bitmap font

## TODO:

- [ ] Figure out if we can write a binding for VST3 API without getting a lawyer

- [ ] AUv2 API

- [ ] Improve VST2 format

- [ ] Actually do stuff with MIDI (I'm a guitar guy not a synth guy)

- [ ] Unit tests

- [ ] Simple cross-platform rendering

	- [x] Got basic shapes using Olivec software renderer

	- [x] Simple bitmap text drawing

	- [ ] Make text drawing more robust and complete

		- [ ] Allow importing/creating a custom font bitmap and using that for text rendering

		- [ ] Text kerning

	- [ ] Make some basic widgets for building UI:

		- [x] Slider (vertical slider at least)
		
		- [ ] Knob

		- [ ] Button
		
		- [x] Label

		- [x] Options menu

	- [ ] Add GUI timer on Linux

- [ ] Add a basic volume meter to/as an example

- [ ] Simple & robust events system

	- [x] Decent syncing of parameter changes

	- [ ] Handle CLAP non-destructive parameter modulation

- [ ] Make GUI optional (should allow cross-compiling)

	- [x] Semi-working by handling user leaving gui null after `gui_init`

## Usage

### 100 LOC Or Less

This is what starting up a project with Arbor *should* look like:
(NOTE: This is a WIP and won't always reflect how the API actually works.
I will try to update to be in sync with changes.)

In top-level build.zig:

```zig
const std = @import("std");
const arbor = @import("arbor");

pub fn build(b: *std.Build) !void {
	const target = b.standardTargetOptions(.{});
	const optimize = b.standardOptimizeOption(.{});

	try arbor.addPlugin(b, .{
		.description = .{
			.id = "com.Plug-O.Evil",
			.name = "My Evil Plugin",
			.company = "Plug-O Corp, Ltd.",
			.version = "0.1.0",
			.url = "https://plug-o-corp.biz",
			.contact = "contact@plug-o-corp.biz",
			.manual = "https://plug-o-corp.biz/Evil/manual.pdf",
			.copyright = "(c) 2100 Plug-O-Corp, Ltd.",
			.description = "Vintage Analog Warmth",
		},
		.features = arbor.features.STEREO | arbor.features.EFFECT |
			arbor.features.EQ,
		.root_source_file = "src/plugin.zig",
		.target = target,
		.optimize = optimize,
	});
}
```

In plugin.zig:

```zig
const arbor = @import("arbor");

const Mode = enum {
	Vintage,
	Modern,
	Apocalypse,
};

const params = &[_]arbor.Parameter{
	arbor.param.Float(
		"Gain", // name
		0.0, // min
		10.0, // max
		0.666, // default
		.{.flags = .{}}, // can provide additional flags
	);
	arbor.param.Choice("Mode", Mode.Vintage, .{.flags = .{}});
};

const Plugin = @This();

// specify an allocator if you want
const allocator = std.heap.c_allocator;

// initialize plugin 
export fn init() *arbor.Plugin {
	const plugin = arbor.init(allocator, params .{
		.deinit = deinit,
		.prepare = prepare,
		.process = process,
	});
	const user_plugin = allocator.create(Plugin) catch |err| // catch any allocation errors
		arbor.log.fatal("Plugin create failed: {!}\n", .{err}, @src());

	user_plugin.* = .{}; // init our plugin to default
	plugin.user = user_plugin; // set user context pointer
		
	return plugin;
}

fn deinit(plugin: *arbor.Plugin) void {
	const plugin: plugin.getUser(Plugin);
	plugin.allocator.destroy(plugin);
}

fn prepare(plugin: *arbor.Plugin, sample_rate: f32, max_num_frames: u32) void {
	// prepare your effect if needed
	_ = plugin;
	_ = sample_rate;
	_ = max_num_frames;
}

// process audio
fn process(plugin: *arbor.Plugin, buffer: arbor.AudioBuffer(f32)) void {

	// load an audio parameter value
	const gain_param = plugin.getParamValue(f32, "Gain");

	for (buffer.input, 0..) |channel_data, ch_num| {
	  	for (channel_data, 0..) |sample, i| {
			buffer.output[ch_num][i] = sample * gain_param;
		}
	}
}

// TODO: Demo how UI would work

```

To build:

```sh
zig build
# Add 'copy' to copy plugin to user plugin dir
# Eventual compile options:
# You can add -Dformat=[VST2/VST3/CLAP/AU]
# Not providing a format will compile all formats available on your platform
# Add 'copy' to put built plugin in appropriate system dir
# Cross compile by adding -Dtarget=[aarch64-macos/x86_64-windows/etc...]
# Build modes: -Doptimize=[Debug/ReleaseSmall/ReleaseSafe/ReleaseFast]
```
