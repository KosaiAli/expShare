import 'package:flutter/material.dart';

import '../providers/experts.dart';

class AboutMe extends StatelessWidget {
  final Expert expertData;
  const AboutMe({super.key, required this.expertData});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: Theme.of(context).primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: expertData.expertMappedData.entries
            .map((e) => infoSlice(e.key, e.value))
            .toList(),
      ),
    );
  }
}

Widget infoSlice(String title, String text) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: RichText(
          text: TextSpan(
              text: '$title:  ',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: title == 'Rate' ? '$text / 5' : text,
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
