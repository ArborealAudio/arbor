# arbor

## For the future of plugin development
## ⚠️ PRE-ALPHA SOFTWARE | YOU WON'T FIND FEATURES YOU WANT ⚠️

## Goals

* Dead-simple plugin development. Write <= 100 lines of code and have a runnable
blank-slate plugin.

* Code-generation for certain aspects of plugin configuration, making development more streamlined
and less reliant on preprocessor stuff

* Cross-platform graphics API. Possibly using software rendering which will cover much of the needs
for plugin UIs while being highly portable.

* Declarative UI design, immediate-mode layout

	* Further down the road considering the option of using a custom CSS-like
	syntax to write stylesheets for UI widgets which can be read at **runtime** or
	**compiled**, all as native code--not running in some god-forsaken web browser
	embedded in a plugin UI 🤮. However, this may prove to be too great an abstraction, especially
	if a flexible IMGUI API can provide a lot of this functionality with stylesheets-as-structs. One
	option could be to read & watch a config file at runtime which fills out stylesheet data & may be
	updated whenever the file is changed.

* Zig bindings
* Odin bindings

## Have

* Some basic implementations of CLAP & VST3 plugins
* Custom build system where you configure your build in a C source file
* Generate parameter information using pre-build code generation

## TODO:

- [ ] Feature parity between VST3 & CLAP

- [ ] AUv2 API

- [ ] Actually do stuff with MIDI (I'm a guitar guy not a synth guy)

- [ ] Unit tests

	- [ ] integrate CLAP validation into build runners using [clap-validator](https://github.com/free-audio/clap-validator)
	- [ ] integrate VST validation into build runners using [pluginval](https://github.com/Tracktion/pluginval), & VST3 validator

	- [ ] Write tests for other parts of the library, handling bad data from hosts, etc

- [ ] Add a basic volume meter to/as an example

- [ ] Simple & robust events system

	- [ ] If possible, create an events system which is format-agnostic

- [ ] Make GUI optional (should allow cross-compiling)

## Usage

TODO

Please see the two example plugins in `src/examples`

## Acknowledgements

These open-source libraries and examples were a huge help in getting started:

* The influential and robust [CLAP tutorial by Nakst](https://nakst.gitlab.io/tutorial/clap-part-1.html)

* [zig-clap-noise-shaker by GreyDodger](https://github.com/GreyDodger/zig-clap-noise-shaker)
was a great starting point to understand how to write Zig while working with a C library

* [schroffl's implementation of VST2 in Zig](https://github.com/schroffl/zig-vst)

[^1]: ["Matched Second Order Filters" by Martin Vicanek (2016)](https://vicanek.de/articles/BiquadFits.pdf)

[^2]: ["Matched One-Pole Digital Shelving Filters" by Martin Vicanek (2019)](https://vicanek.de/articles/ShelvingFits.pdf)

[^3]: ["Matched Two-Pole Digital Shelving Filters" by Martin Vicanek (2024)](https://vicanek.de/articles/2poleShelvingFits.pdf)
