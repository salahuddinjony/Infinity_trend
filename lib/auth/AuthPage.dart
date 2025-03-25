import 'package:flutter/material.dart';
import 'package:login_page/auth/login_page.dart';
import 'package:login_page/auth/register_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  // Initially, show the login page
  bool showLoginPage = true;
  // Function to toggle between Login and Register pages
  void toggleScreen() {
    setState(() {
      showLoginPage = !showLoginPage; // Toggle state
    });
  }

  @override
  Widget build(BuildContext context) {
    return showLoginPage
        ? LoginPage(showRegisterPage: toggleScreen)
        : RegisterPage(showLoginPage: toggleScreen);
  }
}