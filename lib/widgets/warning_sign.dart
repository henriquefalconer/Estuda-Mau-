import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:estuda_maua/widgets/selection_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;

class WarningSign extends StatelessWidget {
  WarningSign({
    this.text,
    this.backgroundColor = Colors.yellow,
    this.icon = Icons.warning,
    this.textColor = const Color(0xFF424242),
    this.iconColor = Colors.grey,
    this.showLink,
    this.linkOnTap,
    this.linkText,
  });

  final String text;
  final Color backgroundColor;
  final IconData icon;
  final Color iconColor;
  final Color textColor;
  final bool showLink;
  final Function linkOnTap;
  final String linkText;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0.0,
      borderRadius: BorderRadius.circular(30.0),
      color: backgroundColor,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 5.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: iconColor,
              size: 30.0,
            ),
            SizedBox(
              width: 15.0,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AutoSizeText(
                      text,
                      style: TextStyle(color: textColor, fontSize: 14.0),
                    ),
                    Visibility(
                      visible: showLink ?? false,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 10.0,
                          ),
                          InkWell(
                            onTap: linkOnTap,
                            child: Text(
                              linkText ?? 'Não mostrar novamente',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
