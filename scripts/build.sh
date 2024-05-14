#!/bin/bash

set -e

ZIG_VERSION="0.12.0"

[ $(uname -s) == 'Darwin' ] && OS="macos"
[ $(uname -s) == 'Linux' ] && OS="linux"
[ $OS == 'Windows_NT' ] && OS='windows'

[ $(uname -m) == 'arm64' ] && ARCH="aarch64" || ARCH=$(uname -m)

TRIPLE="${OS}-${ARCH}-${ZIG_VERSION}"

echo "Getting Zig ${ZIG_VERSION} for ${ARCH} ${OS}"

[ $OS != 'windows' ] && curl "https://ziglang.org/builds/zig-${TRIPLE}.tar.xz" | tar xJ
if [[ $OS == 'windows' ]]; then
  wget "https://ziglang.org/builds/zig-${TRIPLE}.zip"
  unzip -q zig-${TRIPLE}.zip
fi

ZIG="zig-${TRIPLE}/zig"

echo "Zig path = ${ZIG}"

$ZIG build -Dexamples copy
