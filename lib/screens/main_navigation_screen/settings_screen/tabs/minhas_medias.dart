import 'package:estuda_maua/utilities/medias_brain.dart';
import 'package:estuda_maua/utilities/network_brain.dart';
import 'package:estuda_maua/widgets/bland_top_area.dart';
import 'package:estuda_maua/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MinhasMediasSettings extends StatelessWidget {
  static String id = 'minhas_medias_settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: <Widget>[
            BlandTopArea(
              title: 'Minhas Médias',
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Modo debug:',
                          style: TextStyle(
                              fontSize: 17.0, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Material(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          elevation: 5.0,
                          color: Colors.grey,
                          child: MaterialButton(
                            minWidth: double.infinity,
                            onPressed: () async {
                              await Provider.of<MediasBrain>(context)
                                  .setupDisciplinasProvisorias();
                              Provider.of<NetworkBrain>(context)
                                  .notasDownloadError = false;
                            },
                            child: Text(
                              'Inserir notas provisórias',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
