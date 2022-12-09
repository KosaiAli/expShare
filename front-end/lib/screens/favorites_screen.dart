import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/expert_item.dart';
import '../providers/experts.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expertsData = Provider.of<Experts>(context).getFavoritedExperts;
    return expertsData.isEmpty
        ? const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'There are no Favorites, pleas add some!',
              style: TextStyle(color: Colors.black54, fontSize: 30),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                      itemCount: expertsData.length,
                      itemBuilder: (ctx, index) {
                        final expertData = expertsData[index];
                        return ExpertItem(id: expertData.id);
                      }),
                )
              ],
            ),
          );
  }
}
