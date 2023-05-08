set -e

if [[ $(echo $OSTYPE) == "linux-gnu" ]]; then
  os="linux"
elif [[ $(echo $OSTYPE) == "darwin" ]]; then
  os="macos"
elif [[ $(echo $OSTYPE) == "msys" ]]; then # msys = bash on windows
  os="windows"
fi

zig build
if [[ $os == "macos" ]]; then
  cp -pf zig-out/lib/libclap-raw.dylib ~/Library/Audio/Plug-Ins/CLAP/clap-raw.clap
elif [[ $os == "linux" ]]; then
  cp -pf zig-out/lib/libclap-raw.so ~/.clap/clap-raw.clap
elif [[ $os == "windows" ]]; then
  cp -pf zig-out/lib/libclap-raw.dll ~/.clap/clap-raw.clap
fi
