#!/usr/bin/env bash

set -euo pipefail

echo "Make application ..."

rm -rf dist/bin && \
mkdir -p dist/bin && \
GO111MODULE=on go get -u=patch && \
go test ./... -count=1 && \
CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o dist/bin/main -i cmd/manager/main.go
