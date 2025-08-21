import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'theme_provider.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController repeatPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    Color primaryColor = const Color(0xFF6366F1);
    Color bgColor = isDark ? Colors.black : Colors.white;
    Color textColor = isDark ? Colors.white : const Color(0xFF1F2937);
    Color hintColor = isDark ? Colors.white54 : const Color(0xFFD1D5DB);
    Color subTextColor = isDark ? Colors.white70 : const Color(0xFF6B7280);

    void signUp() async {
      if (passController.text != repeatPassController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Passwords do not match.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passController.text.trim(),
        );

        await userCredential.user!.updateDisplayName(nameController.text.trim());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
        
      } on FirebaseAuthException catch (e) {
        String message = 'An unknown error occurred.';
        if (e.code == 'weak-password') {
          message = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          message = 'The account already exists for that email.';
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
                      decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: primaryColor.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))]),
                      child: const Center(child: Icon(Icons.psychology_outlined, size: 35, color: Colors.white)),
                    ),
                    const SizedBox(height: 20),
                    Text("Create an Account", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textColor)),
                    const SizedBox(height: 5),
                    Text("Sign up to continue", style: TextStyle(fontSize: 16, color: subTextColor)),
                  ],
                ),
                const SizedBox(height: 40),
                buildTextField(nameController, Icons.person_outline, "Enter your name", hintColor, isDark),
                const SizedBox(height: 20),
                buildTextField(emailController, Icons.email_outlined, "Enter your email", hintColor, isDark),
                const SizedBox(height: 20),
                buildPassField(passController, "Create password", isDark),
                const SizedBox(height: 20),
                buildPassField(repeatPassController, "Repeat your password", isDark),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark ? Colors.grey[800] : const Color(0xFFF3F4F6),
                            foregroundColor: isDark ? Colors.white : const Color(0xFF6B7280),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back, color: isDark ? Colors.white : const Color(0xFF6B7280), size: 20),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            shadowColor: primaryColor.withOpacity(0.3),
                          ),
                          onPressed: signUp,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Next", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, IconData icon, String hint, Color hintColor, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.grey[700]! : const Color(0xFFE5E7EB)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: TextField(
        controller: controller,
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

  Widget buildPassField(TextEditingController controller, String hint, bool isDark) {
    Color textColor = isDark ? Colors.white : Colors.black;
    Color fieldBg = isDark ? Colors.grey[900]! : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: fieldBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[700]!),
      ),
      child: TextField(
        controller: controller,
        obscureText: true,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock_outline, color: textColor),
          hintText: hint,
          hintStyle: TextStyle(color: textColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        ),
      ),
    );
  }
}