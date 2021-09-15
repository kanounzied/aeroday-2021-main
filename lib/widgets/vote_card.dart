import 'package:aeroday_2021/constants/app_constants.dart';
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
