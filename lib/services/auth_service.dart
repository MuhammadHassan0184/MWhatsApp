
// ignore_for_file: avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ============================
  /// SIGNUP
  /// ============================
  Future<User?> signup(String fullName, String email, String password) async {
    try {
      print("🔹 Creating Firebase user...");
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        print("🔹 Saving user to Firestore...");
        await _firestore.collection("users").doc(user.uid).set({
          "uid": user.uid,
          "name": fullName,
          "email": email,
          "createdAt": DateTime.now(),
        });

        print("✅ Signup success");
        return user;
      } else {
        print("❌ User is null after signup");
        return null;
      }
    } catch (e) {
      print("❌ Signup error: $e");
      rethrow;
    }
  }

  /// ============================
  /// LOGIN
  /// ============================
  Future<UserCredential> login(String email, String password) async {
    print("🔹 Logging in user...");
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// ============================
  /// LOGOUT
  /// ============================
  Future<void> logout() async {
    print("🔹 Logging out user...");
    await _auth.signOut();
  }

  /// ============================
  /// FORGOT PASSWORD
  /// ============================
  Future<void> forgotPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}



