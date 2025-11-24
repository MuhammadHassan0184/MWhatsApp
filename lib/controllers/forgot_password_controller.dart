// import 'package:flutter/material.dart';
// import '../services/auth_service.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class ForgotPasswordController {
//   final AuthService _authService = AuthService();
//   final emailController = TextEditingController();
//   bool isLoading = false;

//   Future<void> resetPassword(BuildContext context) async {
//     final email = emailController.text.trim();

//     if (email.isEmpty) {
//       _showSnack(context, "⚠️ Please enter your email.");
//       print("⚠️ Email field is empty.");
//       return;
//     }

//     try {
//       isLoading = true;
//       print("🔹 Sending password reset email to $email...");
//       _showSnack(context, "Sending password reset email...");

//       await _authService.forgotPassword(email);

//       print("✅ Password reset email sent to $email");
//       isLoading = false;

//       _showSnack(context, "✅ Password reset email sent! Check your inbox.");
//       Navigator.pop(context); // Go back to login screen

//     } on FirebaseAuthException catch (e) {
//       isLoading = false;

//       // Handle specific Firebase error codes
//       String errorMsg;
//       switch (e.code) {
//         case 'user-not-found':
//           errorMsg = "No user found with this email.";
//           break;
//         case 'invalid-email':
//           errorMsg = "Invalid email address.";
//           break;
//         default:
//           errorMsg = e.message ?? "An unexpected error occurred.";
//       }

//       print("❌ FirebaseAuthException (${e.code}): ${e.message}");
//       _showSnack(context, "❌ $errorMsg");

//     } catch (e) {
//       isLoading = false;
//       print("❌ Unexpected error during reset: $e");
//       _showSnack(context, "Something went wrong: $e");
//     }
//   }

//   void _showSnack(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message, style: const TextStyle(fontSize: 15)),
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.black87,
//       ),
//     );
//   }
// }
