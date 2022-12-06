import 'package:flutter/material.dart';

import '../constants.dart';

class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});
  static const routeName = '/LogInScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
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
          const LoginForm()
        ],
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _obsecure = true;
  String password = '';
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none),
                fillColor: const Color(0xFFE4E4ED),
                filled: true,
                hintText: 'Email',
                prefixIcon: const Icon(Icons.email_rounded),
              ),
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 20),
            TextFormField(
              onChanged: (value) => setState(() {
                password = value.trim();
              }),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none),
                fillColor: const Color(0xFFE4E4ED),
                filled: true,
                hintText: 'Password',
                prefixIcon: const Icon(
                  Icons.lock,
                ),
                suffixIcon: password.isNotEmpty
                    ? GestureDetector(
                        onTap: () => setState(() {
                              _obsecure = !_obsecure;
                            }),
                        child: Icon(_obsecure
                            ? Icons.visibility_off
                            : Icons.visibility))
                    : null,
              ),
              obscureText: _obsecure,
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 40),
            RawMaterialButton(
              constraints: const BoxConstraints.tightFor(
                  width: double.infinity, height: 60),
              onPressed: () {},
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35),
              ),
              fillColor: Theme.of(context).primaryColor,
              child: const Text(
                'Login',
                style: kButtonStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
