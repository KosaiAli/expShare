import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;

import '../constants.dart';
import '../https/config.dart';
import '../providers/experts.dart';

class BookAppointment extends StatefulWidget {
  const BookAppointment({super.key, required this.expertID});
  final String expertID;
  @override
  State<BookAppointment> createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<BookAppointment> {
  dynamic appointemnts;
  @override
  void initState() {
    initializeDateFormatting();
    getAppointemnts();
    super.initState();
  }

  void getAppointemnts() async {
    appointemnts = await Provider.of<Experts>(context, listen: false)
        .getAvalibleTimes(widget.expertID);
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> bookAppointment(int timeID) async {
    var languge = Provider.of<Experts>(context, listen: false).language;
    var url = Uri.http(Config.host, 'api/addAppointment');
    var header = await Config.getHeader();
    await http.post(url,
        headers: header,
        body: jsonEncode({'time_id': timeID, 'expert_id': widget.expertID}));

    getAppointemnts();
    showDialog(
      context: context,
      builder: (_) {
        return Directionality(
          textDirection: languge == Language.english
              ? TextDirection.ltr
              : TextDirection.rtl,
          child: AlertDialog(
            content: Text(
              languge == Language.english
                  ? 'Appointment Booked successfully :)'
                  : 'تم حجز الموعد بنجاح :)',
              style: const TextStyle(color: Colors.black),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    languge == Language.english ? 'OK!' : 'تم!  ',
                    style: const TextStyle(color: Colors.blue),
                  ))
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<Experts>(context, listen: false);
    var languge = data.language;
    return Column(
      children: [
        Builder(builder: (ctx) {
          if (appointemnts != null) {
            if (appointemnts['data'].isEmpty && appointemnts['more'].isEmpty) {
              return Container();
            }
            return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: appointemnts['more']!.length,
                itemBuilder: (context, index) {
                  var startTime = intl.DateFormat.Hm('en').parseLoose(
                      appointemnts['more']![index]['start']
                          .toString()
                          .substring(0, 5));
                  var endTime = intl.DateFormat.Hm('en').parseLoose(
                      appointemnts['more']![index]['end']
                          .toString()
                          .substring(0, 5));
                  var date = intl.DateFormat('yyyy-MM-dd', 'en')
                      .parseLoose(appointemnts['more']![index]['day']);
                  const textStyle =
                      TextStyle(color: Colors.black, fontSize: 18, height: 1.1);
                  return Card(
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.language == Language.english
                                    ? 'Date : ${intl.DateFormat('yyyy/MM/dd', 'en').format(date)}'
                                    : 'التاريخ : ${intl.DateFormat('yyyy/MM/dd', 'ar').format(date)}',
                                style: textStyle,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                data.language == Language.english
                                    ? 'Start at : ${intl.DateFormat.jm('en').format(startTime)}'
                                    : 'تبدأ في : ${intl.DateFormat.jm('ar').format(startTime)}',
                                style: textStyle,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                data.language == Language.english
                                    ? 'End at : ${intl.DateFormat.jm('en').format(endTime)}'
                                    : 'تنتهي في : ${intl.DateFormat.jm('ar').format(endTime)}',
                                style: textStyle,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }

          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
              ],
            ),
          );
        }),
        Builder(builder: (ctx) {
          if (appointemnts != null) {
            if (appointemnts['data'].isEmpty && appointemnts['more'].isEmpty) {
              return Expanded(
                child: Center(
                  child: Text(
                    languge == Language.english
                        ? 'No Available times'
                        : 'لم يقم هذا الخبير بجدولة مواعيد لهذا الأسبوع',
                    style: kTitleMediumStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: appointemnts['data']!.length,
                itemBuilder: (context, index) {
                  var startTime = intl.DateFormat.Hm('en').parseLoose(
                      appointemnts['data']![index]['start']
                          .toString()
                          .substring(0, 5));
                  var endTime = intl.DateFormat.Hm('en').parseLoose(
                      appointemnts['data']![index]['end']
                          .toString()
                          .substring(0, 5));
                  var date = intl.DateFormat('yyyy-MM-dd', 'en')
                      .parseLoose(appointemnts['data']![index]['day']);
                  const textStyle =
                      TextStyle(color: Colors.black, fontSize: 18, height: 1.1);
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.language == Language.english
                                    ? 'Date : ${intl.DateFormat('yyyy/MM/dd', 'en').format(date)}'
                                    : 'التاريخ : ${intl.DateFormat('yyyy/MM/dd', 'ar').format(date)}',
                                style: textStyle,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                data.language == Language.english
                                    ? 'Start at : ${intl.DateFormat.jm('en').format(startTime)}'
                                    : 'تبدأ في : ${intl.DateFormat.jm('ar').format(startTime)}',
                                style: textStyle,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                data.language == Language.english
                                    ? 'End at : ${intl.DateFormat.jm('en').format(endTime)}'
                                    : 'تنتهي في : ${intl.DateFormat.jm('ar').format(endTime)}',
                                style: textStyle,
                              ),
                            ],
                          ),
                          GestureDetector(
                              onTap: () => bookAppointment(
                                  appointemnts['data'][index]['id']),
                              child: const Icon(Icons.add))
                        ],
                      ),
                    ),
                  );
                });
          }
          return Container();
        })
      ],
    );
  }
}
