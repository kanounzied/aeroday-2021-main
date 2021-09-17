import 'package:aeroday_2021/services/contestant_info.dart';
import 'package:aeroday_2021/widgets/vote_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:aeroday_2021/constants/app_constants.dart';
import 'package:aeroday_2021/widgets/search_bar.dart';
import 'package:aeroday_2021/widgets/sidebar/sidebar.dart';
import 'package:aeroday_2021/widgets/contestant_card.dart';

class VoteAC extends StatefulWidget {
  @override
  _VoteACState createState() => _VoteACState();
}

bool drawSearchList = false;

class _VoteACState extends State<VoteAC> {
  int selectedNum = 0;
  final List<ContestantInfo> _contestantsList = [
    ContestantInfo(
      name: 'abc',
      lastName: 'devf',
      imageUrl: "https://picsum.photos/200",
      teamName: 'Dream Team 54',
    ),
    ContestantInfo(
      name: 'kiki',
      lastName: 'vwby',
      imageUrl: 'https://picsum.photos/200',
      teamName: 'Dream Team 54',
    ),
    ContestantInfo(
      name: 'bezera',
      lastName: 'zerqa',
      imageUrl: 'https://picsum.photos/200',
      teamName: 'Dream Team 54',
    ),
    ContestantInfo(
      name: 'kamki',
      lastName: 'hkh',
      imageUrl: 'https://picsum.photos/200',
      teamName: 'Dream Team 54',
    ),
    ContestantInfo(
      name: 'bmmma',
      lastName: 'eqsdfzqa',
      imageUrl: 'https://picsum.photos/200',
      teamName: 'Dream Team 54',
    ),
    ContestantInfo(
      name: 'iyzzki',
      lastName: 'zhjky',
      imageUrl: 'https://picsum.photos/200',
      teamName: 'Dream Team 54',
    ),
    ContestantInfo(
      name: 'gfra',
      lastName: 'egkjhqa',
      imageUrl: 'https://picsum.photos/200',
      teamName: 'Dream Team 54',
    ),
  ]; //hardcoded list for testing (will be replaced with getContestantDetails() functionnality, eventually, maybe, one day..)
  List<ContestantInfo> _searchList = [];

  Future<Null> getContestantDetails() async {
    dynamic collectionStream = FirebaseFirestore.instance
        .collection('contestant')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                print(doc.data());
              })
            }); //TODO:Get the list of contestants and store it in responce
    setState(() {
      /* for (Map user in response) {
        _contestantsList.add(ContestantInfo.fromMap(user));
      }*/
    });
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
              VoteCard(
                onVoted: () {},
                contInfo: _contestantsList[selectedNum],
              ),
            ],
          ),
        ),
      ),
      drawer: SideBar(),
    );
  }

  Widget buildContestantList() {
    print('AAAAcontlst');
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
    print('BBBBsearchlst');
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
      print('mario');
      return;
    }

    drawSearchList = true;
    _contestantsList.forEach((contestant) {
      print(contestant.name.contains(input).toString() +
          contestant.lastName.contains(input).toString() +
          (contestant.name + ' ' + contestant.lastName)
              .contains(input)
              .toString() +
          contestant.name);
      if (contestant.name.contains(input) ||
          contestant.lastName.contains(input) ||
          (contestant.name + ' ' + contestant.lastName).contains(input)) {
        drawSearchList = true;
        _searchList.add(contestant);
        print(_searchList);
        print('zeb');
      }
    });
    drawSearchList = _searchList.isEmpty;
    setState(() {});
    print(drawSearchList);
  }
}
