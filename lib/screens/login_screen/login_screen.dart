import 'dart:io';

import 'package:aeroday_2021/constants/functions.dart';
import 'package:aeroday_2021/screens/loading_screen/loading_screen.dart';
import 'package:aeroday_2021/screens/signup_screen/signup_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:aeroday_2021/screens/home_screen/home.dart';
import 'package:aeroday_2021/widgets/dialog_reset_pwd/dialog_reset_pwd.dart';

import 'package:aeroday_2021/config/responsive_size.dart';

class LoginScreen extends StatefulWidget {
  final bool noRedirect;
  LoginScreen({this.noRedirect = false});

  @override
  _LoginScreen createState() => _LoginScreen(noRedirect: this.noRedirect);
}

class _LoginScreen extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool signinDisabled = false;

  final bool noRedirect;
  _LoginScreen({this.noRedirect = false});

  Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('www.google.com');
      //print("h");
      //print(result);
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      //print("false");
      return false;
    }
  }

  @override
  void initState() {
    super.initState();

    if (FirebaseAuth.instance.currentUser != null) {
      // Already logged in
      Future(() {
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      });
    }
  }

  void toggleSignupButton(bool state) {
    // True : active
    // False : disabled

    setState(
      () {
        signinDisabled = !state;
      },
    );
  }

  void signupButtonCalled() async {
    toggleSignupButton(false);

    emailController.text = emailController.text.trim();

    if (!UsualFunctions.validateEmail(emailController.text)) {
      UsualFunctions.showErrorDialog(
        context: context,
        height: SizeConfig.screenHeight * 0.16,
        title: "Sign in error",
        error: "You've used an invalid email address.",
      );

      toggleSignupButton(true);
      return;
    }

    if (passController.text.isEmpty ||
        !RegExp("(?=.*[0-9a-zA-Z]).{6,}").hasMatch(passController.text)) {
      toggleSignupButton(true);

      UsualFunctions.showErrorDialog(
        context: context,
        height: SizeConfig.screenHeight * 0.13,
        title: "Sign in error",
        error: "Invalid password.",
      );
      return;
    }

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailController.text,
        password: passController.text,
      )
          .whenComplete(() {
        //print("signin complete");
        if (FirebaseAuth.instance.currentUser == null) {
          //print("invalid login");
          toggleSignupButton(true);
          return;
        } else {
          if (!FirebaseAuth.instance.currentUser!.emailVerified) {
            FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .get()
                .then((DocumentSnapshot ds) {
              setState(() {
                // Custom email verification
                bool emailVerif = ds.get(
                  FieldPath(['emailValidated']),
                );
                if (emailVerif == false) {
                  UsualFunctions.showErrorDialog(
                    context: context,
                    height: SizeConfig.screenHeight * 0.15,
                    title: "Sign in error",
                    error: "You must verify your email address.",
                  );

                  FirebaseAuth.instance.currentUser?.sendEmailVerification();
                  FirebaseAuth.instance.signOut();
                  toggleSignupButton(true);
                  return;
                }
              });
            });
            return;
          }

          // Redirect to home/voting page HERE
          Navigator.pop(context); // Close signin_screen
          if (!this.noRedirect)
            Navigator.push(
                // Open HomeScreen
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()));
          //print("login");
        }
      });

      //print("bla1");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        toggleSignupButton(true);

        UsualFunctions.showErrorDialog(
          context: context,
          height: SizeConfig.screenHeight * 0.15,
          title: "Sign in error",
          error: "Your email address doesn't exist.",
        );

        //print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        toggleSignupButton(true);

        UsualFunctions.showErrorDialog(
          context: context,
          height: SizeConfig.screenHeight * 0.13,
          title: "Sign in error",
          error: "Invalid password.",
        );

        //print('Wrong password provided for that user.');
      } else if (e.code == 'network-request-failed') {
        //print("network error");
        UsualFunctions.showErrorDialog(
          context: context,
          height: SizeConfig.screenHeight * 0.13,
          title: "Sign in error",
          error: "Verify your network access.",
        );

        toggleSignupButton(true);
        return;
      } else if (e.code == 'too-many-requests') {
        //print("network error");
        UsualFunctions.showErrorDialog(
          context: context,
          height: SizeConfig.screenHeight * 0.13,
          title: "Sign in error",
          error: "Too many invalid signin attemps, try again in few minutes.",
        );

        toggleSignupButton(true);
        return;
      } else {
        //print("error:");
        //print(e.code);

        UsualFunctions.showErrorDialog(
          context: context,
          height: SizeConfig.screenHeight * 0.13,
          title: "Sign in error",
          error: "UNKNOWN: " + e.code,
        );

        toggleSignupButton(true);
        return;
      }
    }
    toggleSignupButton(true);
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFF323A40),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 5,
                    child: Container(
                      color: Color(0xFF323A40),
                    ),
                  ),
                  new Image.asset('assets/logo.png',
                      width: SizeConfig.screenWidth * 0.52,
                      height: SizeConfig.screenHeight * 0.13),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.025,
                    child: Container(
                      color: Color(0xFF323A40),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: new BoxDecoration(
                        color: Color(0xFFF2F2F2),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                      ),
                      width: SizeConfig.screenWidth,
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                                top: SizeConfig.screenHeight * 0.011),
                            child: new Image.asset(
                              "assets/login_icon.png",
                              width: SizeConfig.screenWidth * .1,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: SizeConfig.screenHeight * 0.04),
                            height: SizeConfig.screenHeight * 0.08,
                            width: SizeConfig.screenWidth * 0.75,
                            child: TextFormField(
                              // keyboardType: TextInputType.number,
                              // inputFormatters: <TextInputFormatter>[
                              //   FilteringTextInputFormatter.allow(
                              //       RegExp(r'[0-9]')),
                              // ],
                              controller: emailController,
                              // maxLength: 8,
                              // buildCounter: (
                              //   BuildContext context, {
                              //   required int currentLength,
                              //   int? maxLength,
                              //   required bool isFocused,
                              // }) =>
                              //     null,
                              decoration: InputDecoration(
                                hintText: 'Email address',
                                hintStyle: TextStyle(
                                  fontSize: SizeConfig.defaultSize * 1.3,
                                ),
                                labelText: 'Your email address',
                                labelStyle: TextStyle(
                                  fontSize: SizeConfig.defaultSize * 1.6,
                                ),
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 25.0, horizontal: 15.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32.0)),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: SizeConfig.screenHeight * 0.02),
                            height: SizeConfig.screenHeight * 0.08,
                            width: SizeConfig.screenWidth * 0.75,
                            child: TextFormField(
                              controller: passController,
                              obscureText: true,
                              autocorrect: false,
                              enableSuggestions: false,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                  fontSize: SizeConfig.defaultSize * 1.3,
                                ),
                                labelText: 'Your password',
                                labelStyle: TextStyle(
                                  fontSize: SizeConfig.defaultSize * 1.6,
                                ),
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 25.0, horizontal: 15.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32.0)),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: SizeConfig.screenHeight * 0.05),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all<Size>(
                                    Size(SizeConfig.screenWidth * 0.38,
                                        SizeConfig.screenHeight * 0.06)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                )),
                                backgroundColor:
                                    MaterialStateProperty.resolveWith(
                                  (states) {
                                    if (states
                                        .contains(MaterialState.disabled)) {
                                      return Colors.grey;
                                    } else {
                                      return Colors.red;
                                    }
                                  },
                                ),
                              ),
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: SizeConfig.defaultSize * 1.8,
                                ),
                              ),
                              onPressed:
                                  signinDisabled ? null : signupButtonCalled,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: SizeConfig.screenHeight * 0.05),
                            child: GestureDetector(
                              onTap: () async {
                                // Password lost click
                                //print("pass lost");

                                await dialogResetPwd(
                                    context, emailController.text);
                                //print("back");

                                if (FirebaseAuth.instance.currentUser != null) {
                                  // Already logged in
                                  Future(() {
                                    Navigator.pop(context);
                                    if (!this.noRedirect)
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HomeScreen()));
                                  });
                                }
                              },
                              child: Text(
                                "Forgot password?",
                                style: TextStyle(
                                  fontSize: SizeConfig.defaultSize * 1.2,
                                  color: Color(0xFF519DA6),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: SizeConfig.screenHeight * 0.13),
                            child: Text(
                              "Didn't signup yet?",
                              style: TextStyle(
                                fontSize: SizeConfig.defaultSize * 1.3,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: SizeConfig.screenHeight * 0.007),
                            child: GestureDetector(
                              onTap: () async {
                                // Signup click
                                //print("inscription");
                                //Navigator.pop(context);
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignUpScreen(
                                      noRedirect: this.noRedirect,
                                    ),
                                  ),
                                );
                                if (FirebaseAuth.instance.currentUser != null) {
                                  Navigator.pop(context);
                                  if (!this.noRedirect)
                                    Navigator.push(
                                        // Open HomeScreen
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HomeScreen()));
                                }
                              },
                              child: Text(
                                "Create your account →",
                                style: TextStyle(
                                  fontSize: SizeConfig.defaultSize * 1.3,
                                  color: Color(0xFF519DA6),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: signinDisabled ? LoadingScreen() : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
