import 'package:aeroday_2021/config/responsive_size.dart';
import 'package:aeroday_2021/constants/eventInfo.dart';
import 'package:aeroday_2021/services/contestant_info.dart';
import 'package:aeroday_2021/widgets/appBar/appbar.dart';
import 'package:aeroday_2021/widgets/upcomings_cercle/circle.dart';
import 'package:aeroday_2021/widgets/vote_card.dart';
import 'package:flutter/material.dart';
import 'package:aeroday_2021/constants/app_constants.dart';
import 'package:aeroday_2021/widgets/search_bar.dart';
import 'package:aeroday_2021/widgets/sidebar/sidebar.dart';
import 'package:aeroday_2021/widgets/contestant_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VoteAC extends StatefulWidget {
  @override
  _VoteACState createState() => _VoteACState();
}

bool drawSearchList = false;

class _VoteACState extends State<VoteAC> {
  int selectedNum = 0;
  List<ContestantInfo> _contestantsList = [];
  List<ContestantInfo> _searchList = [];

  bool openCard = false;

  Future<Null> getContestantDetails() async {
    Map<String, dynamic> response;
    dynamic collection = await FirebaseFirestore.instance
        .collection('contestant_' + EventStats.EventList[0])
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        response = doc.data() as Map<String, dynamic>;

        _contestantsList.add(ContestantInfo.fromMap(response, doc.id));
      });
      setState(() {});
    }); //TODO:Get the list of contestants and store it in responce
  }

  @override
  void initState() {
    super.initState();

    getContestantDetails();
  }

  double dynamicHeight = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: dark,
      body: Builder(
        builder: (BuildContext c) => SafeArea(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AppBarCustom(
                    title: 'AIRSHOW',
                    c: c,
                  ),
                  SearchBar(
                    onSearchTextChanged: _onSearchTextChanged,
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 150),
                    width: SizeConfig.screenWidth * 0.9,
                    height:
                        /* SizeConfig.defaultSize * SizeConfig.screenHeight -
                        (3.9 * SizeConfig.defaultSize +
                            14 * SizeConfig.defaultSize +
                            SizeConfig.defaultSize * 4.2)*/
                        SizeConfig.screenWidth / SizeConfig.screenHeight < 0.75
                            ? SizeConfig.screenHeight -
                                (120 * 0.1 * SizeConfig.defaultSize +
                                    5.0 * SizeConfig.defaultSize +
                                    19.9 * SizeConfig.defaultSize +
                                    SizeConfig.defaultSize * 4.2) -
                                dynamicHeight
                            : SizeConfig.screenHeight -
                                (55 * 0.1 * SizeConfig.defaultSize +
                                    5.0 * SizeConfig.defaultSize +
                                    19.9 * SizeConfig.defaultSize +
                                    SizeConfig.defaultSize * 4.2) -
                                dynamicHeight, //height of list(dynamic)
                    margin: EdgeInsets.only(top: 5 * SizeConfig.defaultSize),
                    child: Center(
                      child: _contestantsList.isEmpty
                          ? buildListLoader()
                          : drawSearchList || _searchList.isNotEmpty
                              ? _searchList.isNotEmpty
                                  ? buildSearchList()
                                  : Padding(
                                      padding: EdgeInsets.only(
                                          bottom: 7 * SizeConfig.defaultSize),
                                      child: Text(
                                        "no search results!",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                1.2 * SizeConfig.defaultSize),
                                      ),
                                    )
                              : buildContestantList(),
                    ),
                  ),
                ],
              ),
              _contestantsList.isNotEmpty
                  ? VoteCard(
                      onVoteCardExtended: (h) {
                        setState(() {
                          dynamicHeight = h;
                        });
                      },
                      onVoted: () {},
                      contInfo: _contestantsList[selectedNum],
                      index: selectedNum,
                      vCardEvent: EventStats.EventList[0],
                      openUp: openCard
                          ? () {
                              openCard = false;
                              return true;
                            }()
                          : false,
                    )
                  : Stack(children: [
                      Positioned(
                        bottom: 0,
                        child: Container(
                          height: 140,
                          margin: EdgeInsets.only(
                              left: SizeConfig.screenWidth * 0.05),
                          width: SizeConfig.screenWidth * 0.9,
                          decoration: BoxDecoration(
                            color: Colors.grey[350],
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(19)),
                          ),
                        ),
                      ),
                    ]), //TODO: fix loader for bad net
            ],
          ),
        ),
      ),
      drawer: SideBar(),
    );
  }

  Widget buildContestantList() {
    return new ListView.builder(
      itemCount: _contestantsList.length,
      itemBuilder: (context, index) {
        return ContestantCard(
          index: index + 1,
          contestantInfo: _contestantsList[index],
          onPressed: (e) {
            setState(() {
              selectedNum = _contestantsList.indexOf(e);
              openCard = true;
            });
          },
        );
      },
    );
  }

  Widget buildSearchList() {
    return new ListView.builder(
      itemCount: _searchList.length,
      itemBuilder: (context, index) {
        return ContestantCard(
          contestantInfo: _searchList[index],
          index: _contestantsList.indexOf(_searchList[index]) + 1,
          onPressed: (e) {
            setState(() {
              selectedNum = _contestantsList.indexOf(e);
              _searchList.clear();
            });
          },
        );
      },
    );
  }

  //function to update the list according to search input
  Widget buildListLoader() {
    return new ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          width: SizeConfig.screenWidth * 0.85,
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
          child: Container(
            width: 25,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
          ),
        );
      },
    );
  }

  _onSearchTextChanged(String input) async {
    _searchList.clear();
    if (input.isEmpty) {
      drawSearchList = false;
      setState(() {});
      return;
    }

    drawSearchList = true;
    _contestantsList.forEach((contestant) {
      // if (contestant.name.toLowerCase().contains(input.toLowerCase()) ||
      //     contestant.lastName.toLowerCase().contains(input.toLowerCase()) ||
      //     (contestant.name.toLowerCase() +
      //             ' ' +
      //             contestant.lastName.toLowerCase())
      //         .contains(input.toLowerCase())) {
      if (contestant.teamName.toLowerCase().contains(input.toLowerCase())) {
        drawSearchList = true;
        _searchList.add(contestant);
      }
    });
    drawSearchList = _searchList.isEmpty;
    setState(() {});
  }
}
