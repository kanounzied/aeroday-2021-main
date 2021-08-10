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
      appBar: AppBar(
        title: Text('VPD'),
      ),
      body: Container(),
      drawer: SideBar(),
    );
  }
}
