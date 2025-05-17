import 'package:flutter/material.dart';
import 'theme.dart';
import './screens/splash_screen.dart' show SplashScreen;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Analysis App',
      theme: appTheme,
      home: const SplashScreen(),
    );
  }
}
