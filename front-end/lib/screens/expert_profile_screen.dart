import 'dart:convert';

import 'package:expshare/https/config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../Models/expert.dart';
import '../providers/experts.dart';
import '../widgets/about_me.dart';
import '../widgets/select_appointment.dart';
import '../widgets/expert_evaluation.dart';

class ExpertProfileScreen extends StatefulWidget {
  static const routeName = "/ExpertProfileScreen";
  const ExpertProfileScreen({
    super.key,
  });

  @override
  State<ExpertProfileScreen> createState() => _ExpertProfileScreenState();
}

class _ExpertProfileScreenState extends State<ExpertProfileScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Experts>(context);
    final language = provider.language;
    String expertId;
    Expert expertData;
    if (!provider.isExpert) {
      expertId = ModalRoute.of(context)?.settings.arguments as String;
      expertData = provider.getExpertById(expertId);
    } else {
      expertData = Provider.of<Experts>(context).user!;
    }

    final mediaQuery = MediaQuery.of(context);
    final appBar = AppBar(
      title: Text(expertData.name),
    );

    return Directionality(
      textDirection:
          language == Language.english ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        appBar: appBar,
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Image.network(
                  "http://127.0.0.1:8000/expShare/${expertData.image}",
                  width: double.infinity,
                  height: 230,
                  fit: BoxFit.cover,
                ),
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: TabBar(
                          labelColor: Theme.of(context).primaryColor,
                          controller: _tabController,
                          indicatorColor: Theme.of(context).primaryColor,
                          tabs: [
                            Tab(
                                text: language == Language.english
                                    ? 'About'
                                    : 'تفاصيل'),
                            Tab(
                                text: language == Language.english
                                    ? 'Add Appointment'
                                    : 'الحجوزات'),
                            Tab(
                                text: language == Language.english
                                    ? 'Rate'
                                    : 'تقييم'),
                          ]),
                    ),
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
                          AboutMe(expertData: expertData),
                          provider.isExpert
                              ? SelectAppointment(
                                  price: expertData.price,
                                )
                              : BookAppointment(expertID: expertData.id),
                          ExpertEvaluation(id: expertData.id),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BookAppointment extends StatefulWidget {
  const BookAppointment({super.key, required this.expertID});
  final String expertID;
  @override
  State<BookAppointment> createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<BookAppointment> {
  List? appointemnts;
  @override
  void initState() {
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
    var url = Uri.http(Config.host, 'api/addAppointment');
    var header = await Config.getHeader();
    await http.post(url,
        headers: header,
        body: jsonEncode({'time_id': timeID, 'expert_id': widget.expertID}));

    getAppointemnts();
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: const Text(
            'Appointment Booked successfully :)',
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

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (ctx) {
      if (appointemnts != null) {
        return ListView.builder(
            itemCount: appointemnts!.length,
            itemBuilder: (context, index) {
              const textStyle = TextStyle(color: Colors.black, fontSize: 18);
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Date : ${appointemnts![index]['day']}',
                            style: textStyle,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Start at : ${appointemnts![index]['start']}',
                            style: textStyle,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'End at : ${appointemnts![index]['end']}',
                            style: textStyle,
                          ),
                        ],
                      ),
                      GestureDetector(
                          onTap: () =>
                              bookAppointment(appointemnts![index]['id']),
                          child: const Icon(Icons.add))
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
