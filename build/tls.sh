#!/usr/bin/env bash

set +x

SECRET_DIR=dist/sec
rm -rf ${SECRET_DIR}
mkdir ${SECRET_DIR}

ENDPOINT=$1
SUBJ="/CN=$1/OU=Unknown/O=OE/L=FTW/ST=TX/C=US"

openssl genrsa -out ${SECRET_DIR}/tls.key 2048 && \
openssl req -new -x509 -key ${SECRET_DIR}/tls.key -out ${SECRET_DIR}/tls.crt -days 365 -subj "${SUBJ}"