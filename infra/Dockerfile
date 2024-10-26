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

# Set the base image
FROM gcr.io/oss-fuzz-base/base-builder

# Define an argument
ARG patched

# Install the dependencies for OpenSSL
RUN apt-get update && apt-get install -y make autoconf automake libtool clang

# Clone the repository
RUN git clone https://github.com/openssl/openssl.git openssl

# Checkout at a state where the codebase is vulnerable to Heartbleed
RUN cd openssl && git checkout OpenSSL_1_0_1f

# Set the working directory
WORKDIR openssl

# TODO: Apply the patch
# COPY heartbleed.patch .
# RUN git apply heartbleed.patch


# Copy the build script
COPY build.sh target.cc $SRC/

# Copy the artefacts required for running the harness
COPY runtime $SRC/runtime
