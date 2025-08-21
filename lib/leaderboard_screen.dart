import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'theme_provider.dart';
import 'HomeScreen.dart';
import 'package:mindo/provider/questionprovider.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final User? user = FirebaseAuth.instance.currentUser;
    final questionProvider = Provider.of<QuestionProvider>(context);

    // قائمة تجريبية لـ leaderboard
    final List<Map<String, dynamic>> leaderboardUsers = [
      {'name': 'David James', 'score': 145.093},
      {'name': 'Lennert Niva', 'score': 120.774},
      {'name': 'Peter', 'score': 95.876},
      {'name': 'Stina Gunnarsdottir', 'score': 90.281},
      {'name': 'Benedikt Safiyulin', 'score': 88.463},
      {'name': 'Gabriel Soares', 'score': 85.287},
      {'name': 'Yahiro Ayuko', 'score': 84.009},
    ];

    Color bgColor = isDark ? Colors.black : Colors.white;
    Color textColor = isDark ? Colors.white : Colors.black;
    if (user != null) {
      final userCurrentScore = (questionProvider.score / (questionProvider.questions.isEmpty ? 1 : questionProvider.questions.length)) * 100;
      leaderboardUsers.add({'name': user.displayName ?? 'You', 'score': userCurrentScore});
      leaderboardUsers.sort((a, b) => (b['score'] as double).compareTo(a['score'] as double));
    }

    final int userRank = leaderboardUsers.indexWhere((element) => element['name'] == (user?.displayName ?? 'You')) + 1;
    final double userCurrentScore = user != null ? (questionProvider.score / (questionProvider.questions.isEmpty ? 1 : questionProvider.questions.length)) * 100 : 0.0;

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
                  Text(
                    'Leaderboard',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textColor),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (leaderboardUsers.length > 1)
                        _buildPodiumUser(
                          rank: 2,
                          name: leaderboardUsers[1]['name'] as String,
                          score: (leaderboardUsers[1]['score'] as double).toStringAsFixed(3),
                          avatarSize: 30,
                          isCenter: false,
                          isDark: isDark,
                        ),
                      const SizedBox(width: 20),
                      if (leaderboardUsers.isNotEmpty)
                        _buildPodiumUser(
                          rank: 1,
                          name: leaderboardUsers[0]['name'] as String,
                          score: (leaderboardUsers[0]['score'] as double).toStringAsFixed(3),
                          avatarSize: 50,
                          isCenter: true,
                          isDark: isDark,
                        ),
                      const SizedBox(width: 20),
                      if (leaderboardUsers.length > 2)
                        _buildPodiumUser(
                          rank: 3,
                          name: leaderboardUsers[2]['name'] as String,
                          score: (leaderboardUsers[2]['score'] as double).toStringAsFixed(3),
                          avatarSize: 30,
                          isCenter: false,
                          isDark: isDark,
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[900] : Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF6366F1).withOpacity(0.2) : const Color(0xFF6366F1).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Text(
                            '$userRank',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(width: 16),
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: isDark ? Colors.blueGrey[700] : Colors.grey[300],
                            child: Icon(Icons.person, color: isDark ? Colors.white : Colors.black),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'You',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: textColor,
                              ),
                            ),
                          ),
                          Text(
                            userCurrentScore.toStringAsFixed(3),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: leaderboardUsers.length,
                        itemBuilder: (context, index) {
                          final user = leaderboardUsers[index];
                          if (user['name'] == (user?.isEmpty ?? 'You')) {
                            return const SizedBox.shrink();
                          }
                          return _buildLeaderboardItem(
                            index + 1,
                            user['name'] as String,
                            (user['score'] as double).toStringAsFixed(3),
                            isDark,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildPodiumUser({
  required int rank,
  required String name,
  required String score,
  required double avatarSize,
  required bool isCenter,
  required bool isDark,
}) {
  return Column(
    children: [
      if (rank == 1) ...[
        const Icon(
          Icons.emoji_events,
          color: Colors.yellow,
          size: 28,
        ),
        const SizedBox(height: 4),
      ],
      Container(
        width: avatarSize * 2,
        height: avatarSize * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
        ),
        child: ClipOval(
          child: Image.asset(
            'assets/images/light/user.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: isDark ? Colors.blueGrey[800] : Colors.grey,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: avatarSize,
                ),
              );
            },
          ),
        ),
      ),
      const SizedBox(height: 8),
      Text(
        name,
        style: TextStyle(
          color: Colors.white,
          fontSize: isCenter ? 16 : 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      Text(
        score,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 12,
        ),
      ),
    ],
  );
}

Widget _buildLeaderboardItem(int rank, String name, String score, bool isDark) {
  Color textColor = isDark ? Colors.white : Colors.black;
  Color cardColor = isDark ? Colors.grey[900]! : Colors.grey[200]!;

  return Container(
    margin: const EdgeInsets.only(bottom: 24),
    padding: const EdgeInsets.symmetric(vertical: 8),
    decoration: BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        SizedBox(
          width: 24,
          child: Text(
            rank.toString(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
        const SizedBox(width: 16),
        CircleAvatar(
          radius: 20,
          backgroundColor: isDark ? Colors.blueGrey[700] : Colors.grey[300],
          child: Icon(Icons.person, color: isDark ? Colors.white : Colors.black),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ),
        Text(
          score,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ],
    ),
  );
}