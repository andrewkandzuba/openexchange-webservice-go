#!/usr/bin/env bash

set +x

read -r -d '' USAGE << EOM
Deploy secured to OpenShift project.

Usage: oc-routes.sh <route_url>

Basic commands:
    route_url - the secured route endpoint.

Use "oc-routes.sh --help" for more information about this script.
EOM

SECRET_DIR=dist/sec
rm -rf ${SECRET_DIR}
mkdir ${SECRET_DIR}

if [[ "$1" == "" ]]; then
    echo ${USAGE}
    exit 1
elif [[ $1 == "--help" ]]; then
    echo ${USAGE}
    exit 1
fi

ENDPOINT=$1
SUBJ="/CN=$1/OU=Unknown/O=OE/L=FTW/ST=TX/C=US"

openssl genrsa -out ${SECRET_DIR}/rootCA.key 4096 && \
openssl req -x509 -new -nodes -subj "/CN=openexchange.io/OU=Unknown/O=OE/L=FTW/ST=TX/C=US" -key ${SECRET_DIR}/rootCA.key -sha256 -days 1024 -out ${SECRET_DIR}/rootCA.crt && \
openssl genrsa -out ${SECRET_DIR}/tls.key 2048 && \
openssl req -new -sha256 -key ${SECRET_DIR}/tls.key -subj "${SUBJ}" -out ${SECRET_DIR}/tls.csr && \
openssl x509 -req -in ${SECRET_DIR}/tls.csr -CA dist/sec/rootCA.crt -CAkey ${SECRET_DIR}/rootCA.key -CAcreateserial -out ${SECRET_DIR}/tls.crt -days 365 -sha256 && \

oc create route edge webservice-ingress --port=http --service=webservice-np --hostname=${ENDPOINT} --key=${SECRET_DIR}/tls.key --cert=${SECRET_DIR}/tls.crt --ca-cert=${SECRET_DIR}/rootCA.crt