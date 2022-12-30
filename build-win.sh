[ ! -d build ] && mkdir build
g++ -shared -g -Wall -Wno-unused-parameter -Wextra --std=c++20 -o build/raw.clap plugin.cpp -luser32 -lgdi32
cp build/raw.clap "C:/Program Files/Common Files/CLAP/raw.clap"