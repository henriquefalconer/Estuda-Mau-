import 'package:estuda_maua/utilities/general_functions_brain.dart';
import 'package:estuda_maua/utilities/monitoria_brain.dart';
import 'package:estuda_maua/utilities/user_brain.dart';
import 'package:estuda_maua/widgets/date_bubble.dart';
import 'package:estuda_maua/widgets/message_bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final monitoriaBrain = Provider.of<MonitoriaBrain>(context);

    return StreamBuilder(
      stream: monitoriaBrain.getMessagesStream(),
      builder: (context, snapshot) {
        List<Widget> messageWidgets = [];
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blue[800],
            ),
          );
        }
        var messages = snapshot.data.documents.reversed;

        var nextMessageTime = DateTime.now().toIso8601String();

        for (var message in messages) {
          final messageWidget = MessageBubble(
            messageText: message.data['message'],
            messageImagePath: message.data['photo'],
            messageImageUploading: message.data['photo_uploading'],
            senderIsMe: message.data['sender'] ==
                Provider.of<UserBrain>(context).getUserRA(),
            messageTime: GeneralFunctionsBrain.getFormattedTime(
                fromIso8601String: message.data['time'],
                forceHoursAndMinutes: true),
            messageRead: message.data['read'],
          );

          if ((messageWidgets.length != 0) &&
              (GeneralFunctionsBrain.getDayStartingHourFromString(
                      nextMessageTime)
                  .isAfter(DateTime.parse(message.data['time'])))) {
            messageWidgets.add(
              DateBubble(nextMessagesTime: nextMessageTime),
            );
          }

          nextMessageTime = message.data['time'];

          messageWidgets.add(messageWidget);
        }

        if (messageWidgets.length != 0) {
          messageWidgets.add(
            DateBubble(nextMessagesTime: nextMessageTime),
          );
        }

        return ListView(
          children: <Widget>[SizedBox(height: 1.0)] +
              messageWidgets +
              <Widget>[SizedBox(height: 10.0)],
          reverse: true,
        );
      },
    );
  }
}
