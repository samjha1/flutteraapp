import 'package:flutter/material.dart';
import 'login_page.dart'; // Import the login page

void main() {
  runApp(const MyApp()); // Start the app with MyApp
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // Optional, removes the debug banner
      title: 'Login App', // Title of the app
      home: LoginPage(), // Set LoginPage as the home page
    );
  }
}
