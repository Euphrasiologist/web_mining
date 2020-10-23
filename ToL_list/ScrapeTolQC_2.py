#!/usr/bin/env python3
 
import os
import time
from selenium.webdriver import Chrome
from selenium import webdriver
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.chrome.options import Options

opts = Options()
browser = webdriver.Chrome(ChromeDriverManager().install())


results = [] # heterozygosities may need to be averaged for those results > 0
results.append("Binomial, NCBI taxon id, Order, Family, NCBI lineage, Repeat %, Heterozygosity %") #, Contaminants, Date(P), Date(I)")


with open("urls.txt") as urls:
    for url in urls:

        browser.get(url)
        
        binomial = browser.find_element_by_xpath("/html/body/div[2]/div[1]/div/div[1]/h1/i").text
        gscope_table = browser.find_element_by_id("gscope_table")
        gscope_tbody = gscope_table.find_element_by_tag_name('tbody')
        gscope_tbody_rows = browser.execute_script("return document.getElementById('gscope_table').getElementsByTagName('tr').length")

        for tr_no in range(1, gscope_tbody_rows):
                repeat = gscope_tbody.find_element_by_xpath("//tr[" + str(tr_no) + "]/td[6]").text
                het = gscope_tbody.find_element_by_xpath("//tr[" + str(tr_no) + "]/td[7]").text

                NCBI = browser.find_element_by_xpath("/html/body/div[2]/table/tbody/tr[1]/td/a").text
                Order = browser.find_element_by_xpath("/html/body/div[2]/table/tbody/tr[2]/td").text
                Family = browser.find_element_by_xpath("/html/body/div[2]/table/tbody/tr[3]/td").text
                Lineage = browser.find_element_by_xpath("/html/body/div[2]/table/tbody/tr[4]/td").text

                results.append(binomial + "," + NCBI + "," + Order + "," + Family + "," + Lineage + "," + repeat + "," + het)

        print("Data collected for " + binomial)

# write a data file
with open("data.txt", "w") as data_file:
    for row in results:
        data_file.write(row + "\n")
