import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/expert.dart';
import '../Models/user.dart';
import '../constants.dart';
import '../providers/experts.dart';
import '../widgets/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = "/ChatScreen";
  const ChatScreen({super.key, required this.reciver});
  final dynamic reciver;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseDatabase database = FirebaseDatabase.instance;
  TextEditingController textEditingController = TextEditingController();
  ScrollController scrollController = ScrollController();
  int chatlength = 0;
  List<DataSnapshot>? chats;

  dynamic user;
  @override
  void initState() {
    var data = Provider.of<Experts>(context, listen: false);

    if (data.isExpert) {
      user = data.user as Expert;

      database
          .ref('${widget.reciver.id}/chat${user.id}')
          .onValue
          .listen((event) {
        if (mounted) {
          setState(() {
            chats = event.snapshot.children.toList();
          });
        }
      });
    } else {
      user = data.user as User;

      database
          .ref('${user.id}/chat${widget.reciver.id}')
          .onValue
          .listen((event) {
        if (mounted) {
          setState(() {
            chats = event.snapshot.children.toList();
            chats ??= [];
          });
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<Experts>(context, listen: false);

    return Directionality(
      textDirection: data.language == Language.english
          ? TextDirection.ltr
          : TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.reciver.name),
        ),
        body: chats != null
            ? Column(
                children: [
                  if (chats!.isNotEmpty)
                    Expanded(
                      child: ListView(
                        reverse: true,
                        physics: const BouncingScrollPhysics(),
                        controller: scrollController,
                        children: chats!.reversed.toList().map(
                          (messages) {
                            return ChatBubble(
                                key: ValueKey(messages.key),
                                user: user,
                                reciver: widget.reciver,
                                sender: (messages.value! as dynamic)['sender'],
                                message:
                                    (messages.value! as dynamic)['message']);
                          },
                        ).toList(),
                      ),
                    ),
                  if (!chats!.isNotEmpty)
                    Expanded(
                        child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          data.language == Language.english
                              ? 'No messages yet \nBe the first to send message to this chat'
                              : 'لا يوجد رسائل \n كن أول من يرسل الرسائل في هذه المحادثة',
                          style: kButtonStyle.copyWith(color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: textEditingController,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: data.language == Language.english
                            ? 'write a message'
                            : 'اكتب رسالة',
                        suffixIcon: GestureDetector(
                            onTap: () async {
                              database
                                  .ref()
                                  .child(
                                      '${user.id}/chats/${widget.reciver.id}')
                                  .set(widget.reciver.name);
                              database
                                  .ref()
                                  .child(
                                      '${widget.reciver.id}/chats/${user.id}')
                                  .set(user.name);

                              if (!data.isExpert) {
                                database
                                    .ref()
                                    .child(
                                        '${user.id}/chat${widget.reciver.id}/${chats!.length + 1}')
                                    .set({
                                  'sender': user.id,
                                  'message': textEditingController.text.trim()
                                });
                              } else {
                                database
                                    .ref()
                                    .child(
                                        '${widget.reciver.id}/chat${user.id}/${chats!.length + 1}')
                                    .set({
                                  'sender': user.id,
                                  'message': textEditingController.text.trim()
                                });
                              }
                              textEditingController.clear();
                            },
                            child: Icon(
                              Icons.send,
                              color: Theme.of(context).primaryColor,
                            )),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor, width: 2),
                        ),
                      ),
                    ),
                  )
                ],
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
