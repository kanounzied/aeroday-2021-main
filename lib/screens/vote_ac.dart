import 'package:aeroday_2021/constants/app_constants.dart';
import 'package:aeroday_2021/widgets/sidebar/sidebar.dart';
import 'package:flutter/material.dart';

class VoteAC extends StatefulWidget {
  @override
  _VoteACState createState() => _VoteACState();
}

class _VoteACState extends State<VoteAC> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dark,
      appBar: AppBar(
        title: Text('AC'),
      ),
      body: Container(),
      drawer: SideBar(),
    );
  }
}
