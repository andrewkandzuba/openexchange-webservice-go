#!/usr/bin/env bash

gcloud container clusters get-credentials ${CLOUDSDK_CONTAINER_CLUSTER} && \
sed -e "s|KUBECTL_NAMESPACE|$KUBECTL_NAMESPACE|g" ${BUILD_DIR}/namespace.yaml | kubectl apply -f - && \
kubectl config set-context "$(kubectl config current-context)" --namespace=${KUBECTL_NAMESPACE} && \
sed -e "s|DOCKER_IMAGE|$DOCKER_IMAGE|g" ${BUILD_DIR}/deployment.yaml | kubectl apply -f -