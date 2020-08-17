#!/usr/bin/env bash

# excecute the python script
python scrape_FReD_click.py > ./FReD_all.csv
# some problems with commas sorted out with this awk script
awk -F, '{gsub(/, /, ","); print}' FReD_all.csv > FReD_all2.csv
