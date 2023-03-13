import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

import 'config.dart';
import 'package:http/http.dart' as http;

import '../providers/experts.dart';
import '../screens/fill_your_information.dart';
import '../screens/tabs_screen.dart';

class Client {
  static Future<void> login(
      String email, String password, BuildContext context) async {
    var url = Uri.http(Config.host, 'api/login');
    try {
      await http
          .post(url,
              headers: Config.header,
              body: jsonEncode({'email': email, 'password': password}))
          .timeout(const Duration(seconds: 15))
          .then((response) async {
        var decodedData = jsonDecode(response.body);

        if (decodedData['message'] != null) {
          var language = Provider.of<Experts>(context, listen: false).language;
          showDialog(
            context: context,
            builder: (_) => Directionality(
              textDirection: language == Language.english
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              child: AlertDialog(
                content: Text(
                  language == Language.english
                      ? decodedData['message']
                      : 'البيانات المدخلة غير صالحة',
                  style: const TextStyle(color: Colors.black),
                ),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        language == Language.english ? 'OK!' : 'تم!',
                        style: const TextStyle(color: Colors.blue),
                      ))
                ],
              ),
            ),
          );
          return;
        }

        FlutterSecureStorage storage = const FlutterSecureStorage();
        await storage
            .write(key: 'access_token', value: decodedData['access_token'])
            .then((_) async {
          await Provider.of<Experts>(context, listen: false).getUserData().then(
              (value) => Navigator.pushReplacementNamed(
                  context, TabsScreen.routeName));
        });
      });
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

  static Future<void> toContinue(
    BuildContext context, {
    required GlobalKey<FormState> form,
    required String name,
    required String email,
    required String password,
    required bool isExpert,
  }) async {
    if (!form.currentState!.validate()) {
      return;
    }

    var url = Uri.http(Config.host, Config.regisetApi);
    try {
      await http
          .post(url,
              headers: Config.header,
              body: jsonEncode({
                'name': name,
                'email': email,
                'password': password,
                'isExpert': isExpert
              }))
          .timeout(const Duration(seconds: 15))
          .then((response) async {
        var decodedData = jsonDecode(response.body);

        if (decodedData['errors'] != null) {
          var language = Provider.of<Experts>(context, listen: false).language;
          Map errors = decodedData['errors'];
          print(errors);
          showDialog(
              context: context,
              builder: (_) {
                return Directionality(
                  textDirection: language == Language.english
                      ? TextDirection.ltr
                      : TextDirection.rtl,
                  child: AlertDialog(
                    content: Text(
                      language == Language.english
                          ? 'The email has already been taken'
                          : 'البريد الإلكتروني مستخدم',
                      style: const TextStyle(color: Colors.black),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            language == Language.english ? 'OK!' : 'تم!',
                            style: const TextStyle(color: Colors.blue),
                          ))
                    ],
                  ),
                );
              });
          return;
        }

        FlutterSecureStorage storage = const FlutterSecureStorage();
        await storage
            .write(key: 'access_token', value: decodedData['access_token'])
            .then((_) async {
          await Provider.of<Experts>(context, listen: false).getUserData();
        }).then((_) => Navigator.pushReplacementNamed(
                  context,
                  isExpert
                      ? FillYourInformation.routeName
                      : TabsScreen.routeName,
                ));
      });
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

  static Future<void> fillMyInfo(BuildContext context,
      {required File? base64Image,
      required String phoneNumber,
      required String address,
      required String details,
      required String price,
      required String birthday,
      required int? id}) async {
    var url = Uri.http(Config.host, Config.fillExpertInfoApi);

    var header = await Config.getHeader();
    if (base64Image == null) {
      print('getting root image ..');
      var rootImage = await rootBundle.load('assets/illustrations/user.png');
      base64Image = File('${(await getTemporaryDirectory()).path}/image.png');
      await base64Image.writeAsBytes(rootImage.buffer.asUint8List());
      print(base64Image.path);
    }
    var request = http.MultipartRequest('POST', url)
      ..files
          .add(await http.MultipartFile.fromPath('imageUrl', base64Image.path))
      ..headers.addAll(
          header) //if u have headers, basic auth, token bearer... Else remove line
      ..fields.addAll({
        'phoneNum': phoneNumber,
        'address': address,
        'details': details,
        'price': price,
        'birthday': birthday,
        'specialty_id': id.toString(),
      });
    try {
      var response = await request.send();
      await response.stream.bytesToString().then((respStr) async {
        print(respStr);
        var decodedData = json.decode(respStr);

        if (decodedData['errors'] != null) {
          Map errors = decodedData['errors'];
          showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: const Text(
                    'Error',
                    style: TextStyle(color: Colors.black, fontSize: 24),
                  ),
                  content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: errors.keys
                          .map((e) => Text(
                                errors[e][0],
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
        await Provider.of<Experts>(context, listen: false)
            .getUserData()
            .then((value) {
          Navigator.pushReplacementNamed(context, TabsScreen.routeName);
          return;
        });
      });
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
}
