import requests
import os
from dotenv import load_dotenv

load_dotenv()

# get polygon api key
KEY = os.getenv('POLYGON_API_KEY')
    
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
