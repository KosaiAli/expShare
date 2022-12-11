import 'package:flutter/material.dart';

import '../../screens/fill_your_information.dart';
import '../../screens/login_screen.dart';
import '../buttons/auth_button.dart';
import '../../constants.dart';

class SingUpForm extends StatefulWidget {
  const SingUpForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SingUpForm> createState() => _SingUpFormState();
}

class _SingUpFormState extends State<SingUpForm> {
  bool _obsecure = true;
  String password = '';

  void _continue() {
    if (_form.currentState!.validate()) {
      Navigator.pushNamed(context, FillYourInformation.routeName);
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

  final _form = GlobalKey<FormState>();
  bool isExpert = false;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              createTextForm(
                  hintText: 'Name', prefix: const Icon(Icons.person)),
              const SizedBox(height: 20),
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
                }),
              ),
              const SizedBox(height: 20),
              TextFormField(
                onChanged: (value) => setState(() {
                  password = value.trim();
                }),
                decoration: InputDecoration(
                  errorMaxLines: 3,
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
                    'Sign up as expert',
                    style: kButtonStyle.copyWith(
                        color: Colors.black, fontSize: 16),
                  )
                ],
              ),
              const SizedBox(height: 20),
              AuthButton(
                onPressed: _continue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isExpert ? 'Continue' : 'Sign Up',
                      style: kButtonStyle,
                    ),
                    if (isExpert)
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 22,
                        color: Colors.white,
                      )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(color: Colors.grey),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, LogInScreen.routeName);
                      },
                      child: Text(
                        '  Log in',
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
