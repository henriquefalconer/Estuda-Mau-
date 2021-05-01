import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlandTopArea extends StatelessWidget {
  BlandTopArea({
    this.title,
    this.showDivider,
    this.rightIcon,
    this.onTapRightIcon,
    this.onReturn,
  });

  final IconData rightIcon;
  final Function onTapRightIcon;
  final String title;
  final bool showDivider;
  final Function onReturn;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Material(
          color: Colors.transparent,
          child: Stack(
            alignment: AlignmentDirectional.centerStart,
            children: <Widget>[
              Center(
                child: Container(
                  width: 250.0,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 19.0,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: IconButton(
                      padding: EdgeInsets.all(0.0),
                      onPressed: onReturn ??
                          () {
                            Navigator.pop(context);
                          },
                      icon: Icon(
                        Icons.arrow_back,
                        size: 30.0,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: IconButton(
                      padding: EdgeInsets.all(0.0),
                      onPressed: onTapRightIcon,
                      icon: Icon(
                        rightIcon,
                        size: 30.0,
                        color: onTapRightIcon != null
                            ? Colors.grey[700]
                            : Colors.transparent,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Visibility(
          visible: showDivider ?? true,
          child: Divider(
            height: 1,
            thickness: 1,
          ),
        ),
      ],
    );
  }
}
