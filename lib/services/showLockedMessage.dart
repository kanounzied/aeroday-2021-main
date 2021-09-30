import 'package:flutter/material.dart';
import 'package:aeroday_2021/config/responsive_size.dart';

void showLockedMessage(context, title) {
  // TODO : design
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Container(
          height: SizeConfig.screenHeight * .1,
          child: Column(
            children: [
              Text("Voting is currently disabled."),
              Container(
                margin: EdgeInsets.only(top: SizeConfig.screenHeight * .01),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                        (states) {
                          return Color(0xffd95252);
                        },
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Ok",
                      style: TextStyle(fontSize: SizeConfig.defaultSize * 1.8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
