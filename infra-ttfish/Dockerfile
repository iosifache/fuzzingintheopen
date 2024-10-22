FROM ubuntu:20.04

RUN apt-get update && apt-get install -y git clang build-essential

# Build 

RUN git clone https://github.com/openssl/openssl.git /src
RUN cd /src && git checkout OpenSSL_1_0_1f

# ENV

ENV CC=clang \
    CFLAGS="-O2 -fno-omit-frame-pointer -gline-tables-only -fsanitize=address,fuzzer-no-link -fsanitize-address-use-after-scope" \
    CXX=clang++ \
    CXXFLAGS="-O2 -fno-omit-frame-pointer -gline-tables-only -fsanitize=address,fuzzer-no-link -fsanitize-address-use-after-scope" \
    OUTPUT="openssl-1.0.1f-fsanitize_fuzzer" \
    LIB_FUZZING_ENGINE="-fsanitize=fuzzer"

RUN cp -rf /src /build && \
    cd /build && \
    ./config && make clean && make

RUN mkdir -p /out
COPY runtime /out/runtime
COPY target.cc /out/

RUN cd /out && $CXX $CXXFLAGS target.cc -DCERT_PATH="./" /build/libssl.a /build/libcrypto.a $LIB_FUZZING_ENGINE -I /build/include -o $OUTPUT
