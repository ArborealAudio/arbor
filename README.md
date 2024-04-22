# Arbor

## For the future of plugin development

## Goals

* Dead-simple plugin development. Write <= 100 lines of code and have a runnable
blank-slate plugin.

* Ideally only require Zig as a toolchain dependency, not as a programming
language. You should be able to write plugins in C/C++/whatever and easily link
that code to Arbor using the Zig build system.

* Easy cross-compilation. Compile to Mac/Linux/Windows from Mac/Linux/Windows,
batteries included.

* Cross-platform graphics. A simple software renderer, but also native graphics
programming, ideally using something like [sokol](https://github.com/floooh/sokol.git)
for cross-platform graphics abstraction.

* Simple, declarative UI design. Probably using a custom CSS-like syntax
to declare, arrange, and style UI widgets at **runtime** or **compile-time**, all
compiling to native code--not running in some god-forsaken web browser embedded
in a plugin UI 🤮

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

This is what starting up a project with Arbor should look like:

In top-level build.zig:

```zig
const std = @import("std");
const arbor = @import("arbor/build.zig");
const Plugin = @import("src/plugin.zig");

pub fn build(b: *std.Build) void {
  const target = b.standardTargetOptions(.{});
  const optimize = b.standardOptimizeOption(.{});
	const plugin = b.addSharedLibrary(.{
    .name = plugin_name,
    .root_source_file = b.path("src/plugin.zig"),
    .target = target,
    .optimize = optimize,
  });

  arbor.configure(Plugin);
  plugin.addImport("arbor", arbor.build(b, target, optimize));
}
```

In plugin.zig:

```zig
const arbor = @import("arbor");

pub const PluginName = "My Evil Plugin";
pub const CompanyName = "Plug-O Corp, Ltd.";
pub const Version = "0.1";
pub const Description = "Vintage Analog Warmth";
// etc...

pub const Plugin = @This();

// initialize plugin 
pub fn init() *Plugin {
	// ...
}

// process audio
pub fn process(self: *Plugin, in: []const []const f32, out: [][]f32) void {

	// load an audio parameter
	const gain_param = arbor.getParam("Gain");
	const gain = gain_param.value;
	
	for (in, 0..) |channel_data, ch_num| {
  	for (channel_data, 0..) |sample, i| {
			out[ch_num][i] = sample * gain;
		}
	}
}

pub const params = [_]arbor.Parameter{
	.{ .name = "Gain", .{ .float = .{ .min = 0, .max = 10, .default = 0.666 } } },
	.{ .name = "Mode", .{ .choice = .{ .choices = Mode, .default = .Vintage } } },
};

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
