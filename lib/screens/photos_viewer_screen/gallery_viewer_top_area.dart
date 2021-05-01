import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MediaViewerTopArea extends StatelessWidget {
  MediaViewerTopArea({
    this.sender,
    this.time,
  });

  final String sender;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.grey[100],
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: IconButton(
                    padding: EdgeInsets.all(0.0),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      size: 30.0,
                      color: Colors.grey[700],
                    )),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        sender ?? 'Carregando...',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 2.0,
                      ),
                      Text(
                        time ?? '',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 5.0),
                child: IconButton(
                  padding: EdgeInsets.all(0.0),
                  onPressed: () {},
                  icon: Icon(
                    Icons.more_vert,
                    size: 28.0,
                    color: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 1,
          thickness: 1,
        ),
      ],
    );
  }
}
