import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../login_screen/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreen createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> {
  // TextEdit controllers to access the field's value
  final emailController = TextEditingController();
  final passController = TextEditingController();

  // Signup button event
  void signupButtonCalled() async {
    try {
      // Try to sign up
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passController.text,
      );
      // Send email verification
      userCredential.user.sendEmailVerification();

      // Logout inorder to wait for email confirmation
      await FirebaseAuth.instance.signOut();

      // Ask to check email & redirect to login_screen
      showDialog(
          context: context,
          builder: (BuildContext contextDia) {
            return new AlertDialog(
                title: Text("Inscription"),
                content: SizedBox(
                  height: 120,
                  child: Column(
                    children: <Widget>[
                      Text(
                          "Verifier votre email pour la confirmation de votre inscription."),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 30),
                            child: ElevatedButton(
                              onPressed: () {
                                // Redirect to login
                                Navigator.pop(contextDia); // Close dialog
                                Navigator.pop(context); // Close signup_screen

                                Navigator.push(
                                    // Open login_screen
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()));
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
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return new AlertDialog(
                  title: Text("Erreur d'inscription"),
                  content: SizedBox(
                    height: 120,
                    child: Column(
                      children: <Widget>[
                        Text("Votre mot de passe est faible."),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 30),
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
      } else if (e.code == 'email-already-in-use') {
        // Redirect to login_screen
        showDialog(
            context: context,
            builder: (BuildContext contextDia) {
              return new AlertDialog(
                  title: Text("Erreur d'inscription"),
                  content: SizedBox(
                    height: 120,
                    child: Column(
                      children: <Widget>[
                        Text("Email est deja utilisé."),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 30),
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
                              margin: EdgeInsets.only(top: 30),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
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
        print('The account already exists for that email.');
      }
    } catch (e) {
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
                margin: EdgeInsets.only(top: 5),
                child: new Image.asset('assets/logo.png',
                    width: 200.0, height: 100.0),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 20),
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
                        margin: EdgeInsets.only(top: 80),
                        height: 60,
                        width: 300,
                        child: TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            labelText: 'Votre address email',
                            contentPadding: new EdgeInsets.symmetric(
                                vertical: 25.0, horizontal: 10.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0)),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 15),
                        height: 60,
                        width: 300,
                        child: TextFormField(
                          controller: passController,
                          obscureText: true,
                          autocorrect: false,
                          enableSuggestions: false,
                          decoration: InputDecoration(
                            hintText: 'Mot de passe',
                            labelText: 'Votre mot de passe',
                            contentPadding: new EdgeInsets.symmetric(
                                vertical: 25.0, horizontal: 10.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0)),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 40),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            fixedSize:
                                MaterialStateProperty.all<Size>(Size(150, 40)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xFFD95252)),
                          ),
                          child: const Text(
                            "Signup",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          onPressed: signupButtonCalled,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 50),
                        child: new Image.asset('assets/drone_image.png',
                            width: 200.0, height: 100.0),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 60),
                        child: Text("Vous avez déjà un compte?"),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
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
