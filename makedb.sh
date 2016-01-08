#!/bin/bash

## These three lines will cause stdout/err to go a logfile as well
LOGFILE=run.log
exec > >(tee -a ${LOGFILE})
exec 2> >(tee -a ${LOGFILE} >&2)

#debug..
env | sort #| grep SCA 

progress_url="{$SCA_PROGRESS_URL}/{$SCA_PROGRESS_KEY}.makeblastdb"
dbtype=nucl
dbtitle=sometitle
dbname=somedb

curl -X POST -H "Content-Type: application/json" -d "{\"status\": \"running\", \"progress\": 0, \"msg\":\"Building DB\"}" $progress_url

module load ncbi-blast+

#USAGE
#  makeblastdb [-h] [-help] [-in input_file] [-input_type type]
#    -dbtype molecule_type [-title database_title] [-parse_seqids]
#    [-hash_index] [-mask_data mask_data_files] [-gi_mask]
#    [-gi_mask_name gi_based_mask_names] [-out database_name]
#    [-max_file_sz number_of_bytes] [-taxid TaxID] [-taxid_map TaxIDMapFile]
#    [-logfile File_Name] [-version]
makeblastdb -in $FASTA/sub.fasta.txt -dbtype $dbtype -title $dbtitle -out $dbname
ret=$?

curl -X POST -H "Content-Type: application/json" -d "{\"status\": \"running\", \"progress\": 1, \"msg\":\"Finished Building DB\"}" $progress_url

echo "[{\"type\": \"bio/blastdb\", \"name\": \"$dbname\", \"dbtype\": \"$dbtype\"}]" > products.json

exit $ret
