import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_page/pages/bazar%20pages/card_page.dart';
import 'package:login_page/pages/news/news_page.dart';
import 'package:login_page/pages/notepad/note_list_screen.dart';
import 'package:login_page/pages/weather/weather_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  String userName = "User"; // Default name if data isn't fetched

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    if (user != null) {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection("users")
            .where("email", isEqualTo: user!.email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          var userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
          setState(() {
            userName = "${userData['first name']} ${userData['last name']}";
          });
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40), // Space above the welcome text

            // Centered Welcome Text Above the Image
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Text(
                      "Welcome Back, $userName",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,

                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Start exploring the app and manage your tasks, check the weather, news, and more.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,

                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Banner Section with Centered Image
            Center(
              child: Container(
                height: 240,
                width: 240,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/banner.png"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Cards Section for Quick Links
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisSpacing: 30,
                crossAxisSpacing: 20,
                childAspectRatio: 2.5,
                children: [
                  _buildQuickLinkCard(
                    icon: Icons.cloud,
                    label: "Weather",
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return WeatherPage();
                      }));
                    },
                  ),
                  _buildQuickLinkCard(
                    icon: Icons.article,
                    label: "News",
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return NewsPage();
                      }));
                    },
                  ),

                  _buildQuickLinkCard(
                    icon: Icons.note,
                    label: "Notepad",
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return NotesListScreen();
                      }));
                    },
                  ),
                  _buildQuickLinkCard(
                    icon: Icons.shopping_cart,
                    label: "Bazar",
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return CardPage();
                      }));
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Quick link card widget
  Widget _buildQuickLinkCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Color(0xFF007BFF), // Blue background
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}