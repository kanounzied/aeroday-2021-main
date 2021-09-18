import 'package:aeroday_2021/config/responsive_size.dart';
import 'package:flutter/material.dart';

class CercleStep extends StatelessWidget {
  int nbStep;
  bool finished;

  CercleStep(int this.nbStep, bool this.finished);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.defaultSize * 5,
      width: SizeConfig.defaultSize * 5,
      child: Stack(children: [
        Container(
          decoration: BoxDecoration(
            color: finished ? Color(0xffd95252) : Color(0xCCAAAAAA),
            shape: BoxShape.circle,
          ),
        ),
        Center(
          child: Text(
            nbStep.toString(),
            style: TextStyle(
              fontSize: SizeConfig.defaultSize * 4,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ]),
    );
  }
}
