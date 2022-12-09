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
    final experts = expertsData.getFilteredExperts;
    final categories = expertsData.categories;

    return Scaffold(
      appBar: SearchBar(forwardingSearchInput: expertsData.searchInput),
      body: Column(
        children: [
          categoryItemBuilder(categories, expertsData.selectCategory),
          const SizedBox(height: 10),
          experts.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'There is no Exert with this name or experience!',
                    style: TextStyle(color: Colors.black54, fontSize: 30),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                      itemCount: experts.length,
                      itemBuilder: (ctx, index) {
                        final expertData = experts[index];
                        return ExpertItem(id: expertData.id);
                      }),
                )
        ],
      ),
    );
  }

  Widget categoryItemBuilder(List<String> categories, Function selectCategory) {
    return SizedBox(
      height: 55,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            selectCategory(index);
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).primaryColor,
            ),
            alignment: Alignment.center,
            child: Text(
              categories[index],
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
