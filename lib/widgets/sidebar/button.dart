import 'package:aeroday_2021/constants/eventInfo.dart';
import 'package:flutter/material.dart';
import 'package:aeroday_2021/constants/app_constants.dart';
import 'package:aeroday_2021/config/responsive_size.dart';

class Button extends StatefulWidget {
  final String label;
  bool isSelected = false;
  final Function onTap;
  Button({required this.label, required this.onTap, required this.isSelected});
  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.onTap();
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
        margin: EdgeInsets.only(
            left: 10, right: 10, bottom: 1.5 * SizeConfig.defaultSize),
        decoration: BoxDecoration(
            color: widget.isSelected ? red : Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Row(
          children: [
            Icon(
              getIcon(widget.label),
              color: widget.isSelected ? Colors.white : dark,
              size: SizeConfig.defaultSize * 3,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                widget.label, // TODO : responsive
                style: TextStyle(
                  color: widget.isSelected ? Colors.white : dark,
                  fontSize: 1.5 * SizeConfig.defaultSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData getIcon(String s) {
    IconData getIconFromFunc(String stats) {
      switch (stats) {
        case 'leaderboard':
          return Icons.leaderboard_rounded;
        case 'wait':
        case 'vote':
          return Icons.how_to_vote;
      }
      return Icons.lock; // locked
    }

    switch (s) {
      case 'Home':
        return Icons.home_rounded;
      case 'Videographie par drone':
        return getIconFromFunc(EventStats.vpdStats);
      case 'Airshow':
        return getIconFromFunc(EventStats.airshowStats);

      // case 'Leaderboard':
      //   return Icons.leaderboard_rounded;
      default:
        return Icons.error_outline;
    }
  }
}
