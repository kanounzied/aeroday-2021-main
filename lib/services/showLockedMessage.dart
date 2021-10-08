import 'package:flutter/material.dart';
import 'package:aeroday2021/config/responsive_size.dart';

void showLockedMessage({context, height, title, content}) {
  // TODO : design
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Container(
          height: height,
          child: Column(
            children: [
              Text(content),
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
