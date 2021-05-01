import 'package:estuda_maua/utilities/constants.dart';
import 'package:flutter/material.dart';

class SelectionButton extends StatelessWidget {
  SelectionButton({
    @required this.buttonText,
    @required this.onTap,
    this.roundedButtonHeight = kRoundedButtonHeight,
    this.activeTextColor = const Color(0xFF616161),
    this.inactiveTextColor = const Color(0xFFFFFFFF),
    this.maxLines,
    this.activeBackgroundColor = const Color(0xFFFAFAFA),
    this.inactiveBackgroundColor = const Color(0xFFFF5252),
    this.minimumWidth = 0.0,
    this.value,
    this.groupValue,
  });
  final String buttonText;
  final Function onTap;
  final double roundedButtonHeight;
  final Color inactiveBackgroundColor;
  final Color activeBackgroundColor;
  final Color activeTextColor;
  final Color inactiveTextColor;
  final int maxLines;
  final double minimumWidth;
  final dynamic groupValue;
  final dynamic value;

  @override
  Widget build(BuildContext context) {
    return Material(
      color:
          value == groupValue ? activeBackgroundColor : inactiveBackgroundColor,
      borderRadius: BorderRadius.all(Radius.circular(30.0)),
      elevation: 5.0,
      child: MaterialButton(
        onPressed: onTap,
        minWidth: minimumWidth,
        height: roundedButtonHeight,
        child: Text(
          buttonText,
          style: TextStyle(
            color: value == groupValue ? activeTextColor : inactiveTextColor,
            fontWeight: FontWeight.w600,
            fontSize: 15.0,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: maxLines,
        ),
      ),
    );
  }
}
