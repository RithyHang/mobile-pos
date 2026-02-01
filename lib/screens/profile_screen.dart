import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:midterm/api/domain/domain.dart';
import 'package:midterm/api/end_point/api_end_point.dart';
import 'package:midterm/screens/flash_screen.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      // 1. Get the saved username from local storage
      final prefs = await SharedPreferences.getInstance();
      final savedUsername = prefs.getString('pos.username') ?? "";

      // 2. Fetch all users from FakeStore API
      final response = await http.get(Uri.parse(ApiDomain.domain + ApiEndPoint.users));

      if (response.statusCode == 200) {
        List allUsers = json.decode(response.body);

        // 3. Filter the list to find the one matching your saved username
        // We use .firstWhere to find the specific 'derek' or whatever name is saved
        final user = allUsers.firstWhere(
          (u) => u['username'] == savedUsername,
          orElse: () => null,
        );

        setState(() {
          userData = user;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error: ${e.toString()}";
        isLoading = false;
      });
    }
  }

  _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(15),
          ),
          title: Text("Logout"),
          content: Text("Are you sure you want to log out?"),
          actions: [
            // The "No" button
            TextButton(
              onPressed: () => Navigator.pop(context), // closes the dialog
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // "Yes" button
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                logOut();
              },
              child: Text("Logout", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void logOut() async {
    await Future.delayed(Duration(seconds: 2));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('pos.token');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => FlashScreen()),
      (route) => false,
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userData == null
              ? Center(child: Text(errorMessage.isEmpty ? "User not found" : errorMessage))
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Color(0xFFDE302F),
                          child: Icon(Icons.person, size: 50, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 30),
                      
                      // Display Name
                      ListTile(
                        leading: const Icon(Icons.person_outline),
                        title: const Text("Full Name"),
                        subtitle: Text(
                          "${userData!['name']['firstname']} ${userData!['name']['lastname']}".toUpperCase(),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),

                      //  Display Email
                      ListTile(
                        leading: const Icon(Icons.email_outlined),
                        title: const Text("Email"),
                        subtitle: Text(
                          "${userData!['email']}",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),

                      const Spacer(),

                      //  Logout Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFDE302F),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            _showLogoutDialog();
                          },
                          child: const Text("Logout", style: TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}