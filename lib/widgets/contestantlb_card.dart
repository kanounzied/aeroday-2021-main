import 'package:aeroday_2021/config/responsive_size.dart';
import 'package:aeroday_2021/constants/app_constants.dart';
import 'package:aeroday_2021/screens/vote_ac.dart';
import 'package:aeroday_2021/services/contestant_info.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    double screenWidth = SizeConfig.screenWidth;
    double screenHeight = SizeConfig.screenHeight;
    return Container(
      width: screenWidth * 0.85,
      height: 62,
      margin: EdgeInsets.only(bottom: 16),
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
        borderRadius: BorderRadius.all(Radius.circular(9.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: widget.index > 3
                      ? 14
                      : widget.index == 1
                          ? 2
                          : 4,
                  right: widget.index > 3
                      ? 10
                      : widget.index == 1
                          ? 0
                          : 4,
                ),
                child: Container(
                  width: widget.index > 3
                      ? 15
                      : widget.index == 1
                          ? 35
                          : 30,
                  child: widget.index > 3
                      ? Text(
                          widget.index.toString(),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : widget.index == 3
                          ? Image.asset(
                              'assets/3rd.png',
                            )
                          : widget.index == 2
                              ? Image.asset('assets/2nd.png')
                              : Image.asset('assets/1st.png'),
                ),
              ), //number
              Container(
                width: 47,
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
                  color: dark,
                  image: DecorationImage(
                    image: NetworkImage(
                        widget.contestantInfo.imageUrl), //TODO: loading image
                    fit: BoxFit.fill,
                  ),
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
                            style: TextStyle(
                              color: dark,
                              fontSize: 15,
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
                          fontSize: 14,
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
