import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/experts.dart';
import '../widgets/Forms/signup_form.dart';

class SignUpScreen extends StatelessWidget {
  static const routeName = '/SignUpScreen';

  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<Experts>(context);
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: mediaQuery.size.height * 0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(
                    'assets/illustrations/logo.png',
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                  Text(
                    data.language == Language.english
                        ? 'Create New Account'
                        : 'إنشاء حساب جديد',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.black),
                  ),
                ],
              ),
            ),
            SizedBox(
                height: mediaQuery.viewInsets.bottom == 0
                    ? mediaQuery.size.height * 0.6
                    : mediaQuery.size.height * 0.5,
                child: const SingUpForm()),
          ],
        ),
      ),
    );
  }
}
