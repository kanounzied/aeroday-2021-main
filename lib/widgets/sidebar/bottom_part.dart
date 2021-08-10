import 'package:aeroday_2021/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomPart extends StatelessWidget {
  String eventName = 'Aerochallenge';
  int id = 00000;
  BottomPart({this.eventName, this.id});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18),
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
                      size: 22,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      eventName,
                      style: TextStyle(
                        color: Color(0xFF323A40),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
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
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.link_rounded,
                      color: Color(0xFF323A40),
                      size: 22,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    InkWell(
                      onTap: () => launch('http://aeroday.tn/'),
                      child: Text(
                        'Website',
                        style: TextStyle(
                          color: Color(0xFF0092a6),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50),
                Center(
                  child: Text(
                    '© Aeroday 2021',
                    style: TextStyle(
                      color: Color(0xFF323A40),
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
