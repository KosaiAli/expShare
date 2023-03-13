import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/expert_item.dart';
import '../providers/experts.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expertsData = Provider.of<Experts>(context);
    final favorites = expertsData.getFavoritedExperts;
    return favorites.isEmpty
        ? Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              expertsData.language == Language.english
                  ? 'There are no favorites experts, please add some!'
                  : 'لا يوجد خبراء مفضلون ، يرجى إضافة البعض!',
              style: const TextStyle(color: Colors.black54, fontSize: 30),
              textAlign: TextAlign.center,
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                      itemCount: favorites.length,
                      itemBuilder: (ctx, index) {
                        final expertData = favorites[index];
                        return ExpertItem(id: expertData.id);
                      }),
                )
              ],
            ),
          );
  }
}
