import 'package:flutter/material.dart';

class WelcomeImage extends StatelessWidget {
  const WelcomeImage({Key? key, required this.index, required this.title})
      : super(key: key);
  final int index;
  final String title;
  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.height);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        
      ],
    );
  }
}
