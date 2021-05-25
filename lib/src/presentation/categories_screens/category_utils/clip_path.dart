import 'dart:ui';
import 'package:flutter/material.dart';

class ClipPathClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    // move điểm bắt đầu vẽ đến vị trí (width = width, height = 0)
    path.moveTo(size.width, 0.0);

    // từ điểm bắt đầu, vẽ một đường thẳng đến vị trí (width = 2.8/4 * width, height = 0) (gọi là điểm 1)
    path.lineTo(size.width * 2.8 / 4, 0.0);

    var firstControlPoint = Offset(size.width, size.height * 1 / 2);
    // từ điểm 1, vẽ một đường thẳng đến điểm 2 có vị trí (width = width, height = 1/2 * height)
    path.lineTo(firstControlPoint.dx, firstControlPoint.dy);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
