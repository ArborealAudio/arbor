set -e

[ ! -d build ] && mkdir build
gcc -shared -g -Wall -Wno-unused-parameter -Wextra -o ./build/raw.clap plugin.c -luser32 -lgdi32
echo "Build exited with code $?"
echo "Copying..."
cp ./build/raw.clap "C:/Program Files/Common Files/CLAP/raw.clap"