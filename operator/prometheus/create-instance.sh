#!/bin/bash

oc create -n test-operators secret generic prometheus-scrape-config --from-file=prometheus-scrape-config.yml
oc 