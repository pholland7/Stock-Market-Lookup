import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stock_market_lookup/colors.dart';
import 'package:stock_market_lookup/home_page.dart';


class User {
  final String email;
  final String password;

  // Requires user to type in input for these fields
  User({required this.email, required this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      password: json['password'],
    );
  }
}

/*

class ApiService {
  Future<void> registerUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('http://localhost:3000/api/user'); 
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      // User registered successfully
      // You can handle the success scenario as needed
    } else {
      // Failed to register user
      throw Exception('Failed to register user');
    }
  }
}

*/

// creating the page to sign up
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  //final _apiService = ApiService();
  final _userEmail = TextEditingController();
  final _userPassword = TextEditingController();
  
  @override
  void dispose() {
    _userEmail.dispose();
    _userPassword.dispose();
    super.dispose();
  }

  //if returns true then the email is in valid format 
  bool isValidEmail(String email) {
    // regular expression for valid email format
    RegExp emailFormat = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    // Check if the email matches the pattern
    return emailFormat.hasMatch(email);
  }
  bool isValidUserOrPass (String username) {
    RegExp userFormat = RegExp(r'^[\w.-]+$');
    return userFormat.hasMatch(username.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('Sign Up', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0)),
            const SizedBox(height: 20),
            TextField(
              controller: _userEmail,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _userPassword,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: ElevatedButton(
                  style:  const ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll<Color>(white),
                    backgroundColor: MaterialStatePropertyAll<Color>(teal),
                  ),
              onPressed: () {
                
                if (_userEmail.text.isEmpty || _userPassword.text.isEmpty) {
                    // Show a warning snackbar to the user
                    final snackBar = SnackBar(
                      content: Text('Please fill out all fields to sign up.'),
                      duration: Duration(seconds: 3),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  if (!isValidEmail(_userEmail.text)) {
                    final snackBar = SnackBar(
                      content: Text('Invalid email format, please input a valid email'),
                      duration: Duration(seconds: 3),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } 
                  if (!isValidUserOrPass(_userPassword.text)) {
                    final snackBar = SnackBar(
                      content: Text('Invalid password, please input a valid password with no spaces'),
                      duration: Duration(seconds: 3),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  final email = _userEmail.text;
                  final password = _userPassword.text;
                  // Create a User instance with its info
                  final user = User(email: email, password: password);
                  Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                }
              },
              child: const Text('Sign Up', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
            ),
            ),
          ],
        ),
      ),
    );
  }

  void registerUser() async{

  }
}
