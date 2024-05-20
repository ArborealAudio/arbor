# arbor

## For the future of plugin development

## Have:

### Framework

* A nice abstraction layer over plugin APIs which should lend itself nicely to
extending support to other APIs

* Easy comptime parameter generation

### Plugin APIs

* Basic CLAP audio plugin supporting different types of parameters, sample-accurate automation

* WIP ANV (A.N.V. == **A**NV's **N**ot **V**ST3)

* A janky VST2 implementation that works in Reaper and mostly works in other DAWs

### DSP

* A basic delay module

* "Vicanek" IIR Filters which **don't cramp at Nyquist** [^1][^2][^3]

### UI

* Simple, portable software rendering using [Olivec](https://github.com/tsoding/olive.c) and a custom
text rendering function with a bitmap font

## Goals

* Dead-simple plugin development. Write <= 100 lines of code and have a runnable
blank-slate plugin.

* Easy cross-compilation. Compile to Mac/Linux/Windows from Mac/Linux/Windows,
batteries included.

* Cross-platform graphics. A simple software renderer (like Olivec),
but also native graphics programming, potentially using something like
[sokol](https://github.com/floooh/sokol.git), or making a thin wrapper around
Direct2D/CoreGraphics for cross-platform graphics abstraction (see `direct2d`
branch for an early in-progress idea of this), giving the programmer a simple
choice with little-to-no platform-specific considerations.

* Simple, declarative UI design.

	* Currently working on a custom immediate-mode UI library
	
	* Further down the road considering the option of using a custom CSS-like
	syntax to write stylesheets for UI widgets which can be read at **runtime** or
	**compiled**, all as native code--not running in some god-forsaken web browser
	embedded in a plugin UI 🤮. However, this may prove to be too great an abstraction, especially
	if a flexible IMGUI API can provide a lot of this functionality with stylesheets-as-structs. One
	option could be to read & watch a config file at runtime which fills out stylesheet data & may be
	updated whenever the file is changed.

## TODO:

- [ ] Make a basic VST3-compatible plugin with audio parameters & UI
 
- [ ] AUv2 API

- [ ] Improve VST2 format

- [ ] Actually do stuff with MIDI (I'm a guitar guy not a synth guy)

- [ ] Unit tests

	- [x] Validating CLAP & VST2 w/ [clap-validator](https://github.com/free-audio/clap-validator)
	& [pluginval](https://github.com/Tracktion/pluginval), respectively

	- [ ] Write tests for other parts of the library, handling bad data from hosts, etc

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

Run `zig init` to create some boilerplate for a Zig project. Or, create a
`build.zig` and a `build.zig.zon` file at the root of your project, then run:

`zig fetch --save https://github.com/ArborealAudio/arbor#[commit SHA]`

The commit SHA is the SHA of the commit you wish to checkout. You can supply
`master` instead (not recommended) if you want to pull from the repo's head each time, which is less predictable.

First, create a `config.zon` which will describe some details about your plugin:

```zon
.{
    .description = .{
        .name = "My Evil Plugin",
        .id = "com.Plug-O.Evil",
        .company = "Plug-O Corp, Ltd",
        .version = "0.1.0",
        .copyright = "(c) 2024 Plug-O Corp, Ltd",
        .url = "https://plug-o-corp.biz",
        .manual = "https://plug-o-corp.biz/Evil/manual.pdf",
        .contact = "contact@plug-o-corp.biz",
        .description = "Vintage analog warmth",
    },
    .features = .{
        .stereo = true,
        .effect = true,
        .eq = true,
    },
    .root_source_file = "plugin.zig",
}
```

Now make a `build.zig`:

```zig
const std = @import("std");
const arbor = @import("arbor");

pub fn build(b: *std.Build) !void {
	const target = b.standardTargetOptions(.{});
	const optimize = b.standardOptimizeOption(.{});

	try arbor.addPlugin(b, .{
		.plugin_config = @import("config.zon"), // imports your config as data which will be used by the build process
		.plugin_config_path = b.path("config.zon"), // also requires the path for importing the config later
		.target = target,
		.optimize = optimize,
	}, &.{.CLAP, .VST2}); // an array of plugin formats
}
```

In `plugin.zig`:

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
		.{.flags = .{}}, // can provide additional flags, such as text-value/value-text conversion func., & other stuff
	),
	arbor.param.Choice("Mode", Mode.Vintage, .{.flags = .{}}),
};

const Plugin = @This();

// specify an allocator if you want
const allocator = std.heap.c_allocator;

// initialize plugin 
export fn init() *arbor.Plugin {
	const user_plugin = allocator.create(Plugin) catch |err| // catch any allocation errors
		arbor.log.fatal("Plugin create failed: {!}\n", .{err}, @src());
	user_plugin.* = .{}; // init our plugin to default

	return arbor.createPlugin(.{
		.allocator = allocator,
		.params = params,
		.num_inputs = 2,
		.num_outputs = 2,
		.interface = .{
			.deinit = deinit,
			.prepare = prepare,
			.process = process,
		},
		.user_data = user_plugin, // give arbor a pointer to our private plugin data
	});

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
zig build copy
# Adding 'copy' will copy plugin to user plugin dir
# Optimization modes: -Doptimize=[Debug/ReleaseSmall/ReleaseSafe/ReleaseFast]
# Eventual compile options:
# Cross compile by adding -Dtarget=[aarch64-macos/x86_64-windows/etc...]
```

## Acknowledgements

These open-source libraries and examples were a huge help in getting started:

* The influential and robust [CLAP tutorial by Nakst](https://nakst.gitlab.io/tutorial/clap-part-1.html)

* [zig-clap-noise-shaker by GreyDodger](https://github.com/GreyDodger/zig-clap-noise-shaker)
was a great starting point to understand how to write Zig while working with a C library

* [schroffl's implementation of VST2 in Zig](https://github.com/schroffl/zig-vst)

[^1]: ["Matched Second Order Filters" by Martin Vicanek (2016)](https://vicanek.de/articles/BiquadFits.pdf)

[^2]: ["Matched One-Pole Digital Shelving Filters" by Martin Vicanek (2019)](https://vicanek.de/articles/ShelvingFits.pdf)

[^3]: ["Matched Two-Pole Digital Shelving Filters" by Martin Vicanek (2024)](https://vicanek.de/articles/2poleShelvingFits.pdf)

Additionally, [CPLUG by Tremus](https://github.com/Tremus/CPLUG) was a great help
in figuring out the VST3 format and its...mysteries
