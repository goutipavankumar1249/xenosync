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
  bool isLoading = true; // Track loading state

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
      isLoading = false; // Stop loading
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
            'profileImage': imageSnapshot.data()?['image_url'], // Fetch profile image
          });
        }
      } catch (e) {
        print('Error fetching data for user $userId: $e');
      }
    }

    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chats',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF004DAB), Color(0xFF09163D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: isLoading
          ? _buildShimmerLoading() // Show shimmer effect while loading
          : matchedUsers.isEmpty
          ? _buildEmptyState() // Show empty state
          : ListView.builder(
        itemCount: matchedUsers.length,
        itemBuilder: (context, index) {
          final user = matchedUsers[index];
          return _buildChatItem(user);
        },
      ),
    );
  }

  // Shimmer loading effect
  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5, // Show 5 shimmer items
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey[300],
              ),
              title: Container(
                height: 16,
                width: 100,
                color: Colors.grey[300],
              ),
              subtitle: Container(
                height: 12,
                width: 150,
                color: Colors.grey[300],
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
            'assets/images/no_chats.png', // Add an illustration for empty state
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
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: user['profileImage'] != null
              ? NetworkImage(user['profileImage'])
              : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
        ),
        title: Text(
          user['username'] ?? 'Unknown',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: const Text(
          'Last message preview...', // Replace with actual last message
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        trailing: const Text(
          '12:30 PM', // Replace with actual timestamp
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        onTap: () {
          // Navigate to chat screen
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
      ),
    );
  }
}