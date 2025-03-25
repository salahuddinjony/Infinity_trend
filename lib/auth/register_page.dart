import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback? showLoginPage;
  const RegisterPage({Key? key, required this.showLoginPage}) : super(key: key);

  @override
  State<RegisterPage> createState() => _registerPageState();
}

class _registerPageState extends State<RegisterPage> {
  bool _obscureText = true;
  bool _isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController=TextEditingController();
  final _lastNameController=TextEditingController();
  final _ageController=TextEditingController();

  //clean up resources when a widget is removed from the widget tree permanently.
  @override
  void dispose() {
    _emailController.dispose();
    _confirmPasswordController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> signUp() async {
    if (_isLoading) return; // Avoid multiple submissions

    // Input validation
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty ||
        _confirmPasswordController.text.trim().isEmpty ||
        _firstNameController.text.trim().isEmpty ||
        _lastNameController.text.trim().isEmpty ||
        _ageController.text.trim().isEmpty) {
      showSnackBar("Please fill in all fields.");
      return;
    }

    if (!_isValidEmail(_emailController.text.trim())) {
      showSnackBar("Please enter a valid email.");
      return;
    }

    if (!_passwordsMatch()) {
      showSnackBar("Passwords do not match.");
      return;
    }

    int? age = int.tryParse(_ageController.text.trim());
    if (age == null || age <= 0) {
      showSnackBar("Please enter a valid age.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await addUserdetails(
        _firstNameController.text.trim(),
        _lastNameController.text.trim(),
        _emailController.text.trim(),
        age,
      );

      // Create user in Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      showSnackBar("Singup Successfully!");

    } on FirebaseAuthException catch (e) {
      showSnackBar(e.message ?? "An error occurred.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  Future<void> addUserdetails(String firstName, String lastName, String email, int age) async {
    try {
      await FirebaseFirestore.instance.collection("users").add({
        'first name': firstName,
        'last name': lastName,
        'email': email,
        'age': age,
        'createdAt': FieldValue.serverTimestamp(), // Add timestamp for sorting
      });
      print("User details added to Firestore successfully!");
    } catch (e) {
      print("Error adding user details: $e");
    }
  }
  bool _isValidEmail(String email) {
    RegExp regex = RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    return regex.hasMatch(email);
  }

  bool _passwordsMatch() {
    return _passwordController.text.trim() == _confirmPasswordController.text.trim();
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(milliseconds: 2000),
      ),
    );

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
                  "assets/images/singUp.png",
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 10.0),
                Text(
                  "Hello There",
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  "Register below with your details",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 40.0),

                //First name
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: _firstNameController,
                    keyboardType: TextInputType.name, // Keyboard optimized for names
                    textCapitalization: TextCapitalization.words, // Capitalize first letter
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person, color: Colors.black),
                      hintText: "First Name",
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

                // Last Name
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: _lastNameController,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person, color: Colors.black),
                      hintText: "Last Name",
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

            // Age
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: _ageController,
                    keyboardType: TextInputType.number, // Numeric input
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.cake, color: Colors.black),
                      hintText: "Age",
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

                // Email Input Field with Focused Outline
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

                // Password Input Field with Focused Outline
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
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
                SizedBox(height: 20),

                // Confirm Password Input Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      hintText: "Confirm Password",
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
                SizedBox(height: 20),

                // Sign Up Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: _isLoading ? null : signUp, // Disable button while loading
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Color(0xFF417E78),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                          "Sign Up",
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

                // I am a Member Text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "I am a Member!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.showLoginPage!();
                      },
                      child: Text(
                        " Login",
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