import 'package:chat_app/widgets/chat_message.dart';
import 'package:chat_app/widgets/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void setUpNotification() async {
    final fmsg = FirebaseMessaging.instance;
    await fmsg.requestPermission();
    final token = await fmsg.getToken();
    fmsg.subscribeToTopic('chat');
  }

  @override
  void initState() {
    super.initState();
    setUpNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Chat'),
        actions: [
          IconButton(
            onPressed: FirebaseAuth.instance.signOut,
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Center(
          child: Column(
        children: [
          Expanded(
            child: SafeArea(child: const ChatMessages()),
          ),
          NewMessage(),
        ],
      )),
    );
  }
}
