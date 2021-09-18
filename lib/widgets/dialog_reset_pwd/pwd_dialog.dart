import 'package:aeroday_2021/config/responsive_size.dart';
import 'package:aeroday_2021/widgets/dialog_reset_pwd/cercle_step.dart';
import 'package:flutter/material.dart';

class PwdDialog extends StatefulWidget {
  @override
  _PwdDialogState createState() => _PwdDialogState();
}

class _PwdDialogState extends State<PwdDialog> {
  int nbStep = 1;
  String pwd1 = "";
  String pwd2 = "";
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

          nbStep == 1 ? Container(
            height: SizeConfig.screenHeight * 0.08,
            width: SizeConfig.screenWidth * 0.75,
            child: TextFormField(
              keyboardType: TextInputType.number,
              cursorColor: Color(0xffd95252),
              decoration: InputDecoration(
                hintText: "Verification code",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0)),
              ),
              onChanged: (value) {
                if (value.length == 6) {
                  //send to firebase
                }
              },
            ),
          )
              : (nbStep == 2 ?
          Column(
            children: [
              Container(
                height: SizeConfig.screenHeight * 0.08,
                width: SizeConfig.screenWidth * 0.75,
                child: TextFormField(
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  cursorColor: Color(0xffd95252),
                  decoration: InputDecoration(
                    hintText: "Enter password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0)),
                  ),
                  onChanged: (value) {
                    if (value.length == 6) {
                      //send to firebase
                    }
                  },
                ),
              ),
              SizedBox(height: SizeConfig.defaultSize,),
              Container(
                height: SizeConfig.screenHeight * 0.08,
                width: SizeConfig.screenWidth * 0.75,
                child: TextFormField(
                  obscureText: true,
                  cursorColor: Color(0xffd95252),
                  decoration: InputDecoration(
                    hintText: "Confirm password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0)),
                  ),
                  onChanged: (value) {
                    if (value.length == 6) {
                      //send to firebase
                    }
                  },
                ),
              )
            ],
          )
              : Container()
          ),

          SizedBox(height: SizeConfig.defaultSize,),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xffd95252),
              ),
              onPressed: () {
                if (nbStep < 3) {
                  if(pwd1 == pwd2 && !pwd1.isEmpty && nbStep == 2)
                    //Firebase pwd reset
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
