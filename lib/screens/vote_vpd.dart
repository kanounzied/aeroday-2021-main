import 'package:aeroday_2021/constants/app_constants.dart';
import 'package:aeroday_2021/widgets/sidebar/sidebar.dart';
import 'package:flutter/material.dart';

class VoteVPD extends StatefulWidget {
  @override
  _VoteVPDState createState() => _VoteVPDState();
}

class _VoteVPDState extends State<VoteVPD> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dark,
      body: Builder(
        builder: (BuildContext c) => SafeArea(
          child: Row(
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
                iconSize: 40,
                icon: Icon(
                  Icons.menu_rounded,
                ),
              ),
              Container(
                child: Text(
                  'VIDEOGRAPHIE PAR DRONE',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: 64, //iconsize + horizontal padding (to center the title)
              )
            ],
          ),
        ),
      ),
      drawer: SideBar(),
    );
  }
}
