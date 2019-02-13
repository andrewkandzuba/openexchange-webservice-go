#!/usr/bin/env bash

set -euo pipefail

echo "Deploying to Kubernetes ..."

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

docker tag kubia $1/kubia && \
docker login -u $1 -p $2 && \
docker push $1/kubia && \
sed -e "s/DOCKER_USER_NAME/$1/g" $SCRIPTPATH/kubia.yaml | kubectl create -f -