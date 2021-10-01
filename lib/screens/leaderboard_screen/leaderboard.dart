import 'package:aeroday_2021/config/responsive_size.dart';
import 'package:aeroday_2021/services/contestant_info.dart';
import 'package:aeroday_2021/widgets/appBar/appbar.dart';
import 'package:aeroday_2021/widgets/contestantlb_card.dart';
import 'package:flutter/material.dart';
import 'package:aeroday_2021/constants/app_constants.dart';
import 'package:aeroday_2021/widgets/sidebar/sidebar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderBoard extends StatefulWidget {
  String eventKey;
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
    print(_contestantsList.length);

    await FirebaseFirestore.instance
        .collection('contestant_' + this.eventKey)
        .orderBy('votes', descending: true)
        .get()
        .catchError(
      (err) {
        print(err);
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
              SizedBox(height: 10),
              _contestantsList.isEmpty ? buildTopThreeGray() : buildTopThree(),
              SizedBox(height: 10),
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.50 +
                        30 * 2, //to center the list add 2*margin of list
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 30),
                      width: MediaQuery.of(context).size.width * 0.84,
                      height: MediaQuery.of(context).size.height * 0.50,
                      child: _contestantsList.isEmpty
                          ? buildListLoader()
                          : buildLeaderboardList(),
                    ),
                  ),
                ],
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
          width: MediaQuery.of(context).size.width * 0.85,
          height: 6.2 * SizeConfig.defaultSize,
          margin: EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.grey[350],
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset.zero,
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(9.0)),
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
              child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(_contestantsList[1].imageUrl),
                    radius: 40,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(500),
                          border:
                              Border.all(color: Color(0xFFAAAAAA), width: 3)),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Image.asset(
                      'assets/2nd.png',
                      width: 35,
                      height: 35,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Text(
                _contestantsList[1].lastName,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 3),
              Text(
                _contestantsList[1].name,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 4),
              Text(
                'voted by %${(_contestantsList[1].votes * 100 / totalVotes).floor()}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w200,
                ),
              )
            ],
          )),
          SizedBox(width: 35),
          Container(
              child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(_contestantsList[0].imageUrl),
                    radius: 50,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(500),
                          border:
                              Border.all(color: Color(0xFFFDBC4B), width: 3)),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Image.asset(
                      'assets/1st.png',
                      width: 40,
                      height: 40,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Text(
                _contestantsList[0].lastName,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 3),
              Text(
                _contestantsList[0].name,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 4),
              Text(
                'voted by %${(_contestantsList[0].votes * 100 / totalVotes).floor()}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w200,
                ),
              )
            ],
          )),
          SizedBox(width: 35),
          Container(
              child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(_contestantsList[2].imageUrl),
                    radius: 40,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(500),
                          border:
                              Border.all(color: Color(0xFFBA734B), width: 3)),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Image.asset(
                      'assets/3rd.png',
                      width: 35,
                      height: 35,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Text(
                _contestantsList[2].lastName,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 3),
              Text(
                _contestantsList[2].name,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 4),
              Text(
                'voted by %${(_contestantsList[2].votes * 100 / totalVotes).floor()}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
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
              child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey[350],
                    radius: 40,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(500),
                          border:
                              Border.all(color: Color(0xFFAAAAAA), width: 3)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                width: 67,
                height: 14,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: Color(0x66ffffff),
                ),
              ),
              SizedBox(height: 5),
              Container(
                width: 50,
                height: 12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: Color(0x66ffffff),
                ),
              ),
              SizedBox(height: 4),
              Text(
                '',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          )),
          SizedBox(width: 35),
          Container(
              child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey[350],
                    radius: 50,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(500),
                          border:
                              Border.all(color: Color(0xFFAAAAAA), width: 3)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                width: 67,
                height: 14,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: Color(0x66ffffff),
                ),
              ),
              SizedBox(height: 5),
              Container(
                width: 50,
                height: 12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: Color(0x66ffffff),
                ),
              ),
              SizedBox(height: 4),
              Text(
                '',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          )),
          SizedBox(width: 35),
          Container(
              child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey[350],
                    radius: 40,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(500),
                          border:
                              Border.all(color: Color(0xFFAAAAAA), width: 3)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                width: 67,
                height: 14,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: Color(0x66ffffff),
                ),
              ),
              SizedBox(height: 5),
              Container(
                width: 50,
                height: 12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: Color(0x66ffffff),
                ),
              ),
              SizedBox(height: 4),
              Text(
                '',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}
