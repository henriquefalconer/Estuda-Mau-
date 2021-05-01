import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextBubble extends StatelessWidget {
  TextBubble({this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Opacity(
          opacity: 0.8,
          child: Material(
            elevation: 5.0,
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(30.0),
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 4.0,
                horizontal: 8.0,
              ),
              child: Text(
                text,
                style: TextStyle(
                    color: Colors.grey[900], fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
