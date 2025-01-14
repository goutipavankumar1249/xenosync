import 'package:firebase_database/firebase_database.dart';

class FeedService {
  final DatabaseReference _databaseReference =
  FirebaseDatabase.instance.reference().child('users');

  // Method to fetch posts (images) from all users
  Future<List<Map<String, dynamic>>> fetchAllPosts() async {
    List<Map<String, dynamic>> posts = [];

    try {
      // Get the 'users' node from Firebase
      DatabaseEvent usersEvent = await _databaseReference.once();
      DataSnapshot usersSnapshot = usersEvent.snapshot; // Get the snapshot from the event

      if (usersSnapshot.value != null) {
        // Cast the snapshot value to a Map<String, dynamic>
        Map<String, dynamic> users = Map<String, dynamic>.from(usersSnapshot.value as Map);

        // Iterate through each user and fetch their images
        for (var userId in users.keys) {
          DatabaseReference imagesRef = _databaseReference.child(userId).child('images');

          // Fetch the images sub-collection for each user
          DatabaseEvent imagesEvent = await imagesRef.once();
          DataSnapshot imagesSnapshot = imagesEvent.snapshot;

          if (imagesSnapshot.value != null) {
            // Cast the snapshot value to a Map<String, dynamic>
            Map<String, dynamic> images = Map<String, dynamic>.from(imagesSnapshot.value as Map);

            // Iterate through each image in the images sub-collection
            images.forEach((imageId, imageData) {
              posts.add({
                'imageUrl': imageData['imageUrl'], // Image URL
                'description': imageData['description'], // Description
                'userId': userId, // Optional: Store user ID to track which user the image belongs to
              });
            });
          }
        }
      }
    } catch (error) {
      print("Error fetching posts: $error");
    }

    return posts;
  }
}
