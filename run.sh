#!/bin/bash
## These three lines will cause stdout/err to go a logfile as well
LOGFILE=run.log
exec > >(tee -a ${LOGFILE})
exec 2> >(tee -a ${LOGFILE} >&2)

#debug..
env | sort | grep SCA
cat config.json 

#progress_url=$SCA_PROGRESS_URL/${SCA_PROGRESS_KEY}.blastdb
#dbname=pdbaa

./blastdb.py

#output products.json
#echo "[{\"type\":\"blastdb\", \"name\":\"$dbname\"}]" > products.json
