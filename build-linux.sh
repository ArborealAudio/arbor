#!/bin/bash
[ ! -d build ] && mkdir build
gcc -shared -g -Wall -Wextra -Wno-unused-parameter -fPIC -o ./build/raw.clap plugin.c -lX11
cp ./build/raw.clap ~/.clap/raw.clap
