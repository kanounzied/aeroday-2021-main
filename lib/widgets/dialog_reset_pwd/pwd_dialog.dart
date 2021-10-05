import 'package:aeroday_2021/config/responsive_size.dart';
import 'package:aeroday_2021/constants/functions.dart';
import 'package:aeroday_2021/widgets/dialog_reset_pwd/cercle_step.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class PwdDialog extends StatefulWidget {
  String loginNumber = '';
  PwdDialog(this.loginNumber);

  @override
  _PwdDialogState createState() => _PwdDialogState();
}

class _PwdDialogState extends State<PwdDialog> {
  String? verifCodeError;

  int nbStep = 0;

  TextEditingController codeController = new TextEditingController();

  Widget contentBox(context) {
    codeController.text = widget.loginNumber;

    return Container(
      padding: EdgeInsets.all(SizeConfig.defaultSize * 2.5),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(SizeConfig.defaultSize * 2.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              offset: Offset(4, 4),
              blurRadius: 10,
            ),
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            CercleStep(1, true),
            CercleStep(2, nbStep >= 1),
            CercleStep(3, nbStep == 2),
          ]),
          SizedBox(
            height: SizeConfig.defaultSize,
          ),
          Text(
            "Reset password",
            style: TextStyle(
                fontSize: SizeConfig.defaultSize * 2.2,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: SizeConfig.defaultSize * 1.5,
          ),
          Text(
            nbStep == 0
                ? "Please insert your email address."
                : nbStep == 1
                    ? "We sent you an email with a verification link. \n Please open that link in order to change your password."
                    : "All set! Now go enjoy Aeroday 2021!",
            style: TextStyle(fontSize: SizeConfig.defaultSize * 1.4),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: SizeConfig.defaultSize * 2.2,
          ),
          nbStep == 0
              ? Container(
                  height: SizeConfig.screenHeight * 0.09,
                  width: SizeConfig.screenWidth * 0.75,
                  child: TextFormField(
                    cursorColor: Color(0xffd95252),
                    maxLength: nbStep == 0 ? 60 : 6,
                    controller: codeController,
                    onChanged: (value) async {
                      if (verifCodeError != null) {
                        setState(() {
                          verifCodeError = null;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 30.0, horizontal: 15.0),
                      labelText: "Your email address",
                      labelStyle: TextStyle(
                        fontSize: SizeConfig.defaultSize * 1.6,
                      ),
                      enabled: true,
                      errorText: verifCodeError,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                    ),
                  ),
                )
              : Container(),
          SizedBox(
            height: SizeConfig.defaultSize * .85,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith(
                  (states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.grey;
                    } else {
                      return Color(0xffd95252);
                    }
                  },
                ),
              ),
              onPressed: () async {
                if (nbStep <= 1) {
                  switch (nbStep) {
                    case 0:
                      {
                        if (!UsualFunctions.validateEmail(
                            codeController.text)) {
                          setState(() {
                            verifCodeError = "Invalid email address";
                          });
                          return;
                        }

                        try {
                          print("sent");
                          FirebaseAuth.instance.sendPasswordResetEmail(
                            email: codeController.text,
                          );
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            setState(() {
                              verifCodeError = "Email address isn't used.";
                            });
                            return;
                          }
                          if (e.code == 'invalid-email') {
                            setState(() {
                              verifCodeError = "Invalid email address.";
                            });
                            return;
                          }
                          if (e.code == 'network-request-failed') {
                            UsualFunctions.showErrorDialog(
                              context: context,
                              height: SizeConfig.screenHeight * 0.13,
                              title: "Reset password error",
                              error: "Verify your network access.",
                            );
                            return;
                          }
                          UsualFunctions.showErrorDialog(
                            context: context,
                            height: SizeConfig.screenHeight * 0.13,
                            title: "Reset password error",
                            error: "UNKNOWN: " + e.code,
                          );
                          return;
                        } catch (e) {
                          UsualFunctions.showErrorDialog(
                            context: context,
                            height: SizeConfig.screenHeight * 0.13,
                            title: "Reset password error",
                            error: "UNKNOWN: " + e.toString(),
                          );
                          return;
                        }

                        codeController.clear();
                        setState(() {
                          nbStep = 1;
                        });
                        break;
                      }
                    case 1:
                      {
                        setState(() {
                          nbStep = 2;
                        });
                        break;
                      }
                  }
                } else {
                  Navigator.pop(context);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  nbStep == 2 ? "Let's go!" : "Next",
                  style: TextStyle(fontSize: SizeConfig.defaultSize * 1.8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizeConfig.defaultSize * 2.5),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }
}
