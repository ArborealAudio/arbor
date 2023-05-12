set -e

zig build
if [[ $(uname) == "Darwin" ]]; then
  cp -pf zig-out/lib/libclap-raw.dylib ~/Library/Audio/Plug-Ins/CLAP/clap-raw.clap
elif [[ $(uname) == "Linux" ]]; then
  cp -pf zig-out/lib/libclap-raw.so ~/.clap/clap-raw.clap
elif [[ $os == "windows" ]]; then
  cp -pf zig-out/lib/libclap-raw.dll ~/.clap/clap-raw.clap
fi
