#!/bin/bash

set -e

ZIG_VERSION="0.12.0"

[ $(uname -s) == 'Darwin' ] && OS="macos"
[ $(uname -s) == 'Linux' ] && OS="linux"

[ $(uname -m) == 'arm64' ] && ARCH="aarch64" || ARCH=$(uname -m)

TRIPLE="${OS}-${ARCH}-${ZIG_VERSION}"

echo "Getting Zig ${ZIG_VERSION} for ${ARCH} ${OS}"

curl "https://ziglang.org/builds/zig-${TRIPLE}.tar.xz" | tar xJ

ZIG="zig-${TRIPLE}/zig"

echo "Zig path = ${ZIG}"

$ZIG build -Dexamples copy
