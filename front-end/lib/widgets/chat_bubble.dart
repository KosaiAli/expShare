import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../providers/experts.dart';

class ChatBubble extends StatefulWidget {
  const ChatBubble(
      {super.key,
      required this.user,
      required this.sender,
      required this.reciver,
      required this.message});
  final dynamic user;
  final dynamic reciver;
  final dynamic sender;
  final String message;
  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
      ..addListener(() {
        setState(() {});
      });
    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: widget.sender == widget.user.id
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end,
      children: [
        Opacity(
          opacity: animationController.value >= 0.8 ? 1 : 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
            child: Text(
              widget.sender == widget.user.id
                  ? Provider.of<Experts>(context).language == Language.english
                      ? 'You'
                      : 'أنت'
                  : widget.reciver.name.toString()[0].toUpperCase() +
                      widget.reciver.name.toString().substring(1),
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        ScaleTransition(
          scale: animationController.view,
          child: Row(
            mainAxisAlignment: widget.sender == widget.user.id
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            children: [
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width / 2),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                margin: const EdgeInsets.fromLTRB(5, 0, 5, 3),
                decoration: BoxDecoration(
                    color: widget.sender != widget.user.id
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(20),
                    border:
                        widget.sender != widget.user.id ? Border.all() : null,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: const Offset(0, 8),
                          blurRadius: 10)
                    ]),
                child: Text(
                  widget.message,
                  style: kTitleMediumStyle.copyWith(
                      color: widget.sender != widget.user.id
                          ? Colors.black
                          : Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.left,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
