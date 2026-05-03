import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String? id;
  final String senderId;
  final String receiverId;
  final String text;
  final String imageUrl;
  final bool isRead;
  final DateTime timestamp;

  Message({
    this.id,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.imageUrl,
    required this.isRead,
    required this.timestamp,
  });

  factory Message.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Message(
      id: doc.id,
      senderId: data['senderId'] ?? '',
      receiverId: data['receiverId'] ?? '',
      text: data['text'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      isRead: data['read'] ?? false,
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'imageUrl': imageUrl,
      'read': isRead,
      'timestamp': FieldValue.serverTimestamp(),
      'message': text, // For cross-app compatibility as per plan
    };
  }
}
