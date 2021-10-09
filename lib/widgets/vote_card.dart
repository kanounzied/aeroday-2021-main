import 'dart:math';
import 'package:aeroday_2021/config/responsive_size.dart';
import 'package:aeroday_2021/constants/app_constants.dart';
import 'package:aeroday_2021/constants/colors_hex.dart';
import 'package:aeroday_2021/constants/functions.dart';
import 'package:aeroday_2021/screens/login_screen/login_screen.dart';
import 'package:aeroday_2021/services/contestant_info.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VoteCard extends StatefulWidget {
  @override
  Function onVoted;
  Function onVoteCardExtended;
  ContestantInfo contInfo;
  int index;

  bool openUp;

  String vCardEvent;

  VoteCard({
    required this.onVoted,
    required this.contInfo,
    required this.onVoteCardExtended,
    required this.index,
    this.openUp = false,
    required this.vCardEvent,
  });

  _VoteCardState createState() => _VoteCardState();
}

class _VoteCardState extends State<VoteCard> {
  double initPress = 0;
  double _height = 140 * 0.1 * SizeConfig.defaultSize;
  String userHasVoted = '';

  bool bot = false, top = false;

  User? user = FirebaseAuth.instance.currentUser;

  _VoteCardState() {
    // Update user state
    FirebaseAuth.instance.authStateChanges().listen((User? u) {
      setState(() {
        user = FirebaseAuth.instance.currentUser;
      });
      FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .get()
          .then((DocumentSnapshot ds) {
        setState(() {
          userHasVoted = ds.get(
            FieldPath(['voteID_' + widget.vCardEvent]),
          );
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.openUp) {
      // Open the card when user clicks on a contestant
      _height = 256 * 0.1 * SizeConfig.defaultSize;
      top = true;
      bot = false;
      widget.openUp = false;
    }

    double sHeight = SizeConfig.screenHeight;
    double sWidth = SizeConfig.screenWidth;
    double currPos = 0;
    return Center(
      child: GestureDetector(
        onPanDown: (det) {
          initPress = sHeight - det.globalPosition.dy;
          bot = false;
          top = false;

          if (_height == 140 * 0.1 * SizeConfig.defaultSize) bot = true;
          if (_height == 256 * 0.1 * SizeConfig.defaultSize) top = true;
        },
        onPanUpdate: (details) {
          setState(() {
            currPos = sHeight - details.globalPosition.dy;

            if ((currPos - initPress).abs() <= 117) {
              if (bot && currPos - initPress > 0) {
                _height =
                    (currPos - initPress + 140) * 0.1 * SizeConfig.defaultSize;
              }
              if (top && currPos - initPress < 0) {
                _height =
                    (currPos - initPress + 256) * 0.1 * SizeConfig.defaultSize;
              }
            }
            widget.onVoteCardExtended(
                _height - 140 * 0.1 * SizeConfig.defaultSize);
          });
        },
        onPanEnd: (_) {
          //print(148 * 0.1 * SizeConfig.defaultSize);
          setState(() {
            if (bot && _height > 148 * 0.1 * SizeConfig.defaultSize) {
              _height = 256 * 0.1 * SizeConfig.defaultSize;
              top = true;
              bot = false;
            } else if (bot) {
              _height = 140 * 0.1 * SizeConfig.defaultSize;
              top = false;
              bot = true;
            }
            if (top && _height < 248 * 0.1 * SizeConfig.defaultSize) {
              _height = 140 * 0.1 * SizeConfig.defaultSize;
              top = false;
              bot = true;
            } else if (top) {
              _height = 256 * 0.1 * SizeConfig.defaultSize;
              top = true;
              bot = false;
            }
          });
          setState(() {});
          widget
              .onVoteCardExtended(_height - 140 * 0.1 * SizeConfig.defaultSize);
        },
        onTap: () {
          setState(() {
            if (bot) {
              _height = 256 * 0.1 * SizeConfig.defaultSize;
              top = true;
              bot = false;
            } else if (top) {
              _height = 140 * 0.1 * SizeConfig.defaultSize;
              top = false;
              bot = true;
            }
          });
          widget
              .onVoteCardExtended(_height - 140 * 0.1 * SizeConfig.defaultSize);
          setState(() {});
        },
        child: Stack(alignment: AlignmentDirectional.center, children: [
          AnimatedPositioned(
            bottom: _height - 256 * 0.1 * SizeConfig.defaultSize,
            duration: Duration(milliseconds: 150),
            curve: Curves.easeOut,
            child: Container(
              width: sWidth * 0.9,
              height: 256 * 0.1 * SizeConfig.defaultSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(19)),
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
                  AnimatedContainer(
                      duration: Duration(milliseconds: 100),
                      child: Transform.rotate(
                        angle: top ? pi : 0,
                        child: Icon(
                          Icons.keyboard_arrow_up_rounded,
                          color: Colors.black26,
                          size: 35 * 0.1 * SizeConfig.defaultSize,
                        ),
                      )),
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            left: 25 * 0.1 * SizeConfig.defaultSize),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flex(
                              direction: Axis.vertical,
                              children: [
                                Container(
                                  width: 240 * 0.1 * SizeConfig.defaultSize,
                                  child: Text(
                                    '${widget.contInfo.teamName}',
                                    style: TextStyle(
                                      fontSize:
                                          25 * 0.1 * SizeConfig.defaultSize,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF323A40),
                                    ),
                                  ),
                                )
                              ],
                            ), //name
                            SizedBox(
                              height: 10 * 0.1 * SizeConfig.defaultSize,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 30 * 0.1 * SizeConfig.defaultSize,
                                ),
                                Container(
                                  width: 180 * 0.1 * SizeConfig.defaultSize,
                                  child: Text(
                                    widget.contInfo.etab == 'solo'
                                        ? 'Video numéro ' +
                                            widget.contInfo.vidNum
                                        : 'Etab: ${widget.contInfo.etab}',
                                    style: TextStyle(
                                      fontSize:
                                          14 * 0.1 * SizeConfig.defaultSize,
                                      color: light,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            widget.contInfo.chef == 'solo'
                                ? Container()
                                : Row(
                                    children: [
                                      SizedBox(
                                        width:
                                            30 * 0.1 * SizeConfig.defaultSize,
                                      ),
                                      Container(
                                        width:
                                            180 * 0.1 * SizeConfig.defaultSize,
                                        child: Text(
                                          'Leader: ${widget.contInfo.chef}',
                                          style: TextStyle(
                                            fontSize: 14 *
                                                0.1 *
                                                SizeConfig.defaultSize,
                                            color: Color(0xFF323A40),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ), //infoText
                      Container(
                        margin: EdgeInsets.only(
                            right: 25 * 0.1 * SizeConfig.defaultSize),
                        width: 88 * 0.1 * SizeConfig.defaultSize,
                        height: 88 * 0.1 * SizeConfig.defaultSize,
                        child: Center(
                          child: Text(
                            UsualFunctions.getInitials(widget.contInfo.teamName)
                                .toUpperCase(),
                            style: TextStyle(
                              fontSize: SizeConfig.defaultSize * 3.0,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorList.colorList[(widget.index + 1) % 3],
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset.zero,
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                          ],
                          border: Border.all(
                              color: Color(0xFF323A40),
                              width: 3 * 0.1 * SizeConfig.defaultSize),
                        ),
                      ), //image
                    ],
                  ), //text+image
                  SizedBox(
                    height: 30 * 0.1 * SizeConfig.defaultSize,
                  ),
                  //button
                  GestureDetector(
                    onTap: () async {
                      if (user != null) {
                        DocumentReference selectedContestantDoc =
                            FirebaseFirestore.instance
                                .collection('contestant_' + widget.vCardEvent)
                                .doc(widget.contInfo.id);

                        DocumentReference userDoc = FirebaseFirestore.instance
                            .collection('users')
                            .doc(user?.uid);

                        userDoc.get().then((DocumentSnapshot ds) async {
                          String voteID = ds.get(
                            FieldPath(['voteID_' + widget.vCardEvent]),
                          );

                          if (voteID == widget.contInfo.id) {
                            userHasVoted = '';
                            setState(() {});
                            //change user field voteid and decrement votes for contestant
                            userDoc.update(
                              {'voteID_' + widget.vCardEvent: ''},
                            );

                            selectedContestantDoc.get().then(
                              (DocumentSnapshot ds) {
                                int votes = ds.get(FieldPath(['votes']));
                                selectedContestantDoc.update(
                                  {'votes': --votes},
                                );
                              },
                            );
                          } else {
                            if (voteID != '') {
                              //he's changing the vote
                              //get the old voted contestant
                              DocumentReference oldVoted = FirebaseFirestore
                                  .instance
                                  .collection('contestant_' + widget.vCardEvent)
                                  .doc(voteID);
                              //get the old votes and decrement them
                              oldVoted.get().then(
                                (DocumentSnapshot ds) {
                                  int oldVotedVotes =
                                      ds.get(FieldPath(['votes']));
                                  oldVoted.update(
                                    {'votes': --oldVotedVotes},
                                  );
                                },
                              );
                            }
                            //increment the new voted
                            selectedContestantDoc
                                .get()
                                .then((DocumentSnapshot ds) {
                              int votes = ds.get(FieldPath(['votes']));
                              selectedContestantDoc.update(
                                {'votes': ++votes},
                              );
                            });
                            //update voteid
                            await userDoc.update(
                              {
                                'voteID_' + widget.vCardEvent:
                                    widget.contInfo.id
                              },
                            );
                            userHasVoted = widget.contInfo.id;
                            setState(() {});
                          }
                        });
                      } else {
                        //print('couldnt vote');
                        showDialog(
                          context: context,
                          builder: (c) {
                            return AlertDialog(
                              title: Text('Verification error:'),
                              content: Text('You must be signed in to vote!'),
                              actions: [
                                TextButton(
                                    onPressed: () async {
                                      Navigator.of(c).pop();
                                      await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => LoginScreen(
                                                  noRedirect: true)));
                                      setState(() {
                                        user =
                                            FirebaseAuth.instance.currentUser;
                                      });
                                    },
                                    child: const Text('Sign in')),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(c, 'Dismiss');
                                    },
                                    child: const Text('Dismiss')),
                              ],
                              elevation: 21,
                            );
                          },
                          barrierDismissible: true,
                        );
                      }
                    },
                    child: AnimatedContainer(
                      width: SizeConfig.screenWidth * 0.65,
                      height: 70 * 0.1 * SizeConfig.defaultSize,
                      duration: Duration(milliseconds: 150),
                      curve: Curves.easeOut,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xFF323A40),
                          width: 4 * 0.1 * SizeConfig.defaultSize,
                        ),
                        borderRadius: BorderRadius.all(
                            Radius.circular(7 * 0.1 * SizeConfig.defaultSize)),
                        color: Color(userHasVoted == widget.contInfo.id &&
                                FirebaseAuth.instance.currentUser != null
                            ? 0xFF323A40
                            : 0xFFFFFFFF),
                      ),
                      child: Center(
                        child: Text(
                          'VOTE${userHasVoted == widget.contInfo.id && FirebaseAuth.instance.currentUser != null ? 'D' : ''}',
                          style: TextStyle(
                            color: Color(0xFF51A678),
                            fontSize: 26 * 0.1 * SizeConfig.defaultSize,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ), //button
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
