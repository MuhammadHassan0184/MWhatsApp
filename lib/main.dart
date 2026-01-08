// import 'package:mwhatsapp/screens/login_screen.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:mwhatsapp/firebase_options.dart';
// import 'package:flutter/material.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   try {
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//     // ignore: avoid_print
//     print("✅ Firebase initialized successfully.");
//   } catch (e) {
//     // ignore: avoid_print
//     print("❌ Firebase init error: $e");
//   }
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       debugShowCheckedModeBanner: false,
//       // home: HomeScreen(),
//       home: LoginScreen(),
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:mwhatsapp/screens/home_screen.dart';
import 'package:mwhatsapp/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mwhatsapp/firebase_options.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // ignore: avoid_print
    print("✅ Firebase initialized successfully.");
  } catch (e) {
    // ignore: avoid_print
    print("❌ Firebase init error: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,

      // 🔥 ONLY THIS PART IS CHANGED
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Waiting for Firebase
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // User already logged in
          if (snapshot.hasData) {
            return const HomeScreen();
          }

          // User not logged in
          return const LoginScreen();
        },
      ),

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }
}
