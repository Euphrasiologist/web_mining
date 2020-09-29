#!/usr/bin/env bash

# first run the python script
python scrape_SID.py > allSpeciesUrls.txt

# then filter out unwanted or duplicated URLs
grep -F "https://data.kew.org/sid/SidServlet?ID=" ./allSpeciesUrls.txt | sort -u > allSpeciesUrlsTidy.txt
