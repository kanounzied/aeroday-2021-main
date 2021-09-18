import 'dart:convert';
import 'package:aeroday_2021/services/contestant_info.dart';
import 'package:aeroday_2021/widgets/vote_card.dart';
import 'package:flutter/material.dart';
import 'package:aeroday_2021/constants/app_constants.dart';
import 'package:aeroday_2021/widgets/search_bar.dart';
import 'package:aeroday_2021/widgets/sidebar/sidebar.dart';
import 'package:aeroday_2021/widgets/contestant_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VoteAC extends StatefulWidget {
  @override
  _VoteACState createState() => _VoteACState();
}

bool drawSearchList = false;

class _VoteACState extends State<VoteAC> {
  int selectedNum = 0;
  List<ContestantInfo> _contestantsList = [];
  List<ContestantInfo> _searchList = [];

  Future<Null> getContestantDetails() async {
    Map<String, dynamic> response;
    dynamic collection = await FirebaseFirestore.instance
        .collection('contestant')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        response = doc.data() as Map<String, dynamic>;

        _contestantsList.add(ContestantInfo.fromMap(response));
      });
      setState(() {});
    }); //TODO:Get the list of contestants and store it in responce
  }

  @override
  void initState() {
    super.initState();

    getContestantDetails();
  }

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
                          'AEROCHALLENGE',
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
                      )
                    ],
                  ),
                  SearchBar(
                    onSearchTextChanged: _onSearchTextChanged,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.84,
                    height: MediaQuery.of(context).size.height *
                        0.5, //height of list(maybe dynamic)
                    margin: EdgeInsets.only(top: 50),
                    child: Center(
                      child: drawSearchList || _searchList.isNotEmpty
                          ? _searchList.isNotEmpty
                              ? buildSearchList()
                              : Padding(
                                  padding: const EdgeInsets.only(bottom: 70),
                                  child: Text(
                                    "no search results!",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                          : buildContestantList(),
                    ),
                  ),
                ],
              ),
              _contestantsList.isNotEmpty
                  ? VoteCard(
                      onVoted: () {},
                      contInfo: _contestantsList[selectedNum],
                    )
                  : Container(), //TODO: fix loader for bad net
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

  _onSearchTextChanged(String input) async {
    _searchList.clear();
    if (input.isEmpty) {
      drawSearchList = false;
      setState(() {});
      return;
    }

    drawSearchList = true;
    _contestantsList.forEach((contestant) {
      if (contestant.name.toLowerCase().contains(input.toLowerCase()) ||
          contestant.lastName.toLowerCase().contains(input.toLowerCase()) ||
          (contestant.name.toLowerCase() +
                  ' ' +
                  contestant.lastName.toLowerCase())
              .contains(input.toLowerCase())) {
        drawSearchList = true;
        _searchList.add(contestant);
      }
    });
    drawSearchList = _searchList.isEmpty;
    setState(() {});
  }
}
