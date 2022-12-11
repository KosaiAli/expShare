import 'package:expshare/screens/login_screen.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../widgets/welcome_item.dart';
import 'welcome_screen_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  static const routeName = '/WelcomeScreen';
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int index = 0;

  List<Widget> indicators() {
    return welcomeItem.map((item) {
      final n = welcomeItem.indexOf(item);
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 9,
        width: index == n ? 30 : 10,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: index == n ? Theme.of(context).primaryColor : Colors.grey,
        ),
      );
    }).toList();
  }

  void navigateToNext(BuildContext context) {
    if (index < welcomeItem.length - 1) {
      pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.linear);
    } else {
      Navigator.pushReplacementNamed(context, LogInScreen.routeName);
    }
  }

  final PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: size.height * 0.70,
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              onPageChanged: (index) {
                setState(
                  () => this.index = index,
                );
              },
              children: welcomeItem.map(
                (item) {
                  return WelcomeImage(
                    index: item['index'] as int,
                    title: item['title'] as String,
                  );
                },
              ).toList(),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: indicators(),
          ),
          const SizedBox(
            height: 30,
          ),
          WelcomeScreenButton(
            onPressed: navigateToNext,
            child: index == welcomeItem.length - 1 ? 'Get Started' : 'Next',
          )
        ],
      ),
    );
  }
}
