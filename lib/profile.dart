import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'quizpage.dart';
import 'theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'wellcome.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => WelcomePage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final User? user = FirebaseAuth.instance.currentUser;
    final String displayName = user?.displayName ?? 'User Name';
    final String email = user?.email ?? 'useremail@example.com';

    Color bgColor = isDark ? Colors.black : Colors.white;
    Color textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: textColor),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/light/7611084.png'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    displayName,
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
                  ),
                  Text(
                    email,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Keep Going, $displayName',
                    style: TextStyle(fontSize: 16, color: textColor),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => WelcomePage()),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Log Out'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizCard extends StatelessWidget {
  final String subject;
  final String score;
  final bool isDark;

  const QuizCard({super.key, required this.subject, required this.score, required this.isDark});

  @override
  Widget build(BuildContext context) {
    Color textColor;
    Color refreshColor = Colors.grey;

    if (subject == 'Sports') {
      textColor = const Color(0xFF6366F1);
      refreshColor = const Color(0xFF6366F1);
    } else if (subject == 'Chemistry') {
      textColor = Colors.grey;
      refreshColor = Colors.grey;
    } else {
      textColor = isDark ? Colors.white : Colors.black;
      refreshColor = Colors.grey;
    }

    return Card(
      color: isDark ? Colors.grey[900] : Colors.grey[200],
      child: ListTile(
        title: Text(subject, style: TextStyle(color: textColor)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(score, style: TextStyle(color: isDark ? Colors.white70 : Colors.black)),
            GestureDetector(
              onTap: () {
                if (subject == 'Sports') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const QuizPage()),
                  );
                }
              },
              child: Icon(Icons.refresh, color: refreshColor),
            ),
          ],
        ),
      ),
    );
  }
}