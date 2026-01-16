import 'package:flutter/material.dart';
import 'package:midterm/screens/flash_screen.dart';
import 'package:midterm/screens/home_screen.dart';
import 'package:midterm/screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FlashScreen(),
      theme: ThemeData(
        useMaterial3: false,
        appBarTheme: AppBarThemeData(
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: IconThemeData(color: Colors.black),
          actionsIconTheme: IconThemeData(color: Colors.black),
          shape: LinearBorder.bottom(
            side: BorderSide(
              width: 0.65,
              color: Colors.black.withValues(alpha: 0.1),
            ),
          ),
        ),
      ),
    );
  }
}
