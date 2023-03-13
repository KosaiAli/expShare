import 'dart:convert';
import 'dart:math';

import 'package:expshare/constants.dart';
import 'package:expshare/https/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../screens/welcome_screen.dart';
import '../providers/experts.dart';
import '../screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = 'SplashScreen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _spinKitController;

  late Animation _iconAnimation;
  late AnimationController _iconController;

  late Animation _textAnimation;
  late AnimationController _textController;
  late bool firstTime;
  @override
  void initState() {
    super.initState();

    initializeDateFormatting();

    _spinKitController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _spinKitController.repeat();
        }
      });

    _textController =
        AnimationController(vsync: this, duration: kAnimationDuration)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _spinKitController.forward();
            }
          });
    _iconController =
        AnimationController(vsync: this, duration: kAnimationDuration)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _textController.forward();
            }
          });
    _iconAnimation =
        CurvedAnimation(parent: _iconController, curve: Curves.easeInOutExpo);

    _textController =
        AnimationController(vsync: this, duration: kAnimationDuration)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              getToken();
              _spinKitController.forward();
            }
          });
    _textAnimation =
        CurvedAnimation(parent: _textController, curve: Curves.easeOutExpo);

    _iconController.forward();
  }

  @override
  void dispose() {
    _iconController.dispose();
    _textController.dispose();
    _spinKitController.dispose();
    super.dispose();
  }

  void getToken() async {
    // firstTime =
    //     await const FlutterSecureStorage().read(key: 'first_time') != 'true';

    // const FlutterSecureStorage().read(key: 'access_token').then((token) async {
    //   await Provider.of<Experts>(context, listen: false)
    //       .initCategories(null)
    //       .then((_) async {
    //     if (token != null) {
    //       await Provider.of<Experts>(context, listen: false)
    //           .getUserData()
    //           .then((_) async {
    //         Navigator.pushReplacementNamed(context, TabsScreen.routeName);
    //       });
    //       return;
    //     }
    //     Navigator.pushReplacementNamed(context,
    //         firstTime ? WelcomeScreen.routeName : LogInScreen.routeName);
    //   });
    // });
    var url = Uri.http(Config.host, '/api/consultings');
    await http.get(url).then((value) {
      print(value.body);
      var decodedData = jsonDecode(value.body);
      Provider.of<Experts>(context, listen: false)
          .initCategories(decodedData['consultings'])
          .then((_) =>
              Navigator.pushReplacementNamed(context, WelcomeScreen.routeName));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Opacity(
                      opacity: _iconAnimation.value,
                      child: Transform.scale(
                        scale: _iconAnimation.value,
                        child: Image.asset(
                          'assets/images/widgetsIcon.png',
                          height: 55,
                          width: 55,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      height: 40,
                      width: 135 * _textAnimation.value as double,
                      child: Text(
                        'ExpShare',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 75),
                  child: Transform.rotate(
                    angle: _spinKitController.value * pi * 2,
                    child: AnimatedOpacity(
                      opacity: _textAnimation.isCompleted ? 1 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: CustomPaint(
                          painter: SpinKitPainter(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class SpinKitPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var r = size.width / 2;
    canvas.translate(r, r);
    double radius = 5;
    for (double i = 0; i <= (pi * 2) - (pi / 4); i += (pi * 2) / 8) {
      var cs = (pow(r, 2) + pow(r, 2) - pow((radius), 2)) / (2 * r * r);
      var angle = acos(cs);

      var dx = r * cos((i - (angle / 2)));
      var dy = r * sin((i - (angle / 2)));

      canvas.drawCircle(
          Offset(dx, dy), radius * 0.5, Paint()..color = kPrimaryColor);

      radius += 1;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
