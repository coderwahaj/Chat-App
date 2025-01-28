import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});
  @override
  State<NewMessage> createState() {
    return _StateNewMessage();
  }
}

class _StateNewMessage extends State<NewMessage> {
 final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
void _sendMessage() async {
  final enteredMessage = _messageController.text;

  if (enteredMessage.trim().isEmpty) {
    return;
  }

  FocusScope.of(context).unfocus();
  _messageController.clear();

  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('No authenticated user found.');
    }

   final userData = await FirebaseFirestore.instance
    .collection('users')
    .doc(user.uid)
    .get();

if (!userData.exists || !userData.data()!.containsKey('username')) {
  print('User data retrieval failed or username field is missing.');
  return;
}
print('User data retrieved: ${userData.data()}');


    if (!userData.exists || !userData.data()!.containsKey('username')) {
      throw Exception('User data is incomplete. "username" field is missing.');
    }

    await FirebaseFirestore.instance.collection('chat').add({
      'text': enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData.data()!['username'],
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Message sent successfully!')),
    );
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to send message: $error')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: _messageController,
            textCapitalization: TextCapitalization.sentences,
            autocorrect: true,
            enableSuggestions: true,
            decoration: const InputDecoration(labelText: 'Send message...'),
          )),
          IconButton(
            onPressed: _sendMessage,
            icon: const Icon(Icons.send),
          )
        ],
      ),
    );
  }
}
