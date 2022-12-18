import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../providers/experts.dart';
import '../widgets/expert_item.dart';
import '../widgets/search_bar.dart';
import '../configuration/config.dart';

class ExpertsOverviewScreen extends StatefulWidget {
  const ExpertsOverviewScreen({super.key});

  @override
  State<ExpertsOverviewScreen> createState() => _ExpertsOverviewScreenState();
}

class _ExpertsOverviewScreenState extends State<ExpertsOverviewScreen> {
  bool loading = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final expertsData = Provider.of<Experts>(context);
    final experts = expertsData.getFilteredExperts;
    final categories = expertsData.categories;
    return Scaffold(
      appBar: SearchBar(forwardingSearchInput: expertsData.searchInput),
      body: Column(
        children: [
          categoryItemBuilder(categories, expertsData.selectCategory,
              expertsData.selectedCatergory),
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

  Widget categoryItemBuilder(List<Catigory> categories, Function selectCategory,
      int selectedCategory) {
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
                color: index == selectedCategory
                    ? Colors.white
                    : Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
