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
def find_console_tags(soup):
    # Console tags are stored as images, so we find the image tag and record its 'alt' value as text
    consoles = list()
    for img in soup.find_all('img'):
        if 'images/consoles'in img['src']:
            # Cut file path elements from string
            console_tag = (img['src'][17:-6])
            consoles.append(img['alt'])
    return consoles


# Find the names of games from the links
def find_names_column(table_path):
    names_list = list()
    for row in table_path.xpath('.//tr'):
        for td in row.xpath('.//td'):
            if not td.find('a') is None:
                names_list.append(td.find('a').text.strip()) 
    return names_list

# Write a function that takes in a VGChartz URL and gives us all the data in their video game database
def scrape_vgchartz_videogame_db_page(url):
    print("asking request")
    response = requests.get(url)
    print("request completed")
    ### Check the Status
    assert(response.status_code == 200)," Website not OK " # status code = 200 => OK
    
    #Store the contents of the website under doc
    page=response.text
    soup = BeautifulSoup(page, "lxml")
    doc = lh.fromstring(response.content)
    
    # Selects the table with all the data in it on HTML using xpath
    target_table_path = doc.xpath('//*[@id="generalBody"]/table')[0]

    # Find column values that won't be scraped correctly with .text option
    names_list = find_names_column(target_table_path)
    print("namelist=")
    print(names_list[:4])
    consoles = find_console_tags(soup)
    
    # Parse non-image and non-URL info from the data table to a pandas DataFrame
    row_dict={}
    df=pd.DataFrame()
    row_list= list()
    for counter,row in enumerate(target_table_path.xpath(".//tr")):
        if counter > 2: # To skip header rows
            row_list=[td.text for td in row.xpath(".//td")]
            row_dict[counter] = row_list

    df=pd.DataFrame.from_dict(row_dict).transpose()
    df.columns = ['position','game','blank','console','publisher','developer','vgchart_score',
                 'critic_score','user_score','total_shipped','total_sales',
                  'na_sales','pal_sales','japan_sales','other_sales',
                  'release_date','last_update']
    
    # Correct the console and game columns using scraped values
    
    df=df.reset_index().drop(columns = ['index','blank'])
    df['console'] = consoles
    df['game'] = names_list
    return df
console = ['DS', 'GB', 'PS4', 'PS', 'Wii', 'PS3', 'X360', 'NS', 'GBA', 'PSP', '3DS', 'NES', 'XOne', 'SNES', 'N64', 'GEN', '2600', 'XB', 'GC', 'PSV', 'WiiU', 'GG', 'SAT', 'DC', 'PS5', 'XS']
    # We can 'hack' the URL to display any number of results per page. I'll leave it as an argument.
def scrape_all_vg_chartz_videogame_db(cons,results_per_page):
    df = pd.DataFrame()
    current_page = 1
    games_left = True
    print("scanning page: "+ str(current_page))
    #while games_left:
    url = 'http://www.vgchartz.com/games/games.php?page=' + str(current_page) +\
    '&results=' + str(results_per_page) + '&name=&console='+cons+'&keyword=&publisher=&genre=&order=Sales&ownership\
    =Both&boxart=Both&banner=Both&showdeleted=&region=All&goty_year=&developer=&direction\
    =DESC&showtotalsales=1&shownasales=1&showpalsales=1&showjapansales=1&showothersales=1&\
    showpublisher=1&showdeveloper=1&showreleasedate=1&showlastupdate=1&showvgchartzscore=1&\
    showcriticscore=1&showuserscore=1&showshipped=1&alphasort=&showmultiplat=No'
    new_df = scrape_vgchartz_videogame_db_page(url)
    df = df.append(new_df)
    return df

# Run the code to scrape! I did 10,000 rows per page to speed things up.
for cons in console:
    time.sleep(1)
    print("working on ", cons)
    df=scrape_all_vg_chartz_videogame_db(cons,10000)
    print(df)
    # Compress and store for later!
    csvfilename = cons+ "vgsales-" + time.strftime("%Y-%m-%d_%H_%M_%S") + ".csv"
    df.to_csv(csvfilename, sep=",", encoding='utf-8', index=False)
    print("Wrote scraper data to", csvfilename)
    print("sleeping")
    time.sleep(1)
    print("awake")