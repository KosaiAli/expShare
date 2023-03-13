import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../screens/welcome_screen.dart';
import '../screens/tabs_screen.dart';
import '../providers/experts.dart';
import '../screens/login_screen.dart';
import '../https/config.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = 'SplashScreen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late bool firstTime;
  @override
  void initState() {
    super.initState();
    getToken();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {});
    _animationController.forward();
  }

  void getToken() async {
    firstTime =
        await const FlutterSecureStorage().read(key: 'first_time') != 'true';
    const FlutterSecureStorage().read(key: 'access_token').then((token) async {
      if (token != null) {
        Provider.of<Experts>(context, listen: false).initCategories(null);
        await Provider.of<Experts>(context, listen: false)
            .getUserData()
            .then((_) {
          Navigator.pushReplacementNamed(context, TabsScreen.routeName);
        });
        return;
      }
      Navigator.pushReplacementNamed(
          context, firstTime ? WelcomeScreen.routeName : LogInScreen.routeName);
    });
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
