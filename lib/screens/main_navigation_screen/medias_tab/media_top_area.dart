import 'package:estuda_maua/utilities/constants.dart';
import 'package:estuda_maua/utilities/general_functions_brain.dart';
import 'package:estuda_maua/utilities/medias_brain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MediaTopArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MediasBrain mediasBrain = Provider.of<MediasBrain>(context);
    return Container(
      alignment: AlignmentDirectional.bottomCenter,
      height: 140.0,
      decoration: BoxDecoration(
        color: kProfileBackgroundColor,
      ),
      child: Container(
        height: 50.0,
        child: GestureDetector(
          onLongPress: () {
            mediasBrain.changeTipoMedia();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Média Geral ${mediasBrain.tipoDeMediaSelecionado == TiposDeCalculoMedia.final_ ? 'Final' : 'Parcial'}:',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      GeneralFunctionsBrain.formatMediaToText(
                          mediasBrain.calcularMediaGeral),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                      ),
                    ),
                    Text(
                      (mediasBrain.mediaGeralDiferenteDoMauaNet
//                          ||  mediasBrain.algumaMateriaNaoPossuiPlanoDeEnsino
                          ? '*'
                          : ''),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
