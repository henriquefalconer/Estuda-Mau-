import 'package:estuda_maua/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MediasScrollersColumn extends StatelessWidget {
  MediasScrollersColumn(this.mapAvaliacoes, this.type);

  final Map<kTipoAvaliacao, List<Widget>> mapAvaliacoes;
  final kTipoAvaliacao type;

  bool showDivider(kTipoAvaliacao type1, kTipoAvaliacao type2) {
    try {
      return ((mapAvaliacoes[type1].length ?? 0) != 0 &&
          (mapAvaliacoes[type2].length ?? 0) != 0);
    } catch (e) {
//      print(e);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<kTipoAvaliacao, List<Widget>> widgetStructure = {
      kTipoAvaliacao.provas:
          (mapAvaliacoes[kTipoAvaliacao.provas] ?? <Widget>[]) +
              <Widget>[
                Visibility(
                  visible: showDivider(
                      kTipoAvaliacao.provas, kTipoAvaliacao.substitutivas),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Divider(
                      thickness: 2,
                      color: Colors.blue[900],
                    ),
                  ),
                )
              ] +
              (mapAvaliacoes[kTipoAvaliacao.substitutivas] ?? <Widget>[]),
      kTipoAvaliacao.trabalhos:
          (mapAvaliacoes[kTipoAvaliacao.trabalhos] ?? <Widget>[]),
      kTipoAvaliacao.semClassificacao:
          (mapAvaliacoes[kTipoAvaliacao.semClassificacao] ?? <Widget>[]),
    };

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: widgetStructure[type]),
    );
  }
}
