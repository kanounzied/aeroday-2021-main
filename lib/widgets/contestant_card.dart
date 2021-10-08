import 'package:aeroday2021/config/responsive_size.dart';
import 'package:aeroday2021/constants/app_constants.dart';
import 'package:aeroday2021/constants/functions.dart';
import 'package:aeroday2021/services/contestant_info.dart';
import 'package:flutter/material.dart';
import 'package:aeroday2021/constants/colors_hex.dart';

// ignore: must_be_immutable
class ContestantCard extends StatefulWidget {
  ContestantInfo contestantInfo;
  Function onPressed;
  int index;
  //bool isVoted ;
  //test
  ContestantCard(
      {required this.contestantInfo,
      required this.onPressed,
      required this.index});
  @override
  _ContestantCardState createState() => _ContestantCardState();
}

class _ContestantCardState extends State<ContestantCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = SizeConfig.screenWidth;
    // ignore: unused_local_variable
    double screenHeight = SizeConfig.screenHeight;
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.onPressed(widget.contestantInfo);
        });
      },
      child: Container(
        width: screenWidth * 0.85,
        height: 6.2 * SizeConfig.defaultSize,
        margin: EdgeInsets.only(bottom: 1.6 * SizeConfig.defaultSize),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset.zero,
              blurRadius: 7,
              spreadRadius: 0,
            ),
          ],
          borderRadius:
              BorderRadius.all(Radius.circular(0.9 * SizeConfig.defaultSize)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: 1.4 * SizeConfig.defaultSize,
                      right: 0.5 * SizeConfig.defaultSize),
                  child: Container(
                    width: 1.5 * SizeConfig.defaultSize,
                    child: Text(
                      widget.index.toString(),
                      style: TextStyle(
                        fontSize: 1.3 * SizeConfig.defaultSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ), //number
                Container(
                  width: 4.7 * SizeConfig.defaultSize,
                  height: 4.7 * SizeConfig.defaultSize,
                  child: Center(
                    child: Text(
                      UsualFunctions.getInitials(widget.contestantInfo.teamName)
                          .toUpperCase(),
                      style: TextStyle(
                        fontSize: 1.4 * SizeConfig.defaultSize,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
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
                    color: ColorList.colorList[widget.index % 3],
                  ),
                ), //photo
                Container(
                  margin: EdgeInsets.only(
                      top: .7 * SizeConfig.defaultSize,
                      left: 1.2 * SizeConfig.defaultSize),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Container(
                            child: Text(
                              widget.contestantInfo.teamName,
                              style: TextStyle(
                                color: dark,
                                fontSize: 1.5 * SizeConfig.defaultSize,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: .5 * SizeConfig.defaultSize,
                            left: .4 * SizeConfig.defaultSize),
                        child: Text(
                          widget.contestantInfo.etab,
                          style: TextStyle(
                            color: light,
                            fontSize: 1.4 * SizeConfig.defaultSize,
                          ),
                        ),
                      ),
                    ],
                  ), //name + vote number
                ), //name+vot
              ],
            ),
          ],
        ),
      ),
    );
  }
}
