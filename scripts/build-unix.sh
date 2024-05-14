#!/bin/sh

set -e

source $PWD/scripts/get_zig.sh

echo "Zig path = ${ZIG}"

$ZIG build -Dexamples copy
