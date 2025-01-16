import 'package:flutter/material.dart';
import 'package:login_app/components/MatchesScreen.dart';
import 'package:login_app/pages/feed_page.dart';

import 'Profile_page.dart';


class mainHomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<mainHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const Center(child: Text('Feed Page', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Matches Page', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Chat Page', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Profile Page', style: TextStyle(fontSize: 24))),
  ];

  void _onTabTapped(int index) {
    if (index == 3) {
      // Navigate to ProfilePage when the Profile tab is tapped
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );

    }
    else if(index == 0){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  FeedPage())
        );
    }
    else if(index == 1){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MatchesScreen())
      );
    }
    else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xeno_Sync'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.rss_feed),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Matches',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}


