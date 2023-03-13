import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../providers/experts.dart';

class LanguageChanger extends StatelessWidget {
  const LanguageChanger({super.key});

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<Experts>(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              data.setLanguage('Ar');
            },
            child: Text(
              data.language == Language.english ? 'AR' : 'العربية',
              style: kTitleSmallStyle.copyWith(
                  color: data.language == Language.arabic
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            width: 2,
            height: 20,
            color: Colors.grey,
          ),
          GestureDetector(
            onTap: () {
              data.setLanguage('En');
            },
            child: Text(
              data.language == Language.english ? 'EN' : 'الانكليزية',
              style: kTitleSmallStyle.copyWith(
                  color: data.language == Language.english
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
