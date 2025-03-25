import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_page/auth/home_page.dart';
import 'package:login_page/data/notifiers.dart';
import 'package:login_page/pages/news/news_page.dart';
import 'package:login_page/pages/profile_page.dart';
import 'package:login_page/pages/weather/weather_page.dart';
import '../pages/bazar pages/card_page.dart';
import '../pages/notepad/note_list_screen.dart';
import 'navbar_widget.dart';

List<Widget> pages = [HomePage(), WeatherPage(), NewsPage(), NotesListScreen(), CardPage()];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current user from FirebaseAuth
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("INFINITY TRENDS"),

        actions: [
          // Profile Picture in AppBar
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                // Navigate to Profile Page when clicking on the profile picture
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: CircleAvatar(
                  radius:15,
                  backgroundImage: user?.photoURL != null && user!.photoURL!.isNotEmpty
                      ? NetworkImage(user.photoURL!)
                      : const AssetImage('assets/images/salah.jpeg') as ImageProvider,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: selectedPageNotifier,
        builder: (context, selectedPage, child) {
          return pages.elementAt(selectedPage);
        },
      ),
      bottomNavigationBar: NavbarWidget(),
    );
  }
}