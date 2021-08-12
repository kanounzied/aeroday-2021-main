import 'package:aeroday_2021/constants/app_constants.dart';
import 'package:aeroday_2021/screens/vote_ac.dart';
import 'package:aeroday_2021/services/contestant_info.dart';
import 'package:flutter/material.dart';

class ContestantCard extends StatefulWidget {
  ContestantInfo contestantInfo;
  //bool isVoted ;
  ContestantCard({required this.contestantInfo});
  @override
  _ContestantCardState createState() => _ContestantCardState();
}

class _ContestantCardState extends State<ContestantCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenWidth * 0.8,
      height: 62,
      margin: EdgeInsets.only(bottom: 16),
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
        borderRadius: BorderRadius.all(Radius.circular(9.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 14, right: 10),
                child: Container(
                  width: 15,
                  child: Text(
                    '1',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                            widget.contestantInfo.name +
                                ' ' +
                                widget.contestantInfo.lastName,
                            style: TextStyle(
                              color: dark,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.contestantInfo.status == 1
                                ? green
                                : Colors.transparent,
                          ),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5, left: 4),
                      child: Text(
                        'votes : ' +
                            widget.contestantInfo.votes.toString() +
                            '%',
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
          /* widget.contestantInfo.isVoted
              ? Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.how_to_vote_sharp,
                          color: green,
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          'VOTED',
                          style: TextStyle(
                              fontSize: 9,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w300),
                        )
                      ]),
                )
              : Container(),*/
        ],
      ),
    );
    ;
  }
}
