import 'package:flutter/material.dart';
import 'package:stock_market_lookup/colors.dart';
import 'package:stock_market_lookup/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';



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

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> registerUser() async {
  try {
    final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: _userEmail.text,
      password: _userPassword.text,
    );

    // User registered successfully
    print('User registered: ${userCredential.user?.uid}');

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  } catch (e) {
    // Failed to register user
    print('Failed to register user: $e');

    final snackBar = SnackBar(
      content: Text('Failed to register user. Please try again. Error: $e'),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text('Sign Up',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 30.0, color: navy)),
              const SizedBox(height: 20),
              TextField(
                controller: _userEmail,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(20.0),
                  labelText: 'Email',
                  labelStyle: TextStyle(color: navy),
                  filled: true,
                  fillColor: boxinsides,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                      borderSide: BorderSide(color: boxinsides)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                      borderSide: BorderSide(color: boxinsides)),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _userPassword,
                obscureText: true,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(20.0),
                  labelText: 'Password',
                  labelStyle: TextStyle(color: navy),
                  filled: true,
                  fillColor: boxinsides,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                      borderSide: BorderSide(color: boxinsides, width: 0)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                      borderSide: BorderSide(color: boxinsides, width: 0)),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: ElevatedButton(
                  style: const ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll<Color>(white),
                    backgroundColor: MaterialStatePropertyAll<Color>(periwinkle),
                  ),
                  onPressed: () async {
                    if (_userEmail.text.isEmpty || _userPassword.text.isEmpty) {
                      const snackBar = SnackBar(
                        content: Text('Please fill out all fields to sign up.'),
                        duration: Duration(seconds: 3),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      if (!isValidEmail(_userEmail.text)) {
                        const snackBar = SnackBar(
                          content: Text('Invalid email format, please input a valid email'),
                          duration: Duration(seconds: 3),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        try {
                          final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                            email: _userEmail.text,
                            password: _userPassword.text,
                          );
                          print('User registered: ${userCredential.user?.uid}');
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        } catch (e) {
                          print('Failed to register user: $e');
                          const snackBar = SnackBar(
                            content: Text('Failed to register user. Please try again.'),
                            duration: Duration(seconds: 3),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      }
                    }
                  },
                  child: const Text('Sign Up',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}