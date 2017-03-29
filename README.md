# Halide
video codec using Halide

Compile and Run Halide Code on OSX using clang

g++ sample_code.cpp -g -I ../include -L ../bin -lHalide -o sample_output -std=c++11

DYLD_LIBRARY_PATH=../bin ./sample_output


run with flags:

clang++ template_match.cpp -g -I ../include -I ../tools -L ../bin -lHalide `libpng-config --cflags --ldflags` -o template_match -std=c++11 -stdlib=libc++

