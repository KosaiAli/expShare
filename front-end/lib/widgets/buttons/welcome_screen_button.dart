import 'package:expshare/constants.dart';
import 'package:flutter/material.dart';

class WelcomeScreenButton extends StatelessWidget {
  const WelcomeScreenButton(
      {super.key, required this.onPressed, required this.child});
  final VoidCallback onPressed;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(35),
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 8))
              ]),
          height: 60,
          width: double.infinity,
          alignment: Alignment.center,
          child: child),
    );
  }
}
