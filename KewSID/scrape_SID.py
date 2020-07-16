#!/usr/bin/env python3

import os
import re
import pandas as pd
from selenium.webdriver import Chrome
from selenium.webdriver.chrome.options import Options
opts = Options()

# the browser I was using was Chrome, but any can be used.
browser = Chrome(options=opts)
# the website.
browser.get('https://data.kew.org/sid/')

# technically basal dicots, monocots, and eudicots (and uncertain) should contain the whole database, 
# but I ran the whole thing to be sure...

clades =   ['BASAL DICOTS', 
            'MONOCOTS', 
            'COMMELINOIDS', 
            'EUDICOTS', 
            'CORE EUDICOTS', 
            'ROSIDS', 
            'EUROSIDS I', 
            'EUROSIDS II', 
            'ASTERIDS', 
            'EUASTERIDS I',
            'EUASTERIDS II',
            'UNCERTAIN']

for clade in range(len(clades)):
    # click on the dropdown, first option
    browser.find_element_by_xpath("//select[@name='Clade']/option[text()='{}']".format(clades[clade])).click()
    # then search
    search = browser.find_element_by_xpath("//input[@value='Search']")
    search.location_once_scrolled_into_view
    search.click()
    # Locate the anchor nodes first and load all the elements into some list
    lists = browser.find_elements_by_xpath("//a")
    # Empty list for storing links
    links = []
    for lis in lists:
        print(lis.get_attribute('href'))
        # Fetch and store the links
        links.append(lis.get_attribute('href'))
    # go back one page    
    browser.back()

