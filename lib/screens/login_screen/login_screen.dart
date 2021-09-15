import 'package:aeroday_2021/screens/signup_screen/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import 'package:aeroday_2021/screens/home_screen/home.dart';

import '../../config/responsive_size.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

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

  void signupButtonCalled() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text + "@gmail.com",
        password: passController.text,
      );

      // if (!userCredential.user!.emailVerified) {
      //   userCredential.user!.sendEmailVerification();
      //   showDialog(
      //       context: context,
      //       builder: (BuildContext context) {
      //         return new AlertDialog(
      //             title: Text("Erreur de verification"),
      //             content: SizedBox(
      //               height: SizeConfig.screenHeight * 0.13,
      //               child: Column(
      //                 children: <Widget>[
      //                   Text(
      //                       "Verifier votre email pour la confirmation de votre inscription."),
      //                   Row(
      //                     mainAxisAlignment: MainAxisAlignment.end,
      //                     children: [
      //                       Container(
      //                         margin: EdgeInsets.only(
      //                             top: SizeConfig.screenHeight * 0.04),
      //                         child: ElevatedButton(
      //                           onPressed: () {
      //                             Navigator.pop(context);
      //                           },
      //                           child: Text("Ok"),
      //                         ),
      //                       )
      //                     ],
      //                   ),
      //                 ],
      //               ),
      //             ));
      //       });
      //   await FirebaseAuth.instance.signOut();
      // }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return new AlertDialog(
                  title: Text("Erreur d'inscription"),
                  content: SizedBox(
                    height: SizeConfig.screenHeight * 0.15,
                    child: Column(
                      children: <Widget>[
                        Text("Votre numéro du téléphone n'exist pas."),
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
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return new AlertDialog(
                  title: Text("Mot de passe invalid"),
                  content: SizedBox(
                    height: SizeConfig.screenHeight * 0.13,
                    child: Column(
                      children: <Widget>[
                        Text("Votre mot de passe est incorrect."),
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

        print('Wrong password provided for that user.');
      }
    }

    // Redirect to home/voting page HERE
    Navigator.pop(context); // Close signup_screen
    Navigator.push(
        // Open HomeScreen
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()));
    print("login");
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
        child: Container(
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
                            "Se connecter",
                            style: TextStyle(
                              fontSize: SizeConfig.defaultSize * 1.8,
                            ),
                          ),
                          onPressed: signupButtonCalled,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: SizeConfig.screenHeight * 0.05),
                        child: GestureDetector(
                          onTap: () {
                            // Password lost click
                            print("pass lost");
                          },
                          child: Text(
                            "Mot de passe oublier?",
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
                          onTap: () {
                            // Signup click
                            print("inscription");
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpScreen()));
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
      ),
    );
  }
}
