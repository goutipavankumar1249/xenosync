
import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';
import '../services/feed_service.dart'; // Import the service for fetching posts

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<SwipeItem> swipeItems = [];
  late MatchEngine matchEngine;
  List<Map<String, dynamic>> posts = [];

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  void fetchPosts() async {
    FeedService feedService = FeedService();
    List<Map<String, dynamic>> fetchedPosts = await feedService.fetchAllPosts();
    setState(() {
      posts = fetchedPosts;
      swipeItems = posts
          .map((post) => SwipeItem(
        content: post,
        likeAction: () {
          print("Liked: ${post['postId']}");
        },
        nopeAction: () {
          print("Disliked: ${post['postId']}");
        },
      ))
          .toList();
      matchEngine = MatchEngine(swipeItems: swipeItems);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feed"),
      ),
      body: posts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: SwipeCards(
              matchEngine: matchEngine,
              itemBuilder: (BuildContext context, int index) {
                final post = swipeItems[index].content as Map<String, dynamic>;
                return Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        post['imageUrl'],
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: double.infinity,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          post['description'] ?? '',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              onStackFinished: () {
                print("No more posts!");
              },
              upSwipeAllowed: true,
              fillSpace: true,
            ),
          ),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:swipe_cards/swipe_cards.dart';
//
// class FeedPage extends StatefulWidget {
//   @override
//   _FeedPageState createState() => _FeedPageState();
// }
//
// class _FeedPageState extends State<FeedPage> {
//   List<SwipeItem> swipeItems = [];
//   late MatchEngine matchEngine;
//   List<Map<String, dynamic>> userPosts = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchUserPosts();
//   }
//
//   void fetchUserPosts() async {
//     DatabaseReference database = FirebaseDatabase.instance.ref("users");
//     List<Map<String, dynamic>> users = [];
//
//     try {
//       // Fetching all users
//       DataSnapshot snapshot = await database.get();
//       if (snapshot.exists) {
//         Map<String, dynamic>? usersData = Map<String, dynamic>.from(snapshot.value as Map);
//         usersData.forEach((userId, userData) {
//           if (userData.containsKey("images") && userData["images"] is Map) {
//             // Extracting image URLs
//             Map<dynamic, dynamic> imagesMap = userData["images"];
//             List<String> images = imagesMap.values
//                 .where((image) => image is String)
//                 .map((image) => image as String)
//                 .toList();
//
//             if (images.isNotEmpty) {
//               users.add({
//                 "userId": userId,
//                 "images": images,
//                 "brand": userData["brand"] ?? "Unknown",
//                 "email": userData["email"] ?? "Unknown"
//               });
//             }
//           }
//         });
//       }
//
//       setState(() {
//         userPosts = users;
//         swipeItems = userPosts
//             .map((userPost) => SwipeItem(
//           content: userPost,
//           likeAction: () {
//             print("Liked User: ${userPost['userId']}");
//           },
//           nopeAction: () {
//             print("Disliked User: ${userPost['userId']}");
//           },
//         ))
//             .toList();
//         matchEngine = MatchEngine(swipeItems: swipeItems);
//       });
//     } catch (e) {
//       print("Error fetching user posts: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Feed"),
//       ),
//       body: userPosts.isEmpty
//           ? Center(child: CircularProgressIndicator())
//           : SwipeCards(
//         matchEngine: matchEngine,
//         itemBuilder: (BuildContext context, int index) {
//           final userPost = swipeItems[index].content as Map<String, dynamic>;
//           return _buildUserCard(userPost);
//         },
//         onStackFinished: () {
//           print("No more posts!");
//         },
//         upSwipeAllowed: true,
//         fillSpace: true,
//       ),
//     );
//   }
//
//   Widget _buildUserCard(Map<String, dynamic> userPost) {
//     List<String> images = userPost['images'];
//     return Card(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: PageView.builder(
//               itemCount: images.length,
//               itemBuilder: (context, index) {
//                 return Image.network(
//                   images[index],
//                   fit: BoxFit.cover,
//                   height: MediaQuery.of(context).size.height * 0.5,
//                   width: double.infinity,
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               userPost['brand'] ?? "Unknown Brand",
//               style: TextStyle(
//                 fontSize: 18.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: Text(
//               "Email: ${userPost['email'] ?? "Unknown"}",
//               style: TextStyle(fontSize: 16.0),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
