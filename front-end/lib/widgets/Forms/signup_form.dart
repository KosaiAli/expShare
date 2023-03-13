import 'package:expshare/screens/fill_your_information.dart';
import 'package:expshare/widgets/buttons/welcome_screen_button.dart';
import 'package:expshare/widgets/language_changer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/experts.dart';
import '../widget_functions.dart';
import '../buttons/auth_button.dart';
import '../../screens/login_screen.dart';
import '../../constants.dart';
import '../../https/client.dart';
import '../../validators.dart';

class SingUpForm extends StatefulWidget {
  const SingUpForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SingUpForm> createState() => _SingUpFormState();
}

class _SingUpFormState extends State<SingUpForm> {
  bool _obsecure = true;
  bool _requesting = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _form = GlobalKey<FormState>();
  bool isExpert = false;

  var prefix = const Icon(
    Icons.lock,
  );
  Widget? suffix() {
    return _passwordController.text.isNotEmpty
        ? GestureDetector(
            onTap: () => setState(() {
                  _obsecure = !_obsecure;
                }),
            child: Icon(_obsecure ? Icons.visibility_off : Icons.visibility))
        : null;
  }

  void _continue() {
    if (_form.currentState!.validate()) {
      Client.checkEmail(
              _emailController.text.trim(), _passwordController.text.trim())
          .then((value) {
        if (value['result']) {
          Navigator.pushNamed(context, FillYourInformation.routeName,
              arguments: {
                'isExpert': isExpert,
                'email': _emailController.text.trim(),
                'password': _passwordController.text.trim()
              });
        } else {
          showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  content: Text(
                    value['message'],
                    style: const TextStyle(color: Colors.black),
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
            const SizedBox(height: 5),
            Directionality(
              textDirection: data.language == Language.english
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: isExpert,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    side: const BorderSide(color: kPrimaryColor, width: 2),
                    activeColor: kPrimaryColor,
                    onChanged: (value) => setState(() => isExpert = !isExpert),
                  ),
                  Text(
                    data.language == Language.english
                        ? 'Sign up as expert'
                        : 'إنشاء حساب خبير',
                    style: kButtonStyle.copyWith(
                        color: Colors.black, fontSize: 16),
                  )
                ],
              ),
            ),
            const SizedBox(height: 5),
            WelcomeScreenButton(
              onPressed: _continue,
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
                                ? 'Sign Up'
                                : 'إنشاء حساب',
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
                          ? "Already have an account?"
                          : 'لديك حساب مسبقا،',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, LogInScreen.routeName);
                      },
                      child: Text(
                        data.language == Language.english
                            ? '  Log in'
                            : ' تسجيل الدخول',
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
