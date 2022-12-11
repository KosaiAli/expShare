import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/experts.dart';
import '../widgets/about_me.dart';
import '../widgets/select_appointment.dart';

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
    final expertId = ModalRoute.of(context)?.settings.arguments as String;
    final expertData = Provider.of<Experts>(context).getExpertById(expertId);
    final mediaQuery = MediaQuery.of(context);
    final appBar = AppBar(
      title: Text(expertData.fullName),
    );

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Image.asset(
                expertData.image,
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
                        tabs: const [
                          Tab(text: 'About me'),
                          Tab(text: 'Hire me'),
                          Tab(text: 'Rate me'),
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
                        SelectAppointment(
                          price: expertData.price,
                        ),
                        AboutMe(expertData: expertData),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
