#!/bin/sh

set -e

NAME="Example_Distortion"
FMT="ARBOR_VST3"
EXT="vst3"
OUT="${NAME}.${EXT}"
BUNDLE="${HOME}/.${EXT}/${OUT}"
BUNDLE_CONTENTS="${BUNDLE}/Contents"
BUNDLE_BIN="${BUNDLE_CONTENTS}/MacOS"
CC=clang
USER_CODE="plugin.c"
USER_CONFIG="plugin_config.c"
INCLUDE=("-I." "-I../../src")

$CC -o $OUT -shared -g ${INCLUDE[@]} -D${FMT} -DUSER_CODE="${USER_CODE}" -DUSER_CONFIG="${USER_CONFIG}" ../../src/arbor.c

[ ! -d ${BUNDLE_BIN} ] && mkdir -p ${BUNDLE_BIN}
cp $OUT "${BUNDLE_BIN}/${NAME}"
echo "BNDL????" > "${BUNDLE_CONTENTS}/PkgInfo"
cp Info.plist "${BUNDLE_CONTENTS}/Info.plist"
codesign -f -s - $BUNDLE

[ -d "${BUNDLE}.dSYM" ] && rm -r "${BUNDLE}.dSYM"
cp -r $OUT.dSYM "${HOME}/.${EXT}/"
