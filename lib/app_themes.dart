import 'package:flutter/material.dart';

class AppThemes {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue[800],
    scaffoldBackgroundColor: Colors.grey[100],
    colorScheme: ColorScheme.light(
      primary: const Color.fromARGB(255, 33, 111, 201),
      secondary: const Color.fromARGB(255, 53, 44, 131),
      surface: Colors.white,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
      displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
      bodyLarge: TextStyle(fontSize: 18, color: Colors.black87),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
      labelLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
    ),
    
    cardTheme: CardThemeData(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColorLight: Colors.blue[200],
    primaryColorDark: const Color.fromARGB(255, 82, 121, 153),
    scaffoldBackgroundColor: Colors.grey[900],
    colorScheme: ColorScheme.dark(
      primary: Colors.blue[200]!,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
      displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white70),
      bodyLarge: TextStyle(fontSize: 18, color: Colors.white70),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.white70),
      labelLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
    ),
    cardTheme:CardThemeData(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
