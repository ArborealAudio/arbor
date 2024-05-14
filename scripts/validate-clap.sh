#!/bin/bash

set -e

[ $(uname -s) == 'Darwin' ] && CV_VER="macos-universal"
[ $(uname -s) == 'Linux' ] && CV_VER="ubuntu-18.04"

if [[ $OS != "Windows_NT" ]]; then
  wget "https://github.com/free-audio/clap-validator/releases/download/0.3.2/clap-validator-0.3.2-${CV_VER}.tar.gz"
  tar xfz clap-validator-0.3.2-${CV_VER}.tar.gz
  [ $(uname -s) == 'Darwin' ] && CV=./binaries/clap-validator || CV=./clap-validator
else
	powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest https://github.com/free-audio/clap-validator/releases/download/0.3.2/clap-validator-0.3.2-windows.zip -OutFile clap-validator.zip"
	powershell -Command "Expand-Archive -Path ./clap-validator.zip -DestinationPath ."
	CV=./clap-validator.exe
fi

EXAMPLES=(Distortion) # Filter example produces a bug in the validator

for ex in ${EXAMPLES[@]}; do
  $CV validate zig-out/Example_${ex}.clap
done

rm -rf clap-validator*
