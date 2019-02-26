#!/usr/bin/env bash

set -euo pipefail

echo "Pushing docker image to registry..."

docker tag kubia REPLACE_IMAGE && \
docker login && \
docker push REPLACE_IMAGE