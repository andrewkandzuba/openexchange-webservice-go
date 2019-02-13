#!/usr/bin/env bash

set -euo pipefail

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

$SCRIPTPATH/docker_run.sh
$SCRIPTPATH/kubernetes_run.sh $DOCKER_HUB_USER $DOCKER_HUB_PASSWORD