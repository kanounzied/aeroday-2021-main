import 'package:aeroday_2021/config/responsive_size.dart';
import 'package:aeroday_2021/constants/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        color: Color(0x77000000),
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(red),
            backgroundColor: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
