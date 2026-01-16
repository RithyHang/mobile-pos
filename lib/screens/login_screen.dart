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
  void login() async {
    print('${_emailController.text}, ${_passwordController.text}');
    PopupDialog.showLoading(context);

    // Send a POST request to the API
    final response = await http.post(
      Uri.parse(ApiDomain.domain + ApiEndPoint.login),
      body: jsonEncode({
        "username": _emailController.text,
        "password": _passwordController.text,
      }),
      headers: {"Content-Type": "application/json"},
    );

    // Close the loading dialog
    PopupDialog.dismissLoading(context);

    final data = json.decode(response.body);
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Handle the response
    if (response.statusCode == 201 || response.statusCode == 200) {
      prefs.setString('pos.token', data['token']);
      AuthRepository.token = data['token'];

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false,
      );
    } else {
      PopupDialog.showError(
        context,
        title: 'Login Error',
        description: data['message'] ?? 'Login Failed',
      );
    }
    print(response);
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
                Lottie.asset(
                  'assets/lotties/hello_animation.json',
                  height: 300,
                ),

                // ------------ HELLO AGAIN ------------
                Text(
                  "Welcome back, you've been missed!",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 50),

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
                SizedBox(height: 10),

                // ------------ SIGN IN BUTTON ------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SizedBox(
                    width: double.infinity, // full width
                    height: 56, // button height
                    child: TextButton(
                      onPressed: login,
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
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

                SizedBox(height: 10),

                // ------------ NOT A MEMBER? REGISTER NOW ------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Register Now',
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
