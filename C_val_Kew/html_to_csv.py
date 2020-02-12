#!/usr/bin/env python
# coding: utf-8

import os
import pandas as pd
from bs4 import BeautifulSoup
import csv

# set the working directory
os.chdir("./")

# the number of files in my directory
# dir_len = len([name for name in os.listdir('.') if os.path.isfile(name)])

# loop through each html file

for i in range(1, 109):

		# create the save path
	save_path = './selenium_html_output'
		# path to each html
	completeName = os.path.join(save_path, "cvalues_kew_" + str(i) + ".html") 
		# make the file
	html = open(completeName)
		# make a soup
	soup = BeautifulSoup(html, "html.parser")
		# find table elements in html, and specifically the class table table-striped... etc
	table = soup.find("table", attrs={"class", "table table-striped search-results table-sm"})
		# find all the elements that are called th
	headers = [header.text for header in table.find_all('th')]
		# create an empty list
	rows = []
		# this gets all the rows and their values
	for row in table.find_all('tr'):
		rows.append([val.text.encode('utf8') for val in row.find_all('td')])


	with open('./html_csv_outputs' + "cvalues_kew_" + str(i) + '.csv', 'w') as f:
		writer = csv.writer(f)
		writer.writerow(headers)
		writer.writerows(row for row in rows if row)
	


