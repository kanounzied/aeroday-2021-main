import 'package:flutter/material.dart';
import 'package:aeroday_2021/constants/app_constants.dart';

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
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 15),
        decoration: BoxDecoration(
            color: widget.isSelected ? red : Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Row(
          children: [
            Icon(
              getIcon(widget.label),
              color: widget.isSelected ? Colors.white : dark,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                widget.label,
                style:
                    TextStyle(color: widget.isSelected ? Colors.white : dark),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData getIcon(String s) {
    switch (s) {
      case 'Home':
        return Icons.home_rounded;
      case 'Videographie par drone':
      case 'Aérochallenge':
        return Icons.how_to_vote_rounded;
      case 'Leaderboard':
        return Icons.leaderboard_rounded;
      default:
        return Icons.error_outline;
    }
  }
}
