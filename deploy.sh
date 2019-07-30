#!/usr/bin/env bash

export FULL_DOCKER_IMAGE="${TRAVIS_REPO_SLUG}:${TRAVIS_TAG}" && \
echo "FULL_DOCKER_IMAGE=$FULL_DOCKER_IMAGE"

openssl aes-256-cbc -K $encrypted_9187736ac39a_key -iv $encrypted_9187736ac39a_iv -in travis-ci.json.enc -out travis-ci.json -d && \
gcloud auth activate-service-account travis-ci@gi-gae.iam.gserviceaccount.com --key-file=travis-ci.json --project=${GKE_PROJECT} && \
rm -rf travis-ci.json && \
gcloud config set project ${GKE_PROJECT} && \
gcloud config set compute/zone ${GKE_ZONE} && \
gcloud container clusters get-credentials ${GKE_CLUSTER} && \
sed -e "s|REPLACE_IMAGE|$FULL_DOCKER_IMAGE|g" ${TRAVIS_BUILD_DIR}/deployment.yaml | kubectl apply -f -