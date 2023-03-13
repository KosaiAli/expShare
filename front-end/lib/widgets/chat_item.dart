import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/user.dart';
import '../constants.dart';
import '../providers/experts.dart';
import '../screens/chat_screen.dart';

class ChatItem extends StatelessWidget {
  const ChatItem({super.key, required this.id, required this.name});
  final String id;
  final String name;
  @override
  Widget build(BuildContext context) {
    var data = Provider.of<Experts>(context);
    dynamic reciver;
    if (data.isExpert) {
      reciver = User(id: id, email: 'email', name: name);
    } else {
      reciver = Provider.of<Experts>(context).getExpertById(id);
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(reciver: reciver)));
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              if (!data.isExpert)
                ClipRRect(
                  borderRadius: BorderRadius.circular(85),
                  child: Image.network(
                    'http://127.0.0.1:8000/${reciver.image}',
                    fit: BoxFit.cover,
                    width: 60,
                    height: 60,
                  ),
                ),
              const SizedBox(width: 10),
              Text(
                name,
                style: kTitleSmallStyle,
              )
            ],
          ),
        ),
      ),
    );
  }
}
