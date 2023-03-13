import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/experts.dart';
import '../../screens/signup_screen.dart';
import '../../constants.dart';
import '../../https/client.dart';
import '../../validators.dart';
import '../widget_functions.dart';

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

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<Experts>(context);

    return Form(
      key: _form,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              createTextForm(
                  controller: emailController,
                  hintText: data.language == Language.english
                      ? 'Email'
                      : 'البريد الاكتروني',
                  prefix: const Icon(Icons.email_rounded),
                  validator: (value) {
                    return emailValidator(value, context);
                  },
                  context: context),
              const SizedBox(height: 20),
              Directionality(
                textDirection: data.language == Language.english
                    ? TextDirection.ltr
                    : TextDirection.rtl,
                child: TextFormField(
                    onChanged: (value) => setState(() {
                          password = value.trim();
                        }),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none),
                        fillColor: const Color(0xFFE4E4ED),
                        filled: true,
                        hintText: data.language == Language.english
                            ? 'Password'
                            : 'كلمة السر',
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
                        errorMaxLines: 3),
                    obscureText: _obsecure,
                    style: const TextStyle(color: Colors.black),
                    validator: (value) {
                      return passwordValidator(value, context);
                    }),
              ),
              const SizedBox(height: 20),
              RawMaterialButton(
                constraints: const BoxConstraints.tightFor(
                    width: double.infinity, height: 60),
                onPressed: () {
                  if (_form.currentState!.validate()) {
                    Client.login(
                        emailController.text.trim(), password, context);
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
                fillColor: Theme.of(context).primaryColor,
                child: Text(
                  data.language == Language.english ? 'Login' : 'تسجيل الدخول',
                  style: kButtonStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Directionality(
                  textDirection: data.language == Language.english
                      ? TextDirection.ltr
                      : TextDirection.rtl,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        data.language == Language.english
                            ? "Don't have an account?"
                            : 'ليس لديك حساب؟',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, SignUpScreen.routeName);
                        },
                        child: Text(
                          data.language == Language.english
                              ? '  Sign up'
                              : 'انشئ حساب ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
