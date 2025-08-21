import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'SignUp.dart';
import 'HomeScreen.dart';
import 'theme_provider.dart';

class WelcomePage extends StatelessWidget {
  WelcomePage({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    Color primaryColor = const Color(0xFF6366F1);
    Color bgColor = isDark ? Colors.black : Colors.white;
    Color textColor = isDark ? Colors.white : const Color(0xFF1F2937);
    Color hintColor = isDark ? Colors.white54 : const Color(0xFFD1D5DB);
    Color subTextColor = isDark ? Colors.white70 : const Color(0xFF6B7280);

    void signIn() async {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));

      } on FirebaseAuthException catch (e) {
        String message = 'An unknown error occurred.';

        if (e.code == 'user-not-found') {
          message = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          message = 'Wrong password provided for that user.';
        } else if (e.code == 'invalid-email') {
          message = 'The email address is not valid.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: bgColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [BoxShadow(color: primaryColor.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
                      ),
                      child: const Center(child: Icon(Icons.psychology_outlined, size: 35, color: Colors.white)),
                    ),
                    const SizedBox(height: 20),
                    Text("Welcome!", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textColor)),
                    const SizedBox(height: 5),
                    Text("Sign in to continue", style: TextStyle(fontSize: 16, color: subTextColor)),
                  ],
                ),
                const SizedBox(height: 40),
                buildTextField(emailController, Icons.person_outline, "malak@gmail.com", hintColor, isDark),
                const SizedBox(height: 16),
                buildTextField(passwordController, Icons.lock_outline, "••••••", hintColor, isDark, obscure: true),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text("Forgot password?", style: TextStyle(color: Color(0xFFEF4444), fontSize: 14, fontWeight: FontWeight.w500)),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: signIn, // استدعاء دالة تسجيل الدخول
                    child: const Text("Sign in", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(child: Divider(color: subTextColor, thickness: 1)),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text("OR", style: TextStyle(color: subTextColor))),
                    Expanded(child: Divider(color: subTextColor, thickness: 1)),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primaryColor,
                      side: BorderSide(color: primaryColor, width: 2),
                      backgroundColor: bgColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
                    },
                    child: Text("Create an account", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: primaryColor)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, IconData icon, String hint, Color hintColor, bool isDark, {bool obscure = false}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.grey[700]! : const Color(0xFFE5E7EB)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
        decoration: InputDecoration(
          prefixIcon: Padding(padding: const EdgeInsets.all(16.0), child: Icon(icon, color: isDark ? Colors.white70 : const Color(0xFF6B7280), size: 20)),
          hintText: hint,
          hintStyle: TextStyle(color: hintColor, fontSize: 16),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        ),
      ),
    );
  }
}