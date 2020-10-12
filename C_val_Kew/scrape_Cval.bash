#!/usr/bin/env bash

# get all the urls
python html_scraper.py

# loop over urls and extract csvs
python html_to_csv.py

