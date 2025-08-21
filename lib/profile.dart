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

    Color bgColor = isDark ? Colors.black : Colors.white;
    Color textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: isDark ? Colors.black : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _signOut(context),
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/light/user.png'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Itunuoluwa Abidoye',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
                  ),
                  const Text(
                    'itunuoluwa@petrafrica',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Color(0xFF4555A4)),
                          const SizedBox(width: 5),
                          Text('50 Points', style: TextStyle(color: textColor)),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Row(
                        children: [
                          const Icon(Icons.psychology_outlined, color: Color(0xFF4555A4)),
                          const SizedBox(width: 5),
                          Text('10 Quizzes', style: TextStyle(color: textColor)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 4,
              color: Colors.grey.withOpacity(0.3),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.history, color: textColor),
                  const SizedBox(width: 10),
                  Text('Quiz History', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  QuizCard(subject: 'Chemistry', score: '30/40', isDark: isDark),
                  QuizCard(subject: 'Sports', score: '40/40', isDark: isDark),
                  QuizCard(subject: 'Math', score: '10/20', isDark: isDark),
                  QuizCard(subject: 'Science', score: '50/50', isDark: isDark),
                  QuizCard(subject: 'History', score: '10/10', isDark: isDark),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        color: isDark ? Colors.black : Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () {},
              child: Icon(Icons.person, color: isDark ? Colors.white : Colors.black, size: 30),
            ),
            Icon(Icons.star, color: isDark ? Colors.white : Colors.black, size: 30),
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
    bool isSports = subject == 'Sports';

    if (isSports) {
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
                if (isSports) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QuizPage()),
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