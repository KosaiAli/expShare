import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({super.key, required this.onPressed, this.child});
  final VoidCallback onPressed;
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
        constraints:
            const BoxConstraints.tightFor(width: double.infinity, height: 60),
        onPressed: onPressed,
        splashColor: Colors.white.withOpacity(0.5),
        elevation: 5,
        highlightElevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(35),
        ),
        fillColor: Theme.of(context).primaryColor,
        child: child);
  }
}
