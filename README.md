# Arbor

## For the future of plugin development

## Goals

* Dead-simple plugin development. Write <= 100 lines of code and have a runnable
plugin.

* Ideally Zig required as a toolchain dependency, not as a programming language.
You should be able to write plugins in C/C++/whatever and easily link that code
to Arbor using the Zig build system.

* Easy cross-compilation. Compile to Mac/Linux/Windows from Mac/Linux/Windows,
batteries included.

* Cross-platform graphics. A simple software renderer, but also native graphics
programming, ideally using something like [sokol](https://github.com/floooh/sokol.git)
for cross-platform graphics abstraction.

* Simple, declarative UI design. Probably using a custom CSS-like syntax
to declare, arrange, and style UI widgets *at runtime or compile-time*, all
compiling to native code--not running in some god-forsaken web browser embedded
in a plugin UI 🤮

## TODO:

* VST3 API

* AUv2 API

* Simple cross-platform rendering

  * Got basic shapes using Olivec software renderer

  * Make text drawing more robust and complete

  * Make some basic widgets for building UI:

    * Slider

    * Knob

    * Button

    * Label

* Actually do stuff with MIDI (I'm a guitar guy not a synth guy)
