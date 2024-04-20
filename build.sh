set -e

uname=$(uname)
if [[ $uname == "Linux" ]]; then
  plugin="libZigVerb.so"
elif [[ $uname == "Darwin" ]]; then
  plugin="ZigVerb.dylib"
fi

if [[ $1 == "" ]]; then
  echo "Please provide a format argument"
  exit
fi

if [[ $1 == "VST2" ]]; then
  case $uname in
    Linux) ext="so"
    ;;
    Darwin) ext="vst"
    ;;
  esac
  dest="$HOME/.vst"
elif [[ $1 == "CLAP" ]]; then
  ext="clap"
  dest="$HOME/.clap"
fi

echo "Building..."
zig build -Dformat=$1

echo "Installing plugin..."
cp zig-out/lib/$plugin $dest/ZigVerb.${ext} 
