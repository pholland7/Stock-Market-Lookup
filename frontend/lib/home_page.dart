import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

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
  String BASE_URL =
      'https://stock-lookup-backend-87992ddeef5c.herokuapp.com/api';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String formatCurrency(num number) {
    final format =
        NumberFormat.currency(locale: "en_US", symbol: "\$", decimalDigits: 0);
    return format.format(number);
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

  Future<dynamic> getGrossProfit(String input) async {
    final response = await http.get(Uri.parse('$BASE_URL/gross_profit/$input'));
    final grossProfit =
        formatCurrency(jsonDecode(response.body)["grossProfit"]);
    if (response.statusCode == 200) {
      return grossProfit;
    } else {
      throw Exception('Failed to load gross profit.');
    }
  }

  Future<dynamic> getNews(String input) async {
    final response = await http.get(Uri.parse('$BASE_URL/news/$input'));
    if (response.statusCode == 200) {
      String newsStories = "";
      for (int i = 0; i < jsonDecode(response.body).length; i++) {
        newsStories += jsonDecode(response.body)[i][0] + '\n';
      }
      return newsStories;
    } else {
      throw Exception('Failed to load news.');
    }
  }

  Future<dynamic> getFinancials(String input) async {
    final response = await http.get(Uri.parse('$BASE_URL/financials/$input'));
    final financials =
        formatCurrency(jsonDecode(response.body)["netIncome"]["currentRatio"]);
    if (response.statusCode == 200) {
      return financials;
    } else {
      throw Exception('Failed to load financials.');
    }
  }

  Future<dynamic> getNetIncome(String input) async {
    final response = await http.get(Uri.parse('$BASE_URL/net_income/$input'));
    final netIncome = formatCurrency(jsonDecode(response.body)["netIncome"]);
    if (response.statusCode == 200) {
      return netIncome;
    } else {
      throw Exception('Failed to load net income.');
    }
  }

  Future<dynamic> getOperatingIncome(String input) async {
    final response =
        await http.get(Uri.parse('$BASE_URL/operating_income/$input'));
    final operatingIncome =
        formatCurrency(jsonDecode(response.body)["operatingIncome"]);
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
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: news,
                    style: const TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrl(Uri.parse("https://www.google.com/"));
                      },
                  ),
                ],
              ),
            ),
            Text(financials),
            Text(netIncome),
            Text(operatingIncome),
          ],
        ),
      ),
    );
  }
}
