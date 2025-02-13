import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/agreement/send_agreement_page.dart'; // Import the Agreement Page
import 'package:intl/intl.dart'; // Add this import

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

    try {
      final messageData = {
        'sender': widget.currentUserId,
        'receiver': widget.receiverId,
        'message': message.trim(),
        'timestamp': FieldValue
            .serverTimestamp(), // Using serverTimestamp for consistency
      };

      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatRoomId)
          .collection('messages')
          .add(messageData);

      _messageController.clear();
    } catch (e) {
      // Handle error silently without showing to user
      print('Error sending message: $e');
    }
  }

  // Helper method to format date
  String _formatMessageDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return 'Today';
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else if (now.difference(messageDate).inDays < 7) {
      return DateFormat('EEEE').format(date); // Returns day name
    } else {
      return DateFormat('MMM d, y').format(date); // Returns "Jan 1, 2024"
    }
  }

  Widget _buildMessagesList(List<QueryDocumentSnapshot> messages) {
    // Group messages by date
    Map<String, List<QueryDocumentSnapshot>> groupedMessages = {};

    for (var message in messages) {
      final timestamp = message['timestamp'];
      if (timestamp == null) continue; // Skip messages with null timestamp

      final date = (timestamp as Timestamp).toDate();
      final dateString = _formatMessageDate(date);

      if (!groupedMessages.containsKey(dateString)) {
        groupedMessages[dateString] = [];
      }
      groupedMessages[dateString]!.add(message);
    }

    // Create list items with date headers
    List<Widget> messageWidgets = [];

    groupedMessages.forEach((date, dateMessages) {
      // Add date header
      messageWidgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE8EFF8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                date,
                style: const TextStyle(
                  color: Color(0xFF081B48),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
          ),
        ),
      );

      // Add messages for this date
      messageWidgets.addAll(
        dateMessages.map((message) {
          final isMe = message['sender'] == widget.currentUserId;
          final timestamp = message['timestamp'];

          return Align(
            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF004DAB), Color(0xFF09163D)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: isMe
                      ? const Radius.circular(12)
                      : const Radius.circular(0),
                  bottomRight: isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(12),
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
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    timestamp != null
                        ? DateFormat('HH:mm')
                            .format((timestamp as Timestamp).toDate())
                        : 'Sending...', // Show 'Sending...' while timestamp is null
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      );
    });

    return ListView(
      reverse: false,
      children: messageWidgets,
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatRoomId = getChatRoomId(widget.currentUserId, widget.receiverId);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverName),
        backgroundColor: Colors.blue[100],
        actions: [
          IconButton(
            icon: const Icon(Icons.assignment, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SendAgreementPage(
                    currentUserId: widget.currentUserId,
                    receiverId: widget.receiverId,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(chatRoomId)
                  .collection('messages')
                  .orderBy('timestamp', descending: false)
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

                return _buildMessagesList(snapshot.data!.docs);
              },
            ),
          ),
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
                        borderSide: const BorderSide(color: Color(0xFF081B48)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF081B48)),
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
