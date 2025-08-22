import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'theme_provider.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final User? user = FirebaseAuth.instance.currentUser;

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
              child: Text(
                'Leaderboard',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('leaderboard')
                    .orderBy('score', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No scores yet"));
                  }

                  final docs = snapshot.data!.docs;

                  final leaderboardUsers = docs.map((doc) {
                    return {
                      'id': doc.id,
                      'name': doc['name'] ?? 'Unknown',
                      'score': (doc['score'] as num).toDouble(),
                    };
                  }).toList();

                  // ترتيب المستخدم الحالي
                  int userRank = -1;
                  double userScore = 0;
                  if (user != null) {
                    final index = leaderboardUsers.indexWhere((e) => e['id'] == user.uid);
                    if (index != -1) {
                      userRank = index + 1;
                      userScore = leaderboardUsers[index]['score'];
                    }
                  }

                  // أول 3
                  final topThree = leaderboardUsers.take(3).toList();
                  // الباقي
                  final rest = leaderboardUsers.skip(3).toList();

                  return Column(
                    children: [
                      // لو المستخدم متسجل نعرض ترتيبه
                      if (user != null && userRank != -1)
                        Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[900] : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Text(
                                "$userRank",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Icon(Icons.person, size: 28),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  user.displayName ?? user.email ?? "You",
                                  style: TextStyle(color: textColor),
                                ),
                              ),
                              Text(
                                userScore.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                        ),

                      // البوديوم (Top 3)
                      if (topThree.isNotEmpty)
                        SizedBox(
                          height: 180,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if (topThree.length > 1)
                                _buildPodiumItem(
                                  2,
                                  topThree[1]['name'],
                                  topThree[1]['score'],
                                  isDark,
                                ),
                              _buildPodiumItem(
                                1,
                                topThree[0]['name'],
                                topThree[0]['score'],
                                isDark,
                                big: true,
                              ),
                              if (topThree.length > 2)
                                _buildPodiumItem(
                                  3,
                                  topThree[2]['name'],
                                  topThree[2]['score'],
                                  isDark,
                                ),
                            ],
                          ),
                        ),

                      // الباقي
                      Expanded(
                        child: ListView.builder(
                          itemCount: rest.length,
                          itemBuilder: (context, index) {
                            final item = rest[index];
                            return _buildLeaderboardItem(
                              index + 4,
                              item['name'],
                              item['score'].toString(),
                              isDark,
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildPodiumItem(int rank, String name, double score, bool isDark, {bool big = false}) {
  Color textColor = isDark ? Colors.white : Colors.black;
  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Text(
        name,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
      ),
      Container(
        width: big ? 80 : 60,
        height: big ? 120 : 80,
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        decoration: BoxDecoration(
          color: rank == 1
              ? Colors.amber
              : rank == 2
              ? Colors.grey
              : Colors.brown,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            "$rank\n$score",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ],
  );
}

Widget _buildLeaderboardItem(int rank, String name, String score, bool isDark) {
  Color textColor = isDark ? Colors.white : Colors.black;
  Color cardColor = isDark ? Colors.grey[900]! : Colors.grey[200]!;

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
        const SizedBox(width: 16),
        const Icon(Icons.person, size: 28),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            name,
            style: TextStyle(color: textColor),
          ),
        ),
        Text(
          score,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ],
    ),
  );
}
