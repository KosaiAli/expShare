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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        width: 100,
        height: 110,
        child: GestureDetector(
          onTap: () => {
            Navigator.pushNamed(context, ExpertProfileScreen.routeName,
                arguments: id)
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 5,
            child: Directionality(
              textDirection: expertProvider.language == Language.english
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(85),
                      child: Image.network(
                        'http://127.0.0.1:8000/${expertData.image}',
                        fit: BoxFit.cover,
                        width: 85,
                        height: 85,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            expertData.name,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            expertProvider
                                .getCatigoryById(expertData.experienceCategory)
                                .type,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              iconButtonBuilder(
                                  context,
                                  () => {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ChatScreen(
                                                        reciver: expertData)))
                                      },
                                  Icons.message),
                              Text(
                                expertData.rate != 0
                                    ? '${expertData.rate.toStringAsFixed(1)}/5'
                                    : 'not rated',
                                style: const TextStyle(
                                    color: Colors.amber, fontSize: 16),
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
                            expertProvider
                                .toggleFavoriteStatusForSpecificExpert(id);
                          },
                          expertData.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 25,
                          aligment: Alignment.topCenter,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget iconButtonBuilder(
    BuildContext context, VoidCallback onPressed, IconData icon,
    {Alignment aligment = Alignment.centerLeft, double size = 20.0}) {
  var data = Provider.of<Experts>(context).language;
  return GestureDetector(
    onTap: onPressed,
    child: Padding(
      padding: EdgeInsets.only(
          right: data == Language.english ? 10 : 0,
          left: data == Language.english ? 0 : 10),
      child: Icon(
        icon,
        color: Theme.of(context).primaryColor,
        size: size,
      ),
    ),
  );
}
