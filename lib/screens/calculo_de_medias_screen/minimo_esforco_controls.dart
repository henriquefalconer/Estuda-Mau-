import 'package:estuda_maua/utilities/medias_brain.dart';
import 'package:estuda_maua/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MinimoEsforcoControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow[700],
      height: 110.0,
      child: Column(
        children: <Widget>[
          Opacity(
            opacity: Provider.of<MediasBrain>(context)
                    .estadoDeNotasModificadoEmRelacaoAoUltimoAlgoritmoMinimoEsforco
                ? 0.5
                : 1.0,
            child: Slider(
              activeColor: Colors.orange[800],
              value: Provider.of<MediasBrain>(context)
                  .sliderMinimoEsforcoValue
                  .toDouble(),
              min: 0,
              max: Provider.of<MediasBrain>(context)
                          .conjuntoDeNotasMinimoEsforco
                          .length
                          .toDouble() ==
                      0.0
                  ? 50
                  : (Provider.of<MediasBrain>(context)
                          .conjuntoDeNotasMinimoEsforco
                          .length
                          .toDouble() -
                      1.0),
              onChanged: Provider.of<MediasBrain>(context)
                      .estadoDeNotasModificadoEmRelacaoAoUltimoAlgoritmoMinimoEsforco
                  ? null
                  : (value) {
                      Provider.of<MediasBrain>(context)
                          .onChangeMinimoEsforcoSlider(value);
                    },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 8.0, left: 15.0, right: 15.0),
            child: Opacity(
              opacity: Provider.of<MediasBrain>(context)
                          .listaDeAvaliacoesASeremModificadas
                          .length ==
                      0
                  ? 0.5
                  : 1.0,
              child: RoundedButton(
                onTap: Provider.of<MediasBrain>(context)
                            .listaDeAvaliacoesASeremModificadas
                            .length ==
                        0
                    ? null
                    : () {
                        Provider.of<MediasBrain>(context)
                            .onPressRecalcularMinimoEsforcoButton();
                      },
                backgroundColor: Colors.orange[900],
                minimumWidth: double.infinity,
                buttonText: 'Recalcular mínimo esforço',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
