#!/bin/bash

set -e
ABOVE_SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && cd .. && pwd )


docker run --rm -it \
  -v ${ABOVE_SCRIPT_DIR}:/home/hogaramaInfra \
  quay.io/openshift/origin-cli:latest /home/hogaramaInfra/bootstrap/prometheus.sh \
    --oc-admin-token "$(oc whoami -t)" \
    --oc-cluster https://api.p.aws.ocp.gepardec.com:6443 \
    --namespace hogarama \
    --git-branch $(git branch | grep \* | cut -d ' ' -f2) \
    --force