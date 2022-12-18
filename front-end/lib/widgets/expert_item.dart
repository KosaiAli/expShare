import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/experts.dart';
import '../screens/chat_screen.dart';
import '../screens/expert_profile_screen.dart';

class ExpertItem extends StatelessWidget {
  final String id;
  const ExpertItem({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final expertProvider = Provider.of<Experts>(context);
    final expertData = expertProvider.getExpertById(id);
    return SizedBox(
      width: 125,
      height: 125,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.memory(
                  base64.decode(expertData.image),
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        expertData.name,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Text(
                      expertProvider
                          .getCatigoryById(expertData.experienceCategory)
                          .type,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        iconButtonBuilder(context, () => {}, Icons.phone),
                        iconButtonBuilder(
                            context,
                            () => {
                                  Navigator.pushNamed(
                                      context, ChatScreen.routeName)
                                },
                            Icons.message),
                        const Text(
                          '4.6/5',
                          style: TextStyle(color: Colors.amber, fontSize: 16),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  iconButtonBuilder(
                    context,
                    () {
                      expertProvider.toggleFavoriteStatusForSpecificExpert(id);
                    },
                    expertData.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    size: 25,
                    aligment: Alignment.topCenter,
                  ),
                  iconButtonBuilder(
                    context,
                    () => {
                      Navigator.pushNamed(
                          context, ExpertProfileScreen.routeName,
                          arguments: id)
                    },
                    Icons.person,
                    size: 25,
                    aligment: Alignment.center,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget iconButtonBuilder(
    BuildContext context, VoidCallback onPressed, IconData icon,
    {Alignment aligment = Alignment.centerLeft, double size = 20.0}) {
  return IconButton(
    padding: const EdgeInsets.all(0),
    alignment: aligment,
    onPressed: onPressed,
    icon: Icon(
      icon,
      color: Theme.of(context).primaryColor,
      size: size,
    ),
  );
}
