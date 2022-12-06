import 'package:flutter/material.dart';

import './constants.dart';
import './widgets/welcome_item.dart';
import './widgets/welcome_screen_button.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
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

  void navigateToNext() {
    pageController.nextPage(
        duration: const Duration(milliseconds: 300), curve: Curves.linear);
  }

  final PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Column(
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
    );
  }
}
