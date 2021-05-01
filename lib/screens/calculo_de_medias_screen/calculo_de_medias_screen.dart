import 'package:estuda_maua/utilities/network_brain.dart';
import 'package:estuda_maua/utilities/user_brain.dart';
import 'package:provider/provider.dart';
import 'package:estuda_maua/utilities/medias_brain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'medias_page_content.dart';
import 'medias_top_area.dart';
import 'minimo_esforco_controls.dart';
import 'package:estuda_maua/utilities/constants.dart';

class CalculoDeMediasScreen extends StatefulWidget {
  static String id = 'calculo_de_medias_screen';

  @override
  _CalculoDeMediasScreenState createState() => _CalculoDeMediasScreenState();
}

class _CalculoDeMediasScreenState extends State<CalculoDeMediasScreen> {
  @override
  void initState() {
    super.initState();
    if (Provider.of<MediasBrain>(context, listen: false)
            .getIndefinidosNotasSlidersMap()[kTipoAvaliacao.semClassificacao]
            .length !=
        0) {
      Provider.of<NetworkBrain>(context, listen: false)
          .sendPlanoDeEnsinoDebugReport(
              Provider.of<MediasBrain>(context, listen: false)
                  .currentScreenCourse,
              Provider.of<UserBrain>(context, listen: false).getUserRA());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            MediasPageContent(),
            MediasTopArea(),
            Visibility(
              visible: Provider.of<MediasBrain>(context).modoMinimoEsforco,
              child: MinimoEsforcoControls(),
            )
          ],
        ),
      ),
    );
  }
}
