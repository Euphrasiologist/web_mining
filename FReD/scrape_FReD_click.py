#!/usr/bin/env python
# coding: utf-8

import os
import time
from selenium.webdriver import Chrome
from selenium.webdriver.chrome.options import Options
opts = Options()

# the browser I was using was Chrome, but any can be used.
browser = Chrome(options=opts)


# TODO download the reflectance spectra...
# create loop over which each row of the table is clicked

# v crude, but all printed to stdout.
# these are the headers of the csv
print("family" + ", " + "genus" + ", " + "species" + ", " + "ID" + ", " + "section" + ", " + "bee" + ", " + "human" + ", " + "country"
          + ", " + "town" + ", " + "collector" + ", " + "pub" + ", " + "colTriX" + ", " + "colTriY" + ", " + "colTriQFUV" + ", " + "colTriQFB"
          + ", " + "colTriQFG" + ", " + "colHexX" + ", " + "colHexY" + ", " + "colHexExUV" + ", " + "colHexExB" + ", " + "colHexExG")

# /html/body/table/tbody/tr[4]/td/table/tbody/tr[3626]

for value in range(3626, 5192, 2): # 5192 found by locating the last element in the html. (/html/body/table/tbody/tr[4]/td/table/tbody/tr[5192])
    # the website, pre-searched...
    browser.get('http://reflectance.co.uk//advanceresults.php?bcolourc=Bee%20Colour&hcolourc=Human%20Colour&maincolourc=Main%20Colour&flowersectc=Flower%20Section&altitudec=Altitude&heightc=Height&tubec=tube&corollac=Corolla&pollinatorc=Pollinator&familyc=Family&genusc=Genus&speciesc=Species&countryc=Country&townc=Town/Area&eastc=GPS%20East&southc=GPS%20South&collectorc=Collector&publicationc=Publication&accessionc=accession&family=*Any%20Family*&genus=*Any%20Genus*&species=*Any%20Species*&country=*Any%20Country*&town=*Any%20Town*&bcolour=*Any%20Colour*&hcolour=*Any%20Colour*&flowersect=*Any%20Section*&pollinator=*Any%20Pollinator*&collector=*Any%20Collector*&maincolour=*Do%20not%20mind*&altitudegreat=-1&altitudeless=2801&heightgreat=-1&heightless=1001&tubegreat=-1&tubeless=61&corollagreat=-1&corollaless=161')
    
    # necessary to load and locate the subsequent browser elements
    time.sleep(2)

    # go to the first clickable species
    temp_table_path = browser.find_element_by_xpath("/html/body/table/tbody/tr[4]/td/table/tbody/tr[" + str(value) + "]")
    temp_table_path.location_once_scrolled_into_view
    temp_table_path.click()

    # necessary to load and locate the subsequent browser elements
    time.sleep(2)

    # need to wait for that click to activate, as it pulls up an iframe
    browser.switch_to.frame(browser.find_element_by_xpath("/html/body/div/div/div[2]/iframe"))

    # necessary to load and locate the subsequent browser elements
    time.sleep(2)

    # use a series of absolute xpaths to interrogate the pop up window...
    # family 
    family = browser.find_element_by_xpath("/html/body/table/tbody/tr[2]/td[1]/table[1]/tbody/tr[2]/td").get_attribute("innerHTML").replace(",", "-").replace("          &nbsp;", "")
    # genus
    genus = browser.find_element_by_xpath("/html/body/table/tbody/tr[2]/td[1]/table[2]/tbody/tr[2]/td[1]").get_attribute("innerHTML").replace(",", "-").replace("          &nbsp;", "")
    # species
    species = browser.find_element_by_xpath("/html/body/table/tbody/tr[2]/td[1]/table[2]/tbody/tr[2]/td[2]").get_attribute("innerHTML").replace(",", "-").replace("          &nbsp;", "")
    # ID
    ID = browser.find_element_by_xpath("/html/body/table/tbody/tr[2]/td[1]/table[3]/tbody/tr[2]/td[1]").get_attribute("innerHTML").replace(",", "-").replace("          &nbsp;", "")
    # plant section
    section = browser.find_element_by_xpath("/html/body/table/tbody/tr[2]/td[1]/table[3]/tbody/tr[2]/td[2]").get_attribute("innerHTML").replace(",", "-").replace("          &nbsp;", "")
    # bee colour
    bee = browser.find_element_by_xpath("/html/body/table/tbody/tr[2]/td[1]/table[3]/tbody/tr[2]/td[3]").get_attribute("innerHTML").replace(",", "-").replace("          &nbsp;", "")
    # human
    human = browser.find_element_by_xpath("/html/body/table/tbody/tr[2]/td[1]/table[3]/tbody/tr[2]/td[4]").get_attribute("innerHTML").replace(",", "-").replace("          &nbsp;", "")
    # country 
    country = browser.find_element_by_xpath("/html/body/table/tbody/tr[2]/td[1]/p[3]/table/tbody/tr[2]/td[1]").get_attribute("innerHTML").replace(",", "-").replace("          &nbsp;", "")
    # town
    town = browser.find_element_by_xpath("/html/body/table/tbody/tr[2]/td[1]/p[3]/table/tbody/tr[2]/td[2]").get_attribute("innerHTML").replace(",", "-").replace("          &nbsp;", "")
    # collector
    collector = browser.find_element_by_xpath("/html/body/table/tbody/tr[2]/td[1]/p[3]/table/tbody/tr[6]/td[1]").get_attribute("innerHTML").replace(",", "-").replace("          &nbsp;", "")
    # publication
    pub = browser.find_element_by_xpath("/html/body/table/tbody/tr[2]/td[1]/p[3]/table/tbody/tr[6]/td[2]").get_attribute("innerHTML").replace(",", "-").replace("          &nbsp;", "")
    # COLOUR TRI # 
    # X
    colTriX = browser.find_element_by_xpath("/html/body/table/tbody/tr[2]/td[2]/table/tbody/tr[3]/td").get_attribute("innerHTML").replace(",", "-").replace("          &nbsp;", "")
    # Y
    colTriY = browser.find_element_by_xpath("/html/body/table/tbody/tr[2]/td[2]/table/tbody/tr[5]/td").get_attribute("innerHTML").replace(",", "-").replace("          &nbsp;", "")
    # Quantum flux UV
    colTriQFUV = browser.find_element_by_xpath("/html/body/table/tbody/tr[2]/td[2]/table/tbody/tr[7]/td[2]").get_attribute("innerHTML").replace(",", "-").replace("          &nbsp;", "")
    # Quantum flux B
    colTriQFB = browser.find_element_by_xpath("/html/body/table/tbody/tr[2]/td[2]/table/tbody/tr[8]/td[2]").get_attribute("innerHTML").replace(",", "-").replace("          &nbsp;", "")
    # Quantum flux G
    colTriQFG = browser.find_element_by_xpath("/html/body/table/tbody/tr[2]/td[2]/table/tbody/tr[9]/td[2]").get_attribute("innerHTML").replace(",", "-").replace("          &nbsp;", "")
    # COLOUR HEX #
    # X
    colHexX = browser.find_element_by_xpath("/html/body/table/tbody/tr[4]/td/table/tbody/tr[3]/td").get_attribute("innerHTML").replace(",", "-").replace("          &nbsp;", "")
    # Y
    colHexY = browser.find_element_by_xpath("/html/body/table/tbody/tr[4]/td/table/tbody/tr[5]/td").get_attribute("innerHTML").replace(",", "-").replace("          &nbsp;", "")
    # excitation UV
    colHexExUV = browser.find_element_by_xpath("/html/body/table/tbody/tr[4]/td/table/tbody/tr[7]/td[2]").get_attribute("innerHTML").replace(",", "-").replace("          &nbsp;", "")
    # excitation B
    colHexExB = browser.find_element_by_xpath("/html/body/table/tbody/tr[4]/td/table/tbody/tr[8]/td[2]").get_attribute("innerHTML").replace(",", "-").replace("          &nbsp;", "")
    # excitation G
    colHexExG = browser.find_element_by_xpath("/html/body/table/tbody/tr[4]/td/table/tbody/tr[9]/td[2]").get_attribute("innerHTML").replace(",", "-").replace("          &nbsp;", "")

    print(family + ", " + genus + ", " + species + ", " + ID + ", " + section + ", " + bee + ", " + human + ", " + country
          + ", " + town + ", " + collector + ", " + pub + ", " + colTriX + ", " + colTriY + ", " + colTriQFUV + ", " + colTriQFB
          + ", " + colTriQFG + ", " + colHexX + ", " + colHexY + ", " + colHexExUV + ", " + colHexExB + ", " + colHexExG)

    # again crude, but just go back a page
    browser.execute_script("window.history.go(-1)")
