import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:stock_market_lookup/colors.dart';
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
  List<Widget> newsList = [];
  String debt = '';
  String netIncome = '';
  String operatingIncome = '';
  String BASE_URL =
      'https://stock-lookup-backend-87992ddeef5c.herokuapp.com/api';
  bool isLoading = false;
  bool showError = true;

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
      setState(() {
        isLoading = true;
        showError = false;
      });

      final grossProfitResponse = await getGrossProfit(input);
      final newsResponse = await getNews(input);
      final debtResponse = await getFinancials(input);
      final netIncomeResponse = await getNetIncome(input);
      final operatingIncomeResponse = await getOperatingIncome(input);

      if (newsResponse.isNotEmpty) {
        setState(() {
          grossProfit = '$grossProfitResponse';
          debt = '$debtResponse';
          netIncome = '$netIncomeResponse';
          operatingIncome = '$operatingIncomeResponse';
          newsList = newsResponse;
          isLoading = false;
        });
      } else {
        throw Exception('Invalid Input');
      }
    } catch (e) {
      _showErrorMessage();
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
        showError = true;
      });
    }
  }

  void _showErrorMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Invalid Input',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: navy,
            ),
          ),
          content: const Text(
            'Please enter a valid stock ticker.',
            style: TextStyle(
              fontSize: 16,
              color: navy,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: periwinkle,
                ),
              ),
            ),
          ],
        );
      },
    );
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

  Future<List<Widget>> getNews(String input) async {
    final response = await http.get(Uri.parse('$BASE_URL/news/$input'));
    if (response.statusCode == 200) {
      final news = jsonDecode(response.body);
      List<Widget> newsWidgets = [];
      for (var newsItem in news) {
        String text = newsItem[0];
        String url = newsItem[1];

        newsWidgets.add(
          InkWell(
            onTap: () => launchUrl(Uri.parse(url)),
            child: Text(
              text,
              style: const TextStyle(color: Colors.blue),
            ),
          ),
        );
      }
      return newsWidgets;
    } else {
      throw Exception('Failed to load news.');
    }
  }

  Future<dynamic> getFinancials(String input) async {
    final response = await http.get(Uri.parse('$BASE_URL/financials/$input'));
    final financials =
        formatCurrency(jsonDecode(response.body)['netIncome']["debt"]);
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Search for a stock below!',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 30.0, color: navy),
            ),
            const Text('(ex. \'AAPL\')',
                style: TextStyle(fontSize: 14.0, color: navy)),
            const SizedBox(height: 40),
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(20.0),
                labelText: 'Search',
                labelStyle: TextStyle(color: navy),
                filled: true,
                fillColor: boxinsides,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  borderSide: BorderSide(color: boxinsides),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  borderSide: BorderSide(color: boxinsides),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(white),
                backgroundColor: MaterialStateProperty.all<Color>(periwinkle),
              ),
              onPressed: () {
                fetchData(_searchController.text);
              },
              child: const Text('Search',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0)),
            ),
            const SizedBox(height: 40),
            isLoading
                ? const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Column(
                    children: [
                      _buildInfo("Gross Profit", grossProfit),
                      _buildInfo("Debt", debt),
                      _buildInfo("Net Income", netIncome),
                      _buildInfo("Operating Income", operatingIncome),
                      _buildNews("News", newsList),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(String header, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          "$header: ",
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: navy),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.normal, color: navy),
          ),
        ),
      ],
    );
  }

  Widget _buildNews(String header, List<Widget> news) {
    List<Widget> childrenList = [
      Text(
        "$header: ",
        style: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: navy),
      )
    ];
    for (Widget newsItem in news) {
      childrenList.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('• ', style: TextStyle(fontSize: 30)), // Bullet point
            Expanded(child: newsItem), // News item
          ],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: childrenList,
    );
  }
}
