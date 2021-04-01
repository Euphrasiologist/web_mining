#!/usr/bin/env python
# coding: utf-8

import os
import time
from selenium.webdriver import Chrome
from selenium.webdriver.chrome.options import Options
from selenium.common.exceptions import NoSuchElementException

opts = Options()

# the browser I was using was Chrome, but any can be used.
browser = Chrome("/Users/mb39/homebrew/bin/chromedriver")


# TODO download the reflectance spectra...
# create loop over which each row of the table is clicked

# v crude, but all printed to stdout.
# these are the headers of the csv
# print(
#    "cultivar"
#    + ","
#    + "division"
#    + ","
#    + "perianth"
#    + ","
#    + "corona"
#    + ","
#    + "orig_name"
#    + ","
#    + "date"
#    + ","
#    + "synonym"
#    + ","
#    + "awards"
#    + ","
#    + "seed_parent"
#    + ","
#    + "pollen_parent"
#    + ","
#    + "description"
# )

# started at 200001
# 221274
# 222431
# 224963
for value in range(224964, 227000):
    # the website, pre-searched...
    browser.get(
        "https://apps.rhs.org.uk/horticulturaldatabase/daffodilregister/daffdetails.asp?ID="
        + str(value)
    )

    try:
        cultivar = browser.find_element_by_class_name("specimen").text
    except NoSuchElementException:
        cultivar = None

    if cultivar is None:
        continue
    # table
    temp_table_path = browser.find_element_by_xpath(
        "/html/body/div[2]/div/div[1]/div/div[1]/div[2]/table"
    )
    registered = ""
    perianth = ""
    corona = ""
    orig_name = ""
    date = ""
    synonym = ""
    awards = ""
    seed_parent = ""
    pollen_parent = ""
    description = ""
    for row in temp_table_path.find_elements_by_xpath(".//tr"):
        txt_list = [td.text for td in row.find_elements_by_xpath(".//td")]
        if txt_list[0] == "Division":
            registered = txt_list[1].replace("\r", "").replace("\n", "")
        elif txt_list[0] == "Perianth colour(s)":
            perianth = txt_list[1].replace("\r", "").replace("\n", "")
        elif txt_list[0] == "Corona colour(s)":
            corona = txt_list[1].replace("\r", "").replace("\n", "")
        elif txt_list[0] == "Originator name":
            orig_name = txt_list[1].replace("\r", "").replace("\n", "")
        elif txt_list[0] == "Date of first flowering":
            date = txt_list[1].replace("\r", "").replace("\n", "")
        elif txt_list[0] == "Synonym(s)":
            synonym = txt_list[1].replace("\r", "").replace("\n", "")
        elif txt_list[0] == "Award(s)":
            awards = txt_list[1].replace("\r", "").replace("\n", "")
        elif txt_list[0] == "Seed parent":
            seed_parent = txt_list[1].replace("\r", "").replace("\n", "")
        elif txt_list[0] == "Pollen parent":
            pollen_parent = txt_list[1].replace("\r", "").replace("\n", "")
        elif txt_list[0] == "Description":
            description = txt_list[1].replace("\r", "").replace("\n", "")

    print(
        f'"{cultivar}","{registered}","{perianth}","{corona}","{orig_name}","{date}","{synonym}","{awards}","{seed_parent}","{pollen_parent}","{description}"'
    )
