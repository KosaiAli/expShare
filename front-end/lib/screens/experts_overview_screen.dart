import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/experts.dart';
import '../widgets/expert_item.dart';
import '../widgets/search_bar.dart';

class ExpertsOverviewScreen extends StatelessWidget {
  const ExpertsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expertsData = Provider.of<Experts>(context);
    final experts = expertsData.getExperts;

    return Scaffold(
      appBar: SearchBar(forwardingSearchInput: expertsData.searchInput),
      body: experts.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'There is no Exert with this name or experience!',
                style: TextStyle(color: Colors.black54, fontSize: 30),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: experts.length,
                        itemBuilder: (ctx, index) {
                          final expertData = experts[index];
                          return ExpertItem(id: expertData.id);
                        }),
                  )
                ],
              ),
            ),
    );
  }
}
