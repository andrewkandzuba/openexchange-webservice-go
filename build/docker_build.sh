#!/usr/bin/env bash

set -euo pipefail

echo "Building new docker image ..."

CMD="docker build . -t webservice -f -"

ENV_HTTP_PROXY=""
if [[ ! -z ${HTTP_PROXY+x} ]];  then
    ENV_HTTP_PROXY=$(echo "ENV HTTP_PROXY $(echo env ${HTTP_PROXY} | sed -e 's/=/ /g' | awk '{print $2}')")
fi

ENV_HTTPS_PROXY=""
if [[ ! -z ${HTTPS_PROXY+x} ]];  then
    ENV_HTTP_PROXY=$(echo "ENV HTTP_PROXY $(echo env ${HTTPS_PROXY} | sed -e 's/=/ /g' | awk '{print $2}')")
fi

cat << EOF | ${CMD}
FROM amd64/alpine
${ENV_HTTP_PROXY}
${ENV_HTTPS_PROXY}
RUN apk add --no-cache curl
ADD dist/bin /
CMD ["/main"]
EOF

docker tag webservice webservice:$(cat version/version.go | grep Version | awk '{print $3}' | sed 's/"//g')