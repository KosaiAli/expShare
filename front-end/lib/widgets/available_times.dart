import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/experts.dart';
import '../constants.dart';

class AvailablTimes extends StatelessWidget {
  const AvailablTimes({super.key});

  @override
  Widget build(BuildContext context) {
     final expertsData = Provider.of<Experts>(context);
    return FutureBuilder(
                    future:
                        Provider.of<Experts>(context).getAvalibleTimes(null),
                    builder: (ctx, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!['data'].isEmpty) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                expertsData.language == Language.english
                                    ? 'You haven\'t added any times \nTry to add some in your profile'
                                    : 'لم تقم بإضافة أي مواعيد حاول إضافة بعض المواعيد في ملفك الشخصي',
                                textAlign: TextAlign.center,
                                style: kTitleMediumStyle,
                              ),
                            ],
                          );
                        }

                        return ListView.builder(
                            itemCount: snapshot.data?['data'].length,
                            itemBuilder: (context, index) {
                              var startTime = DateFormat.Hm('en').parseLoose(
                                  snapshot.data!['data'][index]['start']
                                      .toString()
                                      .substring(0, 5));
                              var endTime = DateFormat.Hm('en').parseLoose(
                                  snapshot.data!['data'][index]['end']
                                      .toString()
                                      .substring(0, 5));
                              var date = DateFormat('yyyy-MM-dd', 'en')
                                  .parseLoose(
                                      snapshot.data!['data'][index]['day']);
                              const textStyle = TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  height: 1.1);
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        expertsData.language == Language.english
                                            ? 'Date : ${DateFormat('yyyy/MM/dd', 'en').format(date)}'
                                            : 'التاريخ : ${DateFormat('yyyy/MM/dd', 'ar').format(date)}',
                                        style: textStyle,
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        expertsData.language == Language.english
                                            ? 'Start at : ${DateFormat.jm('en').format(startTime)}'
                                            : 'تبدأ في : ${DateFormat.jm('ar').format(startTime)}',
                                        style: textStyle,
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        expertsData.language == Language.english
                                            ? 'End at : ${DateFormat.jm('en').format(endTime)}'
                                            : 'تنتهي في : ${DateFormat.jm('ar').format(endTime)}',
                                        style: textStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      }
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(),
                        ],
                      );
                    });
  }
}