#!/usr/bin/env bash

set -euo pipefail

echo "Deploying to Kubernetes ..."

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

${SCRIPTPATH}/docker_build.sh && \
sed -e "s|REPLACE_IMAGE|$1|g" $SCRIPTPATH/docker_push.sh | sh && \
sed -e "s|REPLACE_IMAGE|$1|g" $SCRIPTPATH/deployment.yaml | kubectl create -f -