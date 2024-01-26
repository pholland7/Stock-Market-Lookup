from flask import Flask, jsonify
from stockLookup import get_news, get_financials

app = Flask(__name__)

@app.route('/api/news/<ticker>', methods=['GET'])
def api_get_news(ticker):
    result = get_news(ticker)
    return jsonify(result)

@app.route('/api/financials/<ticker>', methods=['GET'])
def api_get_financials(ticker):
    result = get_financials(ticker)
    return jsonify({"netIncome": result})

@app.route('/api/net_income/<ticker>', methods=['GET'])
def api_get_net_income(ticker):
    result = get_financials(ticker)
    return jsonify({"netIncome": result.get('netIncome')})

@app.route('/api/total_revenue/<ticker>', methods=['GET'])
def api_get_total_revenue(ticker):
    result = get_financials(ticker)
    return jsonify({"totalRevenue": result.get('totalRevenue')})

@app.route('/api/gross_profit/<ticker>', methods=['GET'])
def api_get_gross_profit(ticker):
    result = get_financials(ticker)
    return jsonify({"grossProfit": result.get('grossProfit')})

@app.route('/api/operating_income/<ticker>', methods=['GET'])
def api_get_operating_income(ticker):
    result = get_financials(ticker)
    return jsonify({"operatingIncome": result.get('operatingIncome')})

if __name__ == '__main__':
    app.run(debug=True)