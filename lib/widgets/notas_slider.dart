import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotasSlider extends StatelessWidget {
  NotasSlider({
    @required this.width,
    @required this.onDragging,
    @required this.label,
    @required this.peso,
    @required this.nota,
    @required this.faltaText,
    this.substituicao,
    this.nomeSubstitutiva,
    this.substituicaoVisivel = true,
    this.descricaoVisivel = false,
    this.descricao = '',
    this.minimoEsforco = true,
    this.minimoEsforcoNotaMovel,
    this.onTapCheckBox,
    this.notaDiferenteMauaNet,
  });

  final double width;
  final Function onDragging;
  final String label;
  final String peso;
  final double nota;
  final String faltaText;
  final double substituicao;
  final String nomeSubstitutiva;
  final bool substituicaoVisivel;
  final bool descricaoVisivel;
  final String descricao;
  final bool minimoEsforco;
  final bool minimoEsforcoNotaMovel;
  final Function onTapCheckBox;
  final bool notaDiferenteMauaNet;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        minimoEsforco
            ? Checkbox(
                onChanged: onTapCheckBox,
                value: minimoEsforcoNotaMovel,
              )
            : SizedBox(
                width: 7.5,
              ),
        Container(
          width: 40.0,
          child: Column(
            children: <Widget>[
              AutoSizeText(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                textAlign: TextAlign.end,
              ),
              Visibility(
                visible: peso != null,
                child: AutoSizeText(
                  (peso ?? ''),
                  style: TextStyle(
                    fontSize: 1.0,
                    color: Colors.grey[400],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: descricaoVisivel
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 7.0, vertical: 15.0),
                  child: AutoSizeText(
                    descricao ?? 'Sem descrição.',
                    style: TextStyle(color: Colors.grey[100], fontSize: 16.0),
                  ),
                )
              : Row(
                  children: <Widget>[
                    Container(
                      width: 45.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          AutoSizeText(
                            substituicao != null && substituicaoVisivel
                                ? (substituicao == -0.5
                                    ? faltaText
                                    : substituicao
                                        .toString()
                                        .replaceAll('.', ','))
                                : (nota == -1.0
                                        ? ''
                                        : (nota == -0.5
                                            ? faltaText
                                            : nota
                                                .toString()
                                                .replaceAll('.', ','))) +
                                    ((notaDiferenteMauaNet ?? false)
                                        ? '*'
                                        : ''),
                            style: TextStyle(
                              color: substituicao == null ||
                                      substituicaoVisivel == false
                                  ? (nota >= 6.0
                                      ? (nota >= 9.0
                                          ? Colors.greenAccent[400]
                                          : Colors.white)
                                      : (nota == -1.0
                                          ? Colors.white
                                          : Colors.redAccent[200]))
                                  : (substituicao >= 6.0
                                      ? (substituicao >= 9.0
                                          ? Colors.greenAccent[400]
                                          : Colors.white)
                                      : (nota == -1.0
                                          ? Colors.white
                                          : Colors.redAccent[200])),
                              fontSize: 22.0,
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.end,
                          ),
                          Visibility(
                            visible: substituicao != null &&
                                substituicaoVisivel == true,
                            child: AutoSizeText(
                              '(${nomeSubstitutiva ?? 'SUB'})',
                              style: TextStyle(
                                  color: Colors.grey[400], fontSize: 10.0),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Slider(
                        value: nota,
                        min: -1.0,
                        max: 10.0,
                        divisions: 22,
                        onChanged: onDragging,
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
