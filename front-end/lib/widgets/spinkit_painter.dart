import 'dart:math';

import 'package:flutter/material.dart';

import '../constants.dart';

class SpinKitPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var r = size.width / 2;
    canvas.translate(r, r);
    double radius = 5;
    for (double i = 0; i <= (pi * 2) - (pi / 4); i += (pi * 2) / 8) {
      var cs = (pow(r, 2) + pow(r, 2) - pow((radius), 2)) / (2 * r * r);
      var angle = acos(cs);

      var dx = r * cos((i - (angle / 2)));
      var dy = r * sin((i - (angle / 2)));

      canvas.drawCircle(
          Offset(dx, dy), radius * 0.5, Paint()..color = kPrimaryColor);

      radius += 1;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
