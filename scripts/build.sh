#!/bin/bash

set -e

ZIG_VERSION="0.13.0"

[ $(uname -s) == 'Darwin' ] && OS="macos"
[ $(uname -s) == 'Linux' ] && OS="linux"
[ $OS == 'Windows_NT' ] && OS='windows'

[ $(uname -m) == 'arm64' ] && ARCH="aarch64" || ARCH=$(uname -m)

TRIPLE="${OS}-${ARCH}-${ZIG_VERSION}"

echo "Getting Zig ${ZIG_VERSION} for ${ARCH} ${OS}"

[ $OS != 'windows' ] && curl -L "https://ziglang.org/download/${ZIG_VERSION}/zig-${TRIPLE}.tar.xz" | tar xJ
if [[ $OS == 'windows' ]]; then
	choco install zig --version $ZIG_VERSION
	# powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest https://ziglang.org/builds/zig-${TRIPLE}.zip -OutFile zig-${TRIPLE}.zip"
	# powershell -Command "Expand-Archive -Path ./zig-${TRIPLE}.zip -DestinationPath ."
fi

[ $OS != 'windows' ] && ZIG="${PWD}/zig-${TRIPLE}/zig" || ZIG="${PWD}/zig.exe"

echo "Zig path = ${ZIG}"

echo "Running library tests"
$ZIG build test

# Build examples & unit test (all one step)
EXAMPLES=(Distortion Filter)

for ex in ${EXAMPLES[@]}; do
	echo "Building example plugin: $ex"
	pushd ./examples/$ex
	$ZIG build
	popd
done
