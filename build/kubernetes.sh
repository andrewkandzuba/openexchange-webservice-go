#!/usr/bin/env bash

#set -euo pipefail
set +x

echo "Deploying to Kubernetes ..."

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

${SCRIPTPATH}/docker_build.sh && \
sed -e "s|REPLACE_IMAGE|$1|g" $SCRIPTPATH/docker_push.sh | sh && \
sed -e "s|REPLACE_IMAGE|$1|g" $SCRIPTPATH/kubia.yaml | kubectl create -f -