import 'package:flutter/material.dart';

import 'Higuys1.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen > createState() => _SplashState();
}

class _SplashState extends State<SplashScreen > {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 10), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const QuizScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
    
          Positioned.fill(
            child: Image.asset(
              isDark
                  ? 'assets/images/dark/background.png'
                  : 'assets/images/light/background.png',
              fit: BoxFit.cover,
            ),
          ),

      
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  isDark
                      ? 'assets/images/dark/welcome.png'
                      : 'assets/images/light/welcome.png',
                  height: 250,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
