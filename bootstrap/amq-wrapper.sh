#!/bin/bash

set -e
ABOVE_SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && cd .. && pwd )

docker run --rm -it \
  -v ${ABOVE_SCRIPT_DIR}:/home/hogaramaInfra \
  quay.io/openshift/origin-cli:latest /home/hogaramaInfra/bootstrap/amq.sh \
    --oc-admin-token "LbYhuoABOULBVkc77wKVNY_4hNoW3_yd-hZ01QhONk0" \
    --oc-cluster https://api.learningfriday.aws.openshift.gepardec.com:6443 \
    --namespace hogarama