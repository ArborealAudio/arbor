set -e

uname=$(uname)
if [[ $uname == "Linux" ]]; then
  plugin="libZigVerb.so"
elif [[ $uname == "Darwin" ]]; then
  plugin="libZigVerb.dylib"
fi

if [[ $1 == "" ]]; then
  echo "Please provide a format argument"
  exit
fi

if [[ $1 == "VST2" ]]; then
  case $uname in
    Linux)
      ext="so"
      dest="$HOME/.vst"
    ;;
    Darwin)
      ext="vst"
      dest="$HOME/Library/Audio/Plug-Ins/VST"
    ;;
  esac
elif [[ $1 == "CLAP" ]]; then
  ext="clap"
  case $uname in
    Linux) dest="$HOME/.clap"
    ;;
    Darwin) dest="$HOME/Library/Audio/Plug-Ins/CLAP"
  esac
fi

echo "Building..."
zig build -Dformat=$1

echo "Installing plugin..."
cp zig-out/lib/$plugin $dest/ZigVerb.${ext} 
