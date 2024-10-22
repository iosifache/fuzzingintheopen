#!/bin/bash

git clone https://github.com/openssl/openssl.git src
cd src && git checkout OpenSSL_1_0_1f

rm -rf build
cp -rf src build

export CC=clang
export CFLAGS="-O2 -fno-omit-frame-pointer -gline-tables-only -fsanitize=address,fuzzer-no-link -fsanitize-address-use-after-scope"
export CXXFLAGS="-O2 -fno-omit-frame-pointer -gline-tables-only -fsanitize=address,fuzzer-no-link -fsanitize-address-use-after-scope"

cd build && ./config && make clean && make

export LIB_FUZZING_ENGINE="-fsanitize=fuzzer"

export CXX=clang++
export CXXFLAGS="-O2 -fno-omit-frame-pointer -gline-tables-only -fsanitize=address,fuzzer-no-link -fsanitize-address-use-after-scope"
export OUTPUT="openssl-1.0.1f-fsanitize_fuzzer"

$CXX $CXXFLAGS target.cc -DCERT_PATH="./" build/libssl.a build/libcrypto.a $LIB_FUZZING_ENGINE -I build/include -o $OUTPUT