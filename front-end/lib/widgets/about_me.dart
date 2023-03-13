import 'package:expshare/providers/experts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/expert.dart';

class AboutMe extends StatelessWidget {
  final Expert expertData;
  const AboutMe({super.key, required this.expertData});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<Experts>(context);
    var language = provider.language;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: Theme.of(context).primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: provider
            .expertMappedData(expertData)
            .entries
            .map((e) => infoSlice(e.key, e.value, language))
            .toList(),
      ),
    );
  }
}

Widget infoSlice(String title, String text, language) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Directionality(
          textDirection: language == Language.english
              ? TextDirection.ltr
              : TextDirection.rtl,
          child: Row(children: [
            Text('$title:  ',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                )),
            Text(
              title == 'Rate' ? '$text / 5' : text,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
              ),
            )
          ]),
        ),
      ),
      if (title != 'Price Per Hour') const Divider(color: Colors.white),
    ],
  );
}
