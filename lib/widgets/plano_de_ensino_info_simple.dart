import 'package:estuda_maua/screens/explicacao_plano_de_ensino_screen/explicacao_plano_de_ensino_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlanoDeEnsinoInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 15.0, top: 6.0),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.check_circle,
                color: Colors.green[700],
                size: 20.0,
              ),
              Text(
                ' Média 8,0 ou acima.',
                style: TextStyle(color: Colors.grey[700]),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 15.0, top: 6.0),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.check_circle,
                color: Colors.yellow[700],
                size: 20.0,
              ),
              Text(
                ' Média entre 6,0 e 8,0.',
                style: TextStyle(color: Colors.grey[700]),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 15.0, top: 6.0),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.remove_circle,
                color: Colors.red[600],
                size: 20.0,
              ),
              Text(
                ' Média abaixo de 6,0.',
                style: TextStyle(color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
