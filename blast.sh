#!/bin/bash

## These three lines will cause stdout/err to go a logfile as well
LOGFILE=run.log
exec > >(tee -a ${LOGFILE})
exec 2> >(tee -a ${LOGFILE} >&2)

#debug..
env | sort | grep SCA 

#enable nodejs stuff
export PATH=$PATH:~/.sca/bin/node/bin
export PATH=$PATH:~/.sca/node_modules/underscore-cli/bin

#progress_url={$SCA_PROGRESS_URL}/{$SCA_PROGRESS_KEY}
dbname=`cat $SCA_TASK_DIR_DB/products.json | underscore select '.name' --outfmt text`
query_filename=`cat $SCA_TASK_DIR_QUERY/products.json | underscore select '.fasta .filename' --outfmt text`
outfile=blast.out

export BLASTDB=$SCA_TASK_DIR_DB

curl -X POST -H "Content-Type: application/json" -d "{\"status\": \"running\", \"progress\": 0, \"msg\":\"Untarring blast DB\"}" $SCA_PROGRESS_URL
(cd $SCA_TASK_DIR_DB && tar -xzf $dbname.tar.gz)

curl -X POST -H "Content-Type: application/json" -d "{\"status\": \"running\", \"progress\": 0, \"msg\":\"Running blast\"}" $SCA_PROGRESS_URL
echo "running: blastp -query $SCA_TASK_DIR_QUERY/$query_filename -db $dbname -out $outfile -outfmt 6"
blastp -query $SCA_TASK_DIR_QUERY/$query_filename -db $dbname -out blast.out -outfmt 6
echo "blast return code $ret"
ret=$?
curl -X POST -H "Content-Type: application/json" -d "{\"status\": \"finished\", \"progress\": 1, \"msg\":\"blast finished with code $ret\"}" $SCA_PROGRESS_URL

outsize=`stat --printf="%s" $outfile`
echo "[{\"type\": \"bio/blast\", \"filename\":\"$outfile\", \"size\":\"$outsize\", \"outfmt\": \"tabular\", \"name\": \"$query_filename against $dbname\"}]" > products.json

exit $ret
