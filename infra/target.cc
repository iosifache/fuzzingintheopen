// Copyright 2016 Google Inc. All Rights Reserved.
// Licensed under the Apache License, Version 2.0 (the "License")

#include <assert.h>
#include <openssl/err.h>
#include <openssl/ssl.h>
#include <stddef.h>
#include <stdint.h>

SSL_CTX *Init() {
  SSL_CTX *sctx;

  SSL_library_init();
  SSL_load_error_strings();
  ERR_load_BIO_strings();
  OpenSSL_add_all_algorithms();
  
  assert(sctx = SSL_CTX_new(TLSv1_method()));

  assert(SSL_CTX_use_certificate_file(sctx, "/out/runtime/server.pem",
                                      SSL_FILETYPE_PEM));
  assert(SSL_CTX_use_PrivateKey_file(sctx, "/out/runtime/server.key",
                                     SSL_FILETYPE_PEM));

  return sctx;
}

extern "C" int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
  static SSL_CTX *sctx = Init();
  SSL *server = SSL_new(sctx);
  BIO *sinbio = BIO_new(BIO_s_mem());
  BIO *soutbio = BIO_new(BIO_s_mem());

  SSL_set_bio(server, sinbio, soutbio);
  SSL_set_accept_state(server);

  // Fuzz
  BIO_write(sinbio, data, size);
  SSL_do_handshake(server);

  SSL_free(server);

  return 0;
}
