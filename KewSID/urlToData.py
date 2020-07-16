#!/usr/bin/env python3

import os
import re
from selenium.webdriver import Chrome
from selenium.webdriver.chrome.options import Options
opts = Options()

# the browser I was using was Chrome, but any can be used.
browser = Chrome(options=opts)

with open('./allSpeciesUrlsTidy.txt', 'r') as urls:
    for url in urls:
        # the current url 
        browser.get(url)
        # get all information
        clade = browser.find_element_by_xpath("//*[@id='sid']").text
        print(clade + "\n\n" + "NEW RECORD" + "\n")