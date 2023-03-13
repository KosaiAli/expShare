import 'package:expshare/constants.dart';
import 'package:expshare/screens/tabs_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/experts.dart';
import '../widgets/search_bar.dart';

class ExpertHomeScreen extends StatefulWidget {
  const ExpertHomeScreen({super.key});

  @override
  State<ExpertHomeScreen> createState() => _ExpertHomeScreenState();
}

class _ExpertHomeScreenState extends State<ExpertHomeScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final expertsData = Provider.of<Experts>(context);
    final mediaQuery = MediaQuery.of(context);
    final appBar = SearchBar(forwardingSearchInput: () {});
    return Scaffold(
      drawer: NavigationDrawer(),
      appBar: appBar,
      body: Column(
        children: [
          TabBar(
              labelColor: Theme.of(context).primaryColor,
              controller: _tabController,
              indicatorColor: Theme.of(context).primaryColor,
              tabs: [
                Tab(
                    text: expertsData.language == Language.english
                        ? 'Available Appointment'
                        : 'المواعيد المتاحة'),
                Tab(
                    text: expertsData.language == Language.english
                        ? 'Booked Appointment'
                        : 'المواعيد المحجوزة'),
              ]),
          Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxHeight: mediaQuery.size.height -
                  appBar.preferredSize.height -
                  mediaQuery.padding.top -
                  185,
            ),
            child: TabBarView(
              controller: _tabController,
              children: [
                FutureBuilder(
                    future:
                        Provider.of<Experts>(context).getAvalibleTimes(null),
                    builder: (ctx, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.isEmpty) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                expertsData.language == Language.english
                                    ? 'You haven\'t add any times \nTry to add some in your profile'
                                    : 'لم تقم بإضافة أي مواعيد حاول إضافة بعض المواعيد في ملفك الشخصي',
                                textAlign: TextAlign.center,
                                style: kTitleMediumStyle,
                              ),
                            ],
                          );
                        }
                        return ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) {
                              const textStyle =
                                  TextStyle(color: Colors.black, fontSize: 18);
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Date : ${snapshot.data![index]['day']}',
                                        style: textStyle,
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Start at : ${snapshot.data![index]['start']}',
                                        style: textStyle,
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'End at : ${snapshot.data![index]['end']}',
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
                    }),
                FutureBuilder(
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
                              const textStyle =
                                  TextStyle(color: Colors.black, fontSize: 18);
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Date : ${snapshot.data![index]['day']}',
                                        style: textStyle,
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Start at : ${snapshot.data![index]['start']}',
                                        style: textStyle,
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'End at : ${snapshot.data![index]['end']}',
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
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
