#!/bin/bash

# textract needs to be installed, at least that is what I used. See this awesome package at https://github.com/deanmalmgren/textract

# install with pip
# pip install textract

# there are loads of options but I used the default.
# You will need the PDF - the citation is:
# Askew RR, Melika G, Pujade-Villar J, Schonrogge K, Stone GN, Nieves-Aldrey JL. Catalogue of parasitoids and inquilines in cynipid oak galls in the West Palaearctic, Zootaxa (2013);3643:1-133

textract 2013AskewZootaxa.pdf > 2013AskewZootaxa.txt
