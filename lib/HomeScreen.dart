import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Profile.dart';
import 'theme_provider.dart';
import 'Quizpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'leaderboard_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final User? user = FirebaseAuth.instance.currentUser;
    final String displayName = user?.displayName ?? 'User';

    Color bgColor = isDark ? Colors.black : const Color(0xFFF5F5F5);
    Color textColor = isDark ? Colors.white : Colors.black;
    Color subTextColor = isDark ? Colors.white70 : const Color(0xFF737373);
    Color cardColor = isDark ? const Color(0xFF1C1C1C) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hi, $displayName', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25, color: textColor)),
              const SizedBox(height: 8),
              Text('Let’s make this day productive', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 11, color: subTextColor)),
              const SizedBox(height: 40),

              Text('Categories', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: textColor)),
              const SizedBox(height: 16),

              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _buildCategoryCard(
                    context,
                    title: 'Science',
                    categoryId: '17',
                    imagePath: 'assets/images/light/dna.png',
                    questions: '10 Questions',
                    bg: const Color(0xFFFEE2E2),
                    isDark: isDark,
                  ),
                  _buildCategoryCard(
                    context,
                    title: 'Technology',
                    categoryId: '18',
                    imagePath: 'assets/images/light/map.png',
                    questions: '10 Questions',
                    bg: const Color(0xFFDBEAFE),
                    isDark: isDark,
                  ),
                  _buildCategoryCard(
                    context,
                    title: 'Sports',
                    categoryId: '21',
                    imagePath: 'assets/images/light/basket.png',
                    questions: '10 Questions',
                    bg: const Color(0xFFE0E7FF),
                    isDark: isDark,
                  ),
                  _buildCategoryCard(
                    context,
                    title: 'Chemistry',
                    categoryId: '19',
                    imagePath: 'assets/images/light/test_tube.png',
                    questions: '10 Questions',
                    bg: const Color(0xFFD1FAE5),
                    isDark: isDark,
                  ),
                  _buildCategoryCard(
                    context,
                    title: 'Math',
                    categoryId: '19',
                    imagePath: 'assets/images/light/content.png',
                    questions: '10 Questions',
                    bg: const Color(0xFFE2EAD1),
                    isDark: isDark,
                  ),
                  _buildCategoryCard(
                    context,
                    title: 'History',
                    categoryId: '23',
                    imagePath: 'assets/images/light/calender.png',
                    questions: '10 Questions',
                    bg: const Color(0xFFFDE68A),
                    isDark: isDark,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        color: isDark ? Colors.black : Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
              },
              child: Icon(Icons.person, color: isDark ? Colors.white : Colors.black, size: 30),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaderboardScreen()));
              },
              child: Icon(Icons.leaderboard, color: isDark ? Colors.white : Colors.black, size: 30),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, {
    required String title,
    required String categoryId,
    required String imagePath,
    required String questions,
    required Color bg,
    required bool isDark,
  }) {
    Color cardColor = isDark ? const Color(0xFF1C1C1C) : Colors.white;
    Color textColor = isDark ? Colors.white : Colors.black;
    Color subTextColor = isDark ? Colors.white70 : const Color(0xFF737373);
    
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizPage(category: categoryId),
          ),
        );
      },
      child: Container(
        width: 120,
        height: 150,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(4, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, width: 60, height: 60),
            const SizedBox(height: 8),
            Text(title, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: textColor)),
            const SizedBox(height: 4),
            Text(questions, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 11, color: subTextColor)),
          ],
        ),
      ),
    );
  }
}