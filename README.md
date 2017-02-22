# Halide
video codec using Halide

Compile and Run Halide Code on OSX using clang

g++ sample_code.cpp -g -I ../include -L ../bin -lHalide -o sample_output -std=c++11

DYLD_LIBRARY_PATH=../bin ./sample_output

