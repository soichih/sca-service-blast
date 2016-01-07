#!/bin/bash

dbname=swissprot
dbparent=nr
version=`date +%F`

mkdir -p $dbname.$version
cd $dbname.$version

echo "downloading $dbname mask"
wget -nH --cut-dirs=3 -r ftp://ftp.ncbi.nlm.nih.gov/blast/db/$dbname.*

echo "uncompressing swissprot masks"
for gz in $dbname.*.tar.gz
do
        echo "uncompressing $gz"
        tar -xzf $gz
        rm $gz #need to remove because we are going to recreate with the same name
        rm $gz.md5
done

echo "uncompressing parent db"
for gz in ../$dbparent.$version/*.tar.gz
do
        echo "uncompressing $gz"
        tar -xzf $gz
done

part=0
while [ -f $dbname.$(printf "%02d" $part).msk ]
do
        echo "joining and re-compressing part:$part"
        nr=$dbparent.$(printf "%02d" $part).tar.gz
        tar -cz $dbparent.$(printf "%02d" $part).* $dbname.$(printf "%02d" $part).* > $dbname.$(printf "%02d" $part).tar.gz
        part=$((part+1))
done

echo "cleaning up"
rm -rf $dbparent.*
rm -rf *.msk
rm -rf $dbname.*.pal

