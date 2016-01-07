#!/bin/bash

#download db
#DBNAME=nr
echo "Downloading $DBNAME"
mkdir -p $DBNAME
cd $DBNAME

#curl -X POST -H "Content-Type: application/json" -d "{\"status\": \"running\", \"progress\": 0, \"msg\":\"Downloading $DBNAME\"}" $progress_url
wget -nH --cut-dirs=3 -r ftp://ftp.ncbi.nlm.nih.gov/blast/db/$DBNAME*

if [ -f $DBNAME.00.tar.gz ];
then
        echo "this is multipart db - untarring .pal or .nal from $DBNAME.00.tar.gz"
        tar -vxzf $DBNAME.00.tar.gz $DBNAME.*al
fi
#curl -X POST -H "Content-Type: application/json" -d "{\"status\": \"finished\", \"progress\": 1, \"msg\":\"Finished downloading $DBNAME\"}" $progress_url
