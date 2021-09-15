import 'package:aeroday_2021/services/contestant_info.dart';
import 'package:aeroday_2021/widgets/vote_card.dart';
import 'package:flutter/material.dart';
import 'package:aeroday_2021/constants/app_constants.dart';
import 'package:aeroday_2021/widgets/search_bar.dart';
import 'package:aeroday_2021/widgets/sidebar/sidebar.dart';
import 'package:aeroday_2021/widgets/contestant_card.dart';

class VoteAC extends StatefulWidget {
  @override
  _VoteACState createState() => _VoteACState();
}

class _VoteACState extends State<VoteAC> {
  final List<ContestantInfo> _contestantsList = [
    ContestantInfo(
      name: 'abc',
      lastName: 'def',
      imageUrl: "https://picsum.photos/200",
      status: 1,
      votes: 5,
    ),
    ContestantInfo(
      name: 'kiki',
      lastName: 'zy',
      imageUrl: 'https://picsum.photos/200',
      status: 0,
      votes: 5,
    ),
    ContestantInfo(
      name: 'bazera',
      lastName: 'etzqa',
      imageUrl: 'https://picsum.photos/200',
      status: 0,
      votes: 5,
    ),
  ]; //hardcoded list for testing (will be replaced with getContestantDetails() functionnality, eventually, maybe, one day..)
  List<ContestantInfo> _searchList = [];

  Future<Null> getContestantDetails() async {
    final response; //TODO:Get the list of contestants and store it in responce
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
                      child: drawSearchList
                          ? buildSearchList()
                          : buildContestantList(),
                    ),
                  ),
                ],
              ),
              Positioned(
                child: VoteCard(),
                bottom: 0,
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
        return ContestantCard(contestantInfo: _contestantsList[index]);
      },
    );
  }

  Widget buildSearchList() {
    print('BBBBsearchlst');
    return new ListView.builder(
      itemCount: _searchList.length,
      itemBuilder: (context, index) {
        return ContestantCard(contestantInfo: _searchList[index]);
      },
    );
  }

  //function to update the list according to search input

  bool drawSearchList = false;
  _onSearchTextChanged(String input) async {
    _searchList.clear();
    if (input.isEmpty) {
      drawSearchList = false;
      setState(() {});
      print('mario');
      return;
    }

    drawSearchList = false;
    _contestantsList.forEach((contestant) {
      print(contestant.name.contains(input).toString() +
          contestant.lastName.contains(input).toString() +
          contestant.name);

      if (contestant.name.contains(input) ||
          contestant.lastName.contains(input)) {
        drawSearchList = true;
        _searchList.add(contestant);
      }
    });
    drawSearchList = _searchList.isEmpty;
    setState(() {});
    print(drawSearchList);
  }
}
