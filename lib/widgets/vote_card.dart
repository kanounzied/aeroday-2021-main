/*import 'package:aeroday_2021/constants/app_constants.dart';
import 'package:aeroday_2021/services/contestant_info.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class VoteCard extends StatefulWidget {
  const VoteCard({Key? key}) : super(key: key);

  @override
  _VoteCardState createState() => _VoteCardState();
}

double height = 256;
double widthRatio = 0.8;

class _VoteCardState extends State<VoteCard> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        color: red,
      ),
      duration: Duration(
        milliseconds: 200,
      ),
      curve: Curves.easeInExpo,
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * (1 - widthRatio) / 2),
      height: height,
      width: MediaQuery.of(context).size.width * widthRatio,
      child: Column(
        children: [
          Row(
            children: [
              Column(
                children: [
                  Text(
                    "name here",
                  ),
                  Text(
                    "something here",
                  ),
                  Text(
                    "something else here",
                  ),
                ],
              ),
              Container(
                width: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage('https://picsum.photos/100'),
                      fit: BoxFit.fill),
                ),
              ),
              // CachedNetworkImage(
              //   imageUrl: "http://via.placeholder.acom/200",
              //   width: 100,
              //   placeholder: (context, url) => CircularProgressIndicator(),
              //   errorWidget: (context, url, error) => Icon(Icons.error),
              // ),
            ],
          )
        ],
      ),
    );
  }
}

*/

import 'dart:math';

import 'package:aeroday_2021/services/contestant_info.dart';
import 'package:flutter/material.dart';

bool isVoted = false;

class VoteCard extends StatefulWidget {
  @override
  Function onVoted;
  //Duration timePlaying;
  ContestantInfo contInfo;
  VoteCard({
    required this.onVoted,
    required this.contInfo,
    /*required this.timePlaying*/
  });

  _VoteCardState createState() => _VoteCardState();
}

class _VoteCardState extends State<VoteCard> {
  double initPress = 0;
  double _height = 140;

  bool bot = false, top = false;
  @override
  Widget build(BuildContext context) {
    double sHeight = MediaQuery.of(context).size.height;
    double sWidth = MediaQuery.of(context).size.width;
    double currPos = 0;
    String status = '';
    switch (widget.contInfo.status) {
      case 0:
        status = 'Haven\'t Played Yet...';
        break;
      case 1:
        status = 'Playing for ';
        break;
      case 2:
        status = 'Finished Playing ';
        break;
    }
    return Center(
      child: GestureDetector(
        onPanDown: (det) {
          initPress = sHeight - det.globalPosition.dy;
          bot = false;
          top = false;
          if (_height == 140) bot = true;
          if (_height == 256) top = true;
        },
        onPanUpdate: (details) {
          setState(() {
            currPos = sHeight - details.globalPosition.dy;

            if ((currPos - initPress).abs() <= 117) {
              if (bot && currPos - initPress > 0) {
                _height = currPos - initPress + 140;
              }
              if (top && currPos - initPress < 0) {
                _height = currPos - initPress + 256;
              }
            }
          });
        },
        onPanEnd: (_) {
          setState(() {
            if (bot && _height > 148) {
              _height = 256;
            } else if (bot) {
              _height = 140;
            }
            if (top && _height < 248) {
              _height = 140;
            } else if (top) {
              _height = 256;
            }
          });
        },
        onTap: () {
          setState(() {
            if (bot) {
              _height = 256;
            }
            if (top) {
              _height = 140;
            }
          });
        },
        child: Stack(alignment: AlignmentDirectional.center, children: [
          AnimatedPositioned(
            bottom: _height - 256,
            duration: Duration(milliseconds: 150),
            curve: Curves.easeOut,
            child: Container(
              width: sWidth * 0.9,
              height: 256,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(19),
                    topLeft: Radius.circular(19)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Color(0x22000000), blurRadius: 6, spreadRadius: 6)
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      child: Transform.rotate(
                    angle: top ? pi : 0,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.black26,
                      size: 35,
                    ),
                  )),
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flex(
                              direction: Axis.vertical,
                              children: [
                                Container(
                                  width: 245,
                                  child: Text(
                                    '${widget.contInfo.name}',
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF323A40),
                                    ),
                                  ),
                                )
                              ],
                            ), //name
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 30,
                                ),
                                Text(
                                  '$status',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF323A40),
                                  ),
                                ),
                                Text(
                                  widget.contInfo.status == 1 ? 'a' : '',
                                ),
                                Text(
                                  widget.contInfo.status == 1 ? ' minutes' : '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF323A40),
                                  ),
                                ),
                              ],
                            ), //playin for
                            Container(
                                margin: EdgeInsets.only(left: 30, top: 7),
                                child: RichText(
                                    text: TextSpan(children: [
                                  TextSpan(
                                      text: 'Votes : ',
                                      style: TextStyle(
                                        color: Color(0x99323A40),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                      )),
                                  TextSpan(
                                      text: '${widget.contInfo.votes}%',
                                      style: TextStyle(
                                        color: Color(0xFF323A40),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      )),
                                ]))) //vote:%
                          ],
                        ),
                      ), //infoText
                      Container(
                        margin: EdgeInsets.only(right: 25),
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset.zero,
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                          ],
                          border:
                              Border.all(color: Color(0xFF323A40), width: 3),
                          image: DecorationImage(
                            image: NetworkImage('${widget.contInfo.imageUrl}'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ), //image
                    ],
                  ), //text+image
                  SizedBox(
                    height: 30,
                  ),
                  /*VoteButton(
                    isVoted: widget.contInfo.isVoted,
                    clickButton: () {
                      widget.contInfo.isVoted = !widget.contInfo.isVoted;
                      widget.onVoted(widget.contInfo.isVoted);
                      //TODO:implement update voteNumber
                    },
                  ),*/
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
