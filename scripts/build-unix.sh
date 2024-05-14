#!/bin/sh

set -e

source ./scripts/get_zig.sh

echo "Zig path = ${ZIG}"

$ZIG build -Dexamples copy
