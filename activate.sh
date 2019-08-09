#!/usr/bin/env bash

openssl aes-256-cbc -K $encrypted_9187736ac39a_key -iv $encrypted_9187736ac39a_iv -in travis-ci.json.enc -out travis-ci.json -d && \
gcloud auth activate-service-account travis-ci@gi-gae.iam.gserviceaccount.com --key-file=travis-ci.json && \
gcloud container clusters get-credentials ${CLOUDSDK_CONTAINER_CLUSTER}