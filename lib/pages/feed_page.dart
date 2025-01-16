// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:swipe_cards/swipe_cards.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';
//
// class FeedPage extends StatefulWidget {
//   @override
//   _FeedPageState createState() => _FeedPageState();
// }
//
// class _FeedPageState extends State<FeedPage> {
//   List<SwipeItem> swipeItems = [];
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
//
//   Future<void> _loadUserFeeds() async {
//     try {
//       // Get all users except current user
//       final usersSnapshot = await _firestore
//           .collection('users')
//           .where(FieldPath.documentId, isNotEqualTo: currentUserId)
//           .get();
//
//       // Explicitly type the Map structure
//       List<Future<Map<String, dynamic>>> userFeedsFutures = usersSnapshot.docs.map((userDoc) async {
//         // Get user's feed collection
//         final feedSnapshot = await _firestore
//             .collection('users')
//             .doc(userDoc.id)
//             .collection('feed')
//             .orderBy('uploadedAt', descending: true)
//             .get();
//
//         // Group all posts by this user with explicit typing
//         List<Map<String, dynamic>> posts = feedSnapshot.docs.map((doc) {
//           Map<String, dynamic> data = doc.data();
//           data['postId'] = doc.id;
//           return data;
//         }).toList();
//
//         // Only include users who have posts
//         if (posts.isNotEmpty) {
//           return <String, dynamic>{
//             'userId': userDoc.id,
//             'posts': posts,
//           };
//         }
//         return <String, dynamic>{}; // Return empty map with explicit typing
//       }).toList();
//
//       final userFeeds = await Future.wait(userFeedsFutures);
//
//       // Filter out empty feeds and create swipe items
//       swipeItems = userFeeds
//           .where((feed) => feed.isNotEmpty)
//           .map((userFeed) => SwipeItem(
//         content: userFeed,
//         likeAction: () => _handleLike(userFeed['userId'] as String),
//         nopeAction: () => _handleNope(userFeed['userId'] as String),
//         superlikeAction: () => _handleSuperLike(userFeed['userId'] as String),
//       ))
//           .toList();
//
//       if (mounted) {
//         setState(() {
//           matchEngine = MatchEngine(swipeItems: swipeItems);
//           isLoading = false;
//         });
//       }
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
//   Future<void> _handleLike(String userId) async {
//     // Implement like logic
//     print('Liked user: $userId');
//   }
//
//   Future<void> _handleNope(String userId) async {
//     // Implement nope logic
//     print('Noped user: $userId');
//   }
//
//   Future<void> _handleSuperLike(String userId) async {
//     // Implement superlike logic
//     print('Super liked user: $userId');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Discover'),
//         elevation: 0,
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : swipeItems.isEmpty
//           ? Center(child: Text('No profiles available'))
//           : SwipeCards(
//         matchEngine: matchEngine!,
//         itemBuilder: (BuildContext context, int index) {
//           final userFeed = swipeItems[index].content as Map<String, dynamic>;
//           final posts = List<Map<String, dynamic>>.from(userFeed['posts'] as List);
//
//           return UserCard(
//             posts: posts,
//             userId: userFeed['userId'] as String,
//           );
//         },
//         onStackFinished: () {
//           setState(() {
//             isLoading = true;
//           });
//           _loadUserFeeds();
//         },
//         fillSpace: true,
//         upSwipeAllowed: true,
//       ),
//     );
//   }
// }
//
// class UserCard extends StatefulWidget {
//   final List<Map<String, dynamic>> posts;
//   final String userId;
//
//   const UserCard({
//     Key? key,
//     required this.posts,
//     required this.userId,
//   }) : super(key: key);
//
//   @override
//   _UserCardState createState() => _UserCardState();
// }
//
// class _UserCardState extends State<UserCard> {
//   final PageController _pageController = PageController();
//   int _currentPage = 0;
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.all(8),
//       clipBehavior: Clip.antiAlias,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Stack(
//         children: [
//           PageView.builder(
//             controller: _pageController,
//             itemCount: widget.posts.length,
//             onPageChanged: (index) {
//               setState(() {
//                 _currentPage = index;
//               });
//             },
//             itemBuilder: (context, index) {
//               final post = widget.posts[index];
//               return Stack(
//                 fit: StackFit.expand,
//                 children: [
//                   CachedNetworkImage(
//                     imageUrl: post['imageUrl'] as String,
//                     fit: BoxFit.cover,
//                     placeholder: (context, url) => Center(
//                       child: CircularProgressIndicator(),
//                     ),
//                     errorWidget: (context, url, error) => Icon(Icons.error),
//                   ),
//                   Positioned.fill(
//                     child: DecoratedBox(
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                           colors: [
//                             Colors.transparent,
//                             Colors.black.withOpacity(0.7),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 48,
//                     left: 16,
//                     right: 16,
//                     child: Text(
//                       post['description'] as String? ?? '',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//           Positioned(
//             bottom: 16,
//             left: 0,
//             right: 0,
//             child: Center(
//               child: SmoothPageIndicator(
//                 controller: _pageController,
//                 count: widget.posts.length,
//                 effect: WormEffect(
//                   dotHeight: 8,
//                   dotWidth: 8,
//                   spacing: 8,
//                   dotColor: Colors.white.withOpacity(0.5),
//                   activeDotColor: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:swipe_cards/swipe_cards.dart';
// // import 'package:cached_network_image/cached_network_image.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// //
// // import '../components/interaction_service.dart';
// //
// //
// // class FeedPage extends StatefulWidget {
// //   @override
// //   _FeedPageState createState() => _FeedPageState();
// // }
// //
// // class _FeedPageState extends State<FeedPage> {
// //   List<SwipeItem> swipeItems = [];
// //   MatchEngine? matchEngine;
// //   bool isLoading = true;
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// //   final currentUserId = FirebaseAuth.instance.currentUser?.uid;
// //   //final currentUserId = FirebaseAuth.instance.currentUser?.uid;
// //   final InteractionService _interactionService = InteractionService();
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadUserFeeds();
// //   }
// //
// //   Future<void> _loadUserFeeds() async {
// //     try {
// //       final usersSnapshot = await _firestore
// //           .collection('users')
// //           .where(FieldPath.documentId, isNotEqualTo: currentUserId)
// //           .get();
// //
// //       List<Future<Map<String, dynamic>>> userFeedsFutures = usersSnapshot.docs.map((userDoc) async {
// //         final feedSnapshot = await _firestore
// //             .collection('users')
// //             .doc(userDoc.id)
// //             .collection('feed')
// //             .orderBy('uploadedAt', descending: true)
// //             .get();
// //
// //         List<Map<String, dynamic>> posts = feedSnapshot.docs.map((doc) {
// //           Map<String, dynamic> data = doc.data();
// //           data['postId'] = doc.id;
// //           return data;
// //         }).toList();
// //
// //         if (posts.isNotEmpty) {
// //           // Get user profile data
// //           final userProfile = await _firestore.collection('users').doc(userDoc.id).get();
// //           return <String, dynamic>{
// //             'userId': userDoc.id,
// //             'posts': posts,
// //             'userName': userProfile.data()?['name'] ?? 'Unknown',
// //             'userAge': userProfile.data()?['age'] ?? '',
// //             'userLocation': userProfile.data()?['location'] ?? '',
// //           };
// //         }
// //         return <String, dynamic>{};
// //       }).toList();
// //
// //       final userFeeds = await Future.wait(userFeedsFutures);
// //
// //       swipeItems = userFeeds
// //           .where((feed) => feed.isNotEmpty)
// //           .map((userFeed) => SwipeItem(
// //         content: userFeed,
// //         likeAction: () => _handleLike(userFeed['userId'] as String),
// //         nopeAction: () => _handleNope(userFeed['userId'] as String),
// //       ))
// //           .toList();
// //
// //       if (mounted) {
// //         setState(() {
// //           matchEngine = MatchEngine(swipeItems: swipeItems);
// //           isLoading = false;
// //         });
// //       }
// //     } catch (e) {
// //       print('Error loading feeds: $e');
// //       if (mounted) {
// //         setState(() {
// //           isLoading = false;
// //         });
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text('Failed to load feeds. Please try again.')),
// //         );
// //       }
// //     }
// //   }
// //   // final _interactionService = InteractionService();
// //   // Future<void> _handleLike(String userId) async {
// //   //
// //   //   try {
// //   //     // Add to liked_users collection
// //   //     await _firestore
// //   //         .collection('users')
// //   //         .doc(currentUserId)
// //   //         .collection('liked_users')
// //   //         .doc(userId)
// //   //         .set({
// //   //       'timestamp': FieldValue.serverTimestamp(),
// //   //       'status': 'liked'
// //   //     });
// //   //
// //   //     // Check if it's a match (if the other user has already liked current user)
// //   //     final otherUserLike = await _firestore
// //   //         .collection('users')
// //   //         .doc(userId)
// //   //         .collection('liked_users')
// //   //         .doc(currentUserId)
// //   //         .get();
// //   //
// //   //     if (otherUserLike.exists) {
// //   //       // It's a match!
// //   //       await _createMatch(userId);
// //   //       _showMatchDialog(userId);
// //   //     }
// //   //
// //   //
// //   //     ScaffoldMessenger.of(context).showSnackBar(
// //   //       SnackBar(content: Text('Liked profile!')),
// //   //     );
// //   //   } catch (e) {
// //   //     print('Error handling like: $e');
// //   //   }
// //   // }
// //   //
// //   // Future<void> _handleNope(String userId) async {
// //   //   try {
// //   //     // Add to disliked_users collection
// //   //     await _firestore
// //   //         .collection('users')
// //   //         .doc(currentUserId)
// //   //         .collection('disliked_users')
// //   //         .doc(userId)
// //   //         .set({
// //   //       'timestamp': FieldValue.serverTimestamp(),
// //   //       'status': 'disliked'
// //   //     });
// //   //
// //   //     ScaffoldMessenger.of(context).showSnackBar(
// //   //       SnackBar(content: Text('Profile skipped')),
// //   //     );
// //   //   } catch (e) {
// //   //     print('Error handling nope: $e');
// //   //   }
// //   // }
// //   Future<void> _handleLike(String userId) async {
// //     try {
// //       final userFeed = swipeItems
// //           .firstWhere((item) => (item.content as Map<String, dynamic>)['userId'] == userId)
// //           .content as Map<String, dynamic>;
// //
// //       // Record the like using InteractionService
// //       await _interactionService.recordLike(
// //         userId,
// //         userFeed['userName'] as String? ?? 'Unknown',
// //         userFeed['userImage'] as String? ?? '',
// //       );
// //
// //       // Add to liked_users collection (for matching logic)
// //       await _firestore
// //           .collection('users')
// //           .doc(currentUserId)
// //           .collection('liked_users')
// //           .doc(userId)
// //           .set({
// //         'timestamp': FieldValue.serverTimestamp(),
// //         'status': 'liked'
// //       });
// //
// //       // Check if it's a match (if the other user has already liked current user)
// //       final otherUserLike = await _firestore
// //           .collection('users')
// //           .doc(userId)
// //           .collection('liked_users')
// //           .doc(currentUserId)
// //           .get();
// //
// //       if (otherUserLike.exists) {
// //         // It's a match!
// //         await _createMatch(userId);
// //         _showMatchDialog(userId);
// //       }
// //
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Liked profile!')),
// //       );
// //     } catch (e) {
// //       print('Error handling like: $e');
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Failed to like profile. Please try again.')),
// //       );
// //     }
// //   }
// //
// //   Future<void> _handleNope(String userId) async {
// //     try {
// //       final userFeed = swipeItems
// //           .firstWhere((item) => (item.content as Map<String, dynamic>)['userId'] == userId)
// //           .content as Map<String, dynamic>;
// //
// //       // Record the dislike using InteractionService
// //       await _interactionService.recordDislike(
// //         userId,
// //         userFeed['userName'] as String? ?? 'Unknown',
// //         userFeed['userImage'] as String? ?? '',
// //       );
// //
// //       // Add to disliked_users collection
// //       await _firestore
// //           .collection('users')
// //           .doc(currentUserId)
// //           .collection('disliked_users')
// //           .doc(userId)
// //           .set({
// //         'timestamp': FieldValue.serverTimestamp(),
// //         'status': 'disliked'
// //       });
// //
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Profile skipped')),
// //       );
// //     } catch (e) {
// //       print('Error handling nope: $e');
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Failed to skip profile. Please try again.')),
// //       );
// //     }
// //   }
// //   Future<void> _createMatch(String otherUserId) async {
// //     try {
// //       // Create a match document
// //       final matchRef = _firestore.collection('matches').doc();
// //       await matchRef.set({
// //         'users': [currentUserId, otherUserId],
// //         'timestamp': FieldValue.serverTimestamp(),
// //         'lastMessage': null,
// //         'lastMessageTimestamp': null,
// //       });
// //
// //       // Add match reference to both users
// //       await _firestore
// //           .collection('users')
// //           .doc(currentUserId)
// //           .collection('matches')
// //           .doc(matchRef.id)
// //           .set({'matchId': matchRef.id});
// //
// //       await _firestore
// //           .collection('users')
// //           .doc(otherUserId)
// //           .collection('matches')
// //           .doc(matchRef.id)
// //           .set({'matchId': matchRef.id});
// //     } catch (e) {
// //       print('Error creating match: $e');
// //     }
// //   }
// //
// //   void _showMatchDialog(String userId) {
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           title: Text('It\'s a Match! 🎉'),
// //           content: Text('You and this user like each other!'),
// //           actions: <Widget>[
// //             TextButton(
// //               child: Text('Keep Browsing'),
// //               onPressed: () {
// //                 Navigator.of(context).pop();
// //               },
// //             ),
// //             TextButton(
// //               child: Text('Send Message'),
// //               onPressed: () {
// //                 Navigator.of(context).pop();
// //                 // Navigate to chat/message screen
// //                 // You'll need to implement this navigation
// //                 // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(matchId: ...)));
// //               },
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Discover'),
// //         elevation: 0,
// //       ),
// //       body: isLoading
// //           ? Center(child: CircularProgressIndicator())
// //           : swipeItems.isEmpty
// //           ? Center(
// //         child: Padding(
// //           padding: const EdgeInsets.all(16.0),
// //           child: Text(
// //             'No more profiles available.\nCheck back later!',
// //             textAlign: TextAlign.center,
// //             style: TextStyle(fontSize: 16),
// //           ),
// //         ),
// //       )
// //           : Stack(
// //         children: [
// //           SwipeCards(
// //             matchEngine: matchEngine!,
// //             onStackFinished: () {
// //               setState(() {
// //                 isLoading = true;
// //               });
// //               _loadUserFeeds();
// //             },
// //             fillSpace: true,
// //             itemBuilder: (BuildContext context, int index) {
// //               final userFeed = swipeItems[index].content as Map<String, dynamic>;
// //               final posts = List<Map<String, dynamic>>.from(userFeed['posts'] as List);
// //
// //               return UserCard(
// //                 posts: posts,
// //                 userId: userFeed['userId'] as String? ?? '', // Add null check
// //                 userName: userFeed['userName'] as String? ?? 'Unknown', // Add null check
// //                 userAge: (userFeed['userAge']?.toString() ?? ''), // Add null check and convert to string
// //                 userLocation: userFeed['userLocation'] as String? ?? '', // Add null check
// //               );
// //             },
// //             upSwipeAllowed: false,
// //           ),
// //           // Swipe direction indicators
// //           Positioned(
// //             left: 20,
// //             right: 20,
// //             bottom: 20,
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //               children: [
// //                 Icon(
// //                   Icons.close,
// //                   color: Colors.red.withOpacity(0.5),
// //                   size: 40,
// //                 ),
// //                 Icon(
// //                   Icons.favorite,
// //                   color: Colors.green.withOpacity(0.5),
// //                   size: 40,
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// // class UserCard extends StatefulWidget {
// //   final List<Map<String, dynamic>> posts;
// //   final String userId;
// //   final String userName;
// //   final String userAge;
// //   final String userLocation;
// //
// //   const UserCard({
// //     Key? key,
// //     required this.posts,
// //     required this.userId,
// //     required this.userName,
// //     required this.userAge,
// //     required this.userLocation,
// //   }) : super(key: key);
// //
// //   @override
// //   _UserCardState createState() => _UserCardState();
// // }
// //
// // class _UserCardState extends State<UserCard> {
// //   final PageController _pageController = PageController();
// //   int _currentPage = 0;
// //
// //   @override
// //   void dispose() {
// //     _pageController.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Card(
// //       margin: EdgeInsets.all(8),
// //       clipBehavior: Clip.antiAlias,
// //       shape: RoundedRectangleBorder(
// //         borderRadius: BorderRadius.circular(15),
// //       ),
// //       child: Stack(
// //         children: [
// //           PageView.builder(
// //             controller: _pageController,
// //             itemCount: widget.posts.length,
// //             onPageChanged: (index) {
// //               setState(() {
// //                 _currentPage = index;
// //               });
// //             },
// //             itemBuilder: (context, index) {
// //               final post = widget.posts[index];
// //               return Stack(
// //                 fit: StackFit.expand,
// //                 children: [
// //                   CachedNetworkImage(
// //                     imageUrl: post['imageUrl'] as String,
// //                     fit: BoxFit.cover,
// //                     placeholder: (context, url) => Center(
// //                       child: CircularProgressIndicator(),
// //                     ),
// //                     errorWidget: (context, url, error) => Icon(Icons.error),
// //                   ),
// //                   // Gradient overlay
// //                   Positioned.fill(
// //                     child: DecoratedBox(
// //                       decoration: BoxDecoration(
// //                         gradient: LinearGradient(
// //                           begin: Alignment.topCenter,
// //                           end: Alignment.bottomCenter,
// //                           colors: [
// //                             Colors.transparent,
// //                             Colors.black.withOpacity(0.7),
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                   // User info
// //                   Positioned(
// //                     bottom: 60,
// //                     left: 16,
// //                     right: 16,
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         Text(
// //                           '${widget.userName}, ${widget.userAge}',
// //                           style: TextStyle(
// //                             color: Colors.white,
// //                             fontSize: 24,
// //                             fontWeight: FontWeight.bold,
// //                           ),
// //                         ),
// //                         if (widget.userLocation.isNotEmpty)
// //                           Text(
// //                             widget.userLocation,
// //                             style: TextStyle(
// //                               color: Colors.white,
// //                               fontSize: 16,
// //                             ),
// //                           ),
// //                         SizedBox(height: 8),
// //                         Text(
// //                           post['description'] as String? ?? '',
// //                           style: TextStyle(
// //                             color: Colors.white,
// //                             fontSize: 16,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ],
// //               );
// //             },
// //           ),
// //           // Page indicator
// //           Positioned(
// //             bottom: 16,
// //             left: 0,
// //             right: 0,
// //             child: Center(
// //               child: SmoothPageIndicator(
// //                 controller: _pageController,
// //                 count: widget.posts.length,
// //                 effect: WormEffect(
// //                   dotHeight: 8,
// //                   dotWidth: 8,
// //                   spacing: 8,
// //                   dotColor: Colors.white.withOpacity(0.5),
// //                   activeDotColor: Colors.white,
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../components/interaction_service.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}



class _FeedPageState extends State<FeedPage> {

  List<SwipeItem> swipeItems = [];
  MatchEngine? matchEngine;
  bool isLoading = true;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _loadUserFeeds();
  }

  // Future<void> _loadUserFeeds() async {
  //   if (currentUserId == null) {
  //     // Handle case where user is not logged in
  //     setState(() {
  //       isLoading = false;
  //     });
  //     return;
  //   }
  //
  //   try {
  //     // First, get the list of already liked/disliked users
  //     final likedUsersSnapshot = await _firestore
  //         .collection('users')
  //         .doc(currentUserId)
  //         .collection('liked_users')
  //         .get();
  //
  //     final dislikedUsersSnapshot = await _firestore
  //         .collection('users')
  //         .doc(currentUserId)
  //         .collection('disliked_users')
  //         .get();
  //
  //     // Create sets of liked and disliked user IDs
  //     final likedUserIds = likedUsersSnapshot.docs.map((doc) => doc.id).toSet();
  //     final dislikedUserIds = dislikedUsersSnapshot.docs.map((doc) => doc.id).toSet();
  //
  //     // Get users who haven't been liked or disliked yet
  //     final usersSnapshot = await _firestore
  //         .collection('users')
  //         .where(FieldPath.documentId, isNotEqualTo: currentUserId)
  //         .get();
  //
  //     List<Future<Map>> userFeedsFutures = usersSnapshot.docs
  //         .where((doc) => !likedUserIds.contains(doc.id) && !dislikedUserIds.contains(doc.id))
  //         .map((userDoc) async {
  //       try {
  //         // Get user's profile data
  //         final userData = userDoc.data();
  //
  //         // Get user's feed posts
  //         final feedSnapshot = await _firestore
  //             .collection('users')
  //             .doc(userDoc.id)
  //             .collection('feed')
  //             .orderBy('uploadedAt', descending: true)
  //             .get();
  //
  //         List<Map<String, dynamic>> posts = feedSnapshot.docs.map((doc) {
  //           final data = doc.data();
  //           return {
  //             'postId': doc.id,
  //             'imageUrl': data['imageUrl'] ?? '',
  //             'description': data['description'] ?? '',
  //             'uploadedAt': data['uploadedAt'],
  //           };
  //         }).toList();
  //
  //         if (posts.isNotEmpty) {
  //           return {
  //             'userId': userDoc.id,
  //             'name': userData['name'] ?? 'Unknown',
  //             'age': userData['age']?.toString() ?? '',
  //             'location': userData['location'] ?? '',
  //             'posts': posts,
  //           };
  //         }
  //       } catch (e) {
  //         print('Error loading feed for user ${userDoc.id}: $e');
  //       }
  //       return {};
  //     }).toList();
  //
  //     final userFeeds = await Future.wait(userFeedsFutures);
  //
  //     if (mounted) {
  //       setState(() {
  //         swipeItems = userFeeds
  //             .where((feed) => feed.isNotEmpty)
  //             .map((userFeed) => SwipeItem(
  //           content: userFeed,
  //           likeAction: () => _handleLike(userFeed['userId']),
  //           nopeAction: () => _handleNope(userFeed['userId']),
  //           superlikeAction: () => _handleSuperLike(userFeed['userId']),
  //         ))
  //             .toList();
  //
  //         matchEngine = MatchEngine(swipeItems: swipeItems);
  //         isLoading = false;
  //       });
  //     }
  //   } catch (e) {
  //     print('Error loading feeds: $e');
  //     if (mounted) {
  //       setState(() {
  //         isLoading = false;
  //       });
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Failed to load feeds. Please try again.')),
  //       );
  //     }
  //   }
  // }
  // Future<void> _loadUserFeeds() async {
  //   if (currentUserId == null) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     return;
  //   }
  //
  //   try {
  //     // Get liked users without ordering
  //     final likedUsersSnapshot = await _firestore
  //         .collection('users')
  //         .doc(currentUserId)
  //         .collection('liked_users')
  //         .get();
  //
  //     final dislikedUsersSnapshot = await _firestore
  //         .collection('users')
  //         .doc(currentUserId)
  //         .collection('disliked_users')
  //         .get();
  //
  //     // Create sets of liked and disliked user IDs
  //     final likedUserIds = likedUsersSnapshot.docs.map((doc) => doc.id).toSet();
  //     final dislikedUserIds = dislikedUsersSnapshot.docs.map((doc) => doc.id).toSet();
  //
  //     // Get all users except current user
  //     final usersSnapshot = await _firestore
  //         .collection('users')
  //         .where(FieldPath.documentId, isNotEqualTo: currentUserId)
  //         .get();
  //
  //     // Filter out liked and disliked users
  //     final availableUsers = usersSnapshot.docs
  //         .where((doc) =>
  //     !likedUserIds.contains(doc.id) &&
  //         !dislikedUserIds.contains(doc.id));
  //
  //     List<Future<Map>> userFeedsFutures =
  //     availableUsers.map((userDoc) async {
  //       try {
  //         // Get user profile data
  //         final userData = userDoc.data();
  //
  //         // Get user's feed posts
  //         final feedSnapshot = await _firestore
  //             .collection('users')
  //             .doc(userDoc.id)
  //             .collection('feed')
  //             .orderBy('uploadedAt', descending: true)
  //             .get();
  //
  //         if (feedSnapshot.docs.isNotEmpty) {
  //           return {
  //             'userId': userDoc.id,
  //             'name': userData['name'] ?? 'Unknown',
  //             'age': userData['age']?.toString() ?? '',
  //             'location': userData['location'] ?? '',
  //             'posts': feedSnapshot.docs.map((doc) => {
  //               'postId': doc.id,
  //               'imageUrl': doc.data()['imageUrl'] ?? '',
  //               'description': doc.data()['description'] ?? '',
  //               'uploadedAt': doc.data()['uploadedAt'],
  //             }).toList(),
  //           };
  //         }
  //       } catch (e) {
  //         print('Error loading feed for user ${userDoc.id}: $e');
  //       }
  //       return {};
  //     }).toList();
  //
  //     final userFeeds = await Future.wait(userFeedsFutures);
  //
  //     if (mounted) {
  //       setState(() {
  //         swipeItems = userFeeds
  //             .where((feed) => feed.isNotEmpty)
  //             .map((userFeed) => SwipeItem(
  //           content: userFeed,
  //           likeAction: () => _handleLike(userFeed['userId']),
  //           nopeAction: () => _handleNope(userFeed['userId']),
  //         ))
  //             .toList();
  //
  //         matchEngine = MatchEngine(swipeItems: swipeItems);
  //         isLoading = false;
  //       });
  //     }
  //   } catch (e) {
  //     print('Error loading feeds: $e');
  //     if (mounted) {
  //       setState(() {
  //         isLoading = false;
  //       });
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Failed to load feeds. Please try again.')),
  //       );
  //     }
  //   }
  // }
  //
  //
  // // Add this at the top of your FeedPage class
  // final InteractionService _interactionService = InteractionService();
  //
  // Future<void> _handleLike(String userId) async {
  //   try {
  //     final userFeed = swipeItems
  //         .firstWhere((item) => (item.content as Map<String, dynamic>)['userId'] == userId)
  //         .content as Map<String, dynamic>;
  //
  //     await _interactionService.recordLike(
  //       userId,
  //       userFeed['name'] ?? 'Unknown',
  //       userFeed['profileImage'] ?? '', // Make sure this matches your data structure
  //     );
  //
  //     // Check for match
  //     final otherUserLike = await _firestore
  //         .collection('users')
  //         .doc(userId)
  //         .collection('liked_by')
  //         .doc(currentUserId)
  //         .get();
  //
  //     if (otherUserLike.exists) {
  //       await _createMatch(userId);
  //       _showMatchDialog(userId);
  //     }
  //   } catch (e) {
  //     print('Error handling like: $e');
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Failed to like profile. Please try again.')),
  //       );
  //     }
  //   }
  // }
  //
  // Future<void> _handleNope(String userId) async {
  //   try {
  //     final userFeed = swipeItems
  //         .firstWhere((item) => (item.content as Map<String, dynamic>)['userId'] == userId)
  //         .content as Map<String, dynamic>;
  //
  //     await _interactionService.recordDislike(
  //       userId,
  //       userFeed['name'] ?? 'Unknown',
  //       userFeed['profileImage'] ?? '', // Make sure this matches your data structure
  //     );
  //   } catch (e) {
  //     print('Error handling dislike: $e');
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Failed to skip profile. Please try again.')),
  //       );
  //     }
  //   }
  // }

  // Future<void> _loadUserFeeds() async {
  //   if (currentUserId == null) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     return;
  //   }
  //
  //   try {
  //     // Get all users except the current user
  //     final usersSnapshot = await _firestore
  //         .collection('users')
  //         .where(FieldPath.documentId, isNotEqualTo: currentUserId)
  //         .get();
  //
  //
  //     List<Future<Map>> userFeedsFutures = usersSnapshot.docs.map((userDoc) async {
  //       try {
  //         // Get user profile data
  //         final userData = userDoc.data();
  //
  //         // Get user's feed posts
  //         final feedSnapshot = await _firestore
  //             .collection('users')
  //             .doc(userDoc.id)
  //             .collection('feed')
  //             .orderBy('uploadedAt', descending: true)
  //             .get();
  //
  //
  //         if (feedSnapshot.docs.isNotEmpty) {
  //           return {
  //             'userId': userDoc.id,
  //             'name': userData['name'] ?? 'Unknown',
  //             'age': userData['age']?.toString() ?? '',
  //             'location': userData['location'] ?? '',
  //             'profileImage': userData['profileImage'] ?? '', // Add profile image here
  //             'posts': feedSnapshot.docs.map((doc) => {
  //               'postId': doc.id,
  //               'imageUrl': doc.data()['imageUrl'] ?? '',
  //               'description': doc.data()['description'] ?? '',
  //               'uploadedAt': doc.data()['uploadedAt'],
  //             }).toList(),
  //           };
  //         }
  //       } catch (e) {
  //         print('Error loading feed for user ${userDoc.id}: $e');
  //       }
  //       return {};
  //     }).toList();
  //
  //     final userFeeds = await Future.wait(userFeedsFutures);
  //
  //     final likedUsersSnapshot = await _firestore
  //         .collection('users')
  //         .doc(currentUserId)
  //         .collection('liked_users')
  //         .get();
  //     final dislikedUsersSnapshot = await _firestore
  //         .collection('users')
  //         .doc(currentUserId)
  //         .collection('disliked_users')
  //         .get();
  //     final likedUserIds = likedUsersSnapshot.docs.map((doc) => doc.id).toSet();
  //     final dislikedUserIds = dislikedUsersSnapshot.docs.map((doc) => doc.id).toSet();
  //
  //
  //     if (mounted) {
  //       setState(() {
  //         swipeItems = userFeeds
  //             .where((feed) => feed.isNotEmpty &&
  //             !likedUserIds.contains(feed['userId']) &&
  //             !dislikedUserIds.contains(feed['userId'])
  //         )
  //             .map((userFeed) => SwipeItem(
  //           content: userFeed,
  //           likeAction: () => _handleLike(userFeed['userId']),
  //           nopeAction: () => _handleNope(userFeed['userId']),
  //         ))
  //             .toList();
  //         matchEngine = MatchEngine(swipeItems: swipeItems);
  //         isLoading = false;
  //       });
  //     }
  //   } catch (e) {
  //     print('Error loading feeds: $e');
  //     if (mounted) {
  //       setState(() {
  //         isLoading = false;
  //       });
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Failed to load feeds. Please try again.')),
  //       );
  //     }
  //   }
  // }

  Future<void> _loadUserFeeds() async {
    if (currentUserId == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      // Get all users except the current user
      final usersSnapshot = await _firestore
          .collection('users')
          .where(FieldPath.documentId, isNotEqualTo: currentUserId)
          .get();


      List<Future<Map>> userFeedsFutures = usersSnapshot.docs.map((userDoc) async {
        try {
          // Get user profile data
          final userData = userDoc.data();

          // Get user's feed posts
          final feedSnapshot = await _firestore
              .collection('users')
              .doc(userDoc.id)
              .collection('feed')
              .orderBy('uploadedAt', descending: true)
              .get();


          if (feedSnapshot.docs.isNotEmpty) {
            return {
              'userId': userDoc.id,
              'name': userData['name'] ?? 'Unknown',
              'age': userData['age']?.toString() ?? '',
              'location': userData['location'] ?? '',
              'profileImage': userData['profileImage'] ?? '', // Add profile image here
              'posts': feedSnapshot.docs.map((doc) => {
                'postId': doc.id,
                'imageUrl': doc.data()['imageUrl'] ?? '',
                'description': doc.data()['description'] ?? '',
                'uploadedAt': doc.data()['uploadedAt'],
              }).toList(),
            };
          }
        } catch (e) {
          print('Error loading feed for user ${userDoc.id}: $e');
        }
        return {};
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

          // Randomize the order of the swipe items
          swipeItems.shuffle();
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
  final InteractionService _interactionService = InteractionService();
  Future<void> _handleLike(String userId) async {
    try {
      final userFeed = swipeItems
          .firstWhere((item) => (item.content as Map<String, dynamic>)['userId'] == userId)
          .content as Map<String, dynamic>;
      await _interactionService.recordLike(
        userId,
        userFeed['name'] ?? 'Unknown',
        userFeed['profileImage'] ?? '',
      );

      // Check for match
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
        swipeItems.removeWhere((item) => (item.content as Map<String,dynamic>)['userId'] == userId);
        matchEngine = MatchEngine(swipeItems: swipeItems);
      });
    } catch (e) {
      print('Error handling like: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to like profile. Please try again.')),
        );
      }
    }
  }

  Future<void> _handleNope(String userId) async {
    try {
      final userFeed = swipeItems
          .firstWhere((item) => (item.content as Map<String, dynamic>)['userId'] == userId)
          .content as Map<String, dynamic>;

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

  Future<void> _handleSuperLike(String userId) async {
    // Implement super like functionality if needed
    await _handleLike(userId);
  }

  Future<void> _createMatch(String otherUserId) async {
    try {
      final matchRef = _firestore.collection('matches').doc();
      await matchRef.set({
        'users': [currentUserId, otherUserId],
        'timestamp': FieldValue.serverTimestamp(),
        'lastMessage': null,
        'lastMessageTimestamp': null,
      });

      // Add match reference to both users
      final batch = _firestore.batch();
      batch.set(
        _firestore
            .collection('users')
            .doc(currentUserId)
            .collection('matches')
            .doc(matchRef.id),
        {'matchId': matchRef.id},
      );
      batch.set(
        _firestore
            .collection('users')
            .doc(otherUserId)
            .collection('matches')
            .doc(matchRef.id),
        {'matchId': matchRef.id},
      );
      await batch.commit();
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
            TextButton(
              child: Text('Keep Browsing'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('Send Message'),
              onPressed: () {
                Navigator.pop(context);
                // Navigate to chat screen
                // TODO: Implement navigation to chat
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discover'),
        elevation: 0,
      ),
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
                posts: List<Map<String, dynamic>>.from(userFeed['posts'] as List),
                userName: userFeed['name'] as String,
                userAge: userFeed['age'] as String,
                userLocation: userFeed['location'] as String,
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
          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.close, color: Colors.red, size: 32),
                Icon(Icons.favorite, color: Colors.green, size: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserCard extends StatefulWidget {
  final List<Map<String, dynamic>> posts;
  final String userName;
  final String userAge;
  final String userLocation;

  const UserCard({
    Key? key,
    required this.posts,
    required this.userName,
    required this.userAge,
    required this.userLocation,
  }) : super(key: key);

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.posts.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final post = widget.posts[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: post['imageUrl'] as String,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 60,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.userName}, ${widget.userAge}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (widget.userLocation.isNotEmpty)
                          Text(
                            widget.userLocation,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        SizedBox(height: 8),
                        Text(
                          post['description'] as String? ?? '',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: widget.posts.length,
                effect: WormEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  spacing: 8,
                  dotColor: Colors.white.withOpacity(0.5),
                  activeDotColor: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}