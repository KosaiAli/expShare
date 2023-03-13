import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

import '../constants.dart';
import '../providers/experts.dart';

class TimePick extends StatelessWidget {
  const TimePick(
      {super.key,
      required this.title,
      required this.date,
      required this.callBack});
  final String title;
  final DateTime? date;
  final Function() callBack;
  @override
  Widget build(BuildContext context) {
    var data = Provider.of<Experts>(context);
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            title,
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        GestureDetector(
          onTap: callBack,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: date == null ? const Color(0xFFE4E4ED) : kPrimaryColor,
                borderRadius: BorderRadius.circular(25)),
            child: Row(
              children: [
                Text(
                  date == null
                      ? ' -- : -- '
                      : intl.DateFormat.jm(
                              data.language == Language.english ? 'en' : 'ar')
                          .format(date!),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 16,
                      color: date == null ? Colors.black : Colors.white),
                ),
                const SizedBox(width: 10),
                Icon(
                  Icons.watch_later_outlined,
                  color: date == null ? Colors.black : Colors.white,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
