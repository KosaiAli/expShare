import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/expert.dart';
import '../providers/experts.dart';
import '../widgets/about_me.dart';
import '../widgets/book_appointment.dart';
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
                  "http://127.0.0.1:8000/${expertData.image}",
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
