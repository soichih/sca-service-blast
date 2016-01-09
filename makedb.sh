#!/bin/bash

## These three lines will cause stdout/err to go a logfile as well
LOGFILE=run.log
exec > >(tee -a ${LOGFILE})
exec 2> >(tee -a ${LOGFILE} >&2)

#debug..
env | sort #| grep SCA 

#enable nodejs stuff
export PATH=$PATH:~/.sca/bin/node/bin
export PATH=$PATH:~/.sca/node_modules/underscore-cli/bin

progress_url="{$SCA_PROGRESS_URL}/{$SCA_PROGRESS_KEY}.makeblastdb"
dbtype=`cat $SCA_TASK_DIR_FASTA/products.json | underscore select '.fasta .type :first-child'`
dbtitle=sometitle
dbname=somedb
input_file=`cat $SCA_TASK_DIR_FASTA/products.json | underscore select '.fasta .filename :first-child'`
input_filepath=$SCA_TASK_DIR_FASTA/$input_file

curl -X POST -H "Content-Type: application/json" -d "{\"name\": \"$dbname\", \"status\": \"running\", \"progress\": 0, \"msg\":\"Building DB\"}" $progress_url

module load ncbi-blast+

#USAGE
#  makeblastdb [-h] [-help] [-in input_file] [-input_type type]
#    -dbtype molecule_type [-title database_title] [-parse_seqids]
#    [-hash_index] [-mask_data mask_data_files] [-gi_mask]
#    [-gi_mask_name gi_based_mask_names] [-out database_name]
#    [-max_file_sz number_of_bytes] [-taxid TaxID] [-taxid_map TaxIDMapFile]
#    [-logfile File_Name] [-version]
#makeblastdb -in $input_file -dbtype $dbtype -title $dbtitle -out $dbname
makeblastdb -in $input_filepath -title $input_file -dbtype $dbtype
ret=$?
if [ $ret -eq 0 ]
then
    status="finished"
    msg="Successfully built blast DB"
    echo "[{\"type\": \"bio/blastdb\", \"name\": \"$dbname\", \"dbtype\": \"$dbtype\", \"source\":\"user\"}]" > products.json
else
    status="failed"
    msg="makeblastdb returned code:$ret"
fi
curl -X POST -H "Content-Type: application/json" -d "{\"status\": \"finished\", \"progress\": 1, \"msg\":\"Finished Building DB\"}" $progress_url

exit $ret
