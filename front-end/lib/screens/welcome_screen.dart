import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../providers/experts.dart';
import '../widgets/welcome_item.dart';
import '../widgets/buttons/welcome_screen_button.dart';
import '../screens/login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  static const routeName = '/WelcomeScreen';
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int index = 0;
  var welcomeItem = [];
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

  Future<void> navigateToNext() async {
    if (index == welcomeItem.length - 1) {
      await const FlutterSecureStorage()
          .write(key: 'first_time', value: 'true')
          .then((_) {
        Navigator.pushReplacementNamed(context, LogInScreen.routeName);
      });
      return;
    }
    pageController.nextPage(
        duration: const Duration(milliseconds: 300), curve: Curves.linear);
  }

  final PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    var data = Provider.of<Experts>(context);
    welcomeItem = [
      {
        'index': 1,
        'title': data.language == Language.english
            ? 'Thousands of experts are ready to help you'
            : 'آلاف الخبراء جاهزون لمساعدتك',
      },
      {
        'index': 2,
        'title': data.language == Language.english
            ? 'Consulations easily anywhere anytime'
            : 'استشر بسهولة في أي مكان وفي أي وقت',
      },
      {
        'index': 3,
        'title': data.language == Language.english
            ? 'Find doctors and more experts here'
            : 'ابحث عن الأطباء والمزيد من الخبراء هنا',
      }
    ];

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
            child: index == welcomeItem.length - 1
                ? data.language == Language.english
                    ? 'Get Started'
                    : 'البدء'
                : data.language == Language.english
                    ? 'Next'
                    : 'التالي',
          )
        ],
      ),
    );
  }
}
