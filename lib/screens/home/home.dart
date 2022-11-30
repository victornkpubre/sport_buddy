/*
 * Content: Username, Buddies and Chats
 * Bottom Navigator:  Profile, Buddies, Discover and Settings
 */

import 'package:flutter/material.dart';
import 'package:sport_buddy/models/models.dart';
import 'package:sport_buddy/screens/home/tabs/buddies.dart';
import 'package:sport_buddy/screens/home/tabs/discover.dart';
import 'package:sport_buddy/screens/home/tabs/profile.dart';
import 'package:sport_buddy/screens/home/tabs/settings.dart';

class HomePage extends StatefulWidget {

  HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  PageController? pageController = PageController(initialPage: 0);
  int _selectedIndex = 0;
  List pages = [
    ProfilePage(),
    DiscoverPage(),
    BuddiesPage(),
    SettingsPage()
  ];

  void _onTapNav(index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Uber Clone - Drivers"),
      ),
      body: pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        onTap: _onTapNav,
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.black54,
        selectedItemColor: Colors.blue,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile"
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Discover"
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: "Buddies"
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings"
          ),

        ],
      ),
    );

    
  }


  

}

