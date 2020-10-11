#!/usr/bin/env bash

# download and format the DBIF - see: 
# http://www.brc.ac.uk/dbif

printf "Get urls and species names from DBIF...\n"

python DBIF_scrape.py

printf "Done. Cracking DBIF...\n"

python DBIF_scrape2.py

printf "Done. Formatting data... \n"

Rscript format.R > DBIF2.csv

printf "Done. Fixing plant names... \n"

Rscript fix_names.R > DBIF_PL.csv

printf "Done!"