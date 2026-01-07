// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'chat_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class ArchiveScreen extends StatelessWidget {
//   const ArchiveScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final currentUserId = FirebaseAuth.instance.currentUser!.uid;

//     return Scaffold(
//       backgroundColor: Color(0xff0B0B0B),
//       appBar: AppBar(
//         backgroundColor: Color(0xff0B0B0B),
//         title: Text("Archived", style: TextStyle(color: Colors.white)),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('users')
//             .snapshots(), // get users
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(color: Colors.white),
//             );
//           }

//           if (!snapshot.hasData) {
//             return const Center(
//               child: Text(
//                 "No Archived Chats",
//                 style: TextStyle(color: Colors.white54),
//               ),
//             );
//           }

//           final users = snapshot.data!.docs.where((doc) => doc['uid'] != currentUserId);

//           return ListView(
//             children: users.map((data) {
//               String chatId = generateChatId(currentUserId, data['uid']);
//               return StreamBuilder<DocumentSnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection('chats')
//                     .doc(chatId)
//                     .snapshots(),
//                 builder: (context, chatSnapshot) {
//                   if (!chatSnapshot.hasData || !chatSnapshot.data!.exists) {
//                     return SizedBox.shrink();
//                   }

//                   final chatData = chatSnapshot.data!.data() as Map<String, dynamic>;
//                   if (chatData['isArchived'] != true) return SizedBox.shrink();

//                   return ListTile(
//                     leading: CircleAvatar(
//                       backgroundColor: Colors.white,
//                       child: Icon(Icons.person, color: Colors.black),
//                     ),
//                     title: Text(data['name'], style: TextStyle(color: Colors.white)),
//                     subtitle: Text(data['email'], style: TextStyle(color: Colors.white54)),
//                     trailing: IconButton(
//                       icon: Icon(Icons.unarchive, color: Colors.green),
//                       onPressed: () {
//                         FirebaseFirestore.instance
//                             .collection('chats')
//                             .doc(chatId)
//                             .update({'isArchived': false});
//                       },
//                     ),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => ChatScreen(
//                             receiverId: data['uid'],
//                             receiverEmail: data['email'],
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               );
//             }).toList(),
//           );
//         },
//       ),
//     );
//   }

//   String generateChatId(String uid1, String uid2) {
//     List<String> ids = [uid1, uid2];
//     ids.sort();
//     return ids.join("_");
//   }
// }
