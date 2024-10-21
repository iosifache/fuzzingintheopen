# Fuzzer for Finding CVE-2014-0160

## Building the image

```bash
docker build -t fuzzingintheopen .
```

> The default tag will be `docker.io/library/fuzzingintheopen`. See [this SO thread](https://stackoverflow.com/a/66586744). 

## Getting the ID of the container

```bash
FUZZ_ID=$(docker images -q --format='{{.ID}}' | head -1)
```

## Starting the fuzzing session

```bash
docker run $FUZZ_ID /out/openssl-1.0.1f-fsanitize_fuzzer
```
