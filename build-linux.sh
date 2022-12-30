#!/bin/bash
[ ! -d build ] && mkdir build
g++ -shared -g -Wall -Wextra -Wno-unused-parameter -o build/raw.clap plugin.cpp -lX11
cp build/raw.clap ~/.clap/raw.clap