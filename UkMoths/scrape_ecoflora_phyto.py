#!/usr/bin/env python3

import os
import time
from selenium.webdriver import Chrome
from selenium.webdriver.chrome.options import Options
opts = Options()

# the browser I was using was Chrome, but any can be used.
browser = Chrome(options=opts)

browser.get("http://ecoflora.org.uk/search_phytophagy.php")

table_list = browser.find_element_by_xpath("/html/body/ul")

for child in table_list.find_elements_by_xpath(".//*"):
    print(child.get_attribute("href"))