#!/usr/bin/env bash

set -euo pipefail

echo "Building new docker image ..."

rm -rf dist/bin && \
mkdir -p dist/bin && \
GO111MODULE=on go get -u=patch && \
go test ./... -count=1 && \
CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o dist/bin/main -i cmd/manager/main.go

cat << EOF | docker build . -t webservice -f -
FROM scratch
ADD dist/bin /
CMD ["/main"]
EOF

docker tag webservice webservice:$(cat version/version.go | grep Version | awk '{print $3}' | sed 's/"//g')