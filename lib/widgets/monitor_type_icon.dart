import 'package:estuda_maua/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MonitorTypeIcon extends StatelessWidget {
  const MonitorTypeIcon({
    Key key,
    @required this.size,
    @required this.type,
  }) : super(key: key);

  final double size;
  final MonitorType type;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: type != null,
      child: Container(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            CircleAvatar(
              maxRadius: 10 * size / 30.0 / 12.0 * 15.0,
              backgroundColor: Colors.white,
            ),
            {
              MonitorType.oficial: Icon(
                Icons.check_circle,
                color: Colors.blue[600],
                size: size,
              ),
              MonitorType.extraOficial: Icon(
                Icons.check_circle,
                color: Colors.red[600],
                size: size,
              ),
              MonitorType.aguardandoOficializacao: Icon(
                Icons.remove_circle,
                color: Colors.purple[600],
                size: size,
              ),
              null: SizedBox(),
            }[type],
          ],
        ),
      ),
    );
  }
}
