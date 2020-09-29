#!/usr/bin/env python3

import os
import time
from selenium.webdriver import Chrome
from selenium.webdriver.chrome.options import Options
from selenium.common.exceptions import NoSuchElementException

opts = Options()

browser = Chrome(options=opts)

with open("all_ecoflora_hrefs2.txt") as hrefs:
    for href in hrefs:
        browser.get(href)
        time.sleep(1)
        try:
            html_list = browser.find_element_by_xpath("/html/body/ol")
            items = html_list.find_elements_by_tag_name("li")
            for item in items:
                text = item.text
                print(text)
        except NoSuchElementException:
            print("No data found.")
