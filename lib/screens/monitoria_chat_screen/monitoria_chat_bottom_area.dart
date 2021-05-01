import 'package:estuda_maua/utilities/monitoria_brain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MonitoriaChatBottomArea extends StatefulWidget {
  @override
  _MonitoriaChatBottomAreaState createState() =>
      _MonitoriaChatBottomAreaState();
}

class _MonitoriaChatBottomAreaState extends State<MonitoriaChatBottomArea> {
  TextEditingController _messageTextController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  String messageText;

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final monitoriaBrain = Provider.of<MonitoriaBrain>(context);

    return Column(
      children: <Widget>[
        Divider(
          height: 1,
          thickness: 1,
        ),
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 4.0, bottom: 4.0, left: 5.0),
                  child: TextField(
                    focusNode: _focusNode,
                    controller: _messageTextController,
                    onChanged: (value) {
                      setState(() {
                        messageText = value;
                      });
                    },
                    minLines: 1,
                    maxLines: 4,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10.0),
                      hintText: 'Escreva sua mensagem...',
                      border: InputBorder.none,
                      hasFloatingPlaceholder: false,
                    ),
                  ),
                ),
              ),
              (messageText != null && (messageText ?? '').trim() != '')
                  ? FlatButton(
                      child: Text(
                        'Enviar',
                        style: TextStyle(
                          color: Colors.blue[600],
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      onPressed: () {
                        if (messageText != null &&
                            (messageText ?? '').trim() != '') {
                          messageText = (messageText ?? '').trim();

                          if (messageText == '') {
                            messageText = null;
                          }

                          _messageTextController.clear();

                          monitoriaBrain.sendMessage(
                            text: messageText,
                            images: null,
                          );
                          messageText = null;
                          setState(() {});
                        }
                      },
                    )
                  : IconButton(
                      icon: Icon(
                        _focusNode.hasFocus
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                        color: Colors.grey[700],
                        size: 27.0,
                      ),
                      onPressed: () {
                        if (_focusNode.hasFocus) {
                          _focusNode.unfocus();
                        } else {
                          _focusNode.requestFocus();
                        }
                        setState(() {});
                      },
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
