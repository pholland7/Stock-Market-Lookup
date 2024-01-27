import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String grossProfit = '';
  String news = '';
  String financials = '';
  String netIncome = '';
  String operatingIncome = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchData(String input) async {
    try {
      final grossProfitResponse = await getGrossProfit(input);
      final newsResponse = await getNews(input);
      final financialsResponse = await getFinancials(input);
      final netIncomeResponse = await getNetIncome(input);
      final operatingIncomeResponse = await getOperatingIncome(input);
      setState(() {
        grossProfit = 'Gross Profit: $grossProfitResponse';
        news = 'News: $newsResponse';
        financials = 'Financials: $financialsResponse';
        netIncome = 'Net Income: $netIncomeResponse';
        operatingIncome = 'Operating Income: $operatingIncomeResponse';
      });
    } catch (e) {
      // Handle errors
      print('Error fetching data: $e');
    }
  }

  Future<dynamic> getGrossProfit (String input) async{
    final response = await http
      .get(Uri.parse('https://stock-lookup-backend-87992ddeef5c.herokuapp.com/api/gross_profit/' + input));
    final grossProfit = jsonDecode(response.body)["grossProfit"];
    if (response.statusCode == 200) {
      return grossProfit;
    } else {
      throw Exception('Failed to load gross profit.');
    }
  }

  Future<dynamic> getNews (String input) async{
    final response = await http
      .get(Uri.parse('https://stock-lookup-backend-87992ddeef5c.herokuapp.com/api/news/' + input));
    final newsStories = jsonDecode(response.body)[0][0];
    if (response.statusCode == 200) {
      return newsStories;
    } else {
      throw Exception('Failed to load news.');
    }
  }

  Future<dynamic> getFinancials (String input) async{
    final response = await http
      .get(Uri.parse('https://stock-lookup-backend-87992ddeef5c.herokuapp.com/api/financials/' + input));
    final financials = jsonDecode(response.body)["netIncome"]["currentRatio"];
    if (response.statusCode == 200) {
      return financials;
    } else {
      throw Exception('Failed to load financials.');
    }
  }

  Future<dynamic> getNetIncome (String input) async{
    final response = await http
      .get(Uri.parse('https://stock-lookup-backend-87992ddeef5c.herokuapp.com/api/net_income/' + input));
    final netIncome = jsonDecode(response.body)["netIncome"];
    if (response.statusCode == 200) {
      return netIncome;
    } else {
      throw Exception('Failed to load net income.');
    }
  }

  Future<dynamic> getOperatingIncome (String input) async{
    final response = await http
      .get(Uri.parse('https://stock-lookup-backend-87992ddeef5c.herokuapp.com/api/operating_income/' + input));
    final operatingIncome = jsonDecode(response.body)["operatingIncome"];
    if (response.statusCode == 200) {
      return operatingIncome;
    } else {
      throw Exception('Failed to load operating income.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text(
              'Search for a stock below!',
              style: TextStyle(fontSize: 24),
            ),
            const Text(
              '(ie. \'AAPL\')',
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: IconButton(
                  onPressed: () {
                    fetchData(_searchController.text);
                  },
                  icon: const Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(grossProfit),
            Text(news),
            Text(financials),
            Text(netIncome),
            Text(operatingIncome),
          ],
        ),
      ),
    );
  }
}