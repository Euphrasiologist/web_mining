#!/usr/bin/env python3

import os
import re
import time
from selenium.webdriver import Chrome
from selenium.webdriver.chrome.options import Options
opts = Options()

# the browser I was using was Chrome, but any can be used.
browser = Chrome(options=opts)

results = []
results.append("Host, Invertebrate order, Invertebrate family, Invertebrate subfamily, Invertebrate")

with open("urls.txt") as urls:
    url_ID = 1
    for url in urls:
        browser.get(url)
        # get host name
        host = browser.find_element_by_xpath("/html/body/div[1]/table[1]/tbody/tr[3]/td/form/div[3]/table/tbody/tr/td/span/h5/i").text
        # get the table
        table_id = browser.find_element_by_id("cphBody_dgHost")
        tbody = table_id.find_element_by_tag_name('tbody')
        rows = tbody.find_elements_by_tag_name("tr")
        # format the rows
        for row in rows[1:]:
            rowi = row.text
           split_rowi = re.split('(\)|idae|inae|Coleoptera|Diptera|Acari)', rowi)
            join_rowi = [ x+y for x,y in zip(split_rowi[0::2], split_rowi[1::2]) ]
            to_csv = host + ", " + ",".join(join_rowi)
            if to_csv.count(',') >= 3:
                results.append(to_csv)
        url_ID += 1
        print("Data collected for " + url)


# write to file
with open("DBIF.csv", "w") as dbif_csv:
    for row in results:
        dbif_csv.write(row + "\n")