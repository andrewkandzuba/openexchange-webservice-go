#!/usr/bin/env bash

set -x

read -r -d '' USAGE << EOM
Build and deploy to Kubernetes cluster

Usage: kubernetes <docker-image-name>

Basic commands:
    docker-image-name - the name of the docker image in the local Docker registry.

Use "kubernetes --help" for more information about this script.
EOM

if [[ "$1" == "" ]]; then
    echo ${USAGE}
    exit 1
elif [[ $1 == "--help" ]]; then
    echo ${USAGE}
    exit 1
fi

DOCKER_IMAGE_NAME="$1"

echo "Deploying to Kubernetes ..."

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

${SCRIPTPATH}/make.sh && \
${SCRIPTPATH}/docker_build.sh && \
${SCRIPTPATH}/tls.sh && \
sed -e "s|REPLACE_IMAGE|${DOCKER_IMAGE_NAME}|g" ${SCRIPTPATH}/docker_push.sh | sh && \
sed -e "s|REPLACE_IMAGE|${DOCKER_IMAGE_NAME}|g" ${SCRIPTPATH}/deployment.yaml | \
sed -e "s/KEY/`cat dist//sec//tls.key|base64 -w0`/g" |  \
sed -e "s/CERT/`cat dist//sec//tls.crt|base64 -w0`/g" | \
kubectl apply -f -