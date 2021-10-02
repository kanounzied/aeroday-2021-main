import 'package:flutter/material.dart';

import 'app_constants.dart';

class UsualFunctions {
  static String getInitials(name) {
    List<String> names = name.split(" ");
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
          return AlertDialog(
            title: Text(title),
            content: Container(
              margin: EdgeInsets.only(right: 14),
              child: Text(error),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 14.0),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith((states) => red),
                    ),
                    child: Text('Dismiss')),
              ),
            ],
          );
        });
  }
}
