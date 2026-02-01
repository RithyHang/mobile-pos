import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:midterm/api/domain/domain.dart';
import 'package:midterm/api/end_point/api_end_point.dart';
import 'package:midterm/helper/popup_dialog.dart';
import 'package:midterm/repositories/auth_repository.dart';
import 'package:midterm/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isShowPassword = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void togglePassword() {
    isShowPassword = !isShowPassword;
    setState(() {});
  }

  // LOGIN Function
  Future<void> login() async {
  // ---------- BASIC VALIDATION ----------
  if (_emailController.text.isEmpty ||
      _passwordController.text.isEmpty) {
    PopupDialog.showError(
      context,
      title: 'Missing Information',
      description: 'Please enter username and password',
    );
    return;
  }

  PopupDialog.showLoading(context);

  try {
    final response = await http.post(
      Uri.parse(ApiDomain.domain + ApiEndPoint.login),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": _emailController.text.trim(),
        "password": _passwordController.text,
      }),
    );

    PopupDialog.dismissLoading(context);

    // ---------- SUCCESS ----------
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);

      final prefs = await SharedPreferences.getInstance();

      // FakestoreAPI returns ONLY token
      prefs.setString('pos.token', data['token']);
      prefs.setString('pos.username', _emailController.text);

      AuthRepository.token = data['token'];
      AuthRepository.username = _emailController.text;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
      return;
    }

    // ---------- WRONG CREDENTIALS ----------
    if (response.statusCode == 401) {
      PopupDialog.showError(
        context,
        title: 'Login Failed',
        description: 'Invalid username or password',
      );
      return;
    }

    // ---------- OTHER SERVER ERRORS ----------
    PopupDialog.showError(
      context,
      title: 'Server Error',
      description: 'Something went wrong. Please try again.',
    );
  } catch (e) {
    PopupDialog.dismissLoading(context);

    // ---------- NETWORK / PARSE ERROR ----------
    PopupDialog.showError(
      context,
      title: 'Connection Error',
      description: 'Unable to connect to server',
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // HELLO ANIMATION
                // Lottie.asset(
                //   'assets/lotties/hello_animation.json',
                //   height: 300,
                // ),
                SizedBox(height: 135),

                // ------------ HELLO AGAIN ------------
                Text(
                  "Rithymation",
                  style: TextStyle(fontSize: 48, color: Color(0xFFDE302F)),
                ),
                SizedBox(height: 13,),
                Text(
                  "Welcome back, you've been missed!",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 120),

                // ------------ EMAIL TEXT FIELD ------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextFormField(
                        controller: _emailController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }

                          // Regular Expression for email validation
                          final emailRegExp = RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          );

                          if (!emailRegExp.hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email',
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // ------------ PASSWORD TEXT FIELD ------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextFormField(
                        controller: _passwordController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          return null;
                        },
                        obscureText: isShowPassword,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password',
                          suffixIcon: IconButton(
                            onPressed: togglePassword,
                            icon: Icon(
                              isShowPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 60),

                // ------------ SIGN IN BUTTON ------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SizedBox(
                    width: double.infinity, // full width
                    height: 56, // button height
                    child: TextButton(
                      onPressed: login,
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xFFDE302F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 80),

                // ------------ NOT A MEMBER? REGISTER NOW ------------
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '-------',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'or sign in with',
                          style: TextStyle(fontWeight: FontWeight.w100,),
                        ),
                        SizedBox(width: 4),
                        Text(
                          '-------',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 60,
                          child: Image.asset('assets/icons/google.png'),
                        ),
                        SizedBox(width: 45),
                        Container(
                          height: 60,
                          child: Image.asset('assets/icons/apple-logo.png'),
                        )
                      ],
                    ),
                    SizedBox(height: 25,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?"),
                        Text(" Signup", style: TextStyle(color: Color(0xFFDE302F)),)
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
