import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:expshare/screens/tabs_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../configuration/config.dart';
import '../constants.dart';
import '../providers/experts.dart';
import '../widgets/buttons/auth_button.dart';

class FillYourInformation extends StatefulWidget {
  static const routeName = 'FillYourInformation';
  const FillYourInformation({super.key});

  @override
  State<FillYourInformation> createState() => _FillYourInformationState();
}

class _FillYourInformationState extends State<FillYourInformation> {
  String dateOfBirth = '';
  String base64Image = '';
  Catigory? catigory;
  Uint8List? decoded;

  TextEditingController numberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final _form = GlobalKey<FormState>();
  bool _requesting = false;

  Widget createDropDownList(
      {required List<Catigory> items, required Function onTap}) {
    return DropdownButton(
        isExpanded: true,
        underline: Container(),
        dropdownColor: kTextFieldColor,
        borderRadius: BorderRadius.circular(20),
        items: items.map((item) {
          return DropdownMenuItem(
            onTap: () => onTap(item),
            value: item.id,
            child: Text(
              item.type,
              style: const TextStyle(color: Colors.black),
            ),
          );
        }).toList(),
        onChanged: (_) {});
  }

  TextFormField createTextForm(
      {required String hintText,
      Widget? suffix,
      required TextEditingController controller,
      required String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none),
        fillColor: const Color(0xFFE4E4ED),
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(
            color: Colors.grey[700]), //^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$
        suffixIcon: suffix,
      ),
      style: const TextStyle(color: Colors.black),
      validator: validator,
    );
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1950),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate != null) {
        setState(() {
          dateOfBirth = pickedDate.toString();
        });
        return;
      }
      setState(() {
        dateOfBirth = '';
      });
    });
  }

  Container createPickerField(
      {required String text, required Widget child, required String hintText}) {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
          color: kTextFieldColor, borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Text(
              text.isNotEmpty ? text : hintText,
              style: Theme.of(context).textTheme.subtitle1?.copyWith(
                  color: text.isEmpty ? Colors.grey[700] : Colors.black),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                child.runtimeType != Icon ? Expanded(child: child) : child,
              ],
            )
          ],
        ),
      ),
    );
  }

  void pickAnImage() async {
    var xFileImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    File? pickedImage = File(xFileImage!.path);
    Uint8List imagebytes = await pickedImage.readAsBytes();
    base64Image = base64.encode(imagebytes);
    print(base64Image);
    decoded = base64.decode(base64Image);
    setState(() {});
  }

  Future<void> fillMyInfo() async {
    if (!_form.currentState!.validate()) {
      return;
    }
    setState(() {
      _requesting = true;
    });
    var url = Uri.http(Config.host, Config.fillExpertInfoApi);
    var accessToken =
        await const FlutterSecureStorage().read(key: 'access_token');
    try {
      await http
          .post(url,
              headers: {
                'Content-type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer $accessToken'
              },
              body: jsonEncode({
                'imageUrl': base64Image,
                'phoneNum': numberController.text.trim(),
                'address': addressController.text.trim(),
                'details': descriptionController.text.trim(),
                'price': 2000,
                'specialty_id': catigory?.id,
              }))
          .timeout(const Duration(seconds: 15))
          .then((response) {
        var decodedData = json.decode(response.body);
        if (decodedData['errors'] == null) {
          Navigator.pushReplacementNamed(context, TabsScreen.routeName);
        }
      });
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

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Form(
              key: _form,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Icon(
                              Icons.arrow_back_rounded,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const Text(
                          'Fill Your Profile',
                          style: kTitleSmallStyle,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    child: GestureDetector(
                      onTap: pickAnImage,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 2),
                            shape: BoxShape.circle),
                        child: CircleAvatar(
                          radius: size.width / 4,
                          child: decoded == null
                              ? ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(size.width / 2),
                                  child: Image.asset(
                                    'assets/illustrations/user.png',
                                    width: size.width / 2,
                                    height: size.width / 2,
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(size.width / 4),
                                  child: Image.memory(
                                    decoded!,
                                    width: size.width / 2,
                                    height: size.width / 2,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  createTextForm(
                    hintText: 'Phone Number',
                    controller: numberController,
                    validator: (value) {
                      if (value!.isEmpty ||
                          !RegExp(r'^[\+]?[(]?[0-9]{2,3}[)]?[-\s\.]?[0-9]{2,3}[-\s\.]?[0-9]{6,}$')
                              .hasMatch(value)) {
                        return 'Enter Valid phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  createTextForm(
                      hintText: 'Address',
                      controller: addressController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'This field is required';
                        }
                        if (value.trim().length < 10) {
                          return 'it should be 10 charecters at least';
                        }
                      }),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _presentDatePicker,
                    child: createPickerField(
                        hintText: 'Date of birth',
                        child: const Icon(Icons.date_range),
                        text: dateOfBirth),
                  ),
                  const SizedBox(height: 20),
                  createPickerField(
                      text: 'catigory',
                      child: createDropDownList(
                          items: Provider.of<Experts>(context, listen: false)
                              .categories
                              .where(
                                  (element) => element.type != catigory?.type)
                              .toList(),
                          onTap: (item) {
                            setState(() {
                              catigory = item;
                            });
                          }),
                      hintText: 'Catigory'),
                  if (catigory != null) const SizedBox(height: 20),
                  if (catigory != null)
                    Container(
                      height: 35,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            catigory!.type,
                            style: const TextStyle(color: Colors.black),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () => setState(() => catigory = null),
                            child: Icon(
                              Icons.close_rounded,
                              size: 20,
                              color: Theme.of(context).primaryColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  const SizedBox(height: 20),
                  TextFormField(
                    minLines: 1,
                    maxLines: 3,
                    controller: descriptionController,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none),
                      fillColor: const Color(0xFFE4E4ED),
                      filled: true,
                      hintText: 'Description',
                      hintStyle: TextStyle(color: Colors.grey[700]),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'This field is required';
                      }
                      if (value.trim().length < 10) {
                        return 'it should be 10 charecters at least';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  AuthButton(
                    onPressed: fillMyInfo,
                    child: !_requesting
                        ? const Text(
                            'Sign Up',
                            style: kButtonStyle,
                          )
                        : const SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
