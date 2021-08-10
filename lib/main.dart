import 'package:aeroday_2021/screens/home.dart';
import 'package:aeroday_2021/screens/vote_ac.dart';
import 'package:aeroday_2021/screens/vote_vpd.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
        '/voteAC': (context) => VoteAC(),
        '/voteVPD': (context) => VoteVPD(),
      },
    );
  }
}

class pageChanger {}
