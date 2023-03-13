import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Models/user.dart';
import '../constants.dart';
import '../providers/experts.dart';
import '../screens/chat_screen.dart';

class BookedAppointment extends StatelessWidget {
  const BookedAppointment({super.key});

  @override
  Widget build(BuildContext context) {
    
    final expertsData = Provider.of<Experts>(context);
    return FutureBuilder(
        future: Provider.of<Experts>(context).getBookedTimes(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    expertsData.language == Language.english
                        ? 'Looks like no one has taken reservations yet. Make sure to add available times for the week'
                        : 'يبدو أن لا أحد قام بالحجز بعد تأكد من إضافة الأوقات المتاحة للأسبوع',
                    textAlign: TextAlign.center,
                    style: kTitleMediumStyle,
                  ),
                ],
              );
            }
            return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  var startTime = DateFormat.Hm('en').parseLoose(snapshot
                      .data![index]['start']
                      .toString()
                      .substring(0, 5));
                  var endTime = DateFormat.Hm('en').parseLoose(
                      snapshot.data![index]['end'].toString().substring(0, 5));
                  var date = DateFormat('yyyy-MM-dd', 'en')
                      .parseLoose(snapshot.data![index]['day']);

                  const textStyle =
                      TextStyle(color: Colors.black, fontSize: 18, height: 1.1);
                  return GestureDetector(
                    onTap: () {
                      dynamic reciver = User(
                          id: snapshot.data![index]['user_id'].toString(),
                          email: 'email',
                          name: snapshot.data![index]['name']);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ChatScreen(reciver: reciver)));
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              expertsData.language == Language.english
                                  ? 'name : ${snapshot.data![index]['name']}'
                                  : 'الاسم : ${snapshot.data![index]['name']}',
                              style: textStyle,
                            ),
                            const SizedBox(height: 5),
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