import 'package:aeroday_2021/constants/app_constants.dart';
import 'package:aeroday_2021/widgets/sidebar/sidebar.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../../widgets/upcomings_cercle/circle.dart';

import '../../config/responsive_size.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  double boxPerc = .68;
  double timeCircleRad = 11;
  double boxCircleRad = 4;

  TextStyle boxContentStyle = TextStyle(
    //color: Color(0xff523e43),
    fontSize: SizeConfig.defaultSize * 1.5,
    fontFamily: "Arial",
    fontWeight: FontWeight.bold,
  );

  TextStyle timeTextStyle = TextStyle(
    fontSize: SizeConfig.defaultSize * 1.6,
    fontFamily: "Arial",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: dark,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xFF323A40),
        centerTitle: true,
        title: Text('Timeline'),
        flexibleSpace: SafeArea(
          child: Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(right: SizeConfig.screenWidth * .01),
            child: GestureDetector(
              onTap: () async {
                print("tap");
                await FirebaseAuth.instance.signOut();
              },
              child: Icon(
                Icons.logout,
                color: Color(0xFFFFFFFF),
                size: SizeConfig.defaultSize * 3,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Line seperator
            Center(
              child: Container(
                width: SizeConfig.screenWidth * .65,
                height: SizeConfig.screenHeight * 0.003,
                decoration: new BoxDecoration(
                  color: Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(500),
                    topRight: Radius.circular(500),
                    bottomLeft: Radius.circular(500),
                    bottomRight: Radius.circular(500),
                  ),
                ),
              ),
            ),
            // White box for timeline
            Expanded(
              child: Container(
                decoration: new BoxDecoration(
                  color: Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                margin: EdgeInsets.only(top: SizeConfig.screenHeight * .08),
                width: SizeConfig.screenWidth,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(left: 50, top: 25),
                          child: Text(
                            "Upcomings",
                            style: TextStyle(
                              fontFamily: "Nexa",
                              fontSize: SizeConfig.defaultSize * 3.5,
                              fontWeight: FontWeight.w700,
                              //decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        // Ligne 1, "2 Octobre 2021"
                        Row(
                          children: [
                            Container(
                              height: SizeConfig.screenHeight * .065,
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(
                                  top: 40, left: SizeConfig.screenWidth * .25),
                              child: Text(
                                "2 Octobre 2021",
                                style: TextStyle(
                                  fontSize: SizeConfig.defaultSize * 2,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Arial",
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Ligne 2
                        Row(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(
                                  top: 0, left: SizeConfig.screenWidth * .03),
                              child: Text(
                                "08:00",
                                style: timeTextStyle,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: SizeConfig.screenWidth * .05),
                              width: 10,
                              height: 0,
                              child: CustomPaint(
                                painter: CirclePaint(
                                  innerColor: Color(0xFFF2F2F2),
                                  outerColor: Color(0xffd95252),
                                  rad: timeCircleRad,
                                  drawLine: true,
                                  lineColor: Color(0xFFe3aeb3),
                                  lineLen: SizeConfig.screenHeight * .125,
                                  drawUpperLine: true,
                                  lineUpperColor: Color(0xFFeae5ee),
                                  lineUpperLen: SizeConfig.screenHeight * .065,
                                ),
                              ),
                            )
                          ],
                        ),
                        // Ligne 3, Box
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Box 1 (Checkin + Fly test)

                            Container(
                              //constraints: BoxConstraints.expand(),
                              alignment: Alignment.topLeft,
                              //height: SizeConfig.screenHeight * .115,
                              width: SizeConfig.screenWidth * boxPerc,
                              decoration: BoxDecoration(
                                  color: Color(0xffd95252),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  )),
                              margin: EdgeInsets.only(
                                  top: 0, left: SizeConfig.screenWidth * .25),
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: 18,
                                ),
                                // Box 1 content
                                child: Column(
                                  children: [
                                    // Ligne 1 of box 1
                                    Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: SizeConfig.screenWidth *
                                                  .035),
                                          width: 10,
                                          height: 0,
                                          child: CustomPaint(
                                            painter: CirclePaint(
                                                innerColor: Color(0xffd95252),
                                                outerColor: Color(0xff3b2d30),
                                                rad: boxCircleRad),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: SizeConfig.screenWidth * .03,
                                          ),
                                          child: Text(
                                            "Check in",
                                            style: boxContentStyle,
                                          ),
                                        )
                                      ],
                                    ),
                                    // Ligne 2 of box 1
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: SizeConfig.screenWidth * .035,
                                            top: 9,
                                          ),
                                          width: 10,
                                          height: 0,
                                          child: CustomPaint(
                                            painter: CirclePaint(
                                                innerColor: Color(0xffd95252),
                                                outerColor: Color(0xff3b2d30),
                                                rad: boxCircleRad),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: SizeConfig.screenWidth * .03,
                                            top: 4,
                                          ),
                                          width: SizeConfig.screenWidth * 0.58,
                                          child: Text(
                                            "Fly test (Port one aeromodelisme)",
                                            style: boxContentStyle,
                                          ),
                                        )
                                      ],
                                    ),
                                    // Spacing
                                    Row(
                                      children: [
                                        Container(
                                          child: Text(""),
                                          width: 10,
                                          height:
                                              SizeConfig.screenHeight * .025,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Ligne 4 ( 10:00 )
                        Row(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(
                                  top: 0, left: SizeConfig.screenWidth * .03),
                              child: Text(
                                "10:00",
                                style: timeTextStyle,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: SizeConfig.screenWidth * .05),
                              width: 10,
                              height: 0,
                              child: CustomPaint(
                                painter: CirclePaint(
                                  innerColor: Color(0xFFF2F2F2),
                                  outerColor: Color(0xffdc6767),
                                  rad: timeCircleRad,
                                  drawLine: true,
                                  lineColor: Color(0xFFe4b9be),
                                  lineLen: SizeConfig.screenHeight * .070,
                                ),
                              ),
                            )
                          ],
                        ),
                        // Ligne 5, Box 2
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Box 2 (Pause)
                            Container(
                              alignment: Alignment.topLeft,
                              //height: SizeConfig.screenHeight * .070,
                              width: SizeConfig.screenWidth * boxPerc,
                              decoration: BoxDecoration(
                                  color: Color(0xffdc7070),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  )),
                              margin: EdgeInsets.only(
                                  top: 0, left: SizeConfig.screenWidth * .25),
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: 18,
                                ),
                                // Box 2 content
                                child: Column(
                                  children: [
                                    // Ligne 1 of box 2
                                    Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: SizeConfig.screenWidth *
                                                  .035),
                                          width: 10,
                                          height: 0,
                                          child: CustomPaint(
                                            painter: CirclePaint(
                                                innerColor: Color(0xffdc7070),
                                                outerColor: Color(0xff3b2d30),
                                                rad: boxCircleRad),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: SizeConfig.screenWidth * .03,
                                          ),
                                          child: Text(
                                            "Pause artistique",
                                            style: boxContentStyle,
                                          ),
                                        )
                                      ],
                                    ),
                                    // Spacing
                                    Row(
                                      children: [
                                        Container(
                                          child: Text(""),
                                          width: 10,
                                          height:
                                              SizeConfig.screenHeight * .025,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Ligne 6 ( 10:30 )
                        Row(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(
                                  top: 0, left: SizeConfig.screenWidth * .03),
                              child: Text(
                                "10:30",
                                style: timeTextStyle,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: SizeConfig.screenWidth * .05),
                              width: 10,
                              height: 0,
                              child: CustomPaint(
                                painter: CirclePaint(
                                  innerColor: Color(0xFFF2F2F2),
                                  outerColor: Color(0xffde8181),
                                  rad: timeCircleRad,
                                  drawLine: true,
                                  lineColor: Color(0xFFe4c3c8),
                                  lineLen: SizeConfig.screenHeight * .070,
                                ),
                              ),
                            )
                          ],
                        ),
                        // Ligne 7, Box 3
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Box 3 (Airshow)
                            Container(
                              alignment: Alignment.topLeft,
                              //height: SizeConfig.screenHeight * .070,
                              width: SizeConfig.screenWidth * boxPerc,
                              decoration: BoxDecoration(
                                  color: Color(0xffdd8c8c),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  )),
                              margin: EdgeInsets.only(
                                  top: 0, left: SizeConfig.screenWidth * .25),
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: 18,
                                ),
                                // Box 3 content
                                child: Column(
                                  children: [
                                    // Ligne 1 of box 3
                                    Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: SizeConfig.screenWidth *
                                                  .035),
                                          width: 10,
                                          height: 0,
                                          child: CustomPaint(
                                            painter: CirclePaint(
                                                innerColor: Color(0xffdd8c8c),
                                                outerColor: Color(0xff3b2d30),
                                                rad: boxCircleRad),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: SizeConfig.screenWidth * .03,
                                          ),
                                          child: Text(
                                            "Airshow",
                                            style: boxContentStyle,
                                          ),
                                        )
                                      ],
                                    ),
                                    // Spacing
                                    Row(
                                      children: [
                                        Container(
                                          child: Text(""),
                                          width: 10,
                                          height:
                                              SizeConfig.screenHeight * .025,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Ligne 8 ( 12:00 )
                        Row(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(
                                  top: 0, left: SizeConfig.screenWidth * .03),
                              child: Text(
                                "12:00",
                                style: timeTextStyle,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: SizeConfig.screenWidth * .05),
                              width: 10,
                              height: 0,
                              child: CustomPaint(
                                painter: CirclePaint(
                                  innerColor: Color(0xFFF2F2F2),
                                  outerColor: Color(0xffe19c9c),
                                  rad: timeCircleRad,
                                  drawLine: true,
                                  lineColor: Color(0xFFe6ced3),
                                  lineLen: SizeConfig.screenHeight * .070,
                                ),
                              ),
                            )
                          ],
                        ),
                        // Ligne 9, Box 4
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Box 4 (Cloture)
                            Container(
                              alignment: Alignment.topLeft,
                              //height: SizeConfig.screenHeight * .070,
                              width: SizeConfig.screenWidth * boxPerc,
                              decoration: BoxDecoration(
                                  color: Color(0xffdfa9a9),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  )),
                              margin: EdgeInsets.only(
                                  top: 0, left: SizeConfig.screenWidth * .25),
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: 18,
                                ),
                                // Box 4 content
                                child: Column(
                                  children: [
                                    // Ligne 1 of box 4
                                    Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: SizeConfig.screenWidth *
                                                  .035),
                                          width: 10,
                                          height: 0,
                                          child: CustomPaint(
                                            painter: CirclePaint(
                                                innerColor: Color(0xffdfa9a9),
                                                outerColor: Color(0xff3b2d30),
                                                rad: boxCircleRad),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: SizeConfig.screenWidth * .03,
                                          ),
                                          child: Text(
                                            "Cloture et remise des prix",
                                            style: boxContentStyle,
                                          ),
                                        )
                                      ],
                                    ),
                                    // Spacing
                                    Row(
                                      children: [
                                        Container(
                                          child: Text(""),
                                          width: 10,
                                          height:
                                              SizeConfig.screenHeight * .025,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Ligne 10 ( 13:00 )
                        Row(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(
                                  top: 0, left: SizeConfig.screenWidth * .03),
                              child: Text(
                                "13:00",
                                style: timeTextStyle,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: SizeConfig.screenWidth * .05),
                              width: 10,
                              height: 0,
                              child: CustomPaint(
                                painter: CirclePaint(
                                  innerColor: Color(0xFFF2F2F2),
                                  outerColor: Color(0xffdfa9a9),
                                  rad: timeCircleRad,
                                  drawLine: true,
                                  lineColor: Color(0xFFeae0e3),
                                  lineLen: SizeConfig.screenHeight * .070,
                                ),
                              ),
                            )
                          ],
                        ),
                        // Ligne 11, 9 Octobre 2021
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: SizeConfig.screenHeight * .05,
                              margin: EdgeInsets.only(
                                  top: 8, left: SizeConfig.screenWidth * .25),
                              child: Text(
                                "9 Octobre 2021",
                                style: TextStyle(
                                  fontSize: SizeConfig.defaultSize * 2,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Arial",
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Ligne 12 ( 15:00 )
                        Row(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(
                                  top: 0, left: SizeConfig.screenWidth * .03),
                              child: Text(
                                "15:00",
                                style: timeTextStyle,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: SizeConfig.screenWidth * .05),
                              width: 10,
                              height: 0,
                              child: CustomPaint(
                                painter: CirclePaint(
                                  innerColor: Color(0xFFF2F2F2),
                                  outerColor: Color(0xffe8d7b9),
                                  rad: timeCircleRad,
                                  drawLine: true,
                                  lineColor: Color(0xFFe9e1de),
                                  lineLen: SizeConfig.screenHeight * .29,
                                ),
                              ),
                            )
                          ],
                        ),
                        // Ligne 13, Box 5
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Box 5 (challenge 24h)
                            Container(
                              alignment: Alignment.topLeft,
                              //height: SizeConfig.screenHeight * .2,
                              width: SizeConfig.screenWidth * boxPerc,
                              decoration: BoxDecoration(
                                  color: Color(0xffe8d7ba),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  )),
                              margin: EdgeInsets.only(
                                  top: 0, left: SizeConfig.screenWidth * .25),
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: 18,
                                ),
                                // Box 5 content
                                child: Column(
                                  children: [
                                    // Ligne 1 of box 5
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: SizeConfig.screenWidth * .035,
                                            top: 10,
                                          ),
                                          width: 10,
                                          height: 0,
                                          child: CustomPaint(
                                            painter: CirclePaint(
                                                innerColor: Color(0xffe8d7ba),
                                                outerColor: Color(0xff3b2d30),
                                                rad: boxCircleRad),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: SizeConfig.screenWidth * .03,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Challenge 24h CAO",
                                                style: boxContentStyle,
                                              ),
                                              Row(
                                                children: [
                                                  Icon(Icons.location_on),
                                                  Text(
                                                    "Salle de lecture",
                                                    style: TextStyle(
                                                      color: Color(0xff523e43),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    // Ligne 2 of box 5
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: SizeConfig.screenWidth * .035,
                                            top: 25,
                                          ),
                                          width: 10,
                                          height: 0,
                                          child: CustomPaint(
                                            painter: CirclePaint(
                                                innerColor: Color(0xffe8d7ba),
                                                outerColor: Color(0xff3b2d30),
                                                rad: boxCircleRad),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            top: 15,
                                            left: SizeConfig.screenWidth * .03,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: SizeConfig.screenWidth *
                                                    .58,
                                                child: Text(
                                                  "Challenge 24h Aeroentrepreneur",
                                                  style: TextStyle(
                                                    color: Color(0xff523e43),
                                                    fontSize:
                                                        SizeConfig.defaultSize *
                                                            1.7,
                                                    fontFamily: "Arial",
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Icon(Icons.location_on),
                                                  Text(
                                                    "Salle de lecture",
                                                    style: TextStyle(
                                                      color: Color(0xff523e43),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    // Spacing
                                    Row(
                                      children: [
                                        Container(
                                          child: Text(""),
                                          width: 10,
                                          height:
                                              SizeConfig.screenHeight * .025,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Ligne 14, 10 Octobre 2021
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: SizeConfig.screenHeight * .05,
                              margin: EdgeInsets.only(
                                  top: 20, left: SizeConfig.screenWidth * .25),
                              child: Text(
                                "10 Octobre 2021",
                                style: TextStyle(
                                  fontSize: SizeConfig.defaultSize * 2,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Arial",
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Ligne 15 ( 08:00 )
                        Row(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(
                                  top: 0, left: SizeConfig.screenWidth * .03),
                              child: Text(
                                "08:00",
                                style: timeTextStyle,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: SizeConfig.screenWidth * .05),
                              width: 10,
                              height: 0,
                              child: CustomPaint(
                                painter: CirclePaint(
                                  innerColor: Color(0xFFF2F2F2),
                                  outerColor: Color(0xffc6d4d2),
                                  rad: timeCircleRad,
                                  drawLine: true,
                                  lineColor: Color(0xFFd9dde3),
                                  lineLen: SizeConfig.screenHeight * .42,
                                ),
                              ),
                            )
                          ],
                        ),
                        // Ligne 16, Box 6
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Box 6 (atelier)
                            Container(
                              alignment: Alignment.topLeft,
                              //height: SizeConfig.screenHeight * .42,
                              width: SizeConfig.screenWidth * boxPerc,
                              decoration: BoxDecoration(
                                  color: Color(0xffbed1d3),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  )),
                              margin: EdgeInsets.only(
                                  top: 0, left: SizeConfig.screenWidth * .25),
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: 18,
                                ),
                                // Box 6 content
                                child: Column(
                                  children: [
                                    // Ligne 1 of box 6
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: SizeConfig.screenWidth * .035,
                                            top: 9,
                                          ),
                                          width: 10,
                                          height: 0,
                                          child: CustomPaint(
                                            painter: CirclePaint(
                                                innerColor: Color(0xFFd9dde3),
                                                outerColor: Color(0xff3b2d30),
                                                rad: boxCircleRad),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: SizeConfig.screenWidth * .03,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Atelier novices",
                                                style: boxContentStyle,
                                              ),
                                              Text(
                                                "+ Les challenges",
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 20),
                                                    child:
                                                        Icon(Icons.location_on),
                                                  ),
                                                  Text(
                                                    "Salles 155, 157, 159",
                                                    style: TextStyle(
                                                      color: Color(0xff523e43),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                  top: SizeConfig.screenHeight *
                                                      .008,
                                                ),
                                                child: Text(
                                                  "+ Autres shows",
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 20),
                                                    child:
                                                        Icon(Icons.location_on),
                                                  ),
                                                  Text(
                                                    "L'extérieur du hall",
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    // Ligne 2 of box 6
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: SizeConfig.screenWidth * .035,
                                            top: 24,
                                          ),
                                          width: 10,
                                          height: 0,
                                          child: CustomPaint(
                                            painter: CirclePaint(
                                                innerColor: Color(0xFFd9dde3),
                                                outerColor: Color(0xff3b2d30),
                                                rad: boxCircleRad),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            top: 15,
                                            left: SizeConfig.screenWidth * .03,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: SizeConfig.screenWidth *
                                                    .53,
                                                child: Text(
                                                  "Axes Exposition",
                                                  style: boxContentStyle,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Icon(Icons.location_on),
                                                  Text(
                                                    "Partie gauche du hall",
                                                    style: TextStyle(
                                                      color: Color(0xff523e43),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    // Ligne 3 of box 6
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: SizeConfig.screenWidth * .035,
                                            top: 24,
                                          ),
                                          width: 10,
                                          height: 0,
                                          child: CustomPaint(
                                            painter: CirclePaint(
                                                innerColor: Color(0xFFd9dde3),
                                                outerColor: Color(0xff3b2d30),
                                                rad: boxCircleRad),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            top: 15,
                                            left: SizeConfig.screenWidth * .03,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: SizeConfig.screenWidth *
                                                    .53,
                                                child: Text(
                                                  "Axes aerospace",
                                                  style: boxContentStyle,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Icon(Icons.location_on),
                                                  Text(
                                                    "Partie droite du hall",
                                                    style: TextStyle(
                                                      color: Color(0xff523e43),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    // Ligne 4 box 6
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: SizeConfig.screenWidth * .035,
                                            top: 24,
                                          ),
                                          width: 10,
                                          height: 0,
                                          child: CustomPaint(
                                            painter: CirclePaint(
                                                innerColor: Color(0xFFd9dde3),
                                                outerColor: Color(0xff3b2d30),
                                                rad: boxCircleRad),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            top: 15,
                                            left: SizeConfig.screenWidth * .03,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: SizeConfig.screenWidth *
                                                    .53,
                                                child: Text(
                                                  "Conferences",
                                                  style: boxContentStyle,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Icon(Icons.location_on),
                                                  Text(
                                                    "Salles de conference",
                                                    style: TextStyle(
                                                      color: Color(0xff523e43),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(left: 25),
                                                child: Text(
                                                  "B26/B28",
                                                  style: TextStyle(
                                                    color: Color(0xff523e43),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    // Spacing
                                    Row(
                                      children: [
                                        Container(
                                          child: Text(""),
                                          width: 10,
                                          height:
                                              SizeConfig.screenHeight * .025,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Ligne 18 ( 13:00 )
                        Row(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(
                                  top: 0, left: SizeConfig.screenWidth * .03),
                              child: Text(
                                "13:00",
                                style: timeTextStyle,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: SizeConfig.screenWidth * .05),
                              width: 10,
                              height: 0,
                              child: CustomPaint(
                                painter: CirclePaint(
                                  innerColor: Color(0xFFF2F2F2),
                                  outerColor: Color.fromRGBO(169, 199, 203, 1),
                                  rad: timeCircleRad,
                                  drawLine: true,
                                  lineColor: Color.fromRGBO(202, 208, 222, 1),
                                  lineLen: SizeConfig.screenHeight * .070,
                                ),
                              ),
                            )
                          ],
                        ),
                        // Ligne 19, Box 7
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Box 7 (pause)
                            Container(
                              alignment: Alignment.topLeft,
                              //height: SizeConfig.screenHeight * .07,
                              width: SizeConfig.screenWidth * boxPerc,
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(160, 195, 199, 1),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  )),
                              margin: EdgeInsets.only(
                                  top: 0, left: SizeConfig.screenWidth * .25),
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: 18,
                                ),
                                // Box 7 content
                                child: Column(
                                  children: [
                                    // Ligne 1 of box 7
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: SizeConfig.screenWidth * .035,
                                            top: 10,
                                          ),
                                          width: 10,
                                          height: 0,
                                          child: CustomPaint(
                                            painter: CirclePaint(
                                                innerColor: Color.fromRGBO(
                                                    160, 195, 199, 1),
                                                outerColor: Color(0xff3b2d30),
                                                rad: boxCircleRad),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: SizeConfig.screenWidth * .03,
                                          ),
                                          child: Text(
                                            "Pause déjeuner",
                                            style: boxContentStyle,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Spacing
                                    Row(
                                      children: [
                                        Container(
                                          child: Text(""),
                                          width: 10,
                                          height:
                                              SizeConfig.screenHeight * .025,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Ligne 20 ( 14:00 )
                        Row(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(
                                  top: 0, left: SizeConfig.screenWidth * .03),
                              child: Text(
                                "14:00",
                                style: timeTextStyle,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: SizeConfig.screenWidth * .05),
                              width: 10,
                              height: 0,
                              child: CustomPaint(
                                painter: CirclePaint(
                                  innerColor: Color(0xFFF2F2F2),
                                  outerColor: Color.fromRGBO(143, 187, 192, 1),
                                  rad: timeCircleRad,
                                  drawLine: true,
                                  lineColor: Color.fromRGBO(198, 218, 221, 1),
                                  lineLen: SizeConfig.screenHeight * .26,
                                ),
                              ),
                            )
                          ],
                        ),
                        // Ligne 21, Box 8
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Box 8 (aerochallenge)
                            Container(
                              alignment: Alignment.topLeft,
                              //height: SizeConfig.screenHeight * .26,
                              width: SizeConfig.screenWidth * boxPerc,
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(126, 179, 185, 1),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  )),
                              margin: EdgeInsets.only(
                                  top: 0, left: SizeConfig.screenWidth * .25),
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: 18,
                                ),
                                // Box 8 content
                                child: Column(
                                  children: [
                                    // Ligne 1 of box 8
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: SizeConfig.screenWidth * .035,
                                            top: 10,
                                          ),
                                          width: 10,
                                          height: 0,
                                          child: CustomPaint(
                                            painter: CirclePaint(
                                                innerColor: Color.fromRGBO(
                                                    126, 179, 185, 1),
                                                outerColor: Color(0xff3b2d30),
                                                rad: boxCircleRad),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: SizeConfig.screenWidth * .03,
                                          ),
                                          child: Text(
                                            "Aerochallenge",
                                            style: boxContentStyle,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Ligne 2 of box 8
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: SizeConfig.screenWidth * .035,
                                            top: SizeConfig.screenHeight * .025,
                                          ),
                                          width: 10,
                                          height: 0,
                                          child: CustomPaint(
                                            painter: CirclePaint(
                                                innerColor: Color.fromRGBO(
                                                    126, 179, 185, 1),
                                                outerColor: Color(0xff3b2d30),
                                                rad: boxCircleRad),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: SizeConfig.screenWidth * .03,
                                            top: SizeConfig.screenHeight * .015,
                                          ),
                                          child: Text(
                                            "Videographie par drone",
                                            style: boxContentStyle,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Ligne 3 of box 8
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: SizeConfig.screenWidth * .035,
                                            top: SizeConfig.screenHeight * .025,
                                          ),
                                          width: 10,
                                          height: 0,
                                          child: CustomPaint(
                                            painter: CirclePaint(
                                                innerColor: Color.fromRGBO(
                                                    126, 179, 185, 1),
                                                outerColor: Color(0xff3b2d30),
                                                rad: boxCircleRad),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: SizeConfig.screenWidth * .03,
                                            top: SizeConfig.screenHeight * .015,
                                          ),
                                          child: Text(
                                            "Pause artistique",
                                            style: boxContentStyle,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Ligne 4 of box 8
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: SizeConfig.screenWidth * .035,
                                            top: SizeConfig.screenHeight * .025,
                                          ),
                                          width: 10,
                                          height: 0,
                                          child: CustomPaint(
                                            painter: CirclePaint(
                                                innerColor: Color.fromRGBO(
                                                    126, 179, 185, 1),
                                                outerColor: Color(0xff3b2d30),
                                                rad: boxCircleRad),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: SizeConfig.screenWidth * .03,
                                            top: SizeConfig.screenHeight * .015,
                                          ),
                                          child: Text(
                                            "Annonce des vainqueurs",
                                            style: boxContentStyle,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Ligne 5 of box 8
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: SizeConfig.screenWidth * .035,
                                            top: SizeConfig.screenHeight * .025,
                                          ),
                                          width: 10,
                                          height: 0,
                                          child: CustomPaint(
                                            painter: CirclePaint(
                                                innerColor: Color.fromRGBO(
                                                    126, 179, 185, 1),
                                                outerColor: Color(0xff3b2d30),
                                                rad: boxCircleRad),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            top: SizeConfig.screenHeight * .015,
                                            left: SizeConfig.screenWidth * .03,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: SizeConfig.screenWidth *
                                                    .53,
                                                child: Text(
                                                  "Challenge et remise des prix",
                                                  style: boxContentStyle,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Icon(Icons.location_on),
                                                  Text(
                                                    "Auditorium",
                                                    style: TextStyle(
                                                      color: Color(0xff523e43),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    // Spacing
                                    Row(
                                      children: [
                                        Container(
                                          child: Text(""),
                                          width: 10,
                                          height:
                                              SizeConfig.screenHeight * .025,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Ligne 22 ( 18:00 )
                        Row(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(
                                  top: 0, left: SizeConfig.screenWidth * .03),
                              child: Text(
                                "18:00",
                                style: timeTextStyle,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: SizeConfig.screenWidth * .05),
                              width: 10,
                              height: 0,
                              child: CustomPaint(
                                painter: CirclePaint(
                                    innerColor: Color(0xFFF2F2F2),
                                    outerColor:
                                        Color.fromRGBO(129, 181, 185, 1),
                                    rad: timeCircleRad),
                              ),
                            )
                          ],
                        ),

                        // Space
                        Container(
                          child: Text(""),
                          width: 10,
                          height: SizeConfig.screenHeight * .05,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: SideBar(),
    );
  }
}
