#!/usr/bin/env bash

grep -F "https://data.kew.org/sid/SidServlet?ID=" ./allSpeciesUrls.txt | sort -u
