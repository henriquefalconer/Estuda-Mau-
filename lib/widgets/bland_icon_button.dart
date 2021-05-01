import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlandIconButton extends StatelessWidget {
  const BlandIconButton({
    this.onPressed,
    this.text,
    this.icon,
  });

  final Function onPressed;
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.all(0.0),
      onPressed: onPressed,
      child: Column(
        children: <Widget>[
          Divider(
            height: 1,
            thickness: 1,
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    icon == null
                        ? SizedBox()
                        : Padding(
                            padding: EdgeInsets.only(right: 4.0),
                            child: Icon(icon, size: 25.0),
                          ),
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Icon(Icons.arrow_forward),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
