import 'package:flutter/material.dart';
import 'package:login_page/data/notifiers.dart';


class NavbarWidget extends StatelessWidget {
  const NavbarWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, child) {
        return NavigationBar(
          destinations: [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.wb_sunny), label: 'Weather'),
            NavigationDestination(icon: Icon(Icons.newspaper), label: 'News'),
            NavigationDestination(icon: Icon(Icons.note), label: 'Notepad'),
            NavigationDestination(icon: Icon(Icons.shopping_basket), label: 'Bazar'),
          ],
          onDestinationSelected: (int value) {
            selectedPageNotifier.value=value;  
            
          },
          selectedIndex: selectedPage,
        );
      },
    );
  }
}
