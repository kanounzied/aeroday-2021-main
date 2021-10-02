import 'package:aeroday_2021/config/responsive_size.dart';
import 'package:aeroday_2021/constants/colors_hex.dart';
import 'package:aeroday_2021/constants/functions.dart';
import 'package:aeroday_2021/services/contestant_info.dart';
import 'package:aeroday_2021/widgets/appBar/appbar.dart';
import 'package:aeroday_2021/widgets/contestantlb_card.dart';
import 'package:flutter/material.dart';
import 'package:aeroday_2021/constants/app_constants.dart';
import 'package:aeroday_2021/widgets/sidebar/sidebar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderBoard extends StatefulWidget {
  final String eventKey;
  LeaderBoard({required this.eventKey});

  @override
  _LeaderBoardState createState() => _LeaderBoardState(eventKey: this.eventKey);
}

class _LeaderBoardState extends State<LeaderBoard> {
  List<ContestantInfo> _contestantsList = [];
  num totalVotes = 0;
  int selectedEvent = 0;

  bool disableEventNav = false;

  String eventKey;

  _LeaderBoardState({required this.eventKey});

  Future<Null> getLeaderboardDetails() async {
    disableEventNav = true;
    _contestantsList.clear();
    //print(_contestantsList.length);

    await FirebaseFirestore.instance
        .collection('contestant_' + this.eventKey)
        .orderBy('votes', descending: true)
        .get()
        .catchError(
      (err) {
        //print(err);
      },
    ).then((QuerySnapshot qs) {
      qs.docs.forEach((doc) {
        _contestantsList.add(
            ContestantInfo.fromMap(doc.data() as Map<String, dynamic>, doc.id));
        totalVotes += (doc.data() as Map<String, dynamic>)['votes'];
      });
    });
    //setState(() {});
    disableEventNav = false;
  }

  @override
  void initState() {
    super.initState();

    getLeaderboardDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dark,
      body: Builder(
        builder: (BuildContext c) => SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppBarCustom(
                title: 'LEADERBOARD',
                c: c,
              ),
              SizedBox(height: 1 * SizeConfig.defaultSize),
              _contestantsList.isEmpty ? buildTopThreeGray() : buildTopThree(),
              SizedBox(height: 1 * SizeConfig.defaultSize),
              Expanded(
                //  height: SizeConfig.screenHeight - (19 + 6.6) * SizeConfig.defaultSize,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(2.4 * SizeConfig.defaultSize)),
                      ),
                      width: SizeConfig.screenWidth,
                      height: SizeConfig.screenHeight * 0.98 +
                          10, //to center the list add 2*margin of list
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 1 * SizeConfig.defaultSize),
                        width: SizeConfig.screenWidth * 0.98,
                        //height: SizeConfig.screenHeight * 0.48,
                        child: _contestantsList.isEmpty
                            ? buildListLoader()
                            : buildLeaderboardList(),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: SideBar(),
    );
  }

  Widget buildLeaderboardList() {
    return new ListView.builder(
      itemCount: _contestantsList.length,
      itemBuilder: (context, index) {
        return ContestantLbCard(
          index: index + 1,
          contestantInfo: _contestantsList[index],
        );
      },
    );
  }

  Widget buildListLoader() {
    return new ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          width: SizeConfig.screenWidth * 0.85,
          height: 62,
          margin: EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Color(0xffeeeeee),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset.zero,
                blurRadius: 5,
                spreadRadius: 0,
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(9.0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      left: 14,
                      right: 10,
                    ),
                    child: Container(
                      width: 15,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xffcccccc),
                      ),
                      height: 13,
                    ),
                  ), //number
                  Container(
                    width: 47,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset.zero,
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                      color: Color(0xffcccccc), //TODO: loading image
                    ),
                  ), //photo
                  Container(
                    margin: EdgeInsets.only(top: 7, left: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Container(
                                height: 15,
                                width: 80,
                                decoration: BoxDecoration(
                                    color: Color(0xffcccccc),
                                    borderRadius: BorderRadius.circular(2.5))),
                          ],
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 7, left: 4),
                            height: 10,
                            width: 40,
                            decoration: BoxDecoration(
                                color: Color(0xffcccccc),
                                borderRadius: BorderRadius.circular(2.5))),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildTopThree() {
    if (totalVotes == 0) {
      totalVotes++;
    }

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 17 * SizeConfig.defaultSize,
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      backgroundColor: ColorList.colorList[2],
                      radius: 4.0 * SizeConfig.defaultSize,
                      child: Container(
                        child: Center(
                          child: Text(
                            UsualFunctions.getInitials(
                                    _contestantsList[1].teamName)
                                .toUpperCase(),
                            style: TextStyle(
                              fontSize: SizeConfig.defaultSize * 1.8,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                50.0 * SizeConfig.defaultSize),
                            border: Border.all(
                                color: Color(0xFFcccccc),
                                width: 0.3 * SizeConfig.defaultSize)),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Image.asset(
                        'assets/2nd.png',
                        width: 3.5 * SizeConfig.defaultSize,
                        height: 3.5 * SizeConfig.defaultSize,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.defaultSize),
                // Text(
                //   _contestantsList[1].lastName,
                //   style: TextStyle(
                //       color: Colors.white,
                //       fontSize: 14,
                //       fontWeight: FontWeight.w500),
                // ),
                // SizedBox(height: 3),
                Container(
                  height: 6 * SizeConfig.defaultSize,
                  width: 7.4 * SizeConfig.defaultSize,
                  child: Text(
                    _contestantsList[1].teamName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 1.4 * SizeConfig.defaultSize,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: 0.4 * SizeConfig.defaultSize),
                Text(
                  'voted by %${(_contestantsList[1].votes * 100 / totalVotes).floor()}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 1.2 * SizeConfig.defaultSize,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 3.5 * SizeConfig.defaultSize),
          Container(
              height: 20 * SizeConfig.defaultSize,
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor: ColorList.colorList[1],
                        radius: 5.0 * SizeConfig.defaultSize,
                        child: Container(
                          child: Center(
                            child: Text(
                              UsualFunctions.getInitials(
                                      _contestantsList[0].teamName)
                                  .toUpperCase(),
                              style: TextStyle(
                                fontSize: 2 * SizeConfig.defaultSize,
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  50.0 * SizeConfig.defaultSize),
                              border: Border.all(
                                  color: Color(0xFFFDBC4B),
                                  width: 0.3 * SizeConfig.defaultSize)),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Image.asset(
                          'assets/1st.png',
                          width: 4 * SizeConfig.defaultSize,
                          height: 4 * SizeConfig.defaultSize,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.defaultSize),
                  // Text(
                  //   _contestantsList[0].lastName,
                  //   style: TextStyle(
                  //       color: Colors.white,
                  //       fontSize: 14,
                  //       fontWeight: FontWeight.w500),
                  // ),
                  // SizedBox(height: 3),
                  Container(
                    height: 5.5 * SizeConfig.defaultSize,
                    width: 9 * SizeConfig.defaultSize,
                    child: Text(
                      _contestantsList[0].teamName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 1.4 * SizeConfig.defaultSize,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(height: 0.4 * SizeConfig.defaultSize),
                  Text(
                    'voted by %${(_contestantsList[0].votes * 100 / totalVotes).floor()}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 1.2 * SizeConfig.defaultSize,
                      fontWeight: FontWeight.w200,
                    ),
                  )
                ],
              )),
          SizedBox(width: 3.5 * SizeConfig.defaultSize),
          Container(
              height: 17 * SizeConfig.defaultSize,
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor: ColorList.colorList[0],
                        radius: 4.0 * SizeConfig.defaultSize,
                        child: Container(
                          child: Center(
                            child: Text(
                              UsualFunctions.getInitials(
                                      _contestantsList[2].teamName)
                                  .toUpperCase(),
                              style: TextStyle(
                                fontSize: 1.8 * SizeConfig.defaultSize,
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  50.0 * SizeConfig.defaultSize),
                              border: Border.all(
                                  color: Color(0xFFBA734B),
                                  width: 0.3 * SizeConfig.defaultSize)),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Image.asset(
                          'assets/3rd.png',
                          width: 3.5 * SizeConfig.defaultSize,
                          height: 3.5 * SizeConfig.defaultSize,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.defaultSize),
                  // Text(
                  //   _contestantsList[2].lastName,
                  //   style: TextStyle(
                  //       color: Colors.white,
                  //       fontSize: 14,
                  //       fontWeight: FontWeight.w500),
                  // ),
                  // SizedBox(height: 3),
                  Container(
                    height: 6 * SizeConfig.defaultSize,
                    width: 7.4 * SizeConfig.defaultSize,
                    child: Text(
                      _contestantsList[2].teamName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 1.4 * SizeConfig.defaultSize,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'voted by %${(_contestantsList[2].votes * 100 / totalVotes).floor()}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 1.2 * SizeConfig.defaultSize,
                      fontWeight: FontWeight.w200,
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }

  Widget buildTopThreeGray() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 17 * SizeConfig.defaultSize,
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(0xffBBBBBB),
                      radius: 4.0 * SizeConfig.defaultSize,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                50 * SizeConfig.defaultSize),
                            border: Border.all(
                                color: Color(0xff888888),
                                width: .3 * SizeConfig.defaultSize)),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Image.asset(
                        'assets/3rd.png',
                        color: Color(0xff888888),
                        width: 3.5 * SizeConfig.defaultSize,
                        height: 3.5 * SizeConfig.defaultSize,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.defaultSize),
                Container(
                  height: 6 * SizeConfig.defaultSize,
                  width: 7.4 * SizeConfig.defaultSize,
                  child: Column(
                    children: [
                      Container(
                        height: 1.2 * SizeConfig.defaultSize,
                        width: 6 * SizeConfig.defaultSize,
                        color: Color(0xffBBBBBB),
                      ),
                      SizedBox(
                        height: 0.65 * SizeConfig.defaultSize,
                      ),
                      Container(
                        height: 1.2 * SizeConfig.defaultSize,
                        width: 4.3 * SizeConfig.defaultSize,
                        color: Color(0xffBBBBBB),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                Container(
                  height: SizeConfig.defaultSize,
                  width: 4 * SizeConfig.defaultSize,
                  color: Color(0xffBBBBBB),
                ),
              ],
            ),
          ),
          SizedBox(width: 3.5 * SizeConfig.defaultSize),
          Container(
            height: 20 * SizeConfig.defaultSize,
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(0xffBBBBBB),
                      radius: 5.0 * SizeConfig.defaultSize,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(500),
                            border:
                                Border.all(color: Color(0xff888888), width: 3)),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Image.asset(
                        'assets/1st.png',
                        color: Color(0xff888888),
                        width: 4 * SizeConfig.defaultSize,
                        height: 6 * SizeConfig.defaultSize,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.defaultSize),
                Container(
                  height: 5.5 * SizeConfig.defaultSize,
                  width: 9 * SizeConfig.defaultSize,
                  child: Column(
                    children: [
                      Container(
                        height: 1.4 * SizeConfig.defaultSize,
                        width: 8 * SizeConfig.defaultSize,
                        color: Color(0xffBBBBBB),
                      ),
                      SizedBox(
                        height: 0.6 * SizeConfig.defaultSize,
                      ),
                      Container(
                        height: 1.4 * SizeConfig.defaultSize,
                        width: 6 * SizeConfig.defaultSize,
                        color: Color(0xffBBBBBB),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 0.4 * SizeConfig.defaultSize),
                Container(
                  height: SizeConfig.defaultSize,
                  width: 4 * SizeConfig.defaultSize,
                  color: Color(0xffBBBBBB),
                ),
              ],
            ),
          ),
          SizedBox(width: 3.5 * SizeConfig.defaultSize),
          Container(
            height: 17 * SizeConfig.defaultSize,
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(0xffBBBBBB),
                      radius: 4.0 * SizeConfig.defaultSize,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                50 * SizeConfig.defaultSize),
                            border: Border.all(
                                color: Color(0xff888888),
                                width: .3 * SizeConfig.defaultSize)),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Image.asset(
                        'assets/3rd.png',
                        color: Color(0xff888888),
                        width: 3.5 * SizeConfig.defaultSize,
                        height: 3.5 * SizeConfig.defaultSize,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.defaultSize),
                Container(
                  height: 6 * SizeConfig.defaultSize,
                  width: 7.4 * SizeConfig.defaultSize,
                  child: Column(
                    children: [
                      Container(
                        height: 1.2 * SizeConfig.defaultSize,
                        width: 6 * SizeConfig.defaultSize,
                        color: Color(0xffBBBBBB),
                      ),
                      SizedBox(
                        height: 0.65 * SizeConfig.defaultSize,
                      ),
                      Container(
                        height: 1.2 * SizeConfig.defaultSize,
                        width: 4.3 * SizeConfig.defaultSize,
                        color: Color(0xffBBBBBB),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 0.4 * SizeConfig.defaultSize),
                Container(
                  height: SizeConfig.defaultSize,
                  width: 4 * SizeConfig.defaultSize,
                  color: Color(0xffBBBBBB),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
