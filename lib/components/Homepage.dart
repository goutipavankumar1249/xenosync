import 'package:flutter/material.dart';
import '../pages/chatify_navigation.dart';

class mainHomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<mainHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const Center(child: Text('Feed Page')),
    const Center(child: Text('Matches Page')),
    const Center(child: Text('Chat Page')),
    const Center(child: Text('Profile Page')),
  ];

  void _onTabTapped(int index) {
    if (index == 3) { // Assuming Chatify flow is triggered by index 3
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatifyNavigation(), // Navigate to Chatify flow
        ),
      );
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
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
