import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_app/Chatfeature/ChatListPage.dart';
import 'package:login_app/components/MatchesScreen.dart';
import 'package:login_app/components/agreement/agreement_list_page.dart';
import 'package:login_app/filters/FiltersPage.dart';
import 'Profile_page.dart';
import 'boost feature/feed_page.dart';

class MainHomePage extends StatefulWidget {
  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  int _currentIndex = 0;

  final User? user = FirebaseAuth.instance.currentUser;
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  late final List<Widget> _pages = [
    FeedPage(),
    MatchesScreen(),
    ChatListPage(currentUserId: userId ?? ''),
    AgreementListPage(currentUserId: userId ?? ''),
    ProfilePage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Shot OK',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w700,
            fontSize: 28,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.black),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          FiltersPage())); // Navigate to FiltersPage
            },
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF081B48),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
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
            icon: Icon(Icons.assignment),
            label: 'Agreement',
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

// import 'package:flutter/material.dart';
// import 'package:login_app/Chatfeature/ChatListPage.dart';
// import 'package:login_app/components/MatchesScreen.dart';
// import 'package:login_app/components/agreement/agreement_list_page.dart';
// import 'package:login_app/filters/FiltersPage.dart';
// import 'Profile_page.dart';
// import 'boost feature/feed_page.dart';
//
// class MainHomePage extends StatefulWidget {
//   @override
//   _MainHomePageState createState() => _MainHomePageState();
// }
//
// class _MainHomePageState extends State<MainHomePage> {
//   int _currentIndex = 0;
//   late FeedPage _feedPage; // ✅ Declare FeedPage instance
//
//   @override
//   void initState() {
//     super.initState();
//     _feedPage = FeedPage(); // ✅ Initialize FeedPage once
//   }
//
//
//   void _applyFiltersToFeed(Map<String, dynamic> filters) {
//     _feedPage.applyFilters(filters); // ✅ Call applyFilters on the FeedPage instance
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Xeno_Sync'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.filter_list),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => FiltersPage(
//                     onFiltersApplied: _applyFiltersToFeed, // ✅ Pass callback function
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: _currentIndex == 0 ? _feedPage : _getPage(_currentIndex),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (index) => setState(() => _currentIndex = index),
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.rss_feed), label: 'Feed'),
//           BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Matches'),
//           BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
//           BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Agreement'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//         ],
//       ),
//     );
//   }
//
//   Widget _getPage(int index) {
//     switch (index) {
//       case 1:
//         return MatchesScreen();
//       case 2:
//         return ChatListPage(currentUserId: "someUserId");
//       case 3:
//         return AgreementListPage(currentUserId: "someUserId");
//       case 4:
//         return ProfilePage();
//       default:
//         return _feedPage;
//     }
//   }
// }
