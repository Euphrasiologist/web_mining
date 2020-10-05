#!/usr/bin/env python3

import os
import time
from selenium.webdriver import Chrome
from selenium.webdriver.chrome.options import Options
opts = Options()

# the browser I was using was Chrome, but any can be used.
browser = Chrome(options=opts)
# website
browser.get("http://www.brc.ac.uk/dbif/hosts.aspx")
# entering a single space returns the entire database
search_box = browser.find_element_by_xpath("/html/body/div[1]/table[1]/tbody/tr[3]/td/form/div[3]/table/tbody/tr[2]/td[3]/input").send_keys(" ")
# search to bring up the table.
browser.find_element_by_id("cphBody_btnSearchHost").click()

time.sleep(3)

# get the table
table_id = browser.find_element_by_id("cphBody_dgHostSpecies")
tbody = table_id.find_element_by_tag_name('tbody')

hrefs = []
species = []
# there are 4832 rows it seems
for tr_no in range(2,4832):
    href = tbody.find_element_by_xpath("//tr[" + str(tr_no) + "]/td[2]/i/a").get_attribute("href")
    sp = tbody.find_element_by_xpath("//tr[" + str(tr_no) + "]/td[2]/i/a").text
    hrefs.append(href)
    species.append(sp)
    print("href " + str(tr_no) + " scraped; " + "(" + str(sp) + ")")


# write a file of urls
with open("urls.txt", "w") as url_file:
    for href in hrefs:
        url_file.write(href + "\n")
# write a file of species
with open("species.txt", "w") as sp_file:
    for sp in species:
        sp_file.write(sp + "\n")