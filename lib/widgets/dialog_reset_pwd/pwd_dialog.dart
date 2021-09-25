import 'package:aeroday_2021/config/responsive_size.dart';
import 'package:aeroday_2021/widgets/dialog_reset_pwd/cercle_step.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PwdDialog extends StatefulWidget {
  String loginNumber = '';
  PwdDialog(this.loginNumber);

  @override
  _PwdDialogState createState() => _PwdDialogState(this.loginNumber);
}

class _PwdDialogState extends State<PwdDialog> {
  String? passErrorMsg, confirmPassErrorMsg, verifCodeError;

  String verifId = '';
  bool codeInputEnabled = false;

  int nbStep = 0;

  TextEditingController pwd1 = new TextEditingController();
  TextEditingController pwd2 = new TextEditingController();
  TextEditingController codeController = new TextEditingController();

  int attempts = 0;
  static const int MAX_ATTEMPTS = 4;

  _PwdDialogState(loginNumber) {
    codeController.text = loginNumber;
  }

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
            CercleStep(0, true),
            SizedBox(
              width: SizeConfig.defaultSize * 2.5,
            ),
            CercleStep(1, nbStep > 0),
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
            nbStep == 1 || nbStep == 0
                ? (nbStep == 1
                    ? "We sent you an SMS with a verification code. \n Please insert that code."
                    : "Please insert your phone number.")
                : (nbStep == 2
                    ? "Insert your new password"
                    : "All set! Now go enjoy Aeroday 2021!"),
            style: TextStyle(fontSize: SizeConfig.defaultSize * 1.4),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: SizeConfig.defaultSize * 2.2,
          ),
          nbStep == 1 || nbStep == 0
              ? Container(
                  height: SizeConfig.screenHeight * 0.09,
                  width: SizeConfig.screenWidth * 0.75,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    cursorColor: Color(0xffd95252),
                    maxLength: nbStep == 0 ? 8 : 6,
                    controller: codeController,
                    onChanged: (value) async {
                      if (nbStep == 0) {
                        setState(() {
                          verifCodeError = null;
                        });
                      } else if (nbStep == 1 &&
                          value.length <= 5 &&
                          verifCodeError != null) {
                        setState(() {
                          verifCodeError = null;
                        });
                      } else if (nbStep == 1 &&
                          value.length == 6 &&
                          verifCodeError ==
                              null) if (await handleCodeVerificationAndSignin())
                        setState(() {
                          nbStep = 2;
                        });
                    },
                    buildCounter: (
                      BuildContext context, {
                      required int currentLength,
                      int? maxLength,
                      required bool isFocused,
                    }) =>
                        null,
                    decoration: InputDecoration(
                      labelText: nbStep == 1
                          ? "Verification code"
                          : "Your phone number",
                      enabled: nbStep == 1 ? codeInputEnabled : true,
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
              onPressed: nbStep == 1 && verifId == ''
                  ? null
                  : () async {
                      if (nbStep < 3) {
                        switch (nbStep) {
                          case 0:
                            {
                              if (!validateNumber(codeController.text)) {
                                setState(() {
                                  verifCodeError = "Invalid phone number";
                                });
                                return;
                              }

                              List<String> l = await FirebaseAuth.instance
                                  .fetchSignInMethodsForEmail(
                                      codeController.text + "@gmail.com");
                              if (l.length == 0) {
                                setState(() {
                                  verifCodeError = "Phone number isn't used";
                                });
                                return;
                              }
                              await FirebaseAuth.instance.verifyPhoneNumber(
                                phoneNumber: '+216' + codeController.text,
                                codeSent: (String verificationId,
                                    int? resendingToken) {
                                  setState(() {
                                    verifId = verificationId;
                                    codeInputEnabled = true;
                                  });
                                },
                                verificationCompleted: (PhoneAuthCredential
                                    phoneAuthCredential) async {
                                  setState(() {
                                    nbStep = 2;
                                  });
                                  await FirebaseAuth.instance
                                      .signInWithCredential(
                                    phoneAuthCredential,
                                  );
                                },
                                verificationFailed:
                                    (FirebaseAuthException error) {},
                                codeAutoRetrievalTimeout:
                                    (String verificationId) {},
                              );
                              codeController.clear();
                              setState(() {
                                nbStep = 1;
                              });
                              break;
                            }
                          case 1:
                            {
                              if (await handleCodeVerificationAndSignin())
                                setState(() {
                                  nbStep = 2;
                                });
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

                              setState(() {
                                nbStep = 3;
                              });

                              break;
                            }
                        }
                      } else {
                        Navigator.pop(context);
                        setState(() {});
                      }
                      Focus.of(context).unfocus();
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

  bool validateNumber(String number) {
    number = number.replaceAll(' ', '');
    return RegExp("[0-9]").hasMatch(number) && number.length == 8;
  }

  Future<bool> handleCodeVerificationAndSignin() async {
    // Disable input field while verifying
    setState(() {
      codeInputEnabled = false;
    });

    attempts++;
    if (attempts > MAX_ATTEMPTS) {
      setState(() {
        verifCodeError = "Max attempts exceeded!";
      });
      // Keep input field disabled
      return false;
    }

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verifId,
      smsCode: codeController.text,
    );

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-verification-code") {
        setState(() {
          verifCodeError = "Invalid code - Attempt " +
              attempts.toString() +
              "/" +
              MAX_ATTEMPTS.toString();
        });
        print("Invalid code");
        setState(() {
          codeInputEnabled = true;
        });
        return false;
      }
    }
    setState(() {
      codeInputEnabled = true;
    });
    return true;
  }
}
