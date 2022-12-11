import 'package:expshare/providers/experts.dart';
import 'package:expshare/screens/fill_your_information.dart';
import 'package:expshare/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import "package:provider/provider.dart";

import './constants.dart';
import './screens/login_screen.dart';
import './screens/signup_screen.dart';
import './screens/tabs_screen.dart';
import './screens/welcome_screen.dart';
import './screens/expert_profile_screen.dart';
import './screens/chat_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Experts(),
      child: MaterialApp(
        theme: ThemeData.light().copyWith(
          primaryColor: kPrimaryColor,
          textTheme: const TextTheme().copyWith(
            titleLarge: kTitleLargStyle,
          ),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            titleTextStyle:
                TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            backgroundColor: kPrimaryColor,
          ),
        ),
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
        routes: {
          LogInScreen.routeName: (ctx) => const LogInScreen(),
          WelcomeScreen.routeName: (ctx) => const WelcomeScreen(),
          SignUpScreen.routeName: (ctx) => const SignUpScreen(),
          TabsScreen.routeName: (ctx) => const TabsScreen(),
          ChatScreen.routeName: (ctx) => const ChatScreen(),
          ExpertProfileScreen.routeName: (ctx) => const ExpertProfileScreen(),
          FillYourInformation.routeName: (ctx) => const FillYourInformation()
        },
      ),
    );
  }
}
