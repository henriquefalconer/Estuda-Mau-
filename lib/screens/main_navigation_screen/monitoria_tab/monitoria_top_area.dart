import 'package:auto_size_text/auto_size_text.dart';
import 'package:estuda_maua/utilities/constants.dart';
import 'package:estuda_maua/utilities/monitoria_brain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MonitoriaTopArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.bottomCenter,
      height: 140.0,
      decoration: BoxDecoration(
        color: kProfileBackgroundColor,
      ),
      child: Container(
        height: 50.0,
        child: GestureDetector(
          onLongPress: null,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: AutoSizeText(
                    'Modo monitor',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      wordSpacing: 1.0,
                    ),
                  ),
                ),
                Container(
                  width: 60.0,
                  child: Switch(
                    activeColor: Colors.blue[400],
                    inactiveThumbColor: Colors.grey[200],
                    inactiveTrackColor: Colors.grey,
                    value: Provider.of<MonitoriaBrain>(context).modoMonitor,
                    onChanged: (value) {
                      Provider.of<MonitoriaBrain>(context)
                          .modoMonitorChange(value);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
