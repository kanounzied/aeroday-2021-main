import 'dart:io';

import 'package:aeroday_2021/constants/functions.dart';
import 'package:aeroday_2021/screens/home_screen/home.dart';
import 'package:aeroday_2021/screens/loading_screen/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../login_screen/login_screen.dart';

import 'package:aeroday_2021/config/responsive_size.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  final bool noRedirect;
  SignUpScreen({this.noRedirect = false});

  @override
  _SignUpScreen createState() => _SignUpScreen(noRedirect: this.noRedirect);
}

class _SignUpScreen extends State<SignUpScreen> {
  // TextEdit controllers to access the field's value
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final codeController = TextEditingController();
  bool signupDisabled = false;

  final bool noRedirect;
  _SignUpScreen({this.noRedirect = false});

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
        //FirebaseAuth.instance.signOut();
        Navigator.pop(context);
        Navigator.push(
            // Open HomeScreen
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()));
      });
    }
  }

  // bool validateNumber(String number) {
  //   number = number.replaceAll(' ', '');
  //   return RegExp("[0-9]").hasMatch(number) && number.length == 8;
  // }

  void toggleSignupButton(bool state) {
    // True : active
    // False : disabled

    setState(
      () {
        signupDisabled = !state;
      },
    );
  }

  // Signup button event
  void signupButtonCalled() async {
    toggleSignupButton(false);
    emailController.text = emailController.text.trim();

    bool check = await hasNetwork();
    if (!check) {
      UsualFunctions.showErrorDialog(
        context: context,
        height: SizeConfig.screenHeight * 0.13,
        title: "Sign up error",
        error: "Verify your network access.",
      );

      toggleSignupButton(true);
      return;
    }

    if (!UsualFunctions.validateEmail(emailController.text)) {
      UsualFunctions.showErrorDialog(
        context: context,
        height: SizeConfig.screenHeight * 0.16,
        title: "Sign up error",
        error: "You've used an invalid email address.",
      );

      toggleSignupButton(true);
      return;
    }

    if (!RegExp("(?=.*[0-9a-zA-Z]).{6,}").hasMatch(passController.text)) {
      UsualFunctions.showErrorDialog(
        context: context,
        height: SizeConfig.screenHeight * 0.15,
        title: "Sign up error",
        error: "The password provided is too weak.",
      );

      //print('The password provided is too weak.');
      toggleSignupButton(true);
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passController.text,
      );

      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .set({
        'hasVoted': false,
        'voteID_Airshow': '',
        'voteID_Videographie par drone': '',
        'emailValidated': false,
      });

      FirebaseAuth.instance.currentUser?.sendEmailVerification();
      UsualFunctions.showErrorDialog(
        context: context,
        height: SizeConfig.screenHeight * 0.13,
        title: "Sign up Completed",
        error: "Check your email for a verification link.",
      );
      await FirebaseAuth.instance.signOut();

      toggleSignupButton(true);

      // Redirect to home
      Navigator.pop(context);

      //if (!this.noRedirect)
      Navigator.push(
          // Open HomeScreen
          context,
          MaterialPageRoute(
              builder: (context) => LoginScreen(noRedirect: this.noRedirect)));
    } on FirebaseAuthException catch (e) {
      // Error handling
      toggleSignupButton(true);

      if (e.code == 'too-many-requests') {
        //print("network error");
        UsualFunctions.showErrorDialog(
          context: context,
          height: SizeConfig.screenHeight * 0.13,
          title: "Sign up error",
          error: "Too many invalid signin attemps, try again in few minutes.",
        );

        return;
      }
      if (e.code == 'email-already-in-use') {
        UsualFunctions.showErrorDialog(
          context: context,
          height: SizeConfig.screenHeight * 0.13,
          title: "Sign up error",
          error: "Email address is already registered.",
        );
        return;
      }
      if (e.code == 'network-request-failed') {
        UsualFunctions.showErrorDialog(
          context: context,
          height: SizeConfig.screenHeight * 0.13,
          title: "Sign up error",
          error: "Verify your network access.",
        );
        return;
      }
      if (e.code == 'invalid-email') {
        UsualFunctions.showErrorDialog(
          context: context,
          height: SizeConfig.screenHeight * 0.16,
          title: "Sign up error",
          error: "You've used an invalid email address.",
        );
        return;
      }

      UsualFunctions.showErrorDialog(
        context: context,
        height: SizeConfig.screenHeight * 0.13,
        title: "Sign up error",
        error: "UNKNOWN: " + e.code,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFF323A40), // Gray
      body: SafeArea(
        // SafeArea to avoid system's bar for notifications

        /*
          Page's Structure:
            - Container: Aeroday logo 
            - Expanded + Container: White space for sign up form 
              (Expanded to fill the screen)
              - Signup icon (no icon currently)
              - Container : Email
              - Container : Password
              - Container : Signup button
              - Container : Drone image
              - Container : "Vous avez deja un compte?"
              - Container + Gest. detector : "Connectez-vous"
        */
        child: Stack(
          children: [
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    margin:
                        EdgeInsets.only(top: SizeConfig.screenHeight * 0.005),
                    child: new Image.asset('assets/logo.png',
                        width: SizeConfig.screenWidth * 0.52,
                        height: SizeConfig.screenHeight * 0.13),
                  ),
                  Expanded(
                    child: Container(
                      margin:
                          EdgeInsets.only(top: SizeConfig.screenHeight * 0.02),
                      decoration: new BoxDecoration(
                        color: Color(0xFFF2F2F2),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50)),
                      ),
                      width: SizeConfig.screenWidth,
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                                top: SizeConfig.screenHeight * 0.011),
                            child: new Image.asset(
                              "assets/signup.png",
                              width: SizeConfig.screenWidth * .1,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: SizeConfig.screenHeight * 0.03),
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
                                contentPadding: EdgeInsets.symmetric(
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
                                labelText: 'Your passord',
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
                                "Signup",
                                style: TextStyle(
                                  fontSize: SizeConfig.defaultSize * 1.8,
                                ),
                              ),
                              onPressed:
                                  signupDisabled ? null : signupButtonCalled,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: SizeConfig.screenHeight * 0.065),
                            child: new Image.asset('assets/drone_image.png',
                                width: SizeConfig.screenWidth * 0.52,
                                height: SizeConfig.screenHeight * 0.13),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: SizeConfig.screenHeight * 0.06),
                            child: Text(
                              "You already have an account?",
                              style: TextStyle(
                                fontSize: SizeConfig.defaultSize * 1.3,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: SizeConfig.screenHeight * 0.007),
                            child: GestureDetector(
                              onTap: () {
                                // Redirect login_screen
                                //print("redirect login");
                                //Navigator.pop(context);
                                if (!this.noRedirect)
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginScreen(
                                        noRedirect: this.noRedirect,
                                      ),
                                    ),
                                  );
                                else
                                  Navigator.pop(context);
                              },
                              child: Text(
                                "Signin",
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
              child: signupDisabled ? LoadingScreen() : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
