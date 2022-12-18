import 'dart:convert';

import 'package:expshare/screens/tabs_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../providers/experts.dart';
import '../screens/login_screen.dart';
import '../configuration/config.dart';

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
    loadData();
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

  void loadData() async {
    var url = Uri.http(Config.host, 'api/getAllSpecialties');

    try {
      await http.get(url).then((response) {
        var decodedData = jsonDecode(response.body);
        List categories = decodedData['data'];
        categories.sort((a, b) {
          return (a['id'] as int).compareTo((b['id'] as int));
        });
        Provider.of<Experts>(context, listen: false).categoriesList =
            categories;
      });
    } catch (e) {
      print(e);
    }
  }

  void getToken() async {
    const FlutterSecureStorage().read(key: 'access_token').then((value) {
      Navigator.pushReplacementNamed(context,
          value == null ? LogInScreen.routeName : TabsScreen.routeName);
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
