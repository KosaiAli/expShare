import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

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
    if (startDate == null || endDate == null) {
      return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: const Text(
              'Date not Specified',
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
        },
      );
    }

    var date = DateFormat('yyyy-MM-dd').format(startDate!);
    var startTime = DateFormat('HH:mm').format(startDate!);
    var endTime = DateFormat('HH:mm').format(endDate!);
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
              return AlertDialog(
                content: Text(decoddedData['message'] ?? 'Added successfully'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'OK!',
                        style: TextStyle(color: Colors.blue),
                      ))
                ],
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                'Choose Your Appointment date here.',
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
                        ? "Not Specified!"
                        : DateFormat('yyyy/MM/dd').format(startDate!),
                    'Date'),
                const Divider(color: Colors.white),
                appointmentDataRow(
                    startDate == null
                        ? "Not Specified!"
                        : DateFormat('HH:mm').format(startDate!),
                    'Start Time'),
                const Divider(color: Colors.white),
                appointmentDataRow(
                    endDate == null
                        ? "Not Specified!"
                        : DateFormat('HH:mm').format(endDate!),
                    'End Time'),
                const Divider(color: Colors.white),
                appointmentDataRow(
                    endDate == null || startDate == null
                        ? "0"
                        : widget.price.toStringAsFixed(2),
                    'Total Cost'),
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
            child: const SizedBox(
              width: double.infinity,
              child: Center(
                child: Text(
                  'Add an Appointment',
                  style: TextStyle(
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
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Text(text),
        ],
      ),
    );
  }
}
