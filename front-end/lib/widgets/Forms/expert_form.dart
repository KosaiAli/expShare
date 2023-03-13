import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;

import '../../constants.dart';
import '../../providers/experts.dart';
import '../../validators.dart';
import '../choose_card.dart';
import '../time_picker.dart';
import '../widget_functions.dart';

class ExpertForm extends StatefulWidget {
  const ExpertForm({super.key});

  @override
  State<ExpertForm> createState() => _ExpertFormState();
}

class _ExpertFormState extends State<ExpertForm> {
  @override
  Widget build(BuildContext context) {
    var data = Provider.of<Experts>(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Text(
                data.language == Language.english
                    ? 'Choose your Specialities : '
                    : 'اختر تخصصك : ',
                textDirection: data.language == Language.english
                    ? TextDirection.ltr
                    : TextDirection.rtl,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        catsWidget(context),
        const SizedBox(height: 20),
        createTextForm(
            hintText: data.language == Language.english ? 'cost' : 'التكلفة',
            controller: data.costController,
            validator: (value) {
              return priceValidator(value, context);
            },
            context: context),
        const SizedBox(height: 20),
        TextFormField(
            minLines: 1,
            maxLines: 3,
            controller: data.descriptionController,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none),
              fillColor: const Color(0xFFE4E4ED),
              filled: true,
              hintText:
                  data.language == Language.english ? 'Description' : 'الخبرات',
              hintStyle: TextStyle(color: Colors.grey[700]),
            ),
            validator: (value) {
              return normalValidator(value, context);
            }),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Text(
                data.language == Language.english
                    ? 'Choose your working days : '
                    : 'اختر أيام الدوام : ',
                textDirection: data.language == Language.english
                    ? TextDirection.ltr
                    : TextDirection.rtl,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        daysPicker(context),
        const SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TimePick(
              title: data.language == Language.english
                  ? 'Start at : '
                  : 'يبدأ في   : ',
              date: data.dayStart,
              callBack: () {
                showTimePicker(
                  context: context,
                  initialTime: const TimeOfDay(hour: 9, minute: 0),
                ).then((value) {
                  data.setDayStart = intl.DateFormat.jm('en')
                      .parseLoose(value!.format(context));

                  setState(() {});
                });
              },
            ),
            const SizedBox(height: 10),
            TimePick(
              title: data.language == Language.english
                  ? 'End at   : '
                  : 'ينتهي في : ',
              date: data.dayEnd,
              callBack: () {
                showTimePicker(
                  context: context,
                  initialTime: data.dayStart == null
                      ? const TimeOfDay(hour: 9, minute: 0)
                      : TimeOfDay(
                          hour: data.dayStart!.hour + 3,
                          minute: data.dayStart!.minute),
                ).then((value) {
                  data.setDayEnd = intl.DateFormat.jm('en')
                      .parseLoose(value!.format(context));

                  setState(() {});
                });
              },
            )
          ],
        )
      ],
    );
  }
}
