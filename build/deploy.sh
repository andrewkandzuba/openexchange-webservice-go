#!/usr/bin/env bash

openssl aes-256-cbc -K $encrypted_9187736ac39a_key -iv $encrypted_9187736ac39a_iv -in travis-ci.json.enc -out travis-ci.json -d && \
gcloud auth activate-service-account --key-file=${TRAVIS_BUILD_DIR}/dist/travis-ci.json && \
gcloud config set project ${GKE_PROJECT} && \
sed -e "s|REPLACE_IMAGE|${TRAVIS_REPO_SLUG}:${TRAVIS_TAG}|g" ${TRAVIS_BUILD_DIR}/build/deployment.yaml | kubectl apply -f -
