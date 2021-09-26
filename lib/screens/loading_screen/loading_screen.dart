import 'package:aeroday_2021/config/responsive_size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(128, 128, 128, .5),
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenHeight,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
