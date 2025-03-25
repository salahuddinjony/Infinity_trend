import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _forgotPasswordController = TextEditingController();
  bool _isLoading = false;

  Future<void> forgotPass() async {
    if (_isLoading) return;

    String email = _forgotPasswordController.text.trim();
    if (email.isEmpty) {
      showSnackBar("Please enter your email.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showSnackBar("Password reset link sent to your email.");

      Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(e.message ?? "An error occurred.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _forgotPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Text("Forgot Password"),
      //   centerTitle: true,
      //   backgroundColor: Colors.deepPurple,
      //   elevation: 0,
      //   iconTheme: IconThemeData(color: Colors.white),
      //   titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      // ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Container(
            padding: EdgeInsets.all(20),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock_reset, size: 120, color: Colors.deepPurple),
                SizedBox(height: 10),
                Text(
                  "Forgot Password?",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Enter your email to reset your password.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                SizedBox(height: 50),
                TextField(
                  controller: _forgotPasswordController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email, color: Colors.deepPurple),
                    hintText: "Email",
                    // labelText: "Enter Email",
                    filled: true,
                    fillColor: Colors.grey[100],
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.deepPurple, width: 2),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : forgotPass,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : Text(
                      "Send Reset Link",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Back to Login",
                    style: TextStyle(color: Colors.deepPurple, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}