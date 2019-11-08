#!/bin/bash

set -e
ABOVE_SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && cd .. && pwd )

docker run --rm -it \
  -v ${ABOVE_SCRIPT_DIR}:/home/hogaramaInfra \
  gepardec/oc /home/hogaramaInfra/bootstrap/commons.sh \
    --oc-admin-token "1XCadhdpUZ392-J9k34ws7GUF6JYNB0sV_enPuJRRck" \
    --oc-cluster https://api.learningfriday.aws.openshift.gepardec.com:6443 \
    --namespace commons