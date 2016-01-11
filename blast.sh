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
#dbtype=`cat $SCA_TASK_DIR_DB/products.json | underscore select '.dbtype' --outfmt text`
dbname=`cat $SCA_TASK_DIR_DB/products.json | underscore select '.name' --outfmt text`
query_filename=`cat $SCA_TASK_DIR_QUERY/products.json | underscore select '.fasta .filename' --outfmt text`

export BLASTDB=$SCA_TASK_DIR_DB

(cd $SCA_TASK_DIR_DB && tar -xzf $dbname.tar.gz)
echo "running: blastp -query $SCA_TASK_DIR_QUERY/$query_filename -db $dbname -out blast.out -outfmt 6"
blastp -query $SCA_TASK_DIR_QUERY/$query_filename -db $dbname -out blast.out -outfmt 6
echo "blast return code $ret"
ret=$?

echo "[{\"type\": \"bio/blast\", \"outfmt\": \"tabular\", \"name\": \"$query_filename against $dbname\"}]" > products.json

exit $ret
