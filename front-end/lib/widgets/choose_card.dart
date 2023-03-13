import 'package:flutter/material.dart';

import '../constants.dart';

class ChooseCard extends StatelessWidget {
  const ChooseCard(
      {super.key,
      required this.listOfDays,
      required this.callBak,
      required this.element,
      required this.text});
  final Set listOfDays;
  final String element;
  final Function() callBak;
  final String text;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(25),
      onTap: callBak,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 50,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: listOfDays.contains(element)
              ? kPrimaryColor
              : const Color(0xFFE4E4ED),
          borderRadius: BorderRadius.circular(25),
          shape: BoxShape.rectangle,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color:
                  listOfDays.contains(element) ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
