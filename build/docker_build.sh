#!/usr/bin/env bash

set -euo pipefail

echo "Building new docker image ..."

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

rm -rf ${SCRIPTPATH}/../dist/bin/ && \
go get -u=patch && \
go test ./... && \
CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o ${SCRIPTPATH}/../dist/bin/main -i cmd/manager/main.go

cat << EOF | docker build . -t webservice -f -
FROM scratch
ADD dist/bin /
CMD ["/main"]
EOF

docker tag webservice webservice:$(cat version/version.go | grep Version | awk '{print $3}' | sed 's/"//g')