#!/bin/bash

## These three lines will cause stdout/err to go a logfile as well
LOGFILE=run.log
exec > >(tee -a ${LOGFILE})
exec 2> >(tee -a ${LOGFILE} >&2)
env | sort | grep SCA #debug..

#debug..
#env | sort | grep SCA

$SCA_SERVICE_DIR/importdb.py
