import 'package:aeroday2021/config/responsive_size.dart';
import 'package:flutter/material.dart';

class CercleStep extends StatelessWidget {
  final int nbStep;
  final bool finished;

  CercleStep(this.nbStep, this.finished);

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
