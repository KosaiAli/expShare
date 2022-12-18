import 'dart:async';
import 'dart:convert';

import 'package:expshare/screens/tabs_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../buttons/auth_button.dart';
import '../../screens/fill_your_information.dart';
import '../../screens/login_screen.dart';
import '../../constants.dart';
import '../../configuration/config.dart';

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
  bool _requesting = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _continue() async {
    if (!_form.currentState!.validate()) {
      return;
    }
    setState(() {
      _requesting = true;
    });
    var url = Uri.http(Config.host, Config.regisetApi);
    try {
      var response = await http
          .post(url,
              headers: Config.requestHeaders,
              body: jsonEncode({
                'name': nameController.text.trim(),
                'email': emailController.text.trim(),
                'password': passwordController.text.trim(),
                'isExpert': isExpert
              }))
          .timeout(const Duration(seconds: 15));

      var decodedData = jsonDecode(response.body);

      if (decodedData['errors'] != null) {
        setState(() {
          _requesting = false;
        });
        Map errors = decodedData['errors'];
        showDialog(
            context: context,
            builder: (_) {
              List emailError = errors['email'];
              return AlertDialog(
                content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: emailError
                        .map((e) => Text(
                              e,
                              style: const TextStyle(color: Colors.black),
                            ))
                        .toList()),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'OK!',
                        style: TextStyle(color: Colors.blue),
                      ))
                ],
              );
            });
        return;
      }

      FlutterSecureStorage storage = const FlutterSecureStorage();
      await storage
          .write(key: 'access_token', value: decodedData['access_token'])
          .then((_) => Navigator.pushReplacementNamed(
                context,
                isExpert ? FillYourInformation.routeName : TabsScreen.routeName,
              ));
    } on TimeoutException catch (_) {
      setState(() {
        _requesting = false;
      });
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              content: const Text(
                'Request time out, \ncheck your connection!',
                style: TextStyle(color: Colors.black),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'OK!',
                      style: TextStyle(color: Colors.blue),
                    ))
              ],
            );
          });
    }
  }

  TextFormField createTextForm(
      {required String hintText,
      String? Function(String?)? validator,
      Widget? prefix,
      required TextEditingController controller}) {
    return TextFormField(
        controller: controller,
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
                  hintText: 'Name',
                  controller: nameController,
                  prefix: const Icon(Icons.person),
                  validator: (value) {
                    if (value!.isNotEmpty && value.length < 10) {
                      return 'name must be at least 10 charecters';
                    }
                    return null;
                  }),
              const SizedBox(height: 20),
              createTextForm(
                hintText: 'Email',
                controller: emailController,
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
                controller: passwordController,
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
                    !_requesting
                        ? Text(
                            isExpert ? 'Continue' : 'Sign Up',
                            style: kButtonStyle,
                          )
                        : const SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            )),
                    if (isExpert && !_requesting)
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
