import 'dart:io';

import 'package:aeroday_2021/screens/home_screen/home.dart';
import 'package:aeroday_2021/screens/loading_screen/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import '../login_screen/login_screen.dart';

import '../../config/responsive_size.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreen createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> {
  // TextEdit controllers to access the field's value
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final codeController = TextEditingController();
  bool signupDisabled = false;

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
        //FirebaseAuth.instance.signOut();
        Navigator.pop(context);
        Navigator.push(
            // Open HomeScreen
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()));
      });
    }
  }

  bool validateNumber(String number) {
    number = number.replaceAll(' ', '');
    return RegExp("[0-9]").hasMatch(number) && number.length == 8;
  }

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

    bool check = await hasNetwork().whenComplete(
      () {
        print("ready");
      },
    );
    if (!check) {
      print("net");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text("Erreur d'inscription"),
            content: SizedBox(
              height: SizeConfig.screenHeight * 0.13,
              child: Column(
                children: <Widget>[
                  Text("Pas d'accés à l'internet!"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: SizeConfig.screenHeight * 0.04),
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
            ),
          );
        },
      );

      toggleSignupButton(true);
      return;
    }

    if (!validateNumber(emailController.text)) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return new AlertDialog(
                title: Text("Erreur d'inscription"),
                content: SizedBox(
                  height: SizeConfig.screenHeight * 0.16,
                  child: Column(
                    children: <Widget>[
                      Text("Votre numéro du téléphone est invalid."),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                top: SizeConfig.screenHeight * 0.04),
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
      print("num invalid");

      toggleSignupButton(true);
      return;
    }

    List<String> l;
    try {
      // Verify phone number + password
      l = await FirebaseAuth.instance
          .fetchSignInMethodsForEmail(emailController.text + "@gmail.com");
      print("hell");
      if (l.length != 0) {
        // Redirect to login_screen
        showDialog(
            context: context,
            builder: (BuildContext contextDia) {
              return new AlertDialog(
                  title: Text("Erreur d'inscription"),
                  content: SizedBox(
                    height: SizeConfig.screenHeight * 0.13,
                    child: Column(
                      children: <Widget>[
                        Text("Numéro du telephone est deja utilisé."),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  top: SizeConfig.screenHeight * 0.04),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Redirect to login
                                  Navigator.pop(contextDia);
                                  //Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()));
                                },
                                child: Text("Connecter"),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: SizeConfig.screenHeight * 0.04),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(contextDia);
                                },
                                child: Text("OK"),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ));
            });

        print("Exists");
        toggleSignupButton(true);
        return;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        print("network error");
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return new AlertDialog(
              title: Text("Erreur d'inscription"),
              content: SizedBox(
                height: SizeConfig.screenHeight * 0.13,
                child: Column(
                  children: <Widget>[
                    Text("Pas d'accés à l'internet!"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: SizeConfig.screenHeight * 0.04),
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
              ),
            );
          },
        );

        toggleSignupButton(true);
        return;
      }

      // TODO : handle firebase error
      print("firebase error");
      print(e.code);
      toggleSignupButton(true);
      return;
    } catch (e) {
      // TODO: handle unknown error
      print("ERROR: ");
      print(e);

      toggleSignupButton(true);
      return;
    }

    print("hi");

    if (!RegExp("(?=.*[0-9a-zA-Z]).{6,}").hasMatch(passController.text)) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return new AlertDialog(
                title: Text("Erreur d'inscription"),
                content: SizedBox(
                  height: SizeConfig.screenHeight * 0.13,
                  child: Column(
                    children: <Widget>[
                      Text("Votre mot de passe est faible."),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                top: SizeConfig.screenHeight * 0.04),
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

      print('The password provided is too weak.');
      toggleSignupButton(true);
      return;
    }

    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: '+216 ' + emailController.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          print("auto verif");
          // Delete phone number account
          //await FirebaseAuth.instance.currentUser?.delete();

          // Login/Signup
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text + "@gmail.com",
            password: passController.text,
          );

          await FirebaseAuth.instance.currentUser
              ?.linkWithCredential(credential);

          toggleSignupButton(true);

          // Redirect to home
          Navigator.of(context).pop(); // Close signup_screen
          Navigator.push(
              // Open HomeScreen
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()));
        },
        verificationFailed: (FirebaseAuthException e) {
          toggleSignupButton(true);
          print("error verif failed");
          print(e.code);

          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return new AlertDialog(
                    title: Text("Erreur d'inscription"),
                    content: SizedBox(
                      height: SizeConfig.screenHeight * 0.17,
                      child: Column(
                        children: <Widget>[
                          Text("Votre numéro du téléphone est invalid."),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    top: SizeConfig.screenHeight * 0.04),
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
              },
            );
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return new AlertDialog(
                  title: Text("Erreur d'inscription"),
                  content: SizedBox(
                    height: SizeConfig.screenHeight * 0.17,
                    child: Column(
                      children: <Widget>[
                        Text("Erreur inconnue au cour d'inscription!"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  top: SizeConfig.screenHeight * 0.04),
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
                  ),
                );
              },
            );
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          print("codesent");
          // Ask to write 6 digits code
          toggleSignupButton(true);
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext contextDia) {
              return new AlertDialog(
                  title: Text("Verification"),
                  content: SizedBox(
                    height: 195,
                    child: Column(
                      children: <Widget>[
                        Text("Saisir le code composé de 6 chiffre."),
                        Container(
                          width: 150,
                          margin: EdgeInsets.only(top: 20),
                          child: TextFormField(
                            maxLength: 6,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            controller: codeController,
                            decoration: InputDecoration(
                              hintText: 'Code',
                              labelText: 'Code',
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 25.0, horizontal: 15.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0)),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 15),
                              child: ElevatedButton(
                                onPressed: () async {
                                  toggleSignupButton(false);
                                  print("tap");

                                  // Create a PhoneAuthCredential with the code
                                  PhoneAuthCredential credential =
                                      PhoneAuthProvider.credential(
                                          verificationId: verificationId,
                                          smsCode: codeController.text);

                                  try {
                                    await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                      email:
                                          emailController.text + "@gmail.com",
                                      password: passController.text,
                                    );

                                    await FirebaseAuth.instance.currentUser
                                        ?.linkWithCredential(credential);
                                  } on FirebaseAuthException catch (e) {
                                    if (e.code == "invalid-verification-code") {
                                      // Delete email account (invalid code)
                                      await FirebaseAuth.instance.currentUser
                                          ?.delete();

                                      // TODO : invalid code handle
                                      print("Invalid code");
                                      return;
                                    } else {
                                      print("unknown err");
                                      print(e);

                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return new AlertDialog(
                                            title: Text("Erreur d'inscription"),
                                            content: SizedBox(
                                              height: SizeConfig.screenHeight *
                                                  0.17,
                                              child: Column(
                                                children: <Widget>[
                                                  Text(
                                                      "Erreur inconnue au cour d'inscription!"),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: SizeConfig
                                                                    .screenHeight *
                                                                0.04),
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text("Ok"),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );

                                      toggleSignupButton(true);
                                      return;
                                    }
                                  }

                                  // Store user in db
                                  FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(FirebaseAuth
                                          .instance.currentUser?.uid)
                                      .set({
                                    'hasVoted': false,
                                    'voteID': '',
                                  });

                                  toggleSignupButton(true);

                                  // Redirect to login
                                  Navigator.pop(contextDia); // Close dialog

                                  //Navigator.pop(context); // Close signup_screen
                                  Navigator.push(
                                      // Open HomeScreen
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomeScreen()));
                                },
                                child: Text("Ok"),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ));
            },
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
      print('sent');

      //await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e) {
      print(e);
      toggleSignupButton(true);
    }

    //toggleSignupButton(true);
    print("signup");
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
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Signup icon",
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: SizeConfig.screenHeight * 0.1),
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
                                top: SizeConfig.screenHeight * 0.08),
                            child: Text("Vous avez déjà un compte?"),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: SizeConfig.screenHeight * 0.007),
                            child: GestureDetector(
                              onTap: () {
                                // Redirect login_screen
                                print("redirect login");
                                //Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()));
                              },
                              child: Text(
                                "Connectez-vous",
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
              child: signupDisabled ? LoadingScreen() : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
