import 'dart:io';

import 'package:aeroday_2021/constants/functions.dart';
import 'package:aeroday_2021/screens/loading_screen/loading_screen.dart';
import 'package:aeroday_2021/screens/signup_screen/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import 'package:aeroday_2021/screens/home_screen/home.dart';
import 'package:aeroday_2021/widgets/dialog_reset_pwd/dialog_reset_pwd.dart';

import '../../config/responsive_size.dart';

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
      print("h");
      print(result);
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      print("false");
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

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailController.text + "@gmail.com",
        password: passController.text,
      )
          .whenComplete(() {
        print("signin complete");
        if (FirebaseAuth.instance.currentUser == null) {
          print("invalid login");
          toggleSignupButton(true);
          return;
        } else {
          print(FirebaseAuth.instance.currentUser);
          // Redirect to home/voting page HERE
          Navigator.pop(context); // Close signup_screen
          if (!this.noRedirect)
            Navigator.push(
                // Open HomeScreen
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()));
          print("login");
        }
      });

      print("bla1");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        toggleSignupButton(true);

        UsualFunctions.showErrorDialog(
          context: context,
          height: SizeConfig.screenHeight * 0.15,
          title: "Erreur de connexion",
          error: "Votre numéro du téléphone n'exist pas.",
        );

        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        toggleSignupButton(true);

        UsualFunctions.showErrorDialog(
          context: context,
          height: SizeConfig.screenHeight * 0.13,
          title: "Erreur de connexion",
          error: "Votre mot de passe est incorrect.",
        );

        print('Wrong password provided for that user.');
      } else if (e.code == 'network-request-failed') {
        print("network error");
        UsualFunctions.showErrorDialog(
          context: context,
          height: SizeConfig.screenHeight * 0.13,
          title: "Erreur de connexion",
          error: "Verifier votre accés à l'internet.",
        );

        toggleSignupButton(true);
        return;
      } else {
        print("error:");
        print(e.code);

        UsualFunctions.showErrorDialog(
          context: context,
          height: SizeConfig.screenHeight * 0.13,
          title: "Erreur de connexion",
          error: "UNKNOWN: " + e.code,
        );

        toggleSignupButton(true);
        return;
      }
    }
    toggleSignupButton(true);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

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
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                                top: SizeConfig.screenHeight * 0.011),
                            child: new Image.asset(
                              "assets/login_icon.png",
                              width: 50,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: SizeConfig.screenHeight * 0.04),
                            height: SizeConfig.screenHeight * 0.08,
                            width: SizeConfig.screenWidth * 0.75,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                              controller: emailController,
                              maxLength: 8,
                              buildCounter: (
                                BuildContext context, {
                                required int currentLength,
                                int? maxLength,
                                required bool isFocused,
                              }) =>
                                  null,
                              decoration: InputDecoration(
                                hintText: 'Numéro du téléphone',
                                labelText: 'Votre numéro du téléphone',
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
                                hintText: 'Mot de passe',
                                labelText: 'Votre mot de passe',
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
                                "Se connecter",
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
                                print("pass lost");

                                await dialogResetPwd(
                                    context, emailController.text);
                                print("back");

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
                                "Mot de passe oublié?",
                                style: TextStyle(
                                  color: Color(0xFF519DA6),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: SizeConfig.screenHeight * 0.13),
                            child: Text("Vous n'avez pas de compte ?"),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: SizeConfig.screenHeight * 0.007),
                            child: GestureDetector(
                              onTap: () async {
                                // Signup click
                                print("inscription");
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
                                }
                              },
                              child: Text(
                                "Inscrivez-vous",
                                style: TextStyle(
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
