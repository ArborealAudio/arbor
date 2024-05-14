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
	powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest https://ziglang.org/builds/zig-${TRIPLE}.zip -OutFile zig-${TRIPLE}.zip"
	powershell -Command "Expand-Archive -Path ./zig-${TRIPLE}.zip -DestinationPath ."
fi

[ $OS != 'windows'] && ZIG="zig-${TRIPLE}/zig" || ZIG="zig-${TRIPLE}/zig.exe"

echo "Zig path = ${ZIG}"

$ZIG build -Dexamples copy
