#!/usr/bin/env bash

echo "${TRAVIS_REPO_SLUG}:${TRAVIS_TAG}"

openssl aes-256-cbc -K $encrypted_9187736ac39a_key -iv $encrypted_9187736ac39a_iv -in travis-ci.json.enc -out travis-ci.json -d && \
gcloud auth activate-service-account travis-ci@gi-gae.iam.gserviceaccount.com --key-file=travis-ci.json --project=${GKE_PROJECT} && \
rm -rf travis-ci.json && \
gcloud auth list && \
gcloud config configurations list && \
sed -e "s|REPLACE_IMAGE|${TRAVIS_REPO_SLUG}:${TRAVIS_TAG}|g" ${TRAVIS_BUILD_DIR}/build/deployment.yaml | kubectl apply -f -