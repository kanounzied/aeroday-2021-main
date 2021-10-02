import 'package:aeroday_2021/config/responsive_size.dart';
import 'package:flutter/material.dart';

class UsualFunctions {
  static String getInitials(name) {
    List<String> names = name.split(" ");
    //print(names);
    String initials = "";
    int numWords = 2;
    if (numWords > names.length) {
      numWords = names.length;
    }

    for (var i = 0; i < numWords; i++) {
      initials += '${names[i][0]}';
    }
    return initials;
  }

  static void showErrorDialog(
      {required context, required height, required title, required error}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
              title: Text(title),
              content: SizedBox(
                height: height,
                child: Column(
                  children: <Widget>[
                    Text(error),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: SizeConfig.screenHeight * 0.03),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Ok"),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ));
        });
  }
}
