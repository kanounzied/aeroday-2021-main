import 'package:aeroday_2021/screens/home.dart';
import 'package:aeroday_2021/screens/vote_ac.dart';
import 'package:aeroday_2021/screens/vote_vpd.dart';
import 'package:flutter/material.dart';
import 'package:aeroday_2021/constants/app_constants.dart';
import 'package:aeroday_2021/widgets/sidebar/button.dart';
import 'package:aeroday_2021/widgets/sidebar/bottom_part.dart';

String runningEvent = 'Aerochallenge';
int userId = 45416;
const List<String> pageNames = [
  'Home',
  'Aerochallenge',
  'Videographie par drone'
];

int pageNumbers = 3;
int selectedIndex = 0;

class SideBar extends StatefulWidget {
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: ClipRRect(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
        child: SizedBox(
          width: screenWidth * 0.6,
          child: Drawer(
            elevation: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                        Container(
                          height: 70,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 7),
                                    child: Icon(
                                      Icons.air,
                                      color: red,
                                      size: 30,
                                    ),
                                  ),
                                  Container(
                                    width: screenWidth * 0.36,
                                    child: Text(
                                      pageNames[selectedIndex],
                                      style: TextStyle(
                                        color: dark,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 19,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    Navigator.pop(context);
                                  });
                                },
                                icon: Icon(
                                  Icons.close_rounded,
                                ),
                              ),
                            ],
                          ),
                        ), // selected page name
                        Container(
                          height: 1,
                          margin:
                              EdgeInsets.only(right: 9, left: 9, bottom: 15),
                          color: Colors.black26,
                        ), //spacer
                      ] +
                      pageNames
                          .map(
                            (e) => Container(
                              child: Button(
                                label: pageNames[pageNames.indexOf(e)],
                                isSelected:
                                    pageNames.indexOf(e) == selectedIndex,
                                onTap: () {
                                  setState(
                                    () {
                                      if (selectedIndex !=
                                          pageNames.indexOf(e)) {
                                        selectedIndex = pageNames.indexOf(e);
                                        _navigate(selectedIndex);
                                      } else {
                                        Navigator.pop(context);
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                          )
                          .toList(), //buttons
                ),
                SizedBox(height: 20),
                BottomPart(eventName: runningEvent, id: userId),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigate(index) {
    String checkRoute(index) {
      String route = '/home';
      switch (index) {
        case 0:
          route = '/home';
          break;
        case 1:
          route = '/voteAC';
          break;
        case 2:
          route = '/voteVPD';
          break;
      }
      return route;
    }

    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, checkRoute(index));
  }
}
