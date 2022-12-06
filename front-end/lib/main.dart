import 'package:flutter/material.dart';

import './welcome_page.dart';
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
        body: WelcomePage(),
      ),
    );
  }
}
