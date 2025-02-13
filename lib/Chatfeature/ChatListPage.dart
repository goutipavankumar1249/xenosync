// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import 'ChatScreen.dart';
//
// class ChatListPage extends StatefulWidget {
//   final String currentUserId;
//
//   ChatListPage({required this.currentUserId});
//
//   @override
//   _ChatListPageState createState() => _ChatListPageState();
// }
//
// class _ChatListPageState extends State<ChatListPage> {
//   List<Map<String, dynamic>> matchedUsers = [];
//
//   @override
//   void initState() {
//     super.initState();
//     loadMatchedUsers();
//   }
//
//   Future<void> loadMatchedUsers() async {
//     // Step 1: Fetch matched user IDs
//     List<String> userIds = await fetchMatchedUserIds(widget.currentUserId);
//
//     // Step 2: Fetch user data
//     List<Map<String, dynamic>> users = await fetchMatchedUserData(userIds);
//
//     setState(() {
//       matchedUsers = users;
//     });
//   }
//
//   Future<List<String>> fetchMatchedUserIds(String currentUserId) async {
//     try {
//       final snapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(currentUserId)
//           .collection('matched')
//           .get();
//
//       // Extract all matched user IDs from the documents
//       return snapshot.docs.map((doc) => doc.id).toList();
//     } catch (e) {
//       print('Error fetching matched user IDs: $e');
//       return [];
//     }
//   }
//
//   Future<List<Map<String, dynamic>>> fetchMatchedUserData(List<String> userIds) async {
//     List<Map<String, dynamic>> users = [];
//
//     for (String userId in userIds) {
//       try {
//         final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
//         final imageSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).collection('intrest').doc('basic details').get();
//         if (userDoc.exists) {
//           users.add({
//             'userId': userId,
//             'username': userDoc.data()?['username'],
//             'profileImage': imageSnapshot.data()?['image_url'], // Add field if profileImage exists
//           });
//         }
//       } catch (e) {
//         print('Error fetching data for user $userId: $e');
//       }
//     }
//
//     return users;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chats'),
//       ),
//       body: matchedUsers.isEmpty
//           ? Center(child: Text('No chats available', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))
//           : ListView.builder(
//         itemCount: matchedUsers.length,
//         itemBuilder: (context, index) {
//           final user = matchedUsers[index];
//           return ListTile(
//             leading: CircleAvatar(
//               backgroundImage: user['profileImage'] != null
//                   ? NetworkImage(user['profileImage'])
//                   : AssetImage('assets/images/default_avatar.png') as ImageProvider,
//             ),
//             title: Text(user['username'] ?? 'Unknown'),
//             onTap: () {
//               // Navigate to chat screen
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ChatScreen(
//                     currentUserId: widget.currentUserId,
//                     receiverId: user['userId'],
//                     receiverName: user['username'],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
//
//
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shimmer/shimmer.dart'; // For shimmer effect
import 'ChatScreen.dart';

class ChatListPage extends StatefulWidget {
  final String currentUserId;

  const ChatListPage({Key? key, required this.currentUserId}) : super(key: key);

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  List<Map<String, dynamic>> matchedUsers = [];
  List<Map<String, dynamic>> filteredUsers = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadMatchedUsers();
  }

  Future<void> loadMatchedUsers() async {
    List<String> userIds = await fetchMatchedUserIds(widget.currentUserId);
    List<Map<String, dynamic>> users = await fetchMatchedUserData(userIds);

    setState(() {
      matchedUsers = users;
      filteredUsers = users;
      isLoading = false;
    });
  }

  Future<List<String>> fetchMatchedUserIds(String currentUserId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('matched')
          .get();

      return snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print('Error fetching matched user IDs: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchMatchedUserData(List<String> userIds) async {
    List<Map<String, dynamic>> users = [];

    for (String userId in userIds) {
      try {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
        final imageSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('intrest')
            .doc('basic details')
            .get();

        if (userDoc.exists) {
          users.add({
            'userId': userId,
            'username': userDoc.data()?['username'],
            'profileImage': imageSnapshot.data()?['image_url'],
          });
        }
      } catch (e) {
        print('Error fetching data for user $userId: $e');
      }
    }

    return users;
  }

  void _filterUsers(String query) {
    setState(() {
      filteredUsers = matchedUsers
          .where((user) => user['username'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: Column(
        children: [
          _buildSearchBar(), // Add search bar
          Expanded(
            child: isLoading
                ? _buildShimmerLoading()
                : filteredUsers.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                return _buildChatItem(user);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Search Bar Widget
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        controller: searchController,
        onChanged: _filterUsers,
        decoration: InputDecoration(
          hintText: "Search...",
          prefixIcon: Icon(Icons.search, color: Color(0xFF081B48)),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Color(0xFF081B48), width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Color(0xFF081B48), width: 2),
          ),
        ),
      ),
    );
  }

  // Shimmer loading effect
  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          );
        },
      ),
    );
  }

  // Empty state widget
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/no_chats.png',
            width: 150,
            height: 150,
          ),
          const SizedBox(height: 16),
          const Text(
            'No chats available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // Chat list item widget
  Widget _buildChatItem(Map<String, dynamic> user) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                currentUserId: widget.currentUserId,
                receiverId: user['userId'],
                receiverName: user['username'],
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFF5F7FB), // Light shade inside card
            borderRadius: BorderRadius.circular(50), // More roundness
            border: Border.all(color: Color(0xFF081B48), width: 2),
          ),
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: user['profileImage'] != null
                    ? NetworkImage(user['profileImage'])
                    : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  user['username'] ?? 'Unknown',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Color(0xFF081B48)), // Navigation arrow
            ],
          ),
        ),
      ),
    );
  }
}
