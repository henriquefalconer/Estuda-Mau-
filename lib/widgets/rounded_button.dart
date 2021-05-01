import 'package:estuda_maua/utilities/constants.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({
    this.buttonText,
    @required this.onTap,
    this.roundedButtonHeight = kRoundedButtonHeight,
    this.backgroundColor = kRoundedButtonBackgroundColor,
    this.textColor = kRoundedButtonTextColor,
    this.maxLines = kRoundedButtonMaxTextLines,
    this.minimumWidth = 200.0,
    this.enabled = true,
    this.disabledOpacity = 0.7,
    this.icon,
  });

  final String buttonText;
  final Function onTap;
  final double roundedButtonHeight;
  final Color backgroundColor;
  final Color textColor;
  final int maxLines;
  final double minimumWidth;
  final bool enabled;
  final double disabledOpacity;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1.0 : disabledOpacity,
      child: Material(
        color: backgroundColor ?? kRoundedButtonBackgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        elevation: 5.0,
        child: MaterialButton(
          onPressed: enabled ? onTap : null,
          minWidth: minimumWidth,
          height: roundedButtonHeight,
          child: icon == null
              ? Text(
                  buttonText,
                  style: TextStyle(color: textColor),
                  overflow: TextOverflow.ellipsis,
                  maxLines: maxLines,
                )
              : Icon(
                  icon,
                  color: Colors.white,
                ),
        ),
      ),
    );
  }
}
