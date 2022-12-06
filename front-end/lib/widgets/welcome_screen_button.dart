import 'package:expshare/constants.dart';
import 'package:flutter/material.dart';

class WelcomeScreenButton extends StatelessWidget {
  const WelcomeScreenButton(
      {super.key, required this.onPressed, required this.child});
  final Function onPressed;
  final String child;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 50,
      ),
      child: GestureDetector(
        onTap: () => onPressed(),
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(35),
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                    blurRadius: 16,
                    offset: const Offset(0, 8))
              ]),
          height: 50,
          width: double.infinity,
          alignment: Alignment.center,
          child: Text(
            child,
            style: kButtonStyle,
          ),
        ),
      ),
    );
  }
}
