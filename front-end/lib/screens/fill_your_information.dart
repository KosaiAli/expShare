import 'dart:convert';
import 'dart:io';

import 'package:expshare/https/client.dart';
import 'package:expshare/widgets/Image_picker_widget.dart';
import 'package:expshare/widgets/time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

import '../widgets/Forms/expert_form.dart';
import '../widgets/buttons/welcome_screen_button.dart';
import '../validators.dart';
import '../Models/catigory.dart';
import '../constants.dart';
import '../providers/experts.dart';
import '../widgets/choose_card.dart';
import '../widgets/widget_functions.dart';

class FillYourInformation extends StatefulWidget {
  static const routeName = 'FillYourInformation';
  const FillYourInformation({super.key});

  @override
  State<FillYourInformation> createState() => _FillYourInformationState();
}

class _FillYourInformationState extends State<FillYourInformation> {
  String? dateOfBirth;
  Catigory? catigory;

  final _form = GlobalKey<FormState>();
  bool _requesting = false;

  void _fillExpertInfo() {
    if (!_form.currentState!.validate()) {
      return;
    }
    Client.expertRegister(
        context: context,
        email: arguments['email'],
        password: arguments['password'],
        isExpert: isExpert);
  }

  void _fillUserInfo() {
    if (_form.currentState!.validate()) {
      Client.userRegister(
        context,
        email: arguments['email'],
        password: arguments['password'],
      );
    }
  }

  void _googleSignUp() {
    print('using google ...');
    if (_form.currentState!.validate()) {
      Client.googleSignUp(context,isExpert);
    }
  }

  late Map arguments;
  late bool isExpert;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<Experts>(context);
    arguments = ModalRoute.of(context)?.settings.arguments as Map;
    isExpert = arguments['isExpert'];
    var signType = arguments['signType'];
    print(signType);

    return WillPopScope(
      onWillPop: () async {
        data.clearForm();
        return true;
      },
      child: Directionality(
        textDirection: data.language == Language.english
            ? TextDirection.ltr
            : TextDirection.rtl,
        child: Scaffold(
          body: SafeArea(
            child: Form(
              key: _form,
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  data.clearForm();
                                  Navigator.pop(context);
                                },
                                child: const Icon(Icons.arrow_back_rounded),
                              ),
                              Expanded(
                                child: Text(
                                  data.language == Language.english
                                      ? 'Fill Your Profile'
                                      : "استكمل معلوماتك",
                                  style: Theme.of(context).textTheme.titleLarge,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          ImagePickerWidget(isExpert: isExpert),
                          const SizedBox(height: 15),
                          createTextForm(
                              hintText: data.language == Language.english
                                  ? 'Name'
                                  : 'الأسم',
                              controller: data.nameController,
                              validator: (value) {
                                return normalValidator(value, context);
                              },
                              context: context),
                          const SizedBox(height: 20),
                          createTextForm(
                              hintText: data.language == Language.english
                                  ? 'Phone Number'
                                  : 'رقم الموبايل',
                              controller: data.numberController,
                              validator: (value) {
                                return numberValidator(value, context);
                              },
                              context: context),
                          const SizedBox(height: 20),
                          createTextForm(
                              hintText: data.language == Language.english
                                  ? 'Address'
                                  : 'العنوان',
                              controller: data.addressController,
                              validator: (value) {
                                return normalValidator(value, context);
                              },
                              context: context),
                          const SizedBox(height: 20),
                          createTextForm(
                              hintText: data.language == Language.english
                                  ? 'wallet'
                                  : 'المحفظة',
                              controller: data.priceController,
                              validator: (value) {
                                return priceValidator(value, context);
                              },
                              context: context),
                          const SizedBox(height: 20),
                          if (isExpert) const ExpertForm(),
                          if (isExpert) const SizedBox(height: 20),
                          WelcomeScreenButton(
                            onPressed: () {
                              if (signType == 'google') {
                                _googleSignUp();
                                return;
                              }
                              if (isExpert) {
                                _fillExpertInfo();
                              } else {
                                _fillUserInfo();
                              }
                            },
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
