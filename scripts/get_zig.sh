#!/bin/sh

set -e

ZIG_VERSION="0.12.0"

if [[ $(uname -s) == 'Darwin' ]]; then
  OS="macos"
elif [[ $(uname -s) == 'Linux' ]]; then
  OS="linux"
elif [[ $OS == 'Windows_NT' ]]; then
  OS="windows"
fi

if [[ $(uname -m) == 'arm64' ]]; then
  ARCH="aarch64"
else
  ARCH=$(uname -m)
fi

TRIPLE="${OS}-${ARCH}-${ZIG_VERSION}"

echo "Getting Zig ${ZIG_VERSION} for ${ARCH} ${OS}"

curl "https://ziglang.org/builds/zig-${TRIPLE}.tar.xz" | tar xJ

export ZIG="zig-${TRIPLE}/zig"
