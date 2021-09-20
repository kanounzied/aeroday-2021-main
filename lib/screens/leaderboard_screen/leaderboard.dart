import 'package:aeroday_2021/services/contestant_info.dart';
import 'package:aeroday_2021/widgets/contestantlb_card.dart';
import 'package:flutter/material.dart';
import 'package:aeroday_2021/constants/app_constants.dart';
import 'package:aeroday_2021/widgets/sidebar/sidebar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderBoard extends StatefulWidget {
  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  List<ContestantInfo> _contestantsList = [];
  num totalVotes = 0;
  Future<Null> getLeaderboardDetails() async {
    await FirebaseFirestore.instance
        .collection('contestant')
        .orderBy('votes', descending: true)
        .get()
        .then((QuerySnapshot qs) {
      qs.docs.forEach((doc) {
        _contestantsList.add(
            ContestantInfo.fromMap(doc.data() as Map<String, dynamic>, doc.id));
        totalVotes += (doc.data() as Map<String, dynamic>)['votes'];
      });
    });
    setState(() {});
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
              Row(
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
                      'LEADERBOARD',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width:
                        64, //iconsize + horizontal padding (to center the title)
                  ),
                ],
              ),
              SizedBox(height: 10),
              _contestantsList.isEmpty ? Container() : buildTopThree(),
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
          height: 62,
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
}
