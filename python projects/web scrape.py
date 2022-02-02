from email import header
from http import server
from sqlite3 import TimeFromTicks
from black import NewLine
from bs4 import BeautifulSoup
import requests
import smtplib
import time
import datetime
import csv
import pandas as pd


# connecting to the website
URL = 'https://www.amazon.in/Sparx-SM-482-Green-Sports-Shoes/dp/B07YHYCRML/ref=sr_1_10?crid=3IBGFTX5BU0R7&keywords=running%2Bshoes&qid=1643718983&sprefix=running%2Bsh%2Caps%2C564&sr=8-10&th=1&psc=1'

headers = {"User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:96.0) Gecko/20100101 Firefox/96.0"}

page = requests.get(URL, headers= headers)

soup1 = BeautifulSoup(page.content,"html.parser")
soup2 = BeautifulSoup(soup1.prettify(), "html.parser")

title = soup2.find(id='productTitle').get_text()

price = soup2.find('span', 'a-offscreen').get_text()



price =price.strip()[1:]
title = title.strip()
print(title)
print(price)

today = datetime.date.today()


header = ['Title', 'price','Date']
data = [title, price,today]

# creating a csv to store the scrapped data
# only run this once or it will overwrite the previous data  
with open('amazon_scrape_dataset.csv','w', newline='',encoding = 'UTF8') as f:
    writer = csv.writer(f)
    writer.writerow(header)
    writer.writerow(data)


df = pd.read_csv(r'D:\software\VSC\new\amazon_scrape_dataset.csv')
print(df)

# appending data to the csv
with open('amazon_scrape_dataset.csv','a+', newline='',encoding = 'UTF8') as f:
    writer = csv.writer(f)
    writer.writerow(header)
    writer.writerow(data)


# organizing everything into a function

def price_check(): 
    URL = 'https://www.amazon.in/Sparx-SM-482-Green-Sports-Shoes/dp/B07YHYCRML/ref=sr_1_10?crid=3IBGFTX5BU0R7&keywords=running%2Bshoes&qid=1643718983&sprefix=running%2Bsh%2Caps%2C564&sr=8-10&th=1&psc=1'

    headers = {"User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:96.0) Gecko/20100101 Firefox/96.0"}

    page = requests.get(URL, headers= headers)

    soup1 = BeautifulSoup(page.content,"html.parser")
    soup2 = BeautifulSoup(soup1.prettify(), "html.parser")

    title = soup2.find(id='productTitle').get_text()

    price = soup2.find('span', 'a-offscreen').get_text()

    price =price.strip()[1:]
    title = title.strip()

    today = datetime.date.today()

        
    header = ['Title', 'price','Date']
    data = [title, price,today]

    with open('amazon_scrape_dataset.csv','a+', newline='',encoding = 'UTF8') as f:
        writer = csv.writer(f)
        writer.writerow(header)
        writer.writerow(data)


while True:
    price_check()
    time.sleep(86400) #<---- what ever interval of time you need  your data recorded on


#optional sending a mail if the  price requirements are met

def send_mail():
    server = smtplib.SMTP_SSL('smtp.gamil.com',465)
    server.ehlo()
    server.log
    server.login('your mail id','password')

    subject = ('any message you wnat to recive after the price condition is met')
    body = ('a brief message on the product')

    msg = f"subject:{subject}\n \n {body}"

    server.sendmail(
        "mail id", 
         msg 
    )