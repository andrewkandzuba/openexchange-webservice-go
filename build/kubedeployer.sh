#!/usr/bin/env bash

docker tag kubia $1/kubia && \
docker login -u $1 -p $2 2&>1 >/dev/null && \
docker push $1/kubia && \
gcloud container clusters create kubia --machine-type=f1-micro --num-nodes=3 --zone=$3 && \
kubectl run kubia --image=$1/kubia --port=8080 --generator=run/v1

#######################################################################################
# Browse Kubernetes Cluster
#######################################################################################
# kubectl get nodes
# kubectl describe node

kubectl expose rc kubia --type=LoadBalancer --name kubia-http
external_ip=$(echo "$(kubectl get service | grep kubia-http)" | awk  '{print $4}')

# kubectl get svc
# kubectl get rc

kubectl scale rc kubia --replicas=3

# kubectl get pods -o wide
# kubectl describe pod kubia-92krq