import 'package:estuda_maua/screens/photos_viewer_screen/gallery_viewer_screen.dart';
import 'package:estuda_maua/utilities/monitoria_brain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageBubble extends StatefulWidget {
  MessageBubble({
    this.senderIsMe,
    this.messageText,
    this.messageImagePath,
    this.messageImageUploading,
    this.messageTime,
    this.messageRead,
  });

  final bool senderIsMe;
  final String messageText;
  final String messageImagePath;
  final bool messageImageUploading;
  final String messageTime;
  final bool messageRead;

  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  @override
  Widget build(BuildContext context) {
    final monitoriaBrain = Provider.of<MonitoriaBrain>(context);
    return Padding(
      padding: EdgeInsets.only(
          left: widget.senderIsMe ? 70.0 : 10.0,
          right: widget.senderIsMe ? 10.0 : 70.0),
      child: Column(
        crossAxisAlignment: widget.senderIsMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: <Widget>[
          Material(
            elevation: 5.0,
            color: widget.senderIsMe ? Colors.grey[700] : Colors.blue[700],
            borderRadius: BorderRadius.circular(20.0),
            child: Container(
              width: widget.messageImagePath != null ? 300.0 : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Imagem da mensagem:
                  widget.messageImagePath == null
                      ? SizedBox()
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(19.0),
                          child: MaterialButton(
                            padding: EdgeInsets.all(0.0),
                            onPressed: () {
                              monitoriaBrain.setupMediaViewerScreen(
                                  photoPath: widget.messageImagePath);
                              Navigator.pushNamed(
                                  context, PhotosViewerScreen.id);
                            },
                            child: Container(
                              height: 150.0,
                              width: 300.0,
                              padding: EdgeInsets.only(
                                  top: 3.0, left: 3.0, right: 3.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(19.0),
                                child: widget.messageImageUploading
                                    ? Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : monitoriaBrain.getImageMessageBubble(
                                        widget.messageImagePath),
                              ),
                            ),
                          ),
                        ),
                  // Texto da mensagem:
                  widget.messageText == null
                      ? SizedBox(height: 3.0)
                      : Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 15.0,
                          ),
                          child: Text(
                            widget.messageText ?? '',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 3.0),
            height: 28.0,
            child: Row(
              mainAxisAlignment: widget.senderIsMe
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.messageTime ?? '',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  width: 1.0,
                ),
                !widget.senderIsMe
                    ? SizedBox()
                    : Icon(
                        Icons.check,
                        color: widget.messageRead ? Colors.green : Colors.grey,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
