from bs4 import BeautifulSoup, element
import pandas as pd
import numpy as np
import requests
import time
import unidecode
from user_agent import generate_user_agent
from itertools import cycle
import lxml.html as lh
from multiprocessing import Pool, cpu_count  # This is a thread-based Pool
from requests.exceptions import ConnectionError, Timeout, ProxyError, RequestException
from urllib3.exceptions import ProtocolError
import sys
import os
from urllib.request import Request, urlopen
import json
import time

def scrapeBYgame():
    df = pd.DataFrame()
    current_page = 0
    print("scanning page: "+ str(current_page))
    #while games_left:
    new_df = scrape_page()
    df = df.append(new_df)
    return df
def scrape_page():
    file={}
    for current_page in range(141,183):
        url = 'https://www.metacritic.com/browse/games/score/metascore/all/all/filtered?page=' + str(current_page)
        hdr = {'User-Agent': 'Mozilla/5.0'}
        time.sleep(2)
        try:
            req = Request(url,headers=hdr)
            page = urlopen(req)
            soup = BeautifulSoup(page,"lxml")
            print("doing page ", current_page)
            item_list = soup.find_all("td", {"class": "clamp-summary-wrap"})
            for p in item_list:
                json_el = { "title":"", "us":0, "ms":0, "platform" : "", "release": ""}
                json_el["title"] = p.find("h3").text.strip()
                json_el["platform"] = p.find("span", {"class": "data"}).text.strip()
                try:
                    json_el["ms"] = p.find("div", {"class": "metascore_w large game positive"}).text.strip()
                except:
                    try:
                        json_el["ms"] = p.find("div", {"class": "metascore_w large game mixed"}).text.strip()
                    except:
                        json_el["ms"] = p.find("div", {"class": "metascore_w large game negative"}).text.strip()
                try:
                    json_el["us"] = p.find("div", {"class": "metascore_w user large game positive"}).text.strip()
                except:
                    try:
                        json_el["us"] = p.find("div", {"class": "metascore_w user large game mixed"}).text.strip()
                    except:
                        try:
                            json_el["us"] = p.find("div", {"class": "metascore_w user large game negative"}).text.strip()
                        except:
                            json_el["us"] = p.find("div", {"class": "metascore_w user large game tbd"}).text.strip()
                        


                json_el["release"] = p.find("div", {"class": "clamp-details"}).find_all("span")[-1].text.strip()
                file[p.find("span", {"class": "title numbered"}).text.strip()] = json_el
            if(current_page % 20 == 0): 
                bk = 'dataBackup'+ str(current_page) + '.txt'
                with open(bk, 'w') as outfile:
                    json.dump(file, outfile)    
        except:
            with open('data.txt', 'w') as outfile:
                json.dump(file, outfile)
    with open('data.txt', 'w') as outfile:
        json.dump(file, outfile)    


scrapeBYgame()