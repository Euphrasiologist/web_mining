# Examples of mining websites for underlying data

The two examples used so far are:

- The CCDB (Chromosome Count Database) for plants, which has a large collection of chromosome numbers of plants from many different sources. It can be visited here:
http://ccdb.tau.ac.il/
It is maintained by the Mayrose Lab (Plant Evolution, bioinformatics and comparative genomics)

- The plant C-value database, which can be found here:
https://cvalues.science.kew.org/search/
Leitch IJ, Johnston E, Pellicer J, Hidalgo O, Bennett MD. 2019. Plant DNA C-values database (release 7.1, Apr 2019)

## Aims

The aims of this repository is to automate data extraction from websites. The idea is not new, but hopefully I have implemented some pretty simple python scripts to do this. Packages such as os, Selenium and BeautifulSoup make extraction much less painful.

The scripts need a few packages to work, you will need to download these, using apt-get, or pip:
- pandas
- csv
- ssl 
- Selenium
- BeautifulSoup
- os

In particular, Selenium can be used to automate clicking, checking and scrolling actions on a browser. HTML files can then be downloaded on each iteration of search, for example.

## Data

Feel free to take and edit as you like, but if you are using the websites above (or any other website that holds data!) please cite them in any work that you produce from them down the line.

