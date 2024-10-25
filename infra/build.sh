#!/bin/bash -eu
# Copyright 2024 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
################################################################################

# Configures
export CC=clang
export CXX=clang++
export CFLAGS="$CFLAGS -O2 -fno-omit-frame-pointer -gline-tables-only -fsanitize=address,fuzzer-no-link -fsanitize-address-use-after-scope"
export CXXFLAGS="$CXXFLAGS -O2 -fno-omit-frame-pointer -gline-tables-only -fsanitize=address,fuzzer-no-link -fsanitize-address-use-after-scope"
export LIB_FUZZING_ENGINE="-fsanitize=fuzzer"

# Builds the project
CC="$CC $CFLAGS" ./config
make

# Copy the harness
mkdir fuzzer
cp $SRC/target.cc fuzzer

# Build the harness
pushd fuzzer
$CXX $CXXFLAGS target.cc -DCERT_PATH="./" ../libssl.a ../libcrypto.a $LIB_FUZZING_ENGINE -I ../include -o openssl-fuzzer
cp openssl-fuzzer $OUT
popd

# Copy the certs
cp -r $SRC/runtime $OUT
