import 'package:aeroday_2021/config/responsive_size.dart';
import 'package:aeroday_2021/widgets/dialog_reset_pwd/cercle_step.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PwdDialog extends StatefulWidget {
  @override
  _PwdDialogState createState() => _PwdDialogState();
}

class _PwdDialogState extends State<PwdDialog> {
  String? passErrorMsg, confirmPassErrorMsg, verifCodeError;

  int nbStep = 1;
  TextEditingController pwd1 = new TextEditingController();
  TextEditingController pwd2 = new TextEditingController();
  TextEditingController code = new TextEditingController();

  Widget contentBox(context) {
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
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            CercleStep(1, true),
            SizedBox(
              width: SizeConfig.defaultSize * 2.5,
            ),
            CercleStep(2, nbStep > 1),
            SizedBox(
              width: SizeConfig.defaultSize * 2.5,
            ),
            CercleStep(3, nbStep == 3),
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
            nbStep == 1
                ? "We sent you an SMS with a verification code. \n Please insert that code."
                : (nbStep == 2
                    ? "Insert your new password"
                    : "All set! Now go enjoy Aeroday 2021!"),
            style: TextStyle(fontSize: SizeConfig.defaultSize * 1.4),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: SizeConfig.defaultSize * 2.2,
          ),
          nbStep == 1
              ? Container(
                  height: SizeConfig.screenHeight * 0.08,
                  width: SizeConfig.screenWidth * 0.75,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    cursorColor: Color(0xffd95252),
                    maxLength: 6,
                    controller: code,
                    buildCounter: (
                      BuildContext context, {
                      required int currentLength,
                      int? maxLength,
                      required bool isFocused,
                    }) =>
                        null,
                    decoration: InputDecoration(
                      hintText: "Verification code",
                      errorText: verifCodeError,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                    ),
                  ),
                )
              : (nbStep == 2
                  ? Column(
                      children: [
                        Container(
                          height: SizeConfig.screenHeight * 0.09,
                          width: SizeConfig.screenWidth * 0.75,
                          child: TextFormField(
                            obscureText: true,
                            controller: pwd1,
                            onChanged: (text) {
                              if (text != pwd2.text) {
                                setState(() {
                                  confirmPassErrorMsg = 'Password mismatch';
                                });
                              } else {
                                setState(() {
                                  confirmPassErrorMsg = null;
                                });
                              }
                            },
                            keyboardType: TextInputType.number,
                            cursorColor: Color(0xffd95252),
                            decoration: InputDecoration(
                              //hintText: "Enter password",
                              labelText: 'Your password',
                              errorText: passErrorMsg,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.defaultSize,
                        ),
                        Container(
                          height: SizeConfig.screenHeight * 0.09,
                          width: SizeConfig.screenWidth * 0.75,
                          child: TextFormField(
                            controller: pwd2,
                            obscureText: true,
                            cursorColor: Color(0xffd95252),
                            onChanged: (text) {
                              if (text != pwd1.text) {
                                setState(() {
                                  confirmPassErrorMsg = 'Password mismatch';
                                });
                              } else {
                                setState(() {
                                  confirmPassErrorMsg = null;
                                });
                              }
                            },
                            decoration: InputDecoration(
                              //hintText: 'Confirm password',
                              labelText: 'Confirm your password',
                              errorText: confirmPassErrorMsg,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0)),
                            ),
                          ),
                        )
                      ],
                    )
                  : Container()),
          SizedBox(
            height: SizeConfig.defaultSize,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xffd95252),
              ),
              onPressed: () async {
                if (nbStep < 3) {
                  switch (nbStep) {
                    case 1:
                      {
                        // await FirebaseAuth.instance.verifyPhoneNumber(
                        //   phoneNumber: '+216 95262865',
                        //   codeSent: (String verificationId,
                        //       int? forceResendingToken) async {
                        //     print("hi");
                        //     PhoneAuthCredential credential =
                        //         PhoneAuthProvider.credential(
                        //             verificationId: verificationId,
                        //             smsCode: "123456");
                        //     try {
                        //       await FirebaseAuth.instance
                        //           .signInWithCredential(credential);
                        //     } on FirebaseAuthException catch (e) {
                        //       if (e.code == "invalid-verification-code") {
                        //         // TODO : invalid code handle
                        //         print("Invalid code");
                        //         return;
                        //       }
                        //     }
                        //   },
                        //   verificationCompleted:
                        //       (PhoneAuthCredential phoneAuthCredential) {},
                        //   verificationFailed: (FirebaseAuthException error) {},
                        //   codeAutoRetrievalTimeout: (String verificationId) {},
                        // );
                        break;
                      }
                    case 2:
                      {
                        if (pwd1.text != pwd2.text) {
                          return;
                        }
                        if (!RegExp("(?=.*[0-9a-zA-Z]).{6,}")
                            .hasMatch(pwd1.text)) {
                          setState(() {
                            passErrorMsg =
                                "Weak password - At least 6 characters";
                          });
                          return;
                        }

                        await FirebaseAuth.instance.currentUser
                            ?.updatePassword(pwd1.text);

                        break;
                      }
                  }

                  setState(() {
                    nbStep++;
                  });
                } else {
                  Navigator.pop(context);
                }
              },
              child: Text(
                nbStep == 3 ? "Let's go!" : "Next",
                style: TextStyle(fontSize: SizeConfig.defaultSize * 1.8),
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
