import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:stock_market_lookup/colors.dart';

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
  bool isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchData(String input) async {
    try {
      setState(() {
        isLoading = true;
      });

      final grossProfitResponse = await getGrossProfit(input);
      final newsResponse = await getNews(input);
      final financialsResponse = await getFinancials(input);
      final netIncomeResponse = await getNetIncome(input);
      final operatingIncomeResponse = await getOperatingIncome(input);

      setState(() {
        grossProfit = '$grossProfitResponse';
        financials = '$financialsResponse';
        netIncome = '$netIncomeResponse';
        operatingIncome = '$operatingIncomeResponse';
        news = '$newsResponse';
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Search for a stock below!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0, color: navy),
            ),
            const Text('(ie. \'AAPL\')', style: TextStyle(fontSize: 14.0, color: navy)),
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
                backgroundColor: MaterialStateProperty.all<Color>(teal),
              ),
              onPressed: () {
                fetchData(_searchController.text);
              },
              child: const Text('Search', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0)),
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
                      _buildInfo("Financials", financials),
                      _buildInfo("Net Income", netIncome),
                      _buildInfo("Operating Income", operatingIncome),
                      _buildNews("News", news),
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
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: navy),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: navy),
          ),
        ),
      ],
    );
  }

  Widget _buildNews(String header, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$header: ",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: navy),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: navy),
        ),
      ],
    );
  }

}
