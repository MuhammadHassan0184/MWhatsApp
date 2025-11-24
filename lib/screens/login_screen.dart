import 'package:mwhatsapp/controllers/login_controller.dart';
import 'package:mwhatsapp/screens/signup_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = LoginController();

    return Scaffold(
      backgroundColor: const Color(0xFF075E54),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // 🔹 WhatsApp Logo Style
              Center(
                child: Icon(
                  Icons.chat_bubble,
                  size: 90,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),

              const SizedBox(height: 25),

              const Center(
                child: Text(
                  "Welcome Back 👋",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 50),

              _inputField(
                controller.emailController,
                "Email",
                Icons.email_outlined,
              ),

              const SizedBox(height: 20),

              _inputField(
                controller.passwordController,
                "Password",
                Icons.lock_outline,
                isPassword: true,
              ),

              const SizedBox(height: 30),

              // 🔹 LOGIN BUTTON
              InkWell(
                onTap: () => controller.login(context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 17),
                  decoration: BoxDecoration(
                    color: const Color(0xFF25D366),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignupScreen()),
                    );
                  },
                  child: const Text(
                    "Create new account",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField(TextEditingController ctrl, String text, IconData icon,
      {bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: ctrl,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: text,
          prefixIcon: Icon(icon, color: Colors.grey[700]),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        ),
      ),
    );
  }
}
