import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'forgot_password_page.dart';


class LoginPage extends StatefulWidget {
  final VoidCallback? showRegisterPage;
  const LoginPage({Key? key,required this.showRegisterPage}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  bool _isLoading = false; // To handle loading state during sign-in

  final  _emailController = TextEditingController();
  final  _passwordController = TextEditingController();

  int failedAttempts = 0;

  Future<void> signIn() async {
    if (failedAttempts >= 3) {
      showSnackBar("Too many attempts. Try again later.");
      return;
    }

    // Basic validation for email and password
    if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
      showSnackBar("Please enter both email and password");
      return;
    }

    setState(() {
      _isLoading = true; // Set loading state to true
    });

    try {
     await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

  
      failedAttempts = 0; // Reset on success
    } on FirebaseAuthException catch (e) {
      failedAttempts++;

      if (e.code == "quota-exceeded") {
        showSnackBar("Quota exceeded. Try again later.");
        return;
      }
      showSnackBar("Error: ${e.message}");

    
    } finally {
      setState(() {
        _isLoading = false; // Set loading state to false after the sign-in attempt
      });
    }
  }
  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(milliseconds: 1000), 
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 223, 220, 220),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/login.png",
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 40.0),
                Text(
                  "Hello Again!",
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  "Welcome back, you are welcome!",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 60.0),

                /// Email Input Field with Focused Outline
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email, color: Colors.black),
                      hintText: "Email",
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.deepPurple, width: 2),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),

                /// Password Input Field with Focused Outline
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      // prefixIcon: Icon(Icons.password, color: Colors.black),
                      hintText: "Password",
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.deepPurple, width: 2),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 26),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap:(){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return ForgotPasswordPage();
                              },
                          ),
                          );
                         },
                        child: Text(
                          "Forgor Password?",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                /// Sign In Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: _isLoading ? null : signIn, // Disable button while loading
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                                "Sign In",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 30),

                /// Register Now Text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a Member?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.showRegisterPage!();
                      },
                      child: Text(
                        " Register Now",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
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