#!/usr/bin/env bash

# call first scraper to output urls

python ./ScrapeTolQC.py

# then output the data

python ./ScrapeTolQC_2.py

# clean the data a little bit

Rscript tidy.R

echo "Done"
