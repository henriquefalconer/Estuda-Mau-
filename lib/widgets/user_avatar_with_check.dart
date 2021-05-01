import 'package:estuda_maua/utilities/constants.dart';
import 'package:estuda_maua/utilities/monitoria_brain.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'monitor_type_icon.dart';

class UserAvatarWithMonitorType extends StatelessWidget {
  const UserAvatarWithMonitorType({
    Key key,
    @required this.fotoSize,
    @required this.foto,
    this.monitorType,
    @required this.photoTag,
  }) : super(key: key);

  final double fotoSize;
  final ImageProvider foto;
  final MonitorType monitorType;
  final String photoTag;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: <Widget>[
        Hero(
          tag: photoTag ??
              Provider.of<MonitoriaBrain>(context).getTagNumberInsteadOfNull,
          child: CircleAvatar(
            backgroundColor: Colors.grey[100],
            radius: fotoSize,
            backgroundImage: foto ?? AssetImage('images/null_user_photo.png'),
          ),
        ),
        MonitorTypeIcon(
          size: 12.0 * fotoSize / 15.0,
          type: monitorType,
        ),
      ],
    );
  }
}
