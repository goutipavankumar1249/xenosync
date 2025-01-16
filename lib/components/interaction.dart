import 'package:cloud_firestore/cloud_firestore.dart';

class UserInteraction {
  final String userId;
  final String userName;
  final String userImage;
  final String interactionType;
  final DateTime timestamp;

  UserInteraction({
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.interactionType,
    required this.timestamp,
  });

  factory UserInteraction.fromMap(Map<String, dynamic> map) {
    final timestamp = map['timestamp'];
    return UserInteraction(
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userImage: map['userImage'] ?? '',
      interactionType: map['interactionType'] ?? '',
      timestamp: timestamp != null
          ? (timestamp as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userImage': userImage,
      'interactionType': interactionType,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}