import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../screens/tabs_screen.dart';
import '../../screens/signup_screen.dart';
import '../../constants.dart';
import '../../configuration/config.dart';

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
  final TextEditingController emailController = TextEditingController();
  final _form = GlobalKey<FormState>();

  TextFormField createTextForm(
      {required String hintText,
      String? Function(String?)? validator,
      required TextEditingController controller,
      Widget? prefix}) {
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

  Future<void> _login() async {
    var url = Uri.http(Config.host, 'api/login');
    try {
      var resposne = await http
          .post(url,
              headers: Config.requestHeaders,
              body: jsonEncode(
                  {'email': emailController.text.trim(), 'password': password}))
          .timeout(const Duration(seconds: 15));
      var decodedData = jsonDecode(resposne.body);
      if (decodedData['message'] != null) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Text(
              decodedData['message'],
              style: const TextStyle(color: Colors.black),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child:
                      const Text('OK!', style: TextStyle(color: Colors.blue)))
            ],
          ),
        );
        return;
      }
      FlutterSecureStorage storage = const FlutterSecureStorage();
      await storage
          .write(key: 'access_token', value: decodedData['access_token'])
          .then((_) =>
              Navigator.pushReplacementNamed(context, TabsScreen.routeName));
    } on TimeoutException catch (_) {
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
                  controller: emailController,
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
              const SizedBox(height: 20),
              RawMaterialButton(
                constraints: const BoxConstraints.tightFor(
                    width: double.infinity, height: 60),
                onPressed: _login,
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
