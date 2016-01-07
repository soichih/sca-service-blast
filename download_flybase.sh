#!/bin/bash

name=dmel-all-chromosome-r5
version=57
url=ftp://ftp.flybase.net/genomes/Drosophila_melanogaster/current/fasta/$name.$version.fasta.gz
dbtype=nucl
title="Flybase dmel-all-chromosome-r5"

mkdir $name.$version
cd $name.$version
wget -N $url
gunzip -c $name.$version.fasta.gz | makeblastdb -title "$title" -dbtype $dbtype -out $name -hash_index

echo "comprssing each part into *.tar.gz"
tar -cz $name.* > $name.tar.gz

