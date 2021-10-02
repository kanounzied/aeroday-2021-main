import 'package:aeroday_2021/config/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomPart extends StatelessWidget {
  String eventName = 'Aerochallenge';
  int id = 00000;
  BottomPart({required this.eventName, required this.id});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1.8 * SizeConfig.defaultSize),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.event,
                      size: 2.2 * SizeConfig.defaultSize,
                    ),
                    SizedBox(
                      width: 1.2 * SizeConfig.defaultSize,
                    ),
                    Text(
                      eventName,
                      style: TextStyle(
                        color: Color(0xFF323A40),
                        fontSize: 1.75 * SizeConfig.defaultSize,
                      ),
                    ),
                  ],
                ),
                /*SizedBox(height: 00),
                Row(
                  children: [
                    Icon(
                      Icons.perm_identity_outlined,
                      color: Color(0xFF323A40),
                      size: 22,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                   Row(
                      children: [
                        Text(
                          'ID : ',
                          style: TextStyle(
                            color: Color(0xFF323A40),
                          ),
                        ),
                        Text(
                          '$id',
                          style: TextStyle(color: Color(0xFFD95252)),
                        ),
                      ],
                    ),
                  ],
                ),*/
                SizedBox(height: 1.0 * SizeConfig.defaultSize),
                Row(
                  children: [
                    Icon(
                      Icons.link_rounded,
                      color: Color(0xFF323A40),
                      size: 2.2 * SizeConfig.defaultSize,
                    ),
                    SizedBox(
                      width: 1.2 * SizeConfig.defaultSize,
                    ),
                    InkWell(
                      onTap: () => launch('http://aeroday.tn/'),
                      child: Text(
                        'Website',
                        style: TextStyle(
                          fontSize: 1.75 * SizeConfig.defaultSize,
                          color: Color(0xFF0092a6),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.0 * SizeConfig.defaultSize),
                Center(
                  child: Text(
                    '© Aeroday 2021',
                    style: TextStyle(
                      fontSize: 1.75 * SizeConfig.defaultSize,
                      color: Color(0xFF323A40),
                    ),
                  ),
                ),
                SizedBox(height: 1.0 * SizeConfig.defaultSize),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
