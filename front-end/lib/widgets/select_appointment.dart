import 'dart:convert';

import 'package:expshare/providers/experts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../https/config.dart';

class SelectAppointment extends StatefulWidget {
  final double price;

  const SelectAppointment({
    super.key,
    required this.price,
  });

  @override
  State<SelectAppointment> createState() => _SelectAppointmentState();
}

class _SelectAppointmentState extends State<SelectAppointment> {
  DateTime? startDate;
  DateTime? endDate;

  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(
          const Duration(days: 30),
        ),
      );

  Future<TimeOfDay?> pickTime(DateTime date) => showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: date.hour, minute: date.minute),
      );

  Future chooseAppointment(BuildContext context) async {
    DateTime? newStartDate = await pickDate();
    if (newStartDate == null) return;

    TimeOfDay? newStartTime = await pickTime(newStartDate);
    if (newStartTime == null) return;

    newStartDate = DateTime(
      newStartDate.year,
      newStartDate.month,
      newStartDate.day,
      newStartTime.hour,
      newStartTime.minute,
    );

    var newEndDate = DateTime(
      newStartDate.year,
      newStartDate.month,
      newStartDate.day,
      newStartTime.hour,
      newStartTime.minute + 30,
    );

    TimeOfDay? newEndTime = await pickTime(newEndDate);
    if (newEndTime == null) return;

    newEndDate = DateTime(
      newStartDate.year,
      newStartDate.month,
      newStartDate.day,
      newEndTime.hour,
      newEndTime.minute,
    );

    setState(() {
      startDate = newStartDate;
      endDate = newEndDate;
    });
  }

  Future<void> addApointment() async {
    var languge = Provider.of<Experts>(context, listen: false).language;
    if (startDate == null || endDate == null) {
      return showDialog(
        context: context,
        builder: (_) {
          return Directionality(
            textDirection: languge == Language.english
                ? TextDirection.ltr
                : TextDirection.rtl,
            child: AlertDialog(
              content: Text(
                languge == Language.english
                    ? 'Date not Specified'
                    : 'يجب عليك إدخال التاريخ الوقت أولا',
                style: const TextStyle(color: Colors.black),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      languge == Language.english ? 'OK!' : 'تم!',
                      style: const TextStyle(color: Colors.blue),
                    ))
              ],
            ),
          );
        },
      );
    }

    var date = intl.DateFormat('yyyy-MM-dd', 'en').format(startDate!);
    var startTime = intl.DateFormat('HH:mm', 'en').format(startDate!);
    var endTime = intl.DateFormat('HH:mm', 'en').format(endDate!);
    var url = Uri.http(Config.host, 'api/addAvailableTimes');
    var header = await Config.getHeader();

    await http
        .post(url,
            headers: header,
            body: jsonEncode({
              'start': startTime,
              'end': endTime,
              'day': date,
            }))
        .then(
      (response) {
        var decoddedData = jsonDecode(response.body);
        {
          showDialog(
            context: context,
            builder: (_) {
              return Directionality(
                textDirection: languge == Language.english
                    ? TextDirection.ltr
                    : TextDirection.rtl,
                child: AlertDialog(
                  content: Text(
                    decoddedData['message'] ?? languge == Language.english
                        ? 'Added successfully'
                        : 'تمت الإضافة بنجاح',
                    style: const TextStyle(color: Colors.black),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          languge == Language.english ? 'OK!' : 'تم!',
                          style: const TextStyle(color: Colors.blue),
                        ))
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Experts>(context);
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            child: TextButton(
              style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Theme.of(context).primaryColor),
                  )),
              onPressed: () async {
                chooseAppointment(context);
              },
              child: Text(
                data.language == Language.english
                    ? 'Choose Your Appointment date here.'
                    : 'اضفط هنا لاختيار التاريخ',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: <Widget>[
                appointmentDataRow(
                    startDate == null
                        ? data.language == Language.english
                            ? "Not Specified!"
                            : "غير محدد"
                        : intl.DateFormat('yyyy/MM/dd',
                                data.language == Language.english ? 'en' : 'ar')
                            .format(startDate!),
                    data.language == Language.english ? 'Date' : 'التاريخ'),
                const Divider(color: Colors.white),
                appointmentDataRow(
                    startDate == null
                        ? data.language == Language.english
                            ? "Not Specified!"
                            : "غير محدد"
                        : intl.DateFormat.jm(
                                data.language == Language.english ? 'en' : 'ar')
                            .format(startDate!),
                    data.language == Language.english
                        ? 'Start Time'
                        : 'وقت البداية'),
                const Divider(color: Colors.white),
                appointmentDataRow(
                    endDate == null
                        ? data.language == Language.english
                            ? "Not Specified!"
                            : "غير محدد"
                        : intl.DateFormat.jm(
                                data.language == Language.english ? 'en' : 'ar')
                            .format(endDate!),
                    data.language == Language.english
                        ? 'End Time'
                        : 'وقت النهاية'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(color: Theme.of(context).primaryColor),
                )),
            onPressed: addApointment,
            child: SizedBox(
              width: double.infinity,
              child: Center(
                child: Text(
                  data.language == Language.english
                      ? 'Add an Appointment'
                      : 'إدخال',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget appointmentDataRow(String text, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
