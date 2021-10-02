import 'package:aeroday_2021/config/responsive_size.dart';
import 'package:aeroday_2021/constants/app_constants.dart';
import 'package:aeroday_2021/constants/colors_hex.dart';
import 'package:aeroday_2021/constants/functions.dart';
import 'package:aeroday_2021/screens/vote_ac.dart';
import 'package:aeroday_2021/services/contestant_info.dart';
import 'package:flutter/material.dart';

class ContestantLbCard extends StatefulWidget {
  ContestantInfo contestantInfo;
  int index;
  //bool isVoted ;
  //test
  ContestantLbCard({required this.contestantInfo, required this.index});
  @override
  _ContestantLbCardState createState() => _ContestantLbCardState();
}

class _ContestantLbCardState extends State<ContestantLbCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6.2 * SizeConfig.defaultSize,
      margin: EdgeInsets.symmetric(
          vertical: .8 * SizeConfig.defaultSize,
          horizontal: .8 * SizeConfig.defaultSize),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            //end: Alignment(99, 1), // TODO : probably change the design
            colors: [Colors.white, getColorByRank(widget.index)]),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset.zero,
            blurRadius: 7,
            spreadRadius: 1,
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
                  left: widget.index > 3
                      ? 1.4 * SizeConfig.defaultSize
                      : widget.index == 1
                          ? .2 * SizeConfig.defaultSize
                          : .4 * SizeConfig.defaultSize,
                  right: widget.index > 3
                      ? 1 * SizeConfig.defaultSize
                      : widget.index == 1
                          ? 0
                          : .4 * SizeConfig.defaultSize,
                ),
                child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: 0.4 * SizeConfig.defaultSize),
                  width: widget.index > 3
                      ? 1.5 * SizeConfig.defaultSize
                      : widget.index == 1
                          ? 3.5 * SizeConfig.defaultSize
                          : 3.0 * SizeConfig.defaultSize,
                  child: widget.index > 3
                      ? Text(
                          widget.index.toString(),
                          style: TextStyle(
                            fontSize: 1.5 * SizeConfig.defaultSize,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : widget.index == 3
                          ? Image.asset(
                              'assets/3rd.png',
                              width: 3 * SizeConfig.defaultSize,
                            )
                          : widget.index == 2
                              ? Image.asset('assets/2nd.png',
                                  width: 3 * SizeConfig.defaultSize)
                              : Image.asset('assets/1st.png',
                                  width: 3.5 * SizeConfig.defaultSize),
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
                      fontSize: 1.5 * SizeConfig.defaultSize,
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
                margin: EdgeInsets.only(top: 7, left: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Container(
                          child: Text(
                            widget.contestantInfo.teamName,
                            overflow: TextOverflow.clip,
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
                      margin: EdgeInsets.only(top: 5, left: 4),
                      child: Text(
                        'Votes: ' + widget.contestantInfo.votes.toString(),
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
    );
  }

  Color getColorByRank(int i) {
    switch (i) {
      case 1:
        return Color(0xFFEAAD4C);
      case 2:
        return Color(0xffAAAAAA);
      case 3:
        return Color(0xffC4845F);
      default:
        return Colors.white;
    }
  }
}
