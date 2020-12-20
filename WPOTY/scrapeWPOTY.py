#!/usr/bin/env python3
 
import os
import re
import time
from selenium.webdriver import Chrome
from selenium import webdriver
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.chrome.options import Options
from selenium.common.exceptions import NoSuchElementException

opts = Options()
browser = webdriver.Chrome(ChromeDriverManager().install())

data = []
data.append("Date,Category,Commendation,Camera,Lens,FocalLength,ShutterSpeed,Aperture,ISO")

with open("urls.txt") as urls:
    for url in urls:
        browser.get(url)
        date = re.search("https://www.nhm.ac.uk/wpy/gallery/(.+?)-", url)
        if date:
            foundDate = date.group(1)
        try:
            category = browser.find_element_by_xpath("/html/body/div[1]/div[1]/main/aside/aside/div/p[1]").text
            commendation = browser.find_element_by_class_name("Rank___3VgaS").text
            camera = browser.find_element_by_xpath("/html/body/div[1]/div[1]/main/div/div[2]/div/div[1]/div/ul/li[1]").text
            lens = browser.find_element_by_xpath("/html/body/div[1]/div[1]/main/div/div[2]/div/div[1]/div/ul/li[2]").text
            # if the lens contains the intermediate length on a zoom lens, get that data.
            lensList = lens.split("at")
            LENS = lensList[0]
            if len(lensList) == 2:
                focalLength = lensList[1]
            else:
                getFocalLength = re.compile("\d+mm|\d+ mm")
                result = getFocalLength.search(lensList[0])
                try:
                    focalLength = result.group(0)
                except AttributeError:
                    focalLength = "-"
            
            # sort out the settings
            settings = browser.find_element_by_xpath("/html/body/div[1]/div[1]/main/div/div[2]/div/div[1]/div/ul/li[3]").text
            settingsList = settings.replace("at", "•").split("•")

            regexISO = re.compile("ISO [0-9]+ ")
            regexAperture = re.compile("f[0-9]+")
            regexShutterSpeed = re.compile("1/[0-9]+")
            # catch empty lists
            shutterSpeed = list(filter(regexShutterSpeed.search, settingsList))
            if not shutterSpeed:
                shutterSpeed = "-"
            aperture = list(filter(regexAperture.search, settingsList))
            if not aperture:
                aperture = "-"
            ISO = list(filter(regexISO.search, settingsList))
            if not ISO:
                ISO = "-"

            data.append(foundDate + "," + category + "," + commendation + "," + camera + "," + LENS + "," + focalLength + "," + "".join(shutterSpeed[0].split()) + "," + "".join(aperture[0].split()) + "," + "".join(ISO[0].split()))
            print(foundDate + "," + category + "," + commendation + "," + camera + "," + LENS + "," + focalLength + "," + "".join(shutterSpeed[0].split()) + "," + "".join(aperture[0].split()) + "," + "".join(ISO[0].split()))

        except NoSuchElementException:
            print("No data found.")


# write a data file
with open("data.txt", "w") as data_file:
    for row in data:
        data_file.write(row + "\n")
