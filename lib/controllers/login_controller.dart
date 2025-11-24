// ignore_for_file: avoid_print


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mwhatsapp/screens/home_screen.dart';
import '../services/auth_service.dart';

class LoginController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> login(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    print("🔹 Starting login process...");
    print("🔹 Attempting login for $email");

    if (email.isEmpty || password.isEmpty) {
      print("⚠️ Missing email or password");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter email and password")),
      );
      return;
    }

    isLoading = true;
    try {
      // ✅ AuthService returns UserCredential
      UserCredential userCredential = await AuthService().login(email, password);

      print("✅ Login successful: ${userCredential.user?.uid}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Welcome back, ${userCredential.user?.email}!")),
      );

      // 👇 Navigate to HomeScreen after success
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      print("❌ FirebaseAuthException during login: ${e.code} — ${e.message}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: ${e.message}")),
      );
    } catch (e) {
      print("❌ Unknown error during login: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: $e")),
      );
    } finally {
      isLoading = false;
    }
  }
}
