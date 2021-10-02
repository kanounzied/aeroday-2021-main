import 'package:aeroday_2021/screens/home_screen/home.dart';
import 'package:aeroday_2021/screens/leaderboard_screen/leaderboard.dart';
import 'package:aeroday_2021/screens/loading_screen/loading_screen.dart';
import 'package:aeroday_2021/screens/vote_ac.dart';
import 'package:aeroday_2021/screens/vote_vpd.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'config/responsive_size.dart';
import 'package:firebase_core/firebase_core.dart';

import 'constants/eventInfo.dart';

import 'package:device_preview/device_preview.dart';

// void main() {
//   runApp(Home());
// }

void main() => runApp(
      DevicePreview(
        enabled: true,
        builder: (context) => Home(), // Wrap your app
      ),
    );

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.locale(context), // Add the locale here
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyApp(),
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
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  SizeConfig sizeConfig = new SizeConfig();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

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
          // Get the running event
          FirebaseFirestore.instance
              .collection('settings')
              .doc('EventInfo')
              .get()
              .then((DocumentSnapshot ds) {
            EventStats.airshowStats = ds.get(FieldPath(['airshowStats']));
            EventStats.vpdStats = ds.get(FieldPath(['vdpStats']));

            EventStats.currentEvent = ds.get(FieldPath(['currentEvent']));

            print(EventStats.airshowStats);
            setState(() {});
          });

          return MaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: '/home',
              routes: {
                '/home': (context) => HomeScreen(),
                '/voteAC': (context) => (EventStats.airshowStats == 'vote'
                    ? VoteAC()
                    : (EventStats.airshowStats == 'leaderboard'
                        ? LeaderBoard(
                            eventKey: EventStats.EventList[0],
                          )
                        : Home())),
                '/voteVPD': (context) => (EventStats.vpdStats == 'vote'
                    ? VoteVPD()
                    : (EventStats.vpdStats == 'leaderboard'
                        ? LeaderBoard(
                            eventKey: EventStats.EventList[1],
                          )
                        : Home())),
                // '/leaderboard': (context) => LeaderBoard(),
              });
        } else {
          // Otherwise, show something whilst waiting for initialization to complete
          return Scaffold(
            backgroundColor: Color(0xFF323A40),
            body: LoadingScreen(),
          );
        }
      },
    );
  }
}
