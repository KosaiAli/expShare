import 'package:expshare/providers/experts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/Forms/login_form.dart';

class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});
  static const routeName = '/LogInScreen';

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<Experts>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
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
                        ? 'Login to Your Account'
                        : 'قم بتسجيل الدخول إلي حسابك',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.black),
                  ),
                ],
              ),
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: const LoginForm()),
          ],
        ),
      ),
    );
  }
}
