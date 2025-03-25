import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_page/auth/AuthPage.dart';
import 'package:login_page/widgets/widget_tree.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Show loading while checking auth state
          } else if (snapshot.hasData) {
            return const WidgetTree();
          } else {
            return const AuthPage();
          }
        },
      ),
    );
  }
}

