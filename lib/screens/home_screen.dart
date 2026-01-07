import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mwhatsapp/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPage = 0;

  final TextEditingController _searchController = TextEditingController();
  String searchText = "";

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final currentUser = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      backgroundColor: const Color(0xff0B0B0B),

      // -------------------------
      // APP BAR LIKE WHATSAPP
      // -------------------------
      appBar: AppBar(
        backgroundColor: const Color(0xff0B0B0B),
        elevation: 0,
        titleSpacing: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 28),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          "Chats",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,

        actions: [
          IconButton(
            icon: const Icon(
              Icons.camera_alt_outlined,
              color: Colors.white,
              size: 26,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.add_circle, color: Colors.green, size: 30),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),

      // DRAWER
      drawer: Drawer(
        backgroundColor: const Color(0xff1A1A1A),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.black),
              child: const Center(
                child: Text(
                  "Menu",
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.person, color: Colors.white),
              title: const Text(
                "Profile",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {},
            ),

            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text(
                "Settings",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {},
            ),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: () async {
                final shouldLogout = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text(
                      "Logout",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    content: const Text("Are you sure you want to logout?"),
                    actions: [
                      TextButton(
                        child: const Text("Cancel"),
                        onPressed: () => Navigator.pop(context, false),
                      ),
                      TextButton(
                        child: const Text(
                          "Logout",
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () => Navigator.pop(context, true),
                      ),
                    ],
                  ),
                );

                if (shouldLogout == true) {
                  // Firebase logout
                  await FirebaseAuth.instance.signOut();

                  // Navigate to LoginScreen
                  // ignore: use_build_context_synchronously
                  Navigator.pushAndRemoveUntil(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),

      // -------------------------
      // BODY
      // -------------------------
      body: Column(
        children: [
          // SEARCH BAR
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            // height: 35,
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white54, fontSize: 14),
              onChanged: (value) {
                setState(() {
                  searchText = value.toLowerCase();
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide.none),
                prefixIcon: Icon(Icons.search, color: Colors.white),
                hintText: "Ask Meta AI or Search",
                hintStyle: TextStyle(color: Colors.white54, fontSize: 15),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ARCHIVED
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: const [
                Icon(Icons.archive_outlined, color: Colors.white54),
                SizedBox(width: 12),
                Text(
                  "Archived",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                Spacer(),
                Text(
                  "1",
                  style: TextStyle(color: Colors.white54, fontSize: 16),
                ),
              ],
            ),
          ),

          SizedBox(height: 16),

          // -----------------------------------
          // 🔥 FIRESTORE USER LIST (CHAT LIST)
          // -----------------------------------
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              if (!snapshot.hasData) {
                return const Center(
                  child: Text(
                    "No Users Found",
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                );
              }

              final currentUserId = FirebaseAuth.instance.currentUser!.uid;

              // FILTER OUT LOGGED IN USER
              final users = snapshot.data!.docs.where((doc) {
                if (doc['uid'] == currentUserId) return false;

                final name = doc['name'].toString().toLowerCase();
                final email = doc['email'].toString().toLowerCase();

                return name.contains(searchText) || email.contains(searchText);
              }).toList();

              if (users.isEmpty) {
                return const Center(
                  child: Text(
                    "No Users Found",
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                );
              }

              return Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    var data = users[index];

                    return Dismissible(
                      key: ValueKey(data['uid']),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        color: Colors.green,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.archive, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              "Archive",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      confirmDismiss: (direction) async {
                        // Prevent auto delete
                        return false;
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, color: Colors.black),
                        ),
                        title: Text(
                          data['name'],
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        subtitle: Text(
                          data['email'],
                          style: TextStyle(color: Colors.white54, fontSize: 14),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatScreen(
                                receiverId: data['uid'],
                                receiverEmail: data['email'],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),

      // -------------------------
      // BOTTOM NAV BAR
      // -------------------------
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        iconSize: 30,
        backgroundColor: const Color(0xff0B0B0B),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
        onTap: (value) {
          setState(() {
            currentPage = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: "Chats",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.update_outlined),
            label: "Updates",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call_outlined),
            label: "Calls",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_outlined),
            label: "Communities",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
