import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:stock_market_lookup/colors.dart';
import 'package:stock_market_lookup/login_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stock Market Lookup',
      theme: ThemeData(
          primarySwatch: periwinkle,
          textSelectionTheme: const TextSelectionThemeData(cursorColor: navy),
          fontFamily: "PT Serif",
          scaffoldBackgroundColor: background,
          appBarTheme: const AppBarTheme(
              backgroundColor: periwinkle,
              centerTitle: true,
              titleTextStyle: TextStyle(
                  fontFamily: "PT Serif",
                  fontSize: 48.0,
                  color: white,
                  fontWeight: FontWeight.bold))),
      home: const LoginPage(),
    );
  }
}
