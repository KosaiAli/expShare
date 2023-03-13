import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

import '../https/client.dart';
import '../validators.dart';
import '../Models/catigory.dart';
import '../constants.dart';
import '../providers/experts.dart';
import '../widgets/buttons/auth_button.dart';
import '../widgets/widget_functions.dart';

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
  TextEditingController priceController = TextEditingController();

  final _form = GlobalKey<FormState>();
  bool _requesting = false;
  File? pickedImage;
  void pickAnImage() async {
    var xFileImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    pickedImage = File(xFileImage!.path);
    Uint8List imagebytes = await pickedImage!.readAsBytes();
    base64Image = base64.encode(imagebytes);

    decoded = base64.decode(base64Image);
    setState(() {});
  }

  void _fillYourInfo() {
    if (!_form.currentState!.validate()) {
      return;
    }
    setState(() {
      _requesting = true;
    });
    Client.fillMyInfo(context,
            base64Image: pickedImage,
            phoneNumber: numberController.text.trim(),
            address: addressController.text.trim(),
            details: descriptionController.text.trim(),
            price: priceController.text.trim(),
            birthday: dateOfBirth,
            id: catigory?.id)
        .then((_) {
      setState(() {
        _requesting = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<Experts>(context);
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: SingleChildScrollView(
            child: Form(
              key: _form,
              child: Column(
                children: [
                  Text(
                    data.language == Language.english
                        ? 'Fill Your Profile'
                        : "استكمل معلوماتك",
                    style: kTitleSmallStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
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
                      hintText: data.language == Language.english
                          ? 'Phone Number'
                          : 'رقم الموبايل',
                      controller: numberController,
                      validator: (value) {
                        return numberValidator(value, context);
                      },
                      context: context),
                  const SizedBox(height: 20),
                  createTextForm(
                      hintText: data.language == Language.english
                          ? 'Address'
                          : 'العنوان',
                      controller: addressController,
                      validator: (value) {
                        return normalValidator(value, context);
                      },
                      context: context),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () =>
                        presentDatePicker(context, dateOfBirth, (pickedDate) {
                      if (pickedDate != null) {
                        setState(() {
                          dateOfBirth = intl.DateFormat('yyyy-MM-dd')
                              .format(DateTime.parse(pickedDate.toString()))
                              .toString();
                        });
                        return;
                      }
                    }),
                    child: Directionality(
                      textDirection: data.language == Language.english
                          ? TextDirection.ltr
                          : TextDirection.rtl,
                      child: createPickerField(context,
                          hintText: data.language == Language.english
                              ? 'Date of birth'
                              : 'تاريخ الميلاد',
                          child: const Icon(Icons.date_range),
                          text: dateOfBirth),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Directionality(
                    textDirection: data.language == Language.english
                        ? TextDirection.ltr
                        : TextDirection.rtl,
                    child: createPickerField(context,
                        text: data.language == Language.english
                            ? 'catigory'
                            : 'الاختصاصات',
                        child: createDropDownList(
                            items: (Provider.of<Experts>(context, listen: false)
                                    .categories)
                                .where((element) =>
                                    element.type != catigory?.type &&
                                    element.id != 1)
                                .toList(),
                            onTap: (item) {
                              setState(() {
                                catigory = item;
                              });
                            }),
                        hintText: 'Catigory'),
                  ),
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
                  createTextForm(
                      hintText: data.language == Language.english
                          ? 'Price for appointment'
                          : 'سعر الجلسة',
                      controller: priceController,
                      validator: (value) {
                        return priceValidator(value, context);
                      },
                      context: context),
                  const SizedBox(height: 20),
                  Directionality(
                    textDirection: data.language == Language.english
                        ? TextDirection.ltr
                        : TextDirection.rtl,
                    child: TextFormField(
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
                          hintText: data.language == Language.english
                              ? 'Description'
                              : 'الخبرات',
                          hintStyle: TextStyle(color: Colors.grey[700]),
                        ),
                        validator: (value) {
                          return normalValidator(value, context);
                        }),
                  ),
                  const SizedBox(height: 20),
                  AuthButton(
                    onPressed: _fillYourInfo,
                    child: !_requesting
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
