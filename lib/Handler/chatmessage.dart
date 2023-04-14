import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final String otherUserId;

  const ChatScreen({
    Key? key,
    required this.currentUserId,
    required this.otherUserId,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<ChatMessage> _chatMessages = [];
  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      ChatMessage message = ChatMessage(
        sender: widget.currentUserId,
        receiver: widget.otherUserId,
        message: _messageController.text.trim(),
        timestamp: Timestamp.now(),
      );
      _db.collection('messages').add(message.toMap()).then((value) {
        setState(() {
          _chatMessages.add(message);
          _messageController.clear();
        });
      }).catchError((error) {
        debugPrint(error.toString());
      });
    }
  }

  void _getMessages() {
    _db
        .collection('messages')
        .where('sender', isEqualTo: widget.currentUserId)
        .where('receiver', isEqualTo: widget.otherUserId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _chatMessages = snapshot.docs
            .map<ChatMessage>((doc) => ChatMessage.fromMap(doc.data()))
            .toList();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat with ${widget.otherUserId} User"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _chatMessages.length,
              reverse: true,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _chatMessages[index].sender == widget.currentUserId
                        ? Colors.blue[100]
                        : Colors.grey[300],
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Text(_chatMessages[index].message),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration:
                        const InputDecoration(hintText: "Enter a message"),
                  ),
                ),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String sender;
  final String receiver;
  final String message;
  final Timestamp timestamp;

  ChatMessage({
    required this.sender,
    required this.receiver,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'receiver': receiver,
      'message': message,
      'timestamp': timestamp,
    };
  }

  static ChatMessage fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      sender: map['sender'],
      receiver: map['receiver'],
      message: map['message'],
      timestamp: map['timestamp'],
    );
  }
}
