# New OSS-Fuzz Project - Heartbleed

## Generate the certificates

We already have the certs, so you can skip this.

```bash
openssl req -x509 -newkey rsa:512 -keyout server.key -out server.pem -days 9999 -nodes -subj /CN=a/
```

## New
```bash
export PROJECT_NAME="heartbleed"
export LANGUAGE=c++
python infra/helper.py generate $PROJECT_NAME --language=$LANGUAGE
```

## Clone OSS-Fuzz
```bash
git clone https://github.com/google/oss-fuzz.git
cp -r ./infra-ossfuzz oss-fuzz/projects/heartbleed
```

## Build harness
```bash
python infra/helper.py build_fuzzers --sanitizer address --engine libfuzzer --architecture x86_64 heartbleed
# python infra/helper.py check_build heartbleed # check build
```

### Run harness
```bash
python infra/helper.py run_fuzzer --sanitizer address --engine libfuzzer --architecture x86_64 heartbleed openssl-fuzzer
```

### Reproduce and Debugging
```bash
# reproduce
python infra/helper.py reproduce heartbleed openssl-fuzzer ./build/out/heartbleed/crash-XXXXXXXXX # replace the file with the reported testcase

# debugging with GDB
python infra/helper.py shell base-runner-debug
gdb --args /out/heartbleed/openssl-fuzzer /out/heartbleed/crash-XXXXXXXXX
```

## Reference

https://google.github.io/oss-fuzz/getting-started/