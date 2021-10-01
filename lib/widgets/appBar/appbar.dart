import 'package:aeroday_2021/config/responsive_size.dart';
import 'package:aeroday_2021/constants/app_constants.dart';
import 'package:aeroday_2021/widgets/sidebar/button.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class AppBarCustom extends StatefulWidget {
  final String title;
  final BuildContext c;
  AppBarCustom({required this.title, required this.c});

  @override
  _AppBar createState() => _AppBar(title: this.title, c: this.c);
}

class _AppBar extends State<AppBarCustom> {
  String title;
  BuildContext c;

  _AppBar({required this.title, required this.c});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          padding: const EdgeInsets.all(12.0),
          onPressed: () {
            setState(() {
              Scaffold.of(c).openDrawer();
            });
          },
          color: Colors.white,
          iconSize: SizeConfig.defaultSize * 4.2,
          icon: Icon(
            Icons.menu_rounded,
          ),
        ),
        Container(
          child: Text(
            this.title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          margin: EdgeInsets.only(right: SizeConfig.screenWidth * .03),
          child: GestureDetector(
            onTap: () async {
              if (FirebaseAuth.instance.currentUser == null) return;
              print("logout tap");
              await FirebaseAuth.instance.signOut();
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Done!'),
                      content: Text('You are now logged out.'),
                      actions: [
                        Container(
                          margin: const EdgeInsets.only(right: 14.0),
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith(
                                        (states) => red),
                              ),
                              child: Text('Dismiss')),
                        ),
                      ],
                    );
                  });
              setState(() {});
            },
            child: Column(
              children: [
                Icon(
                  Icons.logout,
                  color: FirebaseAuth.instance.currentUser == null
                      ? Color(0x00FFFFFF)
                      : Color(0xFFFFFFFF),
                  size: SizeConfig.defaultSize * 3,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
