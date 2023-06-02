set -e

if [[ $1 != "" ]]; then
  mode=$1
else
  mode="Debug"
fi

echo "Building in $mode mode"

zig build -Doptimize=$mode

if [[ $(uname) == "Darwin" ]]; then
  cp -pf zig-out/lib/libclap-raw.dylib ~/Library/Audio/Plug-Ins/CLAP/clap-raw.clap
elif [[ $(uname) == "Linux" ]]; then
  cp -pf zig-out/lib/libclap-raw.so ~/.clap/clap-raw.clap
elif [[ $OSTYPE == "msys" ]]; then
  cp -pf zig-out/lib/clap-raw.dll ~/.clap/clap-raw.clap
fi
