import 'dart:io';

import 'package:aeroday_2021/screens/home_screen/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import '../login_screen/login_screen.dart';

import '../../config/responsive_size.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreen createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> {
  // TextEdit controllers to access the field's value
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final codeController = TextEditingController();

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

  // Signup button event
  void signupButtonCalled() async {
    bool check = await hasNetwork().whenComplete(
      () {
        print("ready");
      },
    );
    if (!check) {
      print("net");
      return;
    }

    if (!validateNumber(emailController.text)) {
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
          });
      print("num invalid");
      return;
    }
    List<String> l;
    print("hello");
    //try {
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
                                Navigator.pop(context);
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
      return;
    }
    // } on FirebaseAuthException catch (e) {
    //   if (e.code == 'network-request-failed') {
    //     print("network error");
    //     return;
    //   }
    //   print("error");
    //   return;
    // }
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
      return;
    }

    try {
      FirebaseAuth auth = FirebaseAuth.instance;

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+216 ' + emailController.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Delete phone number account
          await FirebaseAuth.instance.currentUser?.delete();

          // Login/Signup
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text + "@gmail.com",
            password: passController.text,
          );

          // Redirect to home
          Navigator.pop(context); // Close signup_screen
          Navigator.push(
              // Open HomeScreen
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()));
        },
        verificationFailed: (FirebaseAuthException e) {
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
          // Ask to write 6 digits code
          showDialog(
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
                                  // Create a PhoneAuthCredential with the code
                                  PhoneAuthCredential credential =
                                      PhoneAuthProvider.credential(
                                          verificationId: verificationId,
                                          smsCode: codeController.text);

                                  // Sign the user in to check for code validation
                                  try {
                                    await auth.signInWithCredential(credential);
                                  } on FirebaseAuthException catch (e) {
                                    if (e.code == "invalid-verification-code") {
                                      // TODO : invalid code handle
                                      print("Invalid code");
                                      return;
                                    }
                                  }

                                  // Delete phone number account
                                  await FirebaseAuth.instance.currentUser
                                      ?.delete();

                                  await FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                    email: emailController.text + "@gmail.com",
                                    password: passController.text,
                                  );

                                  // Redirect to login
                                  Navigator.pop(contextDia); // Close dialog

                                  Navigator.pop(context); // Close signup_screen
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

      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e) {
      print(e);
    }

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
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: SizeConfig.screenHeight * 0.005),
                child: new Image.asset('assets/logo.png',
                    width: SizeConfig.screenWidth * 0.52,
                    height: SizeConfig.screenHeight * 0.13),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: SizeConfig.screenHeight * 0.02),
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
                        margin:
                            EdgeInsets.only(top: SizeConfig.screenHeight * 0.1),
                        height: SizeConfig.screenHeight * 0.08,
                        width: SizeConfig.screenWidth * 0.75,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          controller: emailController,
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
                            minimumSize: MaterialStateProperty.all<Size>(Size(
                                SizeConfig.screenWidth * 0.38,
                                SizeConfig.screenHeight * 0.06)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xFFD95252)),
                          ),
                          child: Text(
                            "Signup",
                            style: TextStyle(
                              fontSize: SizeConfig.defaultSize * 1.8,
                            ),
                          ),
                          onPressed: signupButtonCalled,
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
                            Navigator.pop(context);
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
      ),
    );
  }
}
