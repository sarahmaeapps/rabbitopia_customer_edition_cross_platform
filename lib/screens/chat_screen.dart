import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/message.dart';
import '../widgets/web_safe_image.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _firestore = FirestoreService();
  final _picker = ImagePicker();
  final _storage = FirebaseStorage.instance;
  File? _selectedImage;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final user = Provider.of<AuthService>(context, listen: false).currentUser;
    if (user == null) return;

    bool canSend = await _firestore.canSendImage(user.email ?? '');
    if (!canSend) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You can only send one image per hour.')),
        );
      }
      return;
    }

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      _showImagePreview();
    }
  }

  void _showImagePreview() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Image?'),
        content: Image.file(_selectedImage!),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _sendImage();
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  Future<void> _sendImage() async {
    if (_selectedImage == null) return;
    final user = Provider.of<AuthService>(context, listen: false).currentUser;
    if (user == null) return;

    setState(() => _isUploading = true);
    try {
      String fileName = 'chat_images/${user.email}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference ref = _storage.ref().child(fileName);
      UploadTask uploadTask = ref.putFile(_selectedImage!);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      final newMessage = Message(
        senderId: user.email ?? 'anonymous',
        receiverId: 'rabbitopiafarm@gmail.com',
        text: 'Sent an image',
        imageUrl: downloadUrl,
        isRead: false,
        timestamp: DateTime.now(),
      );

      await _firestore.sendMessage(user.email ?? '', newMessage);
      setState(() => _selectedImage = null);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isUploading = false);
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final user = Provider.of<AuthService>(context, listen: false).currentUser;
    final newMessage = Message(
      senderId: user?.email ?? 'anonymous',
      receiverId: 'rabbitopiafarm@gmail.com',
      text: _messageController.text.trim(),
      imageUrl: '',
      isRead: false,
      timestamp: DateTime.now(),
    );

    _firestore.sendMessage(user?.email ?? '', newMessage);
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context).currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Chat with Rabbitopia')),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fur.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Message>>(
                stream: _firestore.getChatMessages(user?.email ?? ''),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                  final messages = snapshot.data!;
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isMe = msg.senderId == user?.email;
                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blueAccent.withOpacity(0.8) : Colors.grey.shade800.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Column(
                            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              if (msg.imageUrl.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: WebSafeImage(imageUrl: msg.imageUrl, height: 200, fit: BoxFit.cover),
                                  ),
                                ),
                              Text(msg.text, style: const TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            if (_isUploading) const LinearProgressIndicator(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              color: Colors.black87,
              child: SafeArea(
                child: Row(
                  children: [
                    IconButton(icon: const Icon(Icons.image, color: Colors.blueAccent), onPressed: _pickImage),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: const TextStyle(color: Colors.white54),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade900,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                      ),
                    ),
                    IconButton(icon: const Icon(Icons.send, color: Colors.blueAccent), onPressed: _sendMessage),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
