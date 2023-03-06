#!/bin/sh
set -e

[ ! -d build ] && mkdir build
gcc -c gui/gui_mac.m -o ./build/gui_mac.o
gcc -shared -g -Wall -Wextra -Wno-unused-parameter -o ./build/raw.clap plugin.c ./build/gui_mac.o -framework Cocoa
echo "Build finished with code $?"
echo "copying..."
cp -f ./build/raw.clap ~/Library/Audio/Plug-Ins/CLAP/raw.clap