import 'package:aeroday_2021/config/responsive_size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class VerticalBar extends StatelessWidget {
  Color color;
  double len, top = 0;

  VerticalBar({required this.color, required this.len, topMargin}) {
    if (topMargin != null) this.top = topMargin;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: SizeConfig.screenWidth * .1955,
        top: this.top,
      ),
      decoration: BoxDecoration(color: this.color),
      width: 5,
      height: this.len,
    );
  }
}
