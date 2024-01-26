import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stock_market_lookup/colors.dart';
import 'package:stock_market_lookup/home_page.dart';
import 'package:stock_market_lookup/sign_up.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  Future<void> _signIn() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      // Navigate to home page or next screen on successful login
    } catch (e) {
      print('Error: $e');
      // Handle login failure (show a message, etc.)
    }
  }
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('S.A.M.E'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Align(
          alignment: Alignment.center,
          child:  Column(
            children: <Widget>[
              const SizedBox(height: 20), 
              const Text('Welcome!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0)),
              const Text('Login with your credentials below.', style: TextStyle(fontSize: 14.0)),
              const SizedBox(height: 40),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(20.0),
                  labelText: 'Username',
                  labelStyle: TextStyle(color: navy),
                  filled: true,
                  fillColor: boxinsides,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    borderSide: BorderSide(color: boxinsides)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    borderSide: BorderSide(color: boxinsides)
                  )
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(20.0),
                  labelText: 'Password',
                  labelStyle: TextStyle(color: navy),
                  filled: true,
                  fillColor: boxinsides,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    borderSide: BorderSide(color: boxinsides, width: 0)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    borderSide: BorderSide(color: boxinsides, width: 0)
                  ),
                ),
              ),
              const SizedBox(height: 40),
              RichText(text: TextSpan(
                style: const TextStyle(fontFamily: "PT Serif"),
                children: <TextSpan>[
                  const TextSpan(
                    text: "Don't have an account?  ",
                    style: TextStyle(color: Colors.black)
                  ),
                  TextSpan(
                    text: "Register here",
                    style: const TextStyle(color: blue, decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        print("Go to register page"); // insert navigation to register page
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpPage(),
                        ),
                      );
                      } 
                  ),
                ],
              )),
              const SizedBox(height: 40),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: ElevatedButton(
                  style:  const ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll<Color>(white),
                    backgroundColor: MaterialStatePropertyAll<Color>(teal),
                  ),
                  onPressed: () {
                    // check to make sure username & password are NOT empty
                    if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                      // if the username & password is incorrect, show an error
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Username or password is incorrect.')),
                      );
                    } else {
                      // if one of the fields is empty, show an alert to fill in all fields
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill in all fields.')),
                      );
                    }
                  },
                  child: const Text('Sign In', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0))
                )
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}