import 'dart:convert';

import 'package:expshare/https/config.dart';
import 'package:expshare/providers/experts.dart';
import 'package:expshare/screens/fill_your_information.dart';
import 'package:expshare/screens/signup_screen.dart';
import 'package:expshare/widgets/Forms/login_form.dart';
import 'package:expshare/widgets/buttons/welcome_screen_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});
  static const routeName = '/LogInScreen';

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<Experts>(context);
    double deviceHeigh =
        MediaQuery.of(context).orientation == Orientation.portrait
            ? MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top
            : MediaQuery.of(context).size.height * 2;
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Hero(
                      tag: 'login',
                      child: Image.asset(
                        'assets/illustrations/login.png',
                        height: 300,
                        width: 300,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                          data.language == Language.english
                              ? 'Login to Your Account'
                              : 'قم بتسجيل الدخول إلى حسابك',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge),
                    ),
                    Directionality(
                      textDirection: data.language == Language.english
                          ? TextDirection.ltr
                          : TextDirection.rtl,
                      child: LogInOptionCard(
                          title: data.language == Language.english
                              ? 'Continue with Facebook'
                              : 'أكمل باستخدام فيسبوك',
                          imageName: 'facebook'),
                    ),
                    Directionality(
                      textDirection: data.language == Language.english
                          ? TextDirection.ltr
                          : TextDirection.rtl,
                      child: LogInOptionCard(
                          title: data.language == Language.english
                              ? 'Continue with Google'
                              : 'أكمل باستخدام غوغل',
                          imageName: 'google'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 30),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 1,
                            color: Colors.blueGrey.withOpacity(0.2),
                          ),
                          Center(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              color: Colors.white,
                              child: Text(data.language == Language.english
                                  ? 'or'
                                  : 'أو'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: WelcomeScreenButton(
                        onPressed: () => Navigator.pushNamed(
                            context, LogInWithPassword.routeName),
                        child: Text(
                          data.language == Language.english
                              ? 'Sign in with password'
                              : 'أكمل باستخدام كلمة السر',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
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
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
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
          ),
        ],
      ),
    );
  }
}

class LogInWithPassword extends StatelessWidget {
  const LogInWithPassword({super.key});
  static const String routeName = 'LogInWithPassword';
  @override
  Widget build(BuildContext context) {
    var data = Provider.of<Experts>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  Hero(
                    tag: 'login',
                    child: Image.asset(
                      'assets/illustrations/login.png',
                      height: 300,
                      width: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      data.language == Language.english
                          ? 'Login to your account'
                          : 'بتسجيل الدخول إلى حسابك',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: Colors.black),
                    ),
                  ),
                  const LoginForm()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LogInOptionCard extends StatelessWidget {
  const LogInOptionCard({super.key, this.title, required this.imageName});
  final String imageName;
  final String? title;
  @override
  Widget build(BuildContext context) {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () async {
          // try {
          //   await _googleSignIn.signIn().then((value) async {
          //     var url = Uri.http(Config.host, 'api/checkGoogleToken');
          //     var auth = await value?.authentication;
          //     var token = auth?.idToken;
          //     await http
          //         .post(url,
          //             headers: Config.header,
          //             body: jsonEncode({'token': token, 'email': value!.email}))
          //         .then((response) {
          //       print(response.body);
          //       if (response.statusCode == 404) {
          //         var decededResponse = jsonDecode(response.body);
          //         showDialog(
          //             context: context,
          //             builder: (ctx) {
          //               return ErrorMessage(
          //                 decededResponse: decededResponse,
          //                 email: value.email,
          //               );
          //             });
          //       }
          //     });
          //   });
          // } catch (error) {
          //   print(error);
          // }
          // final LoginResult result = await FacebookAuth.instance
          //     .login(); // by default we request the email and the public profile
// or FacebookAuth.i.login()
          // if (result.status == LoginStatus.success) {
          // you are logged
          // final AccessToken accessToken = result.accessToken!;
          // print(accessToken);
          // final userData = await FacebookAuth.instance.getUserData();
          // print(userData['id']);
          var url = Uri.http(Config.host, 'api/checkFacebookToken');
          await http
              .post(url,
                  headers: Config.header,
                  body: jsonEncode({
                    'token':
                        'EAAL5HSkBVsMBAG21EBcIAYuXnTChJZB1mwdxyvxcaiZASO8QovfCSUKFBG5vjZC8PHXda1hcF93609q5aj5ZBhPiUZCpZAm2OmRG1guceBpO2xZAPL0HkyOec2LxgP1IIBV2XtkZBMQQybd4iMNTY74fnrWtcEobpVUIxAm5cF6EN4OfdqSiQZCvLnTSDD6szZBpuGuZA8DlDKL6GEeAGXleURHcogWhZAVCHipZBu8kYbARIhpjrMruK6LdT',
                    'user_id': '632295108653651'
                  }))
              .then((value) {
            if (value.statusCode == 404) {
              var decededResponse = jsonDecode(value.body);
              showDialog(
                  context: context,
                  builder: (ctx) {
                    return ErrorMessage(
                      decededResponse: decededResponse,
                      email: decededResponse['email'],
                    );
                  });
            }
          });
          // print(userData.entries);
          // } else {
          //   print(result.status);
          //   print(result.message);
          // }
        },
        child: Container(
          height: 60,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.blueGrey.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/$imageName.png',
                height: 25,
                width: 25,
              ),
              if (title != null) const SizedBox(width: 10),
              if (title != null) Text(title!)
            ],
          ),
        ),
      ),
    );
  }
}

class ErrorMessage extends StatefulWidget {
  const ErrorMessage(
      {super.key, required this.decededResponse, required this.email});
  final dynamic decededResponse;
  final String email;
  @override
  State<ErrorMessage> createState() => _ErrorMessageState();
}

class _ErrorMessageState extends State<ErrorMessage> {
  bool isExpert = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.90,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.decededResponse['message'],
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.black),
            ),
            SizedBox(height: 10),
            Text(
              'want to create one ?',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black, fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Material(
                  child: Checkbox(
                    value: isExpert,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    side: const BorderSide(color: kPrimaryColor, width: 2),
                    activeColor: kPrimaryColor,
                    onChanged: (value) => setState(() => isExpert = !isExpert),
                  ),
                ),
                Text(
                  'Sign up as expert',
                  style: kButtonStyle.copyWith(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.normal),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: const TextStyle(color: Colors.blue),
                    )),
                TextButton(
                    onPressed: () async {
                      var url = Uri.http(Config.host, 'api/googleSingUp');
                      await http
                          .post(url,
                              headers: Config.header,
                              body: jsonEncode({
                                'email': widget.email,
                                'is_expert': isExpert
                              }))
                          .then((response) async {
                        if (response.statusCode == 200) {
                          var decodedResponse = jsonDecode(response.body);
                          await const FlutterSecureStorage()
                              .write(
                                  key: 'token', value: decodedResponse['token'])
                              .then((value) => Navigator.pushNamed(
                                      context, FillYourInformation.routeName,
                                      arguments: {
                                        'isExpert': isExpert,
                                        'email': widget.email,
                                        'signType': 'google'
                                      }));
                        }
                      });
                    },
                    child: Text(
                      'yes',
                      style: const TextStyle(color: Colors.blue),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
