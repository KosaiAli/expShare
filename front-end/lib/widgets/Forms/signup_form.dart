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
    setState(() {
      _requesting = true;
    });
    Client.toContinue(
      context,
      form: _form,
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      isExpert: isExpert,
    ).then((value) {
      setState(() {
        _requesting = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<Experts>(context);
    return Form(
      key: _form,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              createTextForm(
                  hintText:
                      data.language == Language.english ? 'Name' : 'الاسم',
                  controller: _nameController,
                  prefix: const Icon(Icons.person),
                  validator: (value) {
                    return normalValidator(value, context);
                  },
                  context: context),
              const SizedBox(height: 20),
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
                    style: const TextStyle(color: Colors.black),
                    validator: (value) {
                      return passwordValidator(value, context);
                    }),
              ),
              Directionality(
                textDirection: data.language == Language.english
                    ? TextDirection.ltr
                    : TextDirection.rtl,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: isExpert,
                      onChanged: (value) =>
                          setState(() => isExpert = !isExpert),
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
              const SizedBox(height: 20),
              AuthButton(
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
                                  ? isExpert
                                      ? 'Continue'
                                      : 'Sign Up'
                                  : isExpert
                                      ? 'استكمال'
                                      : 'إنشاء حساب',
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
      ),
    );
  }
}
