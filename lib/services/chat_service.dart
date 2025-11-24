// // chat_service.dart
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/message_model.dart';

// class ChatService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Send a message
//   Future<void> sendMessage({
//     required String senderId,
//     required String receiverId,
//     required String text,
//   }) async {
//     final messageId = _firestore.collection('messages').doc().id;

//     final message = MessageModel(
//       id: messageId,
//       senderId: senderId,
//       receiverId: receiverId,
//       text: text,
//       timestamp: Timestamp.now(),
//     );

//     await _firestore.collection('messages').doc(messageId).set(message.toMap());
//     print("✅ Message sent from $senderId to $receiverId");
//   }

//   // Stream messages between two users
//   Stream<List<MessageModel>> getMessages(String senderId, String receiverId) {
//     return _firestore
//         .collection('messages')
//         .where('senderId', whereIn: [senderId, receiverId])
//         .where('receiverId', whereIn: [senderId, receiverId])
//         .orderBy('timestamp', descending: false)
//         .snapshots()
//         .map((snapshot) => snapshot.docs
//             .map((doc) => MessageModel.fromMap(doc.data()))
//             .toList());
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Generate unique chat ID for 2 users
  String getChatId(String user1, String user2) {
    List<String> ids = [user1, user2];
    ids.sort();
    return ids.join("_");
  }

  // Send a message
  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String text,
  }) async {
    final chatId = getChatId(senderId, receiverId);

    final message = MessageModel(
      id: _firestore.collection('chats/$chatId/messages').doc().id,
      senderId: senderId,
      receiverId: receiverId,
      text: text,
      timestamp: Timestamp.now(),
    );

    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(message.id)
        .set(message.toMap());
  }

  // Stream messages for this chat
  Stream<List<MessageModel>> getMessages(String senderId, String receiverId) {
    final chatId = getChatId(senderId, receiverId);

    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MessageModel.fromMap(doc.data()))
          .toList();
    });
  }
}
