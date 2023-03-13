import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import './providers/experts.dart';
import './screens/fill_your_information.dart';
import './screens/splash_screen.dart';
import './constants.dart';
import './screens/login_screen.dart';
import './screens/signup_screen.dart';
import './screens/welcome_screen.dart';
import './screens/expert_profile_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Experts(),
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 28, height: 1.5),
            bodyMedium: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            titleLarge: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
            titleMedium: TextStyle(
                fontWeight: FontWeight.w400, fontSize: 16, color: Colors.white),
            titleSmall: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
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
          ExpertProfileScreen.routeName: (ctx) => const ExpertProfileScreen(),
          FillYourInformation.routeName: (ctx) => const FillYourInformation(),
          LogInWithPassword.routeName: (ctx) => const LogInWithPassword(),
        },
      ),
    );
  }
}
