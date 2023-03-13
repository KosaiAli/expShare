import 'package:expshare/https/client.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/experts.dart';
import '../../screens/login_screen.dart';
import '../../constants.dart';
import '../../validators.dart';
import '../buttons/welcome_screen_button.dart';
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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _form = GlobalKey<FormState>();
  bool _requesting = false;

  void _login() async {
    setState(() {
      _requesting = true;
    });
    if (_form.currentState!.validate()) {
      await Client.login(_emailController.text.trim(),
          _passwordController.text.trim(), context);
      setState(() {
        _requesting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<Experts>(context);

    return Form(
      key: _form,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            createTextForm(
                hintText: data.language == Language.english
                    ? 'Email'
                    : 'البريد الالكتروني',
                controller: _emailController,
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
                  textAlignVertical: TextAlignVertical.center,
                  controller: _passwordController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none),
                      fillColor: const Color(0xFFE4E4ED),
                      filled: true,
                      hintText: data.language == Language.english
                          ? 'Password'
                          : 'كلمة السر',
                      hintStyle: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(color: Colors.grey),
                      prefixIcon: const Icon(
                        Icons.lock,
                      ),
                      suffixIcon: _passwordController.text.isNotEmpty
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
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.black),
                  validator: (value) {
                    return passwordValidator(value, context);
                  }),
            ),
            const SizedBox(height: 30),
            WelcomeScreenButton(
              onPressed: _login,
              child: Directionality(
                textDirection: data.language == Language.english
                    ? TextDirection.ltr
                    : TextDirection.rtl,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    !_requesting
                        ? Text(
                            data.language == Language.english
                                ? 'Sign in'
                                : 'تسجيل الدخول',
                            style: kButtonStyle,
                          )
                        : const SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 1,
                    color: Colors.blueGrey.withOpacity(0.2),
                  ),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      color: Colors.white,
                      child: Text(data.language == Language.english
                          ? 'or continue with'
                          : 'أو أكمل باستخدام'),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                      width: 80, child: LogInOptionCard(imageName: 'google')),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                      width: 80, child: LogInOptionCard(imageName: 'facebook')),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Directionality(
                textDirection: data.language == Language.english
                    ? TextDirection.ltr
                    : TextDirection.rtl,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data.language == Language.english
                          ? "Don't have an account,"
                          : 'ليس لديك حساب،',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, LogInScreen.routeName);
                      },
                      child: Text(
                        data.language == Language.english
                            ? '  Sign up'
                            : ' إنشاء حساب',
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
    );
  }
}
