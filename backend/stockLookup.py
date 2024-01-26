import requests
import json
import os
import sys
import time
import datetime
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from dotenv import load_dotenv

load_dotenv()


# get polygon api key
KEY = os.getenv('POLYGON_API_KEY')

def get_low_high(ticker: str):
    """
    Get the low and high price of a stock on a given date

    Args:
        ticker (str): Stock ticker
    
    Returns:
        low (float): Low price of stock on given date
        high (float): High price of stock on given date
    """
    url = f"https://api.polygon.io/v1/open-close/{ticker}/{datetime.datetime.today().strftime('%Y-%m-%d')}"
    params = {"apiKey": KEY}
    response = requests.get(url, params=params)
    if response.status_code == 200:
        data = response.json()
        return data['high'], data['low']  # Price
    else:
        return "Error: " + response.text
    
def get_news(ticker: str):
    url = f"https://api.polygon.io/v2/reference/news?limit=5&order=descending&sort=published_utc&ticker={ticker}"
    params = {"apiKey": KEY}
    response = requests.get(url, params=params)
    if response.status_code == 200:
        data = response.json()
        return [(article['title'], article['article_url']) for article in data['results']] 
    else:
        return "Error: " + response.text
    
def get_financials(ticker: str):
    url = f"https://api.polygon.io/v2/reference/financials/{ticker}"
    params = {"apiKey": KEY}
    response = requests.get(url, params=params)
    if response.status_code == 200:
        data = response.json()
        return data['results'][0]
    else:
        return "Error: " + response.text

def get_net_income(ticker: str):
    financials = get_financials(ticker)
    if type(financials) is str:  # Check if the return value is an error message
        return financials
    else:
        return financials.get('netIncome')
    
def get_total_revenue(ticker: str):
    financials = get_financials(ticker)
    if type(financials) is str:
        return financials
    else:
        return financials.get('totalRevenue')

def get_gross_profit(ticker: str):
    financials = get_financials(ticker)
    if type(financials) is str:
        return financials
    else:
        return financials.get('grossProfit')

def get_operating_income(ticker: str):
    financials = get_financials(ticker)
    if type(financials) is str:
        return financials
    else:
        return financials.get('operatingIncome')

# print(get_operating_income('AAPL'))

# print(get_low_high("AAPL"))
