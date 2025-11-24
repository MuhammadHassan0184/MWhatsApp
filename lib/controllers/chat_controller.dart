// chat_controller.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/chat_service.dart';
import '../models/message_model.dart';

class ChatController {
  final ChatService _chatService = ChatService();
  final TextEditingController messageController = TextEditingController();

  Stream<List<MessageModel>> getMessages(String receiverId) {
    final currentUser = FirebaseAuth.instance.currentUser!;
    return _chatService.getMessages(currentUser.uid, receiverId);
  }

  Future<void> sendMessage(String receiverId) async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    final currentUser = FirebaseAuth.instance.currentUser!;
    await _chatService.sendMessage(
      senderId: currentUser.uid,
      receiverId: receiverId,
      text: text,
    );

    messageController.clear();
  }
}
