#!/usr/bin/env bash

set +x

read -r -d '' USAGE << EOM
Deploy secured to OpenShift project.

Usage: oc-routes.sh <route_url>

Basic commands:
    route_url - the secured route host.

Use "oc-routes.sh --help" for more information about this script.
EOM

if [[ "$1" == "" ]]; then
    echo ${USAGE}
    exit 1
elif [[ $1 == "--help" ]]; then
    echo ${USAGE}
    exit 1
fi

SECRET_DIR=dist/sec
HOST=$1

oc create route edge webservice-ingress --port=http --service=webservice-np --hostname=${HOST} --key=${SECRET_DIR}/tls.key --cert=${SECRET_DIR}/tls.crt