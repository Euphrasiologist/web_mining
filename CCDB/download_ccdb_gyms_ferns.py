#!/usr/bin/env python
# coding: utf-8

import os
import time

basestring="wget http://ccdb.tau.ac.il/csv/family/ -O "
listoffamilies=[]


inputHandle=open("./Family_names_gyms_ferns.txt", 'r')
for eachline in inputHandle:
    eachline = eachline.rstrip('\n')
    listoffamilies.append(eachline)

for ea in listoffamilies:
    print(ea)
    command = "wget http://ccdb.tau.ac.il/csv/family/%s -O ./%s.csv" % (ea, ea)
    print(command)
    os.system(command)
    print("Done for %s" % ea)
    time.sleep(5)

