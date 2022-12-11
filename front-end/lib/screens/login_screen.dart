import 'package:flutter/material.dart';

import '../widgets/Forms/login_form.dart';

class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});
  static const routeName = '/LogInScreen';

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
                    'Login to Your Account',
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
                child: const LoginForm()),
          ],
        ),
      ),
    );
  }
}
