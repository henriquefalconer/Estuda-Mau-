import 'package:estuda_maua/utilities/general_functions_brain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PesoSelector extends StatefulWidget {
  PesoSelector({
    @required this.nomes,
    @required this.pesoEditingControllers,
    @required this.isStringParsableMap,
    this.onChangePeso,
    this.textOnTop = false,
  });

  final List<String> nomes;
  final Map<String, TextEditingController> pesoEditingControllers;
  final Map<String, bool> isStringParsableMap;
  final Function(double, String) onChangePeso;
  final bool textOnTop;

  @override
  _PesoSelectorState createState() => _PesoSelectorState();
}

class _PesoSelectorState extends State<PesoSelector> {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        List<Widget> list = [];

        List<Widget> listLine = [];

        for (String avaliacao in widget.nomes ?? []) {
          listLine.add(Padding(
            padding: EdgeInsets.symmetric(
                vertical: 8.0, horizontal: widget.textOnTop ? 20.0 : 8.0),
            child: Column(
              children: <Widget>[
                Visibility(
                  visible: widget.textOnTop,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      avaliacao,
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: widget.textOnTop
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.end,
                  children: <Widget>[
                    Visibility(
                      visible: !widget.textOnTop,
                      child: Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: Text(
                          avaliacao,
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 72.0,
                      child: TextField(
                        autocorrect: false,
                        controller: widget.pesoEditingControllers[avaliacao],
                        keyboardType: TextInputType.numberWithOptions(),
                        scrollPadding: EdgeInsets.all(0.0),
                        onChanged: (text) {
                          String novoCaractere =
                              text.replaceAll('0', '').replaceAll(',', '');

                          if (widget.pesoEditingControllers[avaliacao].selection
                                      .start <
                                  5 &&
                              text.replaceAll(novoCaractere, '') == '0,00') {
                            text = '0,0' + novoCaractere;
                          }

                          String finalText =
                              GeneralFunctionsBrain.formatTextFieldTextFromText(
                                  text);

                          double peso;
                          try {
                            peso = double.parse(finalText.replaceAll(',', '.'));
                            widget.isStringParsableMap[avaliacao] = true;
                            widget.onChangePeso(peso, avaliacao);
                          } catch (e) {
                            widget.isStringParsableMap[avaliacao] = false;
                          }

                          widget.pesoEditingControllers[avaliacao].value =
                              widget.pesoEditingControllers[avaliacao].value
                                  .copyWith(
                            text: finalText,
                            selection: TextSelection.collapsed(
                              offset: finalText.length,
                            ),
                          );

                          setState(() {});
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: (widget.isStringParsableMap[avaliacao] ??
                                        true)
                                    ? ((widget.pesoEditingControllers[
                                                        avaliacao] ??
                                                    TextEditingController(
                                                        text: '0,00'))
                                                .text ==
                                            '0,00'
                                        ? Colors.grey
                                        : Colors.green[600])
                                    : Colors.red[700],
                                width: 1.5),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: (widget.isStringParsableMap[avaliacao] ??
                                        true)
                                    ? ((widget.pesoEditingControllers[
                                                        avaliacao] ??
                                                    TextEditingController(
                                                        text: '0,00'))
                                                .text ==
                                            '0,00'
                                        ? Colors.grey[700]
                                        : Colors.green[600])
                                    : Colors.red[700],
                                width: 2.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                          ),
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ));

          int quantidadeDeColunas = 2;

          if ((widget.nomes.indexOf(avaliacao) + 1) %
                  (widget.nomes.length / quantidadeDeColunas).round() ==
              0) {
            list.add(
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: listLine,
              ),
            );
            listLine = [];
          }
        }
        list.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: listLine,
          ),
        );
        listLine = [];

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: list,
        );
      },
    );
  }
}
