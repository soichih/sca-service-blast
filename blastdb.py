#!/usr/bin/env python
import json
import sys
import os

config_json=open("config.json").read()
config=json.loads(config_json)
os.environ["DBNAME"] = config["db"]

if config["source"] == "ncbi":
    os.system(os.environ["SCA_SERVICE_DIR"]+"/download_ncbi.sh")

product = {'type': 'blastdb', 'name': config["db"], 'source': config["source"]}
with open('products.json', 'w') as out:
    json.dump([product], out)
