import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mwhatsapp/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverEmail;

  const ChatScreen({
    super.key,
    required this.receiverId,
    required this.receiverEmail,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late String chatId;

  @override
  void initState() {
    super.initState();

    // CREATE UNIQUE CHAT ID
    String currentUid = _auth.currentUser!.uid;
    List<String> ids = [currentUid, widget.receiverId];
    ids.sort();
    chatId = ids.join("_");
  }

  // SEND MESSAGE
  Future<void> sendMessage() async {
    String msg = _messageController.text.trim();
    if (msg.isEmpty) return;

    await _firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .add({
      "senderId": _auth.currentUser!.uid,
      "receiverId": widget.receiverId,
      "message": msg,
      "timestamp": FieldValue.serverTimestamp(),
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    String currentUid = _auth.currentUser!.uid;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 26, 26, 26),
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    );
        }, icon: Icon(Icons.arrow_back, color: Colors.white,)),
        title: Text(widget.receiverEmail, style: TextStyle(color: Colors.white),),
        backgroundColor: const Color(0xff0B0B0B),
      ),

      body: Column(
        children: [
          // ==========================
          //     MESSAGES LIST
          // ==========================
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection("chats")
                  .doc(chatId)
                  .collection("messages")
                  .orderBy("timestamp", descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                // --------------------
                // FIX: Prevent loading loop
                // --------------------
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // --------------------
                // FIX: Snapshot has NO data
                // --------------------
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text("No messages yet"),
                  );
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final data = messages[index].data() as Map<String, dynamic>;
                    final bool isMe = data["senderId"] == currentUid;

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.teal : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          data["message"],
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // ==========================
          //     MESSAGE INPUT
          // ==========================
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            color: const Color(0xff0B0B0B),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Message...",
                      hintStyle: TextStyle(
                        color: Colors.white
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 69, 69, 69),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: Colors.teal,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

