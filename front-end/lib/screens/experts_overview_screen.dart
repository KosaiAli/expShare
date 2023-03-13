import 'package:expshare/screens/tabs_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/catigory.dart';
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
      drawer: const NavigationDrawer(),
      body: Column(
        children: [
          categoryItemBuilder(categories, expertsData.selectCategory,
              expertsData.selectedCatergory, context),
          const SizedBox(height: 10),
          experts.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    expertsData.language == Language.english
                        ? 'There is no Exert with this name or experience!'
                        : 'لا يوجد خبير بهذا الاسم أو الخبرة!',
                    style: const TextStyle(color: Colors.black54, fontSize: 30),
                    textAlign: TextAlign.center,
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

  Widget categoryItemBuilder(List<Catigory> categories, Function selectCategory,
      int selectedCategory, context) {
    return SizedBox(
      height: 55,
      child: Directionality(
        textDirection:
            Provider.of<Experts>(context).language == Language.english
                ? TextDirection.ltr
                : TextDirection.rtl,
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
                border: Border.all(color: Theme.of(context).primaryColor),
                color: index == selectedCategory
                    ? Theme.of(context).primaryColor
                    : Colors.white,
              ),
              alignment: Alignment.center,
              child: Text(
                categories[index].type,
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: 1.1,
                  color: index == selectedCategory
                      ? Colors.white
                      : Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
