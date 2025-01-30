import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_app/Chatfeature/ChatListPage.dart';
import 'package:login_app/Chatfeature/ChatScreen.dart';
import 'package:login_app/components/MatchesScreen.dart';
import 'package:login_app/components/agreement/agreement_list_page.dart';
import 'package:login_app/pages/feed_page.dart';
import 'Profile_page.dart';

class MainHomePage extends StatefulWidget {
  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    FeedPage(), // Replace placeholder with FeedPage component
    MatchesScreen(), // Replace placeholder with MatchesScreen component
    ChatListPage(currentUserId: FirebaseAuth.instance.currentUser!.uid),
    //const Center(child: Text('Chat Page', style: TextStyle(fontSize: 24))),
    AgreementListPage(currentUserId: FirebaseAuth.instance.currentUser!.uid),
    ProfilePage(), // Replace placeholder with ProfilePage component
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
        title: const Text('Xeno_Sync'),
        //backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: _pages[_currentIndex], // Display the selected page from the list
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
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:provider/provider.dart';
//
// import 'UserState.dart';
//
// class MainHomePage extends StatefulWidget {
//   final String userId;
//
//   const MainHomePage({Key? key, required this.userId}) : super(key: key);
//
//   @override
//   _MainHomePageState createState() => _MainHomePageState();
// }
//
// class _MainHomePageState extends State<MainHomePage> {
//   Map<String, dynamic>? userData; // To store fetched user data
//   bool isLoading = true; // To track loading state
//
//   @override
//   void initState() {
//     super.initState();
//     fetchUserData(); // Fetch user data on page load
//   }
//
//   Future<void> fetchUserData() async {
//     try {
//       String userId = Provider.of<UserState>(context, listen: false).userId;
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .get();
//
//       if (userDoc.exists) {
//         setState(() {
//           print(userDoc.data());
//           userData = userDoc.data() as Map<String, dynamic>;
//          // Provider.of<UserState>(context, listen: false).setUserData();
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//         print("User not found.");
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       print("Error fetching user data: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("User Data")),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : userData != null
//           ? SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Username: ${userData!['username'] ?? 'N/A'}",
//                 style: TextStyle(fontSize: 18),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 "Email: ${userData!['email'] ?? 'N/A'}",
//                 style: TextStyle(fontSize: 18),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 "Role: ${userData!['role'] ?? 'N/A'}",
//                 style: TextStyle(fontSize: 18),
//               ),
//             ],
//           ),
//         ),
//       )
//           : Center(
//         child: Text(
//           "No user data found.",
//           style: TextStyle(fontSize: 18),
//         ),
//       ),
//     );
//   }
// }


