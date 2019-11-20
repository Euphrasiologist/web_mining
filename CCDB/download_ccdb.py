#!/usr/bin/env python
# coding: utf-8

import os
import time

# make the string to use, we know they keep consistent naming in their URL's.
basestring="wget http://ccdb.tau.ac.il/csv/family/ -O "
# empty list
listoffamilies=[]

# populate the list of families
inputHandle=open("./Family_names.txt", 'r')
for eachline in inputHandle:
    eachline = eachline.rstrip('\n')
    listoffamilies.append(eachline)

# loop through, for each family, print the family
# use the OS library to excecute wget for you
# and download to the current directory
# sleep for 5 seconds in between to not overload the server with requests.

for ea in listoffamilies:
    print(ea)
    command = "wget http://ccdb.tau.ac.il/csv/family/%s -O ./%s.csv" % (ea, ea)
    print(command)
    os.system(command)
    print("Done for %s" % ea)
    time.sleep(5)

