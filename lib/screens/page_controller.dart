import 'package:flutter/material.dart';
import 'package:midterm/screens/cart_screen.dart';
import 'package:midterm/screens/home_screen.dart';
import 'package:midterm/screens/profile_screen.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
    // ========== Bottm Nav Function ========
  int _selectedIndex = 0;
  void _navigateBottomBar(int index){
    setState(() {
      _selectedIndex = index;
    });
  }
  final List<Widget> _pages = [
    HomeScreen(),
    CartScreen(),
    ProfileScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        // backgroundColor: Color(0xFFDE302F),
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Acount'),
        ],
      ),
    );
  }
}