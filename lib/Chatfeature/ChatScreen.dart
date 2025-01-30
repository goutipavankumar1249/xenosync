// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class ChatScreen extends StatefulWidget {
//   final String currentUserId;
//   final String receiverId;
//   final String receiverName;
//
//   const ChatScreen({
//     Key? key,
//     required this.currentUserId,
//     required this.receiverId,
//     required this.receiverName,
//   }) : super(key: key);
//
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _messageController = TextEditingController();
//
//   String getChatRoomId(String user1, String user2) {
//     if (user1.compareTo(user2) < 0) {
//       return "${user1}_$user2";
//     } else {
//       return "${user2}_$user1";
//     }
//   }
//
//
//   void sendMessage(String message) async {
//     if (message.trim().isEmpty) return;
//
//     final chatRoomId = getChatRoomId(widget.currentUserId, widget.receiverId);
//
//     final messageData = {
//       'sender': widget.currentUserId,
//       'receiver': widget.receiverId,
//       'message': message.trim(),
//       'timestamp': FieldValue.serverTimestamp(),
//     };
//
//     await FirebaseFirestore.instance
//         .collection('chats')
//         .doc(chatRoomId)
//         .collection('messages')
//         .add(messageData);
//
//     _messageController.clear();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final chatRoomId = getChatRoomId(widget.currentUserId, widget.receiverId);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.receiverName),
//         backgroundColor: Colors.blue[100],
//       ),
//       body: Column(
//         children: [
//           // Messages List
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('chats')
//                   .doc(chatRoomId)
//                   .collection('messages')
//                   .orderBy('timestamp', descending: true)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//
//                 if (snapshot.hasError) {
//                   return const Center(child: Text("Something went wrong!"));
//                 }
//
//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return const Center(child: Text("No messages yet."));
//                 }
//
//                 final messages = snapshot.data!.docs;
//
//                 return ListView.builder(
//                   reverse: true,
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     final message = messages[index];
//                     final isMe = message['sender'] == widget.currentUserId;
//
//                     return Align(
//                       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//                         margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                         decoration: BoxDecoration(
//                           color: isMe ? Colors.greenAccent : Colors.white,
//                           borderRadius: BorderRadius.only(
//                             topLeft: const Radius.circular(12),
//                             topRight: const Radius.circular(12),
//                             bottomLeft: isMe ? const Radius.circular(12) : const Radius.circular(0),
//                             bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(12),
//                           ),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.3),
//                               spreadRadius: 1,
//                               blurRadius: 2,
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           crossAxisAlignment:
//                           isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               message['message'],
//                               style: const TextStyle(
//                                 color: Colors.black87,
//                                 fontSize: 16,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               message['timestamp'] != null
//                                   ? DateTime.fromMillisecondsSinceEpoch(
//                                   (message['timestamp'] as Timestamp).millisecondsSinceEpoch)
//                                   .toLocal()
//                                   .toString()
//                                   .substring(11, 16) // Displays time in HH:mm format
//                                   : "Sending...",
//                               style: TextStyle(
//                                 color: Colors.grey[600],
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           // Input Field
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: InputDecoration(
//                       hintText: "Type a message...",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 IconButton(
//                   icon: const Icon(Icons.send, color: Colors.blueAccent),
//                   onPressed: () => sendMessage(_messageController.text),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/agreement/send_agreement_page.dart'; // Import the Agreement Page

class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final String receiverId;
  final String receiverName;

  const ChatScreen({
    Key? key,
    required this.currentUserId,
    required this.receiverId,
    required this.receiverName,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  String getChatRoomId(String user1, String user2) {
    if (user1.compareTo(user2) < 0) {
      return "${user1}_$user2";
    } else {
      return "${user2}_$user1";
    }
  }

  void sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    final chatRoomId = getChatRoomId(widget.currentUserId, widget.receiverId);

    final messageData = {
      'sender': widget.currentUserId,
      'receiver': widget.receiverId,
      'message': message.trim(),
      'timestamp': FieldValue.serverTimestamp(),
    };

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .add(messageData);

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final chatRoomId = getChatRoomId(widget.currentUserId, widget.receiverId);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverName),
        backgroundColor: Colors.blue[100],
        actions: [
          // Agreement Button in Top Right Corner
          IconButton(
            icon: Icon(Icons.assignment, color: Colors.blue), // Agreement Icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SendAgreementPage(
                    currentUserId: widget.currentUserId,  // Logged-in user
                    receiverId: widget.receiverId,  // The user they are chatting with
                  ),
                ),
              );
            },
          ),

        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(chatRoomId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text("Something went wrong!"));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No messages yet."));
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message['sender'] == widget.currentUserId;

                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.greenAccent : Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(12),
                            topRight: const Radius.circular(12),
                            bottomLeft: isMe ? const Radius.circular(12) : const Radius.circular(0),
                            bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(12),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment:
                          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Text(
                              message['message'],
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              message['timestamp'] != null
                                  ? DateTime.fromMillisecondsSinceEpoch(
                                  (message['timestamp'] as Timestamp).millisecondsSinceEpoch)
                                  .toLocal()
                                  .toString()
                                  .substring(11, 16)
                                  : "Sending...",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Input Field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blueAccent),
                  onPressed: () => sendMessage(_messageController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
