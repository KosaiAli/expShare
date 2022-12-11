import 'dart:math';
import 'package:flutter/material.dart';

import './tabs_screen.dart';
import './welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = 'SplashScreen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) getToken();
      });
    _animationController.forward();
  }

  void getToken() async {
    Future.delayed(
      const Duration(seconds: 2),
      () {
        return Random().nextBool();
      },
    ).then((value) => Navigator.pushReplacementNamed(
        context, value ? TabsScreen.routeName : WelcomeScreen.routeName));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Opacity(
            opacity: _animationController.value,
            child: Image.asset('assets/illustrations/logo.png')),
      ),
    );
  }
}
