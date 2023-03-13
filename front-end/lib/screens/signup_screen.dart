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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  Hero(
                    tag: 'signup',
                    child: Image.asset(
                      'assets/illustrations/sign_up.png',
                      height: 300,
                      width: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      data.language == Language.english
                          ? 'Create New Account'
                          : 'إنشاء حساب جديد',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: Colors.black),
                    ),
                  ),
                  const SingUpForm(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
