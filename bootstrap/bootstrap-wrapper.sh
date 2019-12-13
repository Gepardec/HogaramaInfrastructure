#!/bin/bash
#TODO: pass force flag through to scripts.
./commons-wrapper.sh
./hogarama-commons-wrapper.sh
./amq-wrapper.sh
./prometheus-wrapper.sh
./grafana-wrapper.sh
./mongodb-wrapper.sh
./fluentd-wrapper.sh

