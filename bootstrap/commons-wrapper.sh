#!/bin/bash

set -e
ABOVE_SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && cd .. && pwd )

docker run --rm -it \
  -v ${ABOVE_SCRIPT_DIR}:/home/hogaramaInfra \
  quay.io/openshift/origin-cli:latest /home/hogaramaInfra/bootstrap/commons.sh \
    --oc-admin-token "dDrZg1tvISPMaJekho7buCfL9aJBgD5n99Jm62l-tDo" \
    --oc-cluster https://api.learningfriday.aws.openshift.gepardec.com:6443 \
    --namespace commons