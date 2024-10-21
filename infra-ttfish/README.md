# Fuzzer for Finding CVE-2014-0160

## Build Image

```bash
docker build -t fuzzingintheopen .
```

## Fuzz

```bash
docker run heartbleed /out/openssl-1.0.1f-fsanitize_fuzzer
```