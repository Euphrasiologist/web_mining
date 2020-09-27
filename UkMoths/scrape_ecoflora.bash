#!/usr/bin/env bash

# collect the urls
python scrape_ecoflora_phyto.py > all_ecoflora_hrefs.txt

# remove dud urls
awk '$1 !~ /None/' all_ecoflora_hrefs.txt > all_ecoflora_hrefs2.txt

# iterate over the urls to produce the data
python scrape_ecoflora_phyto2.py > ecoflora_phy.txt

# tidy up the data in node
node format_ecoflora.js
