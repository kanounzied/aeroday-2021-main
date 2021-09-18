import 'package:aeroday_2021/constants/app_constants.dart';
import 'package:aeroday_2021/screens/vote_ac.dart';
import 'package:aeroday_2021/services/contestant_info.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContestantCard extends StatefulWidget {
  ContestantInfo contestantInfo;
  Function onPressed;
  int index;
  //bool isVoted ;
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.onPressed(widget.contestantInfo);
        });
      },
      child: Container(
        width: screenWidth * 0.85,
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
                      widget.index.toString(),
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
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5, left: 4),
                        child: Text(
<<<<<<< HEAD
                          'Team: ' + widget.contestantInfo.teamName,
=======
                          'Team Name: ' + widget.contestantInfo.teamName,
>>>>>>> a249433e687c237bffc278e19cb2f338b4662511
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
      ),
    );
    ;
  }
}
