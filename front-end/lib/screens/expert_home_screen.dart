import 'package:flutter/material.dart';
import 'package:intl/intl_standalone.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../widgets/available_times.dart';
import '../widgets/booked_appointment.dart';
import '../providers/experts.dart';
import '../widgets/navigation_drawer.dart';

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
    load();
    super.initState();
  }

  Future<void> load() async {
    initializeDateFormatting();
    Intl.systemLocale = await findSystemLocale();
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
    final appBar = AppBar(
      title: const Text('ExpShare'),
    );
    return Scaffold(
      drawer: const NavigationDrawer(),
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
              children: const [AvailablTimes(), BookedAppointment()],
            ),
          ),
        ],
      ),
    );
  }
}
