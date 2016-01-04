#!/bin/bash
## These three lines will cause stdout/err to go a logfile as well
LOGFILE=run.log
exec > >(tee -a ${LOGFILE})
exec 2> >(tee -a ${LOGFILE} >&2)

#debug..
env | sort | grep SCA
cat config.json 

progress_url=$SCA_PROGRESS_URL/${SCA_PROGRESS_KEY}.blastdb

#download db
#dbname=nr
dbname=pdbaa
mkdir -p $dbname
(
    cd $dbname

    curl -X POST -H "Content-Type: application/json" -d '{"status": "running", "progress": 0, "msg":"Downloading $dbname"}' $progress_url
    wget -nH --cut-dirs=3 -r ftp://ftp.ncbi.nlm.nih.gov/blast/db/$dbname.*

    if [ -f $dbname.00.tar.gz ];
    then
            echo "this is multipart db - untarring .pal or .nal from $dbname.00.tar.gz"
            tar -vxzf $dbname.00.tar.gz $dbname.*al
    fi

    curl -X POST -H "Content-Type: application/json" -d '{"status": "finished", "progress": 1, "msg":"Finished downloading $dbname"}' $progress_url
)

#output products.json
echo "[{\"type\":\"blastdb\", \"name\":\"$dbname\"}]" > products.json
