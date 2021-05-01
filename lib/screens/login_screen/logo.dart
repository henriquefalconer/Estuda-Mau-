import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EstudaMauaLogo extends StatelessWidget {
  EstudaMauaLogo({
    @required this.computerSize,
    @required this.phoneSize,
    @required this.textSize,
    this.logoColor,
  });

  final double computerSize;
  final double phoneSize;
  final Color logoColor;
  final double textSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            Container(
              height: phoneSize,
              child: Image.asset('images/estuda_maua_phone.png'),
            ),
            Container(
              height: computerSize,
              width: computerSize,
              child: Image.asset('images/estuda_maua_computer.png'),
            ),
          ],
        ),
        Container(
          height: textSize,
          width: textSize,
          child: Image.asset('images/estuda_maua_text.png'),
        ),
      ],
    );
  }
}
