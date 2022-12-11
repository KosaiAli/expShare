import 'package:flutter/material.dart';

import '../widgets/Forms/signup_form.dart';

class SignUpScreen extends StatelessWidget {
  static const routeName = '/SignUpScreen';

  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 2.5,
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
                    'Create New Account',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.black),
                  ),
                ],
              ),
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: const SingUpForm()),
          ],
        ),
      ),
    );
  }
}
