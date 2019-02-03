#!/usr/bin/env bash

set -euo pipefail

cat << EOF | docker build . -t kubia -f -
FROM golang:latest
RUN mkdir /opt/openexchange-webservice-go && mkdir /opt/openexchange-webservice-go/pkg
ADD pkg /opt/openexchange-webservice-go/pkg
WORKDIR /opt/openexchange-webservice-go
RUN go build -o /opt/openexchange-webservice-go/bin/main ./...
ENTRYPOINT ["/opt/openexchange-webservice-go/bin/main"]
EOF