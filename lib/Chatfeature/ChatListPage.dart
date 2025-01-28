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

import 'ChatScreen.dart';

class ChatListPage extends StatefulWidget {
  final String currentUserId;

  ChatListPage({required this.currentUserId});

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
        title: Text('Chats',style: TextStyle(color:Colors.blue),),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loader while fetching data
          : matchedUsers.isEmpty
          ? Center(
        child: Text(
          'No chats available',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      )
          : ListView.builder(
        itemCount: matchedUsers.length,
        itemBuilder: (context, index) {
          final user = matchedUsers[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: user['profileImage'] != null
                  ? NetworkImage(user['profileImage'])
                  : AssetImage('assets/images/default_avatar.png') as ImageProvider,
            ),
            title: Text(user['username'] ?? 'Unknown'),
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
          );
        },
      ),
    );
  }
}

