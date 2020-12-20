#!/usr/bin/env python3
 
import os
import time
from selenium.webdriver import Chrome
from selenium import webdriver
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.chrome.options import Options
 
opts = Options()
 
browser = webdriver.Chrome(ChromeDriverManager().install())
 
browser.get("https://www.nhm.ac.uk/wpy/gallery?tags=")

elements = browser.find_elements_by_class_name("ImageGrid__container___YSm77")
hrefs = [element.get_attribute('href') for element in elements]

# write a file of urls
with open("urls.txt", "w") as url_file:
    for href in hrefs:
        url_file.write(href + "\n")