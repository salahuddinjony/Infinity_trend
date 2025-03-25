import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_page/data/notifiers.dart';
import 'package:login_page/auth/forgot_password_page.dart';
import 'package:login_page/auth/login_page.dart'; // Import your login page

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (user != null) {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection("users")
            .where("email", isEqualTo: user!.email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          setState(() {
            userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
          });
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    isDarkModeNotifier.value = false;
    selectedPageNotifier.value = 0; // Reset selected page to HomePage

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text("Profile"),

      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Dark Mode Toggle Above Profile Picture
              ValueListenableBuilder(
                valueListenable: isDarkModeNotifier,
                builder: (context, isDarkMode, child) {
                  return Column(
                    children: [
                      Text(
                        isDarkMode ? "Go to Light Mode" : "Go to Dark Mode",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode,
                              color: Colors.deepPurple, size: 30),
                          Switch(
                            value: isDarkMode,
                            onChanged: (bool value) {
                              isDarkModeNotifier.value = value;
                            },
                            activeColor: Colors.deepPurple,
                          ),
                        ],
                      ),
                      const SizedBox(height: 60),
                    ],
                  );
                },
              ),

              // Profile Picture
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.deepPurple[400]!,
                    width: 3,
                  ),
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: user?.photoURL != null && user!.photoURL!.isNotEmpty
                      ? NetworkImage(user!.photoURL!)
                      : const AssetImage('assets/images/salah.jpeg') as ImageProvider,
                ),
              ),
              const SizedBox(height: 20),
              // Display Name
              Text(
                userData != null
                    ? "${userData!['first name']} ${userData!['last name']}"
                    : "No Name",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 10),
              // User Email
              Text(
                "Email: ${user?.email ?? "No User Signed In"}",
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              // User Age
              Text(
                userData != null ? "Age: ${userData!['age']}" : "Age: N/A",
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              // Sign Out Button
              SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  onPressed: _signOut,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Sign Out", style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(height: 15),
              // Change Password Button
              SizedBox(
                width: 300,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.deepPurple,
                    side: const BorderSide(color: Colors.deepPurple),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Change Password", style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}