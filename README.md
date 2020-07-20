# Examples of mining websites for underlying data

The four projects so far (20.07.20):

- Gall wasp and associated parasitoid wasp dataset locked in a PDF. The software "textract" (https://github.com/deanmalmgren/textract) was used to initially parse the PDF, then endlines were clipped (manually, sadly), then an R script was used to parse the text into a data table. The citation is here:
Askew RR, Melika G, Pujade-Villar J, Schonrogge K, Stone GN, Nieves-Aldrey JL. Catalogue of parasitoids and inquilines in cynipid oak galls in the West Palaearctic, Zootaxa (2013);3643:1-133

- The CCDB (Chromosome Count Database) for plants, which has a large collection of chromosome numbers of plants from many different sources. It can be visited here:
http://ccdb.tau.ac.il/
It is maintained by the Mayrose Lab (Plant Evolution, bioinformatics and comparative genomics)

- The plant C-value database, which can be found here:
https://cvalues.science.kew.org/search/
Leitch IJ, Johnston E, Pellicer J, Hidalgo O, Bennett MD. 2019. Plant DNA C-values database (release 7.1, Apr 2019)

- The Kew Seed Information Database (SID), which was last updated in 2008, contains a wealth of information about ~50,000 different plant species. The entire underlying database is extracted here. Please visit and cite https://data.kew.org/sid/ if you use.

## Aims

The aims of this repository is to automate data extraction from websites. The idea is not new but can be done in a variety of ways. Packages such as os, Selenium and BeautifulSoup make extraction much less painful.

The scripts need a few packages to work, you will need to download these, using apt-get, or pip:
- pandas
- csv
- ssl 
- Selenium
- BeautifulSoup
- os
- textract
- data.table R package

In particular, Selenium can be used to automate clicking, checking and scrolling actions on a browser. HTML files can then be downloaded on each iteration of search, for example.

## Data

Feel free to take and edit as you like, but if you are using the websites or citations above (or any other website that holds data!) please cite them in any work that you produce from them down the line.

