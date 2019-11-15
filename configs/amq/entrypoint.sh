#!/bin/bash

/opt/amq/bin/launch.sh nostart
cp /home/jboss/cfg/* /home/jboss/broker/etc/
/home/jboss/broker/bin/artemis run