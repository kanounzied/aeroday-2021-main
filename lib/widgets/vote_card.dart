import 'dart:math';
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
  VoteCard({
    required this.onVoted,
    required this.contInfo,
    required this.onVoteCardExtended,
  });

  _VoteCardState createState() => _VoteCardState();
}

class _VoteCardState extends State<VoteCard> {
  double initPress = 0;
  double _height = 140;
  String userHasVoted = '';

  bool bot = false, top = false;

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get()
        .then((DocumentSnapshot ds) {
      setState(() {
        userHasVoted = ds.get(
          FieldPath(['voteID']),
        );
      });
    });

    double sHeight = MediaQuery.of(context).size.height;
    double sWidth = MediaQuery.of(context).size.width;
    double currPos = 0;
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
            widget.onVoteCardExtended(_height - 140);
          });
        },
        onPanEnd: (_) {
          setState(() {
            if (bot && _height > 148) {
              _height = 256;
              top = true;
              bot = false;
            } else if (bot) {
              _height = 140;
              top = false;
              bot = true;
            }
            if (top && _height < 248) {
              _height = 140;
              top = false;
              bot = true;
            } else if (top) {
              _height = 256;
              top = true;
              bot = false;
            }
          });
          setState(() {});
          widget.onVoteCardExtended(_height - 140);
        },
        onTap: () {
          setState(() {
            if (bot) {
              _height = 256;
              top = true;
              bot = false;
            } else if (top) {
              _height = 140;
              top = false;
              bot = true;
            }
          });
          widget.onVoteCardExtended(_height - 140);
          setState(() {});
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
                                    '${widget.contInfo.teamName}',
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
                                  'Etablissement: ${widget.contInfo.etab}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF323A40),
                                  ),
                                ),
                              ],
                            ), //playin for
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
                            image: NetworkImage(
                              "https://ui-avatars.com/api/?length=" +
                                  (widget.contInfo.teamName.contains(' ')
                                          ? 2
                                          : 1)
                                      .toString() +
                                  "&name=" +
                                  widget.contInfo.teamName,
                            ), //TODO: Image font change
                            fit: BoxFit.fill,
                          ),
                        ),
                      ), //image
                    ],
                  ), //text+image
                  SizedBox(
                    height: 30,
                  ),
                  //button
                  GestureDetector(
                    onTap: () async {
                      if (user != null) {
                        DocumentReference selectedContestantDoc =
                            FirebaseFirestore.instance
                                .collection('contestant')
                                .doc(widget.contInfo.id);

                        DocumentReference userDoc = FirebaseFirestore.instance
                            .collection('users')
                            .doc(user?.uid);

                        userDoc.get().then((DocumentSnapshot ds) async {
                          String voteID = ds.get(
                            FieldPath(['voteID']),
                          );

                          print("ID: " + widget.contInfo.id.toString());

                          if (voteID == widget.contInfo.id) {
                            userHasVoted = '';
                            setState(() {});
                            //change user field voteid and decrement votes for contestant
                            userDoc.update(
                              {'voteID': ''},
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
                                  .collection('contestant')
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
                              {'voteID': widget.contInfo.id},
                            );
                            userHasVoted = widget.contInfo.id;
                            setState(() {});
                          }
                        });
                      } else {
                        print('couldnt vote');
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
                      width: MediaQuery.of(context).size.width * 0.65,
                      height: 70,
                      duration: Duration(milliseconds: 150),
                      curve: Curves.easeOut,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xFF323A40),
                          width: 4,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                        color: Color(userHasVoted == widget.contInfo.id
                            ? 0xFF323A40
                            : 0xFFFFFFFF),
                      ),
                      child: Center(
                        child: Text(
                          'VOTE${userHasVoted == widget.contInfo.id ? 'D' : ''}',
                          style: TextStyle(
                            color: Color(0xFF51A678),
                            fontSize: 26,
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

  Future<void> _updateVoteforUser() async {
    print('todo update vote status for user and contestant');
  }
}
