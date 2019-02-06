#!/usr/bin/env bash

set -euo pipefail

cat << EOF | docker build . -t kubia -f -
FROM golang:latest
RUN mkdir -p /go/src/github.com/andrewkandzuba/openexchange-webservice-go/pkg
ADD pkg /go/src/github.com/andrewkandzuba/openexchange-webservice-go/pkg
WORKDIR /go/src/github.com/andrewkandzuba/openexchange-webservice-go
RUN go test ./... && go build -o /opt/openexchange-webservice-go/bin/main pkg/main/main.go
ENTRYPOINT ["/opt/openexchange-webservice-go/bin/main"]
EOF