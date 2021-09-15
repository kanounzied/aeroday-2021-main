import 'package:aeroday_2021/constants/app_constants.dart';
import 'package:aeroday_2021/widgets/sidebar/sidebar.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dark,
      body: Builder(
        builder: (BuildContext c) => SafeArea(
          child: IconButton(
            onPressed: () {
              setState(() {
                Scaffold.of(c).openDrawer();
              });
            },
            icon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.menu_rounded,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      drawer: SideBar(),
    );
  }
}
