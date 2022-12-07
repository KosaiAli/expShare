import 'package:expshare/widgets/expert_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/experts.dart';

class ExpertsOverviewScreen extends StatelessWidget {
  const ExpertsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expertsData = Provider.of<Experts>(context).getAllExperts;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                itemCount: expertsData.length,
                itemBuilder: (ctx, index) {
                  final expertData = expertsData[index];
                  return ExpertItem(
                    image: expertData.image,
                    name: '${expertData.firstName} ${expertData.lastName}',
                    experienceCategory: expertData.experienceCategory,
                  );
                }),
          )
        ],
      ),
    );
  }
}
