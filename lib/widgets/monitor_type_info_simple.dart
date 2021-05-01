import 'package:estuda_maua/screens/explicacao_monitor_verificado/explicacao_monitor_verificado_screen.dart';
import 'package:estuda_maua/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'monitor_type_icon.dart';

class MonitorTypeInfoSimple extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 6.0),
            child: Row(
              children: <Widget>[
                MonitorTypeIcon(
                  type: MonitorType.oficial,
                  size: 20.0,
                ),
                Text(
                  ' Monitor oficial da Mauá.',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 6.0),
            child: Row(
              children: <Widget>[
                MonitorTypeIcon(
                  type: MonitorType.aguardandoOficializacao,
                  size: 20.0,
                ),
                Text(
                  ' Monitor aguardando oficialização.',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 6.0),
            child: Row(
              children: <Widget>[
                MonitorTypeIcon(
                  type: MonitorType.extraOficial,
                  size: 20.0,
                ),
                Text(
                  ' Monitor extra-oficial do Estuda Mauá.',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                    context, ExplicacaoMonitorVerificadoScreen.id);
              },
              child: Text(
                'Mais informações',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
        ],
      ),
    );
  }
}
