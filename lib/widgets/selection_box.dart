import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectionBox extends StatelessWidget {
  SelectionBox({
    this.onTapButton,
    this.onTapCard,
    this.dica,
    this.valueButton1,
    this.valueButton2,
    this.title,
    this.labelButton1,
    this.labelButton2,
    this.groupValue,
  });

  final String title;
  final String dica;
  final String labelButton1;
  final String labelButton2;
  final Function onTapButton;
  final Function onTapCard;
  final valueButton1;
  final valueButton2;
  final groupValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 21.0,
            fontWeight: FontWeight.bold,
            wordSpacing: 1.0,
          ),
        ),
        SizedBox(
          height: 6.0,
        ),
        GestureDetector(
          onTap: onTapCard,
          child: Row(
            children: <Widget>[
              Radio(
                activeColor: Colors.blue,
                value: valueButton1,
                groupValue: groupValue,
                onChanged: onTapButton,
              ),
              Expanded(
                child: AutoSizeText(
                  labelButton1,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19.0,
                  ),
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onTapCard,
          child: Row(
            children: <Widget>[
              Radio(
                activeColor: Colors.blue,
                value: valueButton2,
                groupValue: groupValue,
                onChanged: onTapButton,
              ),
              Expanded(
                child: AutoSizeText(
                  labelButton2,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19.0,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 6.0,
        ),
        Text(
          dica ?? '',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 15.0,
          ),
        ),
      ],
    );
  }
}
