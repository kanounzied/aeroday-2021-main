import 'package:aeroday_2021/config/responsive_size.dart';
import 'package:aeroday_2021/services/contestant_info.dart';
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

  Future<Null> getContestantDetails() async {
    Map<String, dynamic> response;
    dynamic collection = await FirebaseFirestore.instance
        .collection('contestant')
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
                        iconSize: SizeConfig.defaultSize * 4.2,
                        icon: Icon(
                          Icons.menu_rounded,
                        ),
                      ),
                      Container(
                        child: Text(
                          'AIRSHOW',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.only(
                            right: SizeConfig.screenWidth * .03),
                        child: GestureDetector(
                          onTap: () async {
                            if (FirebaseAuth.instance.currentUser == null)
                              return;
                            print("logout tap");
                            await FirebaseAuth.instance.signOut();
                            setState(() {});
                          },
                          child: Icon(
                            Icons.logout,
                            color: FirebaseAuth.instance.currentUser == null
                                ? Color(0x00FFFFFF)
                                : Color(0xFFFFFFFF),
                            size: SizeConfig.defaultSize * 3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SearchBar(
                    onSearchTextChanged: _onSearchTextChanged,
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 150),
                    width: MediaQuery.of(context).size.width * 0.84,
                    height: MediaQuery.of(context).size.height * 0.54 -
                        dynamicHeight, //height of list(maybe dynamic)
                    margin: EdgeInsets.only(top: 50),
                    child: Center(
                      child: _contestantsList.isEmpty
                          ? buildListLoader()
                          : drawSearchList || _searchList.isNotEmpty
                              ? _searchList.isNotEmpty
                                  ? buildSearchList()
                                  : Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 70),
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
                      onVoteCardExtended: (h) {
                        setState(() {
                          dynamicHeight = h;
                          print(dynamicHeight);
                        });
                      },
                      onVoted: () {},
                      contInfo: _contestantsList[selectedNum],
                      index: selectedNum,
                    )
                  : Stack(children: [
                      Positioned(
                        bottom: 0,
                        child: Container(
                          height: 140,
                          margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.05),
                          width: MediaQuery.of(context).size.width * 0.9,
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
