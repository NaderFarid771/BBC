import 'package:flutter/material.dart';
import 'package:mindo/provider/questionprovider.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';
import 'theme_provider.dart';
import 'app_themes.dart';
import 'firebase_options.dart';
import 'Splash.dart';
import 'Higuys1.dart';
import 'Higuys2.dart';
import 'Quizpage.dart' hide QuestionProvider;
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => QuestionProvider()),
      ],
      child: DevicePreview(
        enabled: true,
        builder: (context) => const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'Mindo Quizzes',
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: themeProvider.themeMode,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/quiz': (context) => const QuizScreen(),
        '/higuys2': (context) => const Higuys2(),
        '/quizPage':(context) => QuizPage(),
      },
    );
  }
}