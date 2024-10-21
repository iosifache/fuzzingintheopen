FROM ubuntu:20.04

RUN apt-get update && apt-get install git clang build-essential

# Build 

RUN git clone https://github.com/openssl/openssl.git /src
RUN cd /src && git checkout OpenSSL_1_0_1f

RUN rm -rf build
RUN cp -rf /src /build

RUN export CC=clang
RUN export CFLAGS="-O2 -fno-omit-frame-pointer -gline-tables-only -fsanitize=address,fuzzer-no-link -fsanitize-address-use-after-scope"
RUN export CXX=clang++
RUN export CXXFLAGS="-O2 -fno-omit-frame-pointer -gline-tables-only -fsanitize=address,fuzzer-no-link -fsanitize-address-use-after-scope"
RUN export OUTPUT="openssl-1.0.1f-fsanitize_fuzzer"
RUN export LIB_FUZZING_ENGINE="-fsanitize=fuzzer"

RUN cd /build && ./config && make clean && make
RUN cd ~ && git clone https://github.com/iosifache/fuzzingintheopen.git
RUN cd fuzzingintheopen/infra-ttfish && $CXX $CXXFLAGS target.cc -DCERT_PATH="./" /build/libssl.a /build/libcrypto.a $LIB_FUZZING_ENGINE -I /build/include -o $OUTPUT
