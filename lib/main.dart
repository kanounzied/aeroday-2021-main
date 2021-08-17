import 'package:aeroday_2021/screens/vote_ac.dart';
import 'package:aeroday_2021/screens/vote_vpd.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'config/responsive_size.dart';
import 'screens/signup_screen/signup_screen.dart';

import 'package:firebase_core/firebase_core.dart' as firebase;

void main() {
  runApp(Home());
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme,),
    primarySwatch: Colors.blue,
      ),
      home: MyApp(),
    // TODO: Find a new place to store the routes
    //   initialRoute: '/home',
    //   routes: {
    //   '/home': (context) => Home(),
    //   '/voteAC': (context) => VoteAC(),
    // '/voteVPD': (context) => VoteVPD(),
    // },
    );
  }
}


class MyApp extends StatefulWidget {
  // Create the initialization Future outside of `build`:
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<MyApp> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  final Future<firebase.FirebaseApp> _initialization = firebase.Firebase.initializeApp();
  SizeConfig sizeConfig = new SizeConfig();
  @override
  Widget build(BuildContext context) {
    sizeConfig.init(context);
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Text("error");
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return SignUpScreen();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Scaffold(
            backgroundColor: Color(0xFF323A40),
            body: SafeArea(
              child: Text("loading"),
            ),
          );
      },

    );}
}
