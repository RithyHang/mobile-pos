import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:midterm/repositories/auth_repository.dart';
import 'package:midterm/screens/home_screen.dart';
import 'package:midterm/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FlashScreen extends StatefulWidget {
  const FlashScreen({super.key});

  @override
  State<FlashScreen> createState() => _FlashScreenState();
}

class _FlashScreenState extends State<FlashScreen> {
  @override
  void initState() {
    super.initState(); // ✅ Call this first
    _init();           // ✅ Then run your logic
  }

  Future<void> _init() async {
    await Future.delayed(const Duration(seconds: 2));
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('pos.token');


    AuthRepository.token = token;

    final nextScreen = token != null ? const HomeScreen() : const LoginScreen();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => nextScreen),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Rithymation',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const CupertinoActivityIndicator(radius: 14),
            ],
          ),
        ),
      ),
    );
  }
}