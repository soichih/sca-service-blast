#!/bin/bash

## These three lines will cause stdout/err to go a logfile as well
LOGFILE=run.log
exec > >(tee -a ${LOGFILE})
exec 2> >(tee -a ${LOGFILE} >&2)

#debug..
env | sort | grep SCA 

progress_url="{$SCA_PROGRESS_URL}/{$SCA_PROGRESS_KEY}.makeblastdb"
input_file=$FASTADIR
dbtype=nucl
dbtitle=sometitle
dbname=somedb

curl -X POST -H "Content-Type: application/json" -d "{\"status\": \"running\", \"progress\": 0, \"msg\":\"Building DB\"}" $progress_url
module load ncbi-blast+
makeblastdb -in $input_file -dbtype $dbtype -title $dbtitle -out $dbname
ret=$?

curl -X POST -H "Content-Type: application/json" -d "{\"status\": \"running\", \"progress\": 1, \"msg\":\"Finished Building DB\"}" $progress_url

echo "[{\"type\": \"bio/blastdb\", \"name\": \"$dbname\", \"dbtype\": \"$dbtype\"}]" > products.json

exit $ret
