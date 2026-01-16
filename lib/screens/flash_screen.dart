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
    _init();
    super.initState();
  }

  // Functions
  _init() async{
    await Future.delayed(Duration(seconds: 2));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('pos.token');
    AuthRepository.token = token;

    if(token != null){
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false);
    }else{
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FlutterLogo(
              size: 86,
            ),
            SizedBox(
              height: 20,
            ),
            CupertinoActivityIndicator(),
          ],
        ),
      )
    );
  }
}
