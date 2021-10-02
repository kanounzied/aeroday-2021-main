import 'package:aeroday_2021/config/responsive_size.dart';
import 'package:aeroday_2021/constants/eventInfo.dart';
import 'package:aeroday_2021/screens/home_screen/home.dart';
import 'package:aeroday_2021/screens/vote_ac.dart';
import 'package:aeroday_2021/screens/vote_vpd.dart';
import 'package:aeroday_2021/services/showLockedMessage.dart';
import 'package:flutter/material.dart';
import 'package:aeroday_2021/constants/app_constants.dart';
import 'package:aeroday_2021/widgets/sidebar/button.dart';
import 'package:aeroday_2021/widgets/sidebar/bottom_part.dart';

int userId = 45416;

int pageNumbers = 3;
int selectedIndex = 0;

class SideBar extends StatefulWidget {
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  List<String> pageNames = [
    'Home',
    'Airshow',
    'Videographie par drone',
    //'Leaderboard'
  ]; //add pagename here to add a button

  static const IconData air = IconData(0xe064, fontFamily: 'MaterialIcons');
  @override
  Widget build(BuildContext context) {
    double screenWidth = SizeConfig.screenWidth;
    double screenHeight = SizeConfig.screenHeight;
    return SafeArea(
      child: ClipRRect(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
        child: SizedBox(
          width: screenWidth * 0.65,
          child: Drawer(
            elevation: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                        Container(
                          height: 7 * SizeConfig.defaultSize,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal:
                                            .7 * SizeConfig.defaultSize),
                                    child: Icon(
                                      Icons
                                          .airplanemode_active_rounded, // TODO: change the icon, fdha7tna
                                      color: Colors
                                          .red, //TODO: Change the color, fdha7tna
                                      size: 3 * SizeConfig.defaultSize,
                                    ),
                                  ),
                                  Container(
                                    width: screenWidth * 0.36,
                                    child: Text(
                                      pageNames[selectedIndex],
                                      style: TextStyle(
                                        color: dark,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 1.9 * SizeConfig.defaultSize,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                padding: EdgeInsets.only(
                                    right: SizeConfig.screenWidth * .005),
                                onPressed: () {
                                  setState(() {
                                    Navigator.pop(context);
                                  });
                                },
                                icon: Icon(
                                  Icons.close_rounded,
                                  size: 2 * SizeConfig.defaultSize,
                                ),
                              ),
                            ],
                          ),
                        ), // selected page name
                        Container(
                          height: 1,
                          margin: EdgeInsets.only(
                              right: 9,
                              left: 9,
                              bottom: 1.5 * SizeConfig.defaultSize),
                          color: Colors.black26,
                        ), //spacer
                      ] +
                      pageNames.map((e) {
                        setState(() {});
                        return Container(
                          child: Button(
                            label: pageNames[pageNames.indexOf(e)],
                            isSelected: pageNames.indexOf(e) == selectedIndex,
                            onTap: () {
                              setState(
                                () {
                                  if (selectedIndex != pageNames.indexOf(e)) {
                                    _navigate(pageNames.indexOf(e));
                                  } else {
                                    Navigator.pop(context);
                                  }
                                },
                              );
                            },
                          ),
                        );
                      }).toList(), //buttons
                ),
                SizedBox(height: 20),
                BottomPart(eventName: EventStats.currentEvent, id: userId),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigate(index) {
    String route = '/home';
    switch (index) {
      case 1:
        if (EventStats.airshowStats == "locked") {
          showLockedMessage(
            context: context,
            title: "Airshow",
            height: SizeConfig.screenHeight * .1,
            content: "Wait till", // TODO : fix this msg
          );
          return;
        } else if (EventStats.airshowStats == "wait") {
          showLockedMessage(
            context: context,
            title: "Airshow",
            height: SizeConfig.screenHeight * .1,
            content: "Wait till", // TODO : fix this msg
          );
          return;
        }
        route = '/voteAC';
        break;
      case 2:
        if (EventStats.vpdStats == "locked") {
          showLockedMessage(
            context: context,
            title: "Videographie par drone",
            height: SizeConfig.screenHeight * .1,
            content: "Wait till", // TODO : fix this msg
          );
          return;
        } else if (EventStats.vpdStats == "wait") {
          showLockedMessage(
            context: context,
            title: "Videographie par drone",
            height: SizeConfig.screenHeight * .1,
            content: "Wait till", // TODO : fix this msg
          );
          return;
        }
        route = '/voteVPD';
        break;
      // case 2:
      //   route = '/leaderboard';
    }

    selectedIndex = index;
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, route);
  }
}
