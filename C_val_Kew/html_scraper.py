#!/usr/bin/env python
# coding: utf-8

import ssl
# to get rid of an error I don't know what it means.
# this is possible dangerous, but I am keeping only to Kew...
ssl._create_default_https_context = ssl._create_unverified_context

import os
import pandas as pd
from selenium.webdriver import Chrome
from selenium.webdriver.chrome.options import Options
opts = Options()

# the browser I was using was Chrome, but any can be used.
browser = Chrome(options=opts)
# the website.
browser.get('https://cvalues.science.kew.org/search/angiosperm')

## select the checkboxes for the search ##

# find the boxes to check
search_form_all = browser.find_elements_by_class_name("form-check-input")

# delete elements from the list which are not needed [there are 21 elements]
# list of indexes
indexes = [0,4,5,6,7,8,9,11,12]
# names of elements to click
indexed = [search_form_all[i] for i in indexes]

for element in indexed:
	element.location_once_scrolled_into_view
	element.click()

# the actual search, could not find by class name, so using xpath
# click the search bar!
search = browser.find_element_by_xpath("//input[@class='btn btn-primary']")
search.location_once_scrolled_into_view
search.click()

# there are 108 pages

i = 1

# below, i should be 109! (108 pages)

while i < 109:
		# find the next button number
	string = "//a[@href='#'][@class='page-link cvalues-pagination'][@data-page='" + str(i) + "']"
	next_page_search = browser.find_element_by_xpath(string)

		# get the current html
	html = browser.page_source
		# create the save path
	save_path = './selenium_html_output'
		# name the html
	completeName = os.path.join(save_path, "cvalues_kew_" + str(i) + ".html") 
		# make the file
	make_file_i = open(completeName, "w")
		# actually write it
	make_file_i.write(html)
		# close for iteration i
	make_file_i.close()

		# now move to the 
	next_page_search.location_once_scrolled_into_view
	next_page_search.click()
	i += 1
