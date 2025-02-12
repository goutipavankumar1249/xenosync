//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:login_app/Chatfeature/ChatListPage.dart';
// import 'package:provider/provider.dart';
// import 'package:swipe_cards/swipe_cards.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../UserState.dart';
// import '../interaction_service.dart';
//
// class FeedPage extends StatefulWidget {
//   const FeedPage({Key? key}) : super(key: key);
//   @override
//   _FeedPageState createState() => _FeedPageState();
// }
//
//
//
//
// class _FeedPageState extends State<FeedPage> {
//
//   List<SwipeItem> swipeItems = [];
//   List<Map<String, dynamic>> allDocuments = [];
//   List<Map<String, dynamic>> allDocsForIntrest = [];
//   List<String> aboutMe = [];
//   List<String> passions = [];
//   MatchEngine? matchEngine;
//   bool isLoading = true;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final currentUserId = FirebaseAuth.instance.currentUser?.uid;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserFeeds();
//   }
//   final InteractionService _interactionService = InteractionService();
//
//   Future<void> _fetchData(String feeduserId) async {
//     try {
//
//       print('fetch data function is called');
//       allDocuments = await getAllDocumentsInCollection('users', feeduserId);
//       // Now you can use the fetched data
//       print('all the documents in the feedpage $allDocuments');
//
//       allDocsForIntrest = await getAllDocumentsInCollectionForIntrest('users', feeduserId);
//       print('all the documents in the feedpage for intrest $allDocsForIntrest');
//
//     } catch (e) {
//       print("Error fetching data: $e");
//     }
//   }
//
//   Future<List<Map<String, dynamic>>> getAllDocumentsInCollection(String collectionPath,String userId) async {
//     List<Map<String, dynamic>> documents = [];
//
//     try {
//       QuerySnapshot<Map<String, dynamic>> querySnapshot =
//       await FirebaseFirestore.instance.collection(collectionPath).doc(userId).collection('details').get();
//
//       for (QueryDocumentSnapshot<Map<String, dynamic>> doc in querySnapshot.docs) {
//         documents.add(doc.data());
//       }
//     } catch (e) {
//       print("Error fetching documents: $e");
//     }
//
//     return documents;
//   }
//
//   Future<List<Map<String, dynamic>>> getAllDocumentsInCollectionForIntrest(String collectionPath,String userId) async {
//     List<Map<String, dynamic>> documents = [];
//
//     try {
//       QuerySnapshot<Map<String, dynamic>> querySnapshot =
//       await FirebaseFirestore.instance.collection(collectionPath).doc(userId).collection('intrest').get();
//
//       for (QueryDocumentSnapshot<Map<String, dynamic>> doc in querySnapshot.docs) {
//         documents.add(doc.data());
//       }
//     } catch (e) {
//       print("Error fetching documents: $e");
//     }
//
//     return documents;
//   }
//
//
//
//
//   Future<void> _loadUserFeeds() async {
//     if (currentUserId == null) {
//       setState(() {
//         isLoading = false;
//       });
//       return;
//     }
//
//     try {
//       // Fetch boosted users (active boosts only)
//       final boostedUsersQuery = await _firestore
//           .collection('users')
//           .where('boostedUntil', isGreaterThan: Timestamp.now()) // Active boosts only
//           .orderBy('boostedUntil', descending: true) // Most recently boosted first
//           .get();
//
//       print('Boosted user IDs: ${boostedUsersQuery.docs.map((doc) => doc.id).toList()}');
//
//       // Fetch all users except the current user
//       final allUsersQuery = await _firestore
//           .collection('users')
//           .where(FieldPath.documentId, isNotEqualTo: currentUserId) // Exclude self
//           .get();
//
//       // Get boosted user IDs for filtering
//       final boostedUserIds = boostedUsersQuery.docs.map((doc) => doc.id).toSet();
//
//       // Filter normal users (excluding boosted ones)
//       final normalUsers = allUsersQuery.docs.where((doc) => !boostedUserIds.contains(doc.id));
//
//       // Merge: Boosted users first, then normal users
//       final List<QueryDocumentSnapshot> sortedUsers = [
//         ...boostedUsersQuery.docs, // Boosted users first
//         ...normalUsers, // Normal users follow
//       ];
//
//       List<Future<Map>> userFeedsFutures = sortedUsers.map((userDoc) async {
//         final userId = userDoc.id;
//         print('Processing user: $userId');
//
//         // Fetch user details
//         final userNameSnapshot = await _firestore.collection('users').doc(userId).get();
//         final passionSnapshot = await _firestore.collection('users').doc(userId).collection('intrest').doc('passion').get();
//         final feedSnapshot = await _firestore.collection('users').doc(userId).collection('feed').get();
//
//         // Extract passions if available
//         List<String> passions = [];
//         if (passionSnapshot.exists && passionSnapshot.data()!.containsKey('passion')) {
//           passions = List<String>.from(passionSnapshot['passion']);
//         }
//
//         // Extract posts
//         List<Map<String, dynamic>> posts = feedSnapshot.docs.map((doc) => {
//           'postId': doc.id,
//           'imageUrl': doc.data()['imageUrl'] ?? '',
//           'description': doc.data()['description'] ?? '',
//           'uploadedAt': doc.data()['uploadedAt'],
//         }).toList();
//
//         return {
//           'userName': userNameSnapshot.data()?['username'],
//           'userId': userId,
//           'posts': posts,
//           'passions': passions,
//         };
//       }).toList();
//
//       final userFeeds = await Future.wait(userFeedsFutures);
//
//       print('the userfeeds is $userFeeds');
//
//       if (mounted) {
//         setState(() {
//           swipeItems = userFeeds
//               .where((feed) => feed.isNotEmpty) // Keep only users with feeds
//               .map((userFeed) => SwipeItem(
//             content: userFeed,
//             likeAction: () => _handleLike(userFeed['userId']),
//             nopeAction: () => _handleNope(userFeed['userId']),
//           ))
//               .toList();
//
//           // ✅ Do NOT shuffle the list, so boosted users stay at the top
//           matchEngine = MatchEngine(swipeItems: swipeItems);
//           isLoading = false;
//         });
//       }
//
//     } catch (e) {
//       print('Error loading feeds: $e');
//       if (mounted) {
//         setState(() {
//           isLoading = false;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to load feeds. Please try again.')),
//         );
//       }
//     }
//   }
//
//   Future<void> _handleNope(String userId) async {
//     try {
//       final userFeed = swipeItems
//           .firstWhere((item) => (item.content as Map<String, dynamic>)['userId'] == userId)
//           .content as Map<String, dynamic>;
//       print('userfeed of dislike $userFeed');
//       await _interactionService.recordDislike(
//         userId,
//         userFeed['name'] ?? 'Unknown',
//         userFeed['profileImage'] ?? '',
//       );
//       // Remove the disliked user from the swipe items list
//       setState(() {
//         swipeItems.removeWhere((item) => (item.content as Map<String,dynamic>)['userId'] == userId);
//         matchEngine = MatchEngine(swipeItems: swipeItems);
//       });
//     } catch (e) {
//       print('Error handling dislike: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to skip profile. Please try again.')),
//         );
//       }
//     }
//   }
//
//   Future<void> _handleLike(String userId) async {
//     try {
//       final userFeed = swipeItems
//           .firstWhere((item) => (item.content as Map<String, dynamic>)['userId'] == userId)
//           .content as Map<String, dynamic>;
//       print('userfeed of like $userFeed');
//       await _interactionService.recordLike(
//         userId,
//         userFeed['name'] ?? 'Unknown',
//         userFeed['profileImage'] ?? '',
//       );
//       await _interactionService.matchandRemove(
//         userId,
//         userFeed['name'] ?? 'Unknown',
//         userFeed['profileImage'] ?? '',
//       );
//       // After successful like, call the function to check for match and handle removal
//       await _handleMatchAndRemove(userId);
//     } catch (e) {
//       print('Error handling like: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to skip profile. Please try again.')),
//         );
//       }
//     }
//   }
//
//   Future<void> _handleMatchAndRemove(String userId) async {
//     try {
//       print('match and remove function is called');
//       final otherUserLike = await _firestore
//           .collection('users')
//           .doc(userId)
//           .collection('liked_by')
//           .doc(currentUserId)
//           .get();
//
//       if (otherUserLike.exists) {
//         await _createMatch(userId);
//         _showMatchDialog(userId);
//       }
//
//       // Remove the liked user from the swipe items list
//       setState(() {
//         swipeItems.removeWhere((item) => (item.content as Map<String, dynamic>)['userId'] == userId);
//         matchEngine = MatchEngine(swipeItems: swipeItems);
//       });
//     } catch (e) {
//       print('Error handling match and remove: $e');
//     }
//   }
//
//   Future<void> _createMatch(String otherUserId) async {
//     try {
//       print('create match is called');
//       // Create a match in Firestore
//       final matchRef = _firestore.collection('matches').doc();
//       await matchRef.set({
//         'users': [currentUserId, otherUserId],
//         'timestamp': FieldValue.serverTimestamp(),
//         'lastMessage': null,
//         'lastMessageTimestamp': null,
//       });
//
//       // Add match reference to the other user's matches
//
//       await _interactionService.addMatchForCurrentUser(currentUserId!, matchRef.id, otherUserId);
//       // Add match reference to the other user's matches
//       await _interactionService.addMatchForOtherUser(otherUserId, matchRef.id, currentUserId!);
//
//       // Create a new chat collection for the match
//       await _firestore.collection('chats').doc(matchRef.id).set({
//         'messages': [],
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       print('Error creating match: $e');
//     }
//   }
//
//
//   void _showMatchDialog(String userId) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('It\'s a Match! 🎉'),
//           content: Text('You and this person like each other!'),
//           actions: [
//             ElevatedButton(
//               child: Text('Keep Browsing'),
//               onPressed: () => Navigator.pop(context),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ChatListPage(
//                       currentUserId: FirebaseAuth.instance.currentUser!.uid,
//                     ),
//                   ),
//                 );
//               },
//               child: const Text('Send Message'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//   Future<void> _handleSuperLike(String userId) async {
//     // Implement super like functionality if needed
//     await _handleLike(userId);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Map<String, dynamic> selectedFilters = Provider.of<UserState>(context, listen: false).selectedFilters;
//     print('the selected options are $selectedFilters'); // This will print the applied filters
//     return Scaffold(
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : swipeItems.isEmpty
//           ? Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Text(
//             'No more profiles available.\nCheck back later!',
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize: 16),
//           ),
//         ),
//       )
//           : Stack(
//         children: [
//           SwipeCards(
//             matchEngine: matchEngine!,
//             itemBuilder: (BuildContext context, int index) {
//               final userFeed = swipeItems[index].content as Map<String, dynamic>;
//               return UserCard(
//                 userName : userFeed['userName'],
//                 userId : userFeed['userId'],
//                 posts: List<Map<String, dynamic>>.from(userFeed['posts'] as List),
//                 passions: List<String>.from(userFeed['passions'] as List),
//                 //aboutMe: List<String>.from(userFeed['aboutMe'] as List),
//               );
//             },
//             onStackFinished: () {
//               setState(() {
//                 isLoading = true;
//               });
//               _loadUserFeeds();
//             },
//             fillSpace: true,
//             upSwipeAllowed: true,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
// class UserCard extends StatelessWidget {
//
//   final String userName;
//   final List<Map<String, dynamic>> posts;
//   final String userId;
//   final List<String> passions;  // ✅ Added passions
//   //final List<String> aboutMe;  // ✅ Added aboutMe
//
//
//   const UserCard({
//     Key? key,
//     required this.userName,
//     required this.userId,
//     required this.posts,
//     required this.passions,
//     //required this.aboutMe,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold( // Use Scaffold for overall app structure
//       appBar: AppBar(title: Text("Swipe Feed of $userId")),
//       body: SingleChildScrollView( // Enable scrolling for entire content
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Image Section (First Image)
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: CachedNetworkImage(
//                 imageUrl: posts.isNotEmpty ? posts[0]['imageUrl'] as String : 'https://asset.1cdn.vn/all/images/placeholder-image10.jpg',
//                 fit: BoxFit.cover,
//                 height: 700, // Adjust height as needed
//                 width: double.infinity,
//                 placeholder: (context, url) => Center(
//                   child: CircularProgressIndicator(),
//                 ),
//                 errorWidget: (context, url, error) => Icon(Icons.error),
//               ),
//             ),
//             // User Details Section
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "About me",
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   // Wrap(
//                   //   spacing: 8,
//                   //   runSpacing: 8.0, // Vertical spacing between rows of tags
//                   //   children: aboutMe.map((tag) => _buildTag(context, tag)).toList(),
//                   // ),
//                   SizedBox(height: 16),
//                   Text(
//                     "My interests",
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   Wrap(
//                     spacing: 8,
//                     runSpacing: 8.0, // Vertical spacing between rows of tags
//                     children: passions.map((tag) => _buildTag(context, tag)).toList(),
//                   ),
//                 ],
//               ),
//             ),
//             // Remaining Posts Section
//             ListView.builder(
//               shrinkWrap: true, // Prevent excessive scrolling
//               physics: NeverScrollableScrollPhysics(), // Disable scrolling within this section
//               itemCount: posts.length,
//               itemBuilder: (context, index) {
//                 final post = posts[index];
//                 return Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       CachedNetworkImage(
//                         imageUrl: post['imageUrl'] as String,
//                         fit: BoxFit.cover,
//                         height: 700, // Adjust height as needed
//                         width: double.infinity,
//                         placeholder: (context, url) => Center(
//                           child: CircularProgressIndicator(),
//                         ),
//                         errorWidget: (context, url, error) => Icon(Icons.error),
//                       ),
//                       SizedBox(height: 8),
//                       Text(
//                         post['description'] as String? ?? '',
//                         style: TextStyle(
//                           fontSize: 14,
//                         ),
//                       ),
//                       SizedBox(height: 16),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//
//
//
//   Widget _buildTag(BuildContext context, String tag) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(
//         tag,
//         style: TextStyle(fontSize: 12),
//       ),
//     );
//   }
// }
//
//



import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login_app/Chatfeature/ChatListPage.dart';
import 'package:provider/provider.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../filters/FiltersPage.dart';
import '../UserState.dart';
import '../VideoWidget.dart';
import '../interaction_service.dart';
import 'package:video_player/video_player.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {

  List<SwipeItem> swipeItems = [];
  List<Map<String, dynamic>> allDocuments = [];
  List<Map<String, dynamic>> allDocsForIntrest = [];
  List<String> aboutMe = [];
  List<String> passions = [];
  MatchEngine? matchEngine;
  bool isLoading = true;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;
  final InteractionService _interactionService = InteractionService();

  @override
  void initState() {
    super.initState();
    _loadUserFeeds();
  }

  Future<void> _loadUserFeeds() async {
    if (currentUserId == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      // ✅ Get selected filters (if any)
      final filters = Provider.of<UserState>(context, listen: false).selectedFilters;

      // ✅ Fetch boosted users (active boosts only)
      final boostedUsersQuery = await _firestore
          .collection('users')
          .where('boostedUntil', isGreaterThan: Timestamp.now()) // Active boosts only
          .orderBy('boostedUntil', descending: true) // Most recently boosted first
          .get();

      // ✅ Fetch all users except the current user
      final allUsersQuery = await _firestore
          .collection('users')
          .where(FieldPath.documentId, isNotEqualTo: currentUserId) // Exclude self
          .get();

      // ✅ Get boosted user IDs
      final boostedUserIds = boostedUsersQuery.docs.map((doc) => doc.id).toSet();

      // 🔹 Remove current user if they are in boosted users
      boostedUserIds.remove(currentUserId);

      print('Boosted user IDs after removal of current user: $boostedUserIds');

      // 🔹 *Function to Check if a User Matches Filters (Only If Filters Are Applied)*
      bool matchesFilter(Map<String, dynamic> user) {
        if (filters.isEmpty) return true; // No filters selected → Show all users

        int userAge = user['age'] ?? 0;
        String userGender = user['gender'] ?? "";
        int userHeight = user['height'] ?? 0;
        String userBodyColor = user['bodyColor'] ?? "";

        bool ageMatch = userAge >= filters['ageRange']['min'] && userAge <= filters['ageRange']['max'];
        bool genderMatch = filters['gender'] == null || filters['gender'] == userGender;
        bool heightMatch = filters['height'] == 0 || filters['height'] == userHeight;
        bool bodyColorMatch = filters['bodyColor'] == null || filters['bodyColor'] == userBodyColor;

        return ageMatch && genderMatch && heightMatch && bodyColorMatch;
      }

      // ✅ First, Collect Boosted Users (Without Filtering Initially) and Remove Current User
      final boostedUsers = boostedUsersQuery.docs.where((doc) => doc.id != currentUserId).toList();

      // ✅ Collect Normal Users (Exclude Boosted Ones)
      final normalUsers = allUsersQuery.docs.where((doc) => !boostedUserIds.contains(doc.id)).toList();

      // ✅ If filters are selected, apply them
      if (filters.isNotEmpty) {
        normalUsers.removeWhere((doc) => !matchesFilter(doc.data() as Map<String, dynamic>));
      }

      // ✅ Merge: Boosted users first, then normal users
      final List<QueryDocumentSnapshot> sortedUsers = [
        ...boostedUsers, // Boosted users first
        ...normalUsers,  // Normal users follow
      ];

      // ✅ Fetch User Feeds
      List<Future<Map>> userFeedsFutures = sortedUsers.map((userDoc) async {
        final userId = userDoc.id;

        // Fetch user details
        final userNameSnapshot = await _firestore.collection('users').doc(userId).get();
        final passionSnapshot = await _firestore.collection('users').doc(userId).collection('intrest').doc('passion').get();
        final feedSnapshot = await _firestore.collection('users').doc(userId).collection('feed').get();

        // Extract passions if available
        List<String> passions = [];
        if (passionSnapshot.exists && passionSnapshot.data()!.containsKey('passion')) {
          passions = List<String>.from(passionSnapshot['passion']);
        }

        // Extract posts
        List<Map<String, dynamic>> posts = feedSnapshot.docs.map((doc) => {
          'postId': doc.id,
          'imageUrl': doc.data()['imageUrl'] ?? '',
          'description': doc.data()['description'] ?? '',
          'uploadedAt': doc.data()['uploadedAt'],
          'type': doc.data()['type'],
        }).toList();

        print('The posts are $posts');

        return {
          'userName': userNameSnapshot.data()?['username'],
          'userId': userId,
          'posts': posts,
          'passions': passions,
        };
      }).toList();

      final userFeeds = await Future.wait(userFeedsFutures);

      if (mounted) {
        setState(() {
          swipeItems = userFeeds
              .where((feed) => feed.isNotEmpty) // Keep only users with feeds
              .map((userFeed) => SwipeItem(
            content: userFeed,
            likeAction: () => _handleLike(userFeed['userId']),
            nopeAction: () => _handleNope(userFeed['userId']),
          ))
              .toList();

          // ✅ Do NOT shuffle the list, so boosted users stay at the top
          matchEngine = MatchEngine(swipeItems: swipeItems);
          isLoading = false;
        });
      }

    } catch (e) {
      print('Error loading feeds: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load feeds. Please try again.')),
        );
      }
    }
  }


  Future<void> _handleNope(String userId) async {
    try {
      final userFeed = swipeItems
          .firstWhere((item) => (item.content as Map<String, dynamic>)['userId'] == userId)
          .content as Map<String, dynamic>;
      print('userfeed of dislike $userFeed');
      await _interactionService.recordDislike(
        userId,
        userFeed['name'] ?? 'Unknown',
        userFeed['profileImage'] ?? '',
      );
      // Remove the disliked user from the swipe items list
      setState(() {
        swipeItems.removeWhere((item) => (item.content as Map<String,dynamic>)['userId'] == userId);
        matchEngine = MatchEngine(swipeItems: swipeItems);
      });
    } catch (e) {
      print('Error handling dislike: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to skip profile. Please try again.')),
        );
      }
    }
  }

  Future<void> _handleLike(String userId) async {
    try {
      final userFeed = swipeItems
          .firstWhere((item) => (item.content as Map<String, dynamic>)['userId'] == userId)
          .content as Map<String, dynamic>;
      print('userfeed of like $userFeed');
      await _interactionService.recordLike(
        userId,
        userFeed['name'] ?? 'Unknown',
        userFeed['profileImage'] ?? '',
      );
      await _interactionService.matchandRemove(
        userId,
        userFeed['name'] ?? 'Unknown',
        userFeed['profileImage'] ?? '',
      );
      // After successful like, call the function to check for match and handle removal
      await _handleMatchAndRemove(userId);
    } catch (e) {
      print('Error handling like: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to skip profile. Please try again.')),
        );
      }
    }
  }

  Future<void> _handleMatchAndRemove(String userId) async {
    try {
      print('match and remove function is called');
      final otherUserLike = await _firestore
          .collection('users')
          .doc(userId)
          .collection('liked_by')
          .doc(currentUserId)
          .get();

      if (otherUserLike.exists) {
        await _createMatch(userId);
        _showMatchDialog(userId);
      }

      // Remove the liked user from the swipe items list
      setState(() {
        swipeItems.removeWhere((item) => (item.content as Map<String, dynamic>)['userId'] == userId);
        matchEngine = MatchEngine(swipeItems: swipeItems);
      });
    } catch (e) {
      print('Error handling match and remove: $e');
    }
  }

  Future<void> _createMatch(String otherUserId) async {
    try {
      print('create match is called');
      // Create a match in Firestore
      final matchRef = _firestore.collection('matches').doc();
      await matchRef.set({
        'users': [currentUserId, otherUserId],
        'timestamp': FieldValue.serverTimestamp(),
        'lastMessage': null,
        'lastMessageTimestamp': null,
      });

      // Add match reference to the other user's matches

      await _interactionService.addMatchForCurrentUser(currentUserId!, matchRef.id, otherUserId);
      // Add match reference to the other user's matches
      await _interactionService.addMatchForOtherUser(otherUserId, matchRef.id, currentUserId!);

      // Create a new chat collection for the match
      await _firestore.collection('chats').doc(matchRef.id).set({
        'messages': [],
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error creating match: $e');
    }
  }


  void _showMatchDialog(String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('It\'s a Match! 🎉'),
          content: Text('You and this person like each other!'),
          actions: [
            ElevatedButton(
              child: Text('Keep Browsing'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatListPage(
                      currentUserId: FirebaseAuth.instance.currentUser!.uid,
                    ),
                  ),
                );
              },
              child: const Text('Send Message'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> selectedFilters = Provider.of<UserState>(context, listen: false).selectedFilters;
    print('the selected options are $selectedFilters'); // This will print the applied filters
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : swipeItems.isEmpty
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'No more profiles available.\nCheck back later!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
      )
          : Stack(
        children: [
          SwipeCards(
            matchEngine: matchEngine!,
            itemBuilder: (BuildContext context, int index) {
              final userFeed = swipeItems[index].content as Map<String, dynamic>;
              return UserCard(
                userName : userFeed['userName'],
                userId : userFeed['userId'],
                posts: List<Map<String, dynamic>>.from(userFeed['posts'] as List),
                passions: List<String>.from(userFeed['passions'] as List),
                //aboutMe: List<String>.from(userFeed['aboutMe'] as List),
              );
            },
            onStackFinished: () {
              setState(() {
                isLoading = true;
              });
              _loadUserFeeds();
            },
            fillSpace: true,
            upSwipeAllowed: true,
          ),
        ],
      ),
    );
  }
}


class UserCard extends StatelessWidget {
  final String userName;
  final List<Map<String, dynamic>> posts;
  final String userId;
  final List<String> passions;

  const UserCard({
    Key? key,
    required this.userName,
    required this.userId,
    required this.posts,
    required this.passions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Swipe Feed of $userId"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // **Check if posts list is not empty before accessing posts[0]**
            if (posts.isNotEmpty)
              posts[0]['type'] == 'video'
                  ? VideoWidget(videoUrl: posts[0]['imageUrl'])
                  : CachedNetworkImage(
                imageUrl: posts[0]['imageUrl'],
                fit: BoxFit.cover,
                height: 700,
                width: double.infinity,
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) =>
                    Icon(Icons.error),
              )
            else
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "No posts available",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

            // **User Details Section**
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "My interests",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8.0,
                    children:
                    passions.map((tag) => _buildTag(context, tag)).toList(),
                  ),
                ],
              ),
            ),

            // **Remaining Posts Section**
            if (posts.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: posts.length-1,
                itemBuilder: (context, index) {
                  final post = posts[index+1];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (post['type'] == 'video')
                          VideoWidget(videoUrl: post['imageUrl'])
                        else
                          CachedNetworkImage(
                            imageUrl: post['imageUrl'],
                            fit: BoxFit.cover,
                            height: 700,
                            width: double.infinity,
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        SizedBox(height: 8),
                        Text(
                          post['description'] as String? ?? '',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(BuildContext context, String tag) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        tag,
        style: TextStyle(fontSize: 12),
      ),
    );
  }
}

