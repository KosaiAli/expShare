import 'package:flutter/material.dart';

import '../../screens/tabs_screen.dart';
import '../../screens/signup_screen.dart';
import '../../constants.dart';

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
  final _form = GlobalKey<FormState>();

  void _saveFrom() {
    if (_form.currentState!.validate()) {
      Navigator.pushReplacementNamed(context, TabsScreen.routeName);
    }
  }

  TextFormField createTextForm(
      {required String hintText,
      String? Function(String?)? validator,
      Widget? prefix}) {
    return TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none),
          fillColor: const Color(0xFFE4E4ED),
          filled: true,
          hintText: hintText, //^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$
          prefixIcon: prefix,
        ),
        style: const TextStyle(color: Colors.black),
        validator: validator);
  }

  bool isExpert = false;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              createTextForm(
                  hintText: 'Email',
                  prefix: const Icon(Icons.email_rounded),
                  validator: ((value) {
                    if (value!.isEmpty) {
                      return 'This field is required';
                    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Valid Email Address';
                    }
                    return null;
                  })),
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
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'This feild is required!';
                  }

                  if (value.isNotEmpty &&
                      !RegExp(r'(?=.*[+=;:\",<>./?(){}|\\`~!@#$%^&*_-])(?=.*\d).*$')
                          .hasMatch(value)) {
                    return r'Password must be 8 charecters min and contain at least one number and one symbol: () [] {} | \\ `~! @ # $% ^ & * _- + =;:\", <> ./? ';
                  }
                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    value: isExpert,
                    onChanged: (value) => setState(() => isExpert = !isExpert),
                  ),
                  Text(
                    'Login as expert',
                    style: kButtonStyle.copyWith(
                        color: Colors.black, fontSize: 16),
                  )
                ],
              ),
              const SizedBox(height: 20),
              RawMaterialButton(
                constraints: const BoxConstraints.tightFor(
                    width: double.infinity, height: 60),
                onPressed: _saveFrom,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
                fillColor: Theme.of(context).primaryColor,
                child: const Text(
                  'Login',
                  style: kButtonStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.grey),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, SignUpScreen.routeName);
                      },
                      child: Text(
                        '  Sign up',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
