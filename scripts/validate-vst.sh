#!/bin/bash

set -e

[ $(uname -s) == 'Darwin' ] && OS='macos'
[ $(uname -s) == 'Linux' ] && OS='linux'
[ $OS == 'Windows_NT' ] && OS='windows'

if [[ $OS == 'windows' ]]; then
	powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest https://github.com/Tracktion/pluginval/releases/download/v1.0.3/pluginval_Windows.zip -OutFile pluginval.zip"
	powershell -Command "Expand-Archive -Path ./pluginval.zip -DestinationPath ."
	pluginval="./pluginval.exe"
else
	wget -O pluginval.zip https://github.com/Tracktion/pluginval/releases/download/v1.0.3/pluginval_${OS}.zip
	unzip pluginval
	if [[ $(uname -s) == 'Darwin' ]]; then
		pluginval="pluginval.app/Contents/MacOS/pluginval"
	else
		pluginval="./pluginval"
	fi
fi

EXAMPLES=(Distortion Filter)
[ $OS == 'windows' ] && EXT="dll" || [ $(uname -s) == 'Darwin' ] && EXT="vst" || EXT="so"

for ex in ${EXAMPLES[@]}; do
	echo "Validating $ex"
	if $pluginval --strictness-level 10 --validate-in-process --skip-gui-tests --timeout-ms 300000 zig-out/Example_${ex}.${EXT};
	then
		echo "Pluginval successful"
	else
		echo "Pluginval failed"
		rm -rf pluginval*
		exit 1
	fi
done

rm -rf pluginval*
