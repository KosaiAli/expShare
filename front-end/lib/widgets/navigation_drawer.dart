import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/widget_functions.dart';
import '../constants.dart';
import '../providers/experts.dart';

class NavigationDrawer extends StatefulWidget {
  const NavigationDrawer({super.key});

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  late String pickedLang;

  @override
  void initState() {
    pickedLang = Provider.of<Experts>(context, listen: false).language ==
            Language.english
        ? 'En'
        : 'Ar';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<Experts>(context);
    pickedLang = data.language == Language.english ? 'En' : 'Ar';

    return SafeArea(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.75,
            height: MediaQuery.of(context).size.height * 0.20,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12), color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Directionality(
                textDirection:
                    pickedLang == 'En' ? TextDirection.ltr : TextDirection.rtl,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          pickedLang == 'En' ? 'language :' : 'اللغة: ',
                          style: const TextStyle(
                              color: Colors.black, fontSize: 18),
                        ),
                        SizedBox(
                          width: 100,
                          child: createPickerField(
                            context,
                            hintText: pickedLang == 'En' ? 'choose' : 'اختر',
                            text: pickedLang == 'En' ? 'choose' : 'اختر',
                            child: createDropDownList(
                                context: context,
                                items: pickedLang == 'En'
                                    ? ['En', 'Ar']
                                    : ['الإنكليزية', 'العربية'],
                                onTap: (item) {
                                  if (item == 'الإنكليزية') {
                                    item = 'En';
                                  } else if (item == 'العربية') {
                                    item = 'Ar';
                                  }
                                  // data.initCategories(item);
                                }),
                                typeExpcted: Language
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () =>
                              Provider.of<Experts>(context, listen: false)
                                  .logot(context),
                          child: Transform.rotate(
                            angle: pickedLang == 'En' ? pi : 0,
                            child: const Icon(
                              Icons.logout_rounded,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () =>
                              Provider.of<Experts>(context, listen: false)
                                  .logot(context),
                          child: Text(
                            pickedLang == 'En' ? 'log out' : 'تسحيل الخروج',
                            style: kTitleSmallStyle,
                          ),
                        ),
                      ],
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
