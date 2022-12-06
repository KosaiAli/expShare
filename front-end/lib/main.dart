import 'package:expshare/screens/login_screen.dart';
import 'package:flutter/material.dart';

import 'screens/welcome_screen.dart';
import './constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        primaryColor: kPrimaryColor,
        textTheme: const TextTheme().copyWith(titleLarge: kTitleLargStyle),
      ),
      home: const Scaffold(
        body: WelcomeScreen(),
      ),
      routes: {
        LogInScreen.routeName: (ctx) => const LogInScreen(),
        WelcomeScreen.routeName: (ctx) => const WelcomeScreen(),
      },
    );
  }
}
