#!/usr/bin/env python3
 
import os
import time
from selenium.webdriver import Chrome
from selenium import webdriver
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.chrome.options import Options
 
opts = Options()
 
browser = webdriver.Chrome(ChromeDriverManager().install())
 
browser.get("https://tolqc.cog.sanger.ac.uk/index.html")
 
table_id = browser.find_element_by_id("reports_table")
tbody = table_id.find_element_by_tag_name('tbody')

# limit
lim = browser.find_element_by_xpath("/html/body/div[2]/div[4]/div[1]/div[3]/div[2]/ul/li[8]/a").text
 
hrefs = []
tick = 0

while tick < int(lim):

    tbody_rows = browser.execute_script("return document.getElementById('reports_table').getElementsByTagName('tr').length")

    for tr_no in range(1, tbody_rows):
        href = tbody.find_element_by_xpath("//tr[" + str(tr_no) + "]/td[2]/i/a").get_attribute("href")
        sp = tbody.find_element_by_xpath("//tr[" + str(tr_no) + "]/td[2]/i/a").text
        hrefs.append(href)
        print("href " + str(tr_no) + " scraped.")
        print("Done for page " + str(tick + 1) + ".")
    
    tick += 1
    time.sleep(1)
    browser.find_element_by_xpath("/html/body/div[2]/div[4]/div[1]/div[3]/div[2]/ul/li[9]").click()
    
 

# write a file of urls
with open("urls.txt", "w") as url_file:
    for href in hrefs:
        url_file.write(href + "\n")