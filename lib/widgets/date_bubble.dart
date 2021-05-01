import 'package:estuda_maua/utilities/general_functions_brain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DateBubble extends StatelessWidget {
  DateBubble({
    @required this.nextMessagesTime,
  });

  final String nextMessagesTime;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(bottom: 15.0),
        child: Opacity(
          opacity: 0.8,
          child: Material(
            elevation: 5.0,
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(30.0),
            child: Container(
              width: 150.0,
              padding: EdgeInsets.symmetric(
                vertical: 4.0,
                horizontal: 8.0,
              ),
              child: Text(
                GeneralFunctionsBrain.getFormattedTime(
                  fromIso8601String: nextMessagesTime,
                  forceDayOfTheWeekOrFullDate: true,
                ),
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
