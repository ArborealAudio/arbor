set -e

if [[ $(echo $OSTYPE) == "linux-gnu" ]]; then
  os="linux"
elif [[ $(echo $OSTYPE) == "darwin" ]]; then
  os="macos"
fi

zig build
if [[ $os == "macos" ]]; then
  cp -pf zig-out/lib/libclap-raw.dylib ~/Library/Audio/Plug-Ins/CLAP/clap-raw.clap
elif [[ $os == "linux" ]]; then
  cp -pf zig-out/lib/libclap-raw.so ~/.clap/clap-raw.clap
fi
