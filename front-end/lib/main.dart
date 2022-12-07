import 'package:flutter/material.dart';

import './constants.dart';
import './screens/login_screen.dart';
import './screens/signup_screen.dart';
import './screens/tabs_screen.dart';
import 'screens/welcome_screen.dart';

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
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          titleTextStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          backgroundColor: Color(0xFF00677f),
        ),
      ),
      home: const Scaffold(
        body: WelcomeScreen(),
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        LogInScreen.routeName: (ctx) => const LogInScreen(),
        WelcomeScreen.routeName: (ctx) => const WelcomeScreen(),
        SignUpScreen.routeName: (ctx) => const SignUpScreen(),
        TabsScreen.routeName: (ctx) => const TabsScreen(),
      },
    );
  }
}
