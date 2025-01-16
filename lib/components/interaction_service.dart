import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'interaction.dart';

class InteractionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

  // Record when current user likes someone
  Future<void> recordLike(String likedUserId, String likedUserName, String likedUserImage) async {
    final batch = _firestore.batch();

    // Add to current user's "liked" collection
    batch.set(
      _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('liked_users')
          .doc(likedUserId),
      {
        'userId': likedUserId,
        'userName': likedUserName,
        'userImage': likedUserImage,
        'timestamp': FieldValue.serverTimestamp(),
        'interactionType': 'like',
      },
    );

    // Add to other user's "liked_by" collection
    batch.set(
      _firestore
          .collection('users')
          .doc(likedUserId)
          .collection('liked_by')
          .doc(currentUserId),
      {
        'userId': currentUserId,
        'timestamp': FieldValue.serverTimestamp(),
        'interactionType': 'like',
      },
    );

    await batch.commit();
  }

  // Record when current user dislikes someone
  Future<void> recordDislike(String dislikedUserId, String dislikedUserName, String dislikedUserImage) async {
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('disliked_users')
        .doc(dislikedUserId)
        .set({
      'userId': dislikedUserId,
      'userName': dislikedUserName,
      'userImage': dislikedUserImage,
      'timestamp': FieldValue.serverTimestamp(),
      'interactionType': 'dislike',
    });
  }

  // Get users who liked current user
  Stream<List<UserInteraction>> getLikedByStream() {
    return _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('liked_by')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      List<UserInteraction> interactions = [];

      for (var doc in snapshot.docs) {
        // Get the user details who liked current user
        final userDoc = await _firestore
            .collection('users')
            .doc(doc.data()['userId'])
            .get();

        if (userDoc.exists) {
          interactions.add(
            UserInteraction(
              userId: doc.data()['userId'],
              userName: userDoc.data()?['name'] ?? 'Unknown',
              userImage: userDoc.data()?['profileImage'] ?? '',
              interactionType: 'like',
              timestamp: (doc.data()['timestamp'] as Timestamp).toDate(),
            ),
          );
        }
      }

      return interactions;
    });
  }

  // Get users current user liked
  Stream<List<UserInteraction>> getLikedUsersStream() {
    return _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('liked_users')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => UserInteraction.fromMap(doc.data()))
        .toList());
  }

  // Get users current user disliked
  Stream<List<UserInteraction>> getDislikedUsersStream() {
    return _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('disliked_users')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => UserInteraction.fromMap(doc.data()))
        .toList());
  }
}
