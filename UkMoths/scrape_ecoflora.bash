#!/usr/bin/env bash

python scrape_ecoflora_phyto.py > all_ecoflora_hrefs.txt

awk '$1 !~ /None/' all_ecoflora_hrefs.txt > all_ecoflora_hrefs2.txt