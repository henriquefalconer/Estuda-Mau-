import 'package:estuda_maua/utilities/constants.dart';
import 'package:flutter/material.dart';

class ImagelessButton extends StatelessWidget {
  ImagelessButton({
    @required this.title,
    @required this.onTap,
    this.textColor = kImagelessTextColor,
    this.textSize = kImagelessTextSize,
    this.cardMargins,
    this.cardDecoration = kImagelessDecoration,
    this.cardColor,
  });

  final String title;
  final Function onTap;
  final Color textColor;
  final Color cardColor;
  final double textSize;
  final EdgeInsets cardMargins;
  final Decoration cardDecoration;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: cardColor,
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      child: MaterialButton(
        onPressed: onTap,
        child: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontSize: textSize,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
