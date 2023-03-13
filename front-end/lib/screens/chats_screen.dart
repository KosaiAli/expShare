import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/expert.dart';
import '../constants.dart';
import '../providers/experts.dart';
import '../Models/user.dart';
import '../widgets/chat_item.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  FirebaseDatabase database = FirebaseDatabase.instance;
  @override
  void initState() {
 
    super.initState();
  }

  late Map chats;
 

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<Experts>(context);
    dynamic user = data.isExpert ? data.user as Expert : data.user as User;
    return FutureBuilder<DataSnapshot>(
      future: database.ref('${user.id}/chats').get(),
      builder: ((context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data!.value == null) {
          return Center(
            child: Text(
              data.language == Language.english
                  ? 'No Chats yet'
                  : 'لا يوجد لديك محادثات',
              style: kTitleMediumStyle,
            ),
          );
        }
        List<MapEntry> chats = (snapshot.data!.value as Map).entries.toList();
        return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
             
              return ChatItem(id: chats[index].key, name: chats[index].value);
            });
      }),
    );
  }
}
