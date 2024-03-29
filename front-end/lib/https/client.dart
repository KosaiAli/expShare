import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

import 'config.dart';
import 'package:http/http.dart' as http;

import '../providers/experts.dart';

class Client {
  static Future<void> login(
      String email, String password, BuildContext context) async {
    var url = Uri.http(Config.host, 'api/login');
    try {
      await http
          .post(url,
              headers: Config.header,
              body: jsonEncode({'email': email, 'password': password}))
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
            .write(key: 'access_token', value: decodedData['token'])
            .then((_) async {
          await Provider.of<Experts>(context, listen: false)
              .getUserData()
              .then((value) => Navigator.pushReplacementNamed(context, ''));
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

  static Future<Map<String, dynamic>> checkEmail(
      String email, String password) async {
    var url = Uri.http(Config.host, 'api/checkEmailValidation');
    return await http
        .post(url,
            headers: Config.header,
            body: jsonEncode({
              'email': email,
              'password': password,
            }))
        .then((response) {
      if (response.statusCode == 200) {
        return {'result': true};
      } else {
        var decodedData = jsonDecode(response.body);
        return {'result': false, 'message': decodedData['message']};
      }
    });
  }

  static Future<void> userRegister(BuildContext context,
      {required String email, required String password}) async {
    var url = Uri.http(Config.host, Config.regisetApi);
    var data = Provider.of<Experts>(context, listen: false);
    try {
      await http
          .post(url,
              headers: Config.header,
              body: jsonEncode({
                'email': email,
                'password': password,
                'name': data.nameController.text.trim(),
                'phone': data.numberController.text.trim(),
                'address': data.addressController.text.trim(),
                'wallet': data.priceController.text.trim(),
                'is_expert': false
              }))
          .then((response) async {
        var decodedData = jsonDecode(response.body);
        print(decodedData);
        //     if (decodedData['errors'] != null) {
        //       var language = Provider.of<Experts>(context, listen: false).language;

        //       showDialog(
        //           context: context,
        //           builder: (_) {
        //             return Directionality(
        //               textDirection: language == Language.english
        //                   ? TextDirection.ltr
        //                   : TextDirection.rtl,
        //               child: AlertDialog(
        //                 content: Text(
        //                   language == Language.english
        //                       ? 'The email has already been taken'
        //                       : 'البريد الإلكتروني مستخدم',
        //                   style: const TextStyle(color: Colors.black),
        //                 ),
        //                 actions: [
        //                   TextButton(
        //                       onPressed: () => Navigator.pop(context),
        //                       child: Text(
        //                         language == Language.english ? 'OK!' : 'تم!',
        //                         style: const TextStyle(color: Colors.blue),
        //                       ))
        //                 ],
        //               ),
        //             );
        //           });
        //       return;
        //     }

        //     FlutterSecureStorage storage = const FlutterSecureStorage();
        //     await storage
        //         .write(key: 'access_token', value: decodedData['access_token'])
        //         .then((_) async {
        //       await Provider.of<Experts>(context, listen: false).getUserData();
        //     }).then((_) => Navigator.pushReplacementNamed(
        //               context,
        //               isExpert
        //                   ? FillYourInformation.routeName
        //                   : TabsScreen.routeName,
        //             ));
        //   });
        // } on TimeoutException catch (_) {
        //   showDialog(
        //       context: context,
        //       builder: (_) {
        //         return AlertDialog(
        //           content: const Text(
        //             'Request time out, \ncheck your connection!',
        //             style: TextStyle(color: Colors.black),
        //           ),
        //           actions: [
        //             TextButton(
        //                 onPressed: () => Navigator.pop(context),
        //                 child: const Text(
        //                   'OK!',
        //                   style: TextStyle(color: Colors.blue),
        //                 ))
        //           ],
        //         );
      });
    } catch (e) {
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              content: Text(
                e.toString(),
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
      return;
    }
  }

  static Future<void> expertRegister(
      {context, email, isExpert, password}) async {
    var data = Provider.of<Experts>(context, listen: false);

    var url = Uri.http(Config.host, Config.regisetApi);
    var header = await Config.getHeader();

    var request = http.MultipartRequest('POST', url);

    if (data.profilePic != null) {
      request.files.add(await http.MultipartFile.fromPath(
          'profile_picture', data.profilePic!.path));
    }
    request
      ..headers.addAll(header)
      ..fields.addAll({
        'name': data.nameController.text.trim(),
        'email': email,
        'phone': data.numberController.text.trim(),
        'address': data.addressController.text.trim(),
        'wallet': data.priceController.text.trim(),
        'is_expert': isExpert ? '1' : '0',
        'cost': data.costController.text.trim(),
        'start_day': intl.DateFormat.Hms().format(data.dayStart!),
        'end_day': intl.DateFormat.Hms().format(data.dayEnd!),
        'password': password,
        'skills': data.descriptionController.text.trim(),
        'days': jsonEncode(data.listOfDays.toList()),
        'consultings': jsonEncode(data.categoriesSet.toList())
      });
    var response = await request.send();
    await response.stream.bytesToString().then((respStr) async {
      print(respStr);
    });
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
      var rootImage = await rootBundle.load('assets/illustrations/user.png');
      base64Image = File('${(await getTemporaryDirectory()).path}/image.png');
      await base64Image.writeAsBytes(rootImage.buffer.asUint8List());
    }
    var request = http.MultipartRequest('POST', url)
      ..files
          .add(await http.MultipartFile.fromPath('imageUrl', base64Image.path))
      ..headers.addAll(header)
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
        var decodedData = json.decode(respStr);
        print(decodedData);
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
          Navigator.pushReplacementNamed(context, '');
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

  static Future googleSignUp(context, isExpert) async {
    var data = Provider.of<Experts>(context, listen: false);
    var url = Uri.http(Config.host, 'api/fillInfo');
    var headers = await Config.getHeader();

    if (isExpert) {
      var request = http.MultipartRequest('POST', url);

      if (data.profilePic != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'profile_picture', data.profilePic!.path));
      }
      print(headers);
      request
        ..headers.addAll(headers)
        ..fields.addAll({
          'name': data.nameController.text.trim(),
          'phone': data.numberController.text.trim(),
          'address': data.addressController.text.trim(),
          'wallet': data.priceController.text.trim(),
          'is_expert': isExpert ? '1' : '0',
          'cost': data.costController.text.trim(),
          'start_day': intl.DateFormat.Hms().format(data.dayStart!),
          'end_day': intl.DateFormat.Hms().format(data.dayEnd!),
          'skills': data.descriptionController.text.trim(),
          'days': jsonEncode(data.listOfDays.toList()),
          'consultings': jsonEncode(data.categoriesSet.toList())
        });
      var response = await request.send();
      await response.stream.bytesToString().then((respStr) async {
        print(respStr);
      });
    }

    await http
        .post(url,
            headers: headers,
            body: jsonEncode({
              'name': data.nameController.text.trim(),
              'phone': data.numberController.text.trim(),
              'address': data.addressController.text.trim(),
              'wallet': data.priceController.text.trim(),
            }))
        .then((value) => print(value.body));
  }
}
