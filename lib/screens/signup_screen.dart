import 'package:mwhatsapp/controllers/signup_controller.dart';
import 'package:mwhatsapp/screens/login_screen.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SignupController();

    return Scaffold(
      backgroundColor: const Color(0xFF128C7E),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             SizedBox(height: 30),

              Center(
                child: Icon(
                  Icons.person_add,
                  size: 90,
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.9),
                ),
              ),

              const SizedBox(height: 15),

              const Center(
                child: Text(
                  "Create Account ✨",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              _inputField(
                controller.nameController,
                "Full Name",
                Icons.person_outline,
              ),

              const SizedBox(height: 20),

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

              SizedBox(height: 30),

              InkWell(
                onTap: () => controller.signup(context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 17),
                  decoration: BoxDecoration(
                    color: const Color(0xFF25D366),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  child: Text(
                    "Already have an account? Login",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
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
