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

# takes in ticker symbol, a date and returns the high and the low for that date
def getLowHigh(ticker: str, date: str):
    url = f"https://api.polygon.io/v1/open-close/{ticker}/{date}"
    params = {"apiKey": KEY}
    response = requests.get(url, params=params)
    if response.status_code == 200:
        data = response.json()
        return data['high']  # Price
    else:
        return "Error: " + response.text

