import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/experts.dart';
import '../screens/chat_screen.dart';

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
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  expertData.image,
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
                    Text(
                      "${expertData.firstName} ${expertData.lastName}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      expertData.experienceCategory,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const Spacer(),
                    Row(
                      children: <Widget>[
                        const Text(
                          '4.6/5',
                          style: TextStyle(color: Colors.amber, fontSize: 12),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        iconButtonBuilder(context, () => {}, Icons.phone),
                        const SizedBox(
                          width: 15,
                        ),
                        iconButtonBuilder(
                            context,
                            () => {
                                  Navigator.pushNamed(
                                      context, ChatScreen.routeName)
                                },
                            Icons.message),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Column(
                children: [
                  iconButtonBuilder(context, () {
                    expertProvider.toggleFavoriteStatusForSpecificExpert(id);
                  },
                      expertData.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      size: 24),
                  const Spacer(),
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
    {double size = 20.0}) {
  return GestureDetector(
    onTap: onPressed,
    child: Icon(
      icon,
      color: Theme.of(context).primaryColor,
      size: size,
    ),
  );
}
