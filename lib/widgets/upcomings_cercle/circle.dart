import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CirclePaint extends CustomPainter {
  Color innerColor, outerColor, lineColor;
  double rad, lineLen;
  bool drawLine;

  CirclePaint(
      {required this.outerColor,
      required this.innerColor,
      required this.rad,
      this.drawLine = false,
      this.lineColor = const Color(0xFFFFFF),
      this.lineLen = 0.0});

  @override
  void paint(Canvas canvas, Size size) {
    var outerCercle = Paint()
      ..color = this.outerColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(5 + 1, 0), this.rad, outerCercle);

    var innerCercle = Paint()
      ..color = this.innerColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(5 + 1, 0), this.rad / 2, innerCercle);

    var linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    if (this.drawLine)
      canvas.drawRect(
          Rect.fromLTWH(this.rad / 2 - 1, this.rad, 5.5, lineLen), linePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
