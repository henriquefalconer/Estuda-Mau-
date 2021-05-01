import 'package:estuda_maua/screens/calculo_de_medias_screen/calculo_de_medias_screen.dart';
import 'package:estuda_maua/utilities/constants.dart';
import 'package:estuda_maua/utilities/medias_brain.dart';
import 'package:estuda_maua/utilities/network_brain.dart';
import 'package:estuda_maua/utilities/plano_de_ensino_brain.dart';
import 'package:estuda_maua/widgets/peso_selector.dart';
import 'package:estuda_maua/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class Editor extends StatefulWidget {
  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  @override
  Widget build(BuildContext context) {
    PlanoDeEnsinoBrain planoDeEnsinoBrain =
        Provider.of<PlanoDeEnsinoBrain>(context);

    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(30.0),
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(bottom: 15.0),
                child: Text(
                  '1. Quantos trabalhos existem nesta disciplina?',
                  style: TextStyle(
                    fontSize: 25.0,
                  ),
                ),
              ),
              Builder(
                builder: (context) {
                  List<DropdownMenuItem> listTrabalhos = [];

                  List<String> trabalhosStrings = [
                    'Não possui trabalhos',
                    '1 trabalho',
                  ];

                  for (int i = 2; i <= 16; i++) {
                    trabalhosStrings.add('$i trabalhos');
                  }

                  for (int index = 0;
                      index < trabalhosStrings.length;
                      index++) {
                    listTrabalhos.add(
                      DropdownMenuItem(
                        value: index,
                        child: Text(
                          trabalhosStrings[index],
                          style: TextStyle(color: Colors.grey[700]),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  }

                  return Material(
                    elevation: 2.0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: DropdownButton(
                        isExpanded: true,
                        style:
                            TextStyle(color: Colors.grey[700], fontSize: 16.5),
                        underline: Container(),
                        hint: Text(
                          'Selecione quantidade',
                          style: TextStyle(color: Colors.grey[700]),
                          overflow: TextOverflow.ellipsis,
                        ),
                        value: planoDeEnsinoBrain.quantidadeTrabalhos[
                            planoDeEnsinoBrain.selectedCourse],
                        items: listTrabalhos,
                        onChanged: (quantidade) {
                          planoDeEnsinoBrain
                              .onChangeTrabalhosDropdownButton(quantidade);
                        },
                      ),
                    ),
                  );
                },
              ),
              (planoDeEnsinoBrain.quantidadeTrabalhos ?? 0) != 0
                  ? Column(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: Text(
                            '1.1 Preencha os pesos individuais dos trabalhos:',
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        PesoSelector(
                          nomes: planoDeEnsinoBrain.getListaTrabalhos,
                          pesoEditingControllers: planoDeEnsinoBrain
                                      .pesoAvaliacoesTextEditingControllers[
                                  planoDeEnsinoBrain.selectedCourse]
                              [kTipoAvaliacao.trabalhos],
                          isStringParsableMap: planoDeEnsinoBrain
                                  .isParsable[planoDeEnsinoBrain.selectedCourse]
                              [EditorType.trabalhos],
                          onChangePeso: (peso, avaliacao) {
                            planoDeEnsinoBrain
                                    .disciplinaDatas[
                                        planoDeEnsinoBrain.selectedCourse]
                                    .avaliacoes[kTipoAvaliacao.trabalhos]
                                [avaliacao] = AvaliacaoData(
                              peso: peso,
                              substituiAvaliacoes: null,
                            );

                            if (planoDeEnsinoBrain
                                    .disciplinaDatas[
                                        planoDeEnsinoBrain.selectedCourse]
                                    .avaliacoes[kTipoAvaliacao.trabalhos]
                                        [avaliacao]
                                    .peso >=
                                10.0) {
                              planoDeEnsinoBrain.isParsable[
                                      planoDeEnsinoBrain.selectedCourse]
                                  [EditorType.trabalhos][avaliacao] = false;
                            } else {
                              planoDeEnsinoBrain.isParsable[
                                      planoDeEnsinoBrain.selectedCourse]
                                  [EditorType.trabalhos][avaliacao] = true;
                            }
                            setState(() {});
                          },
                        ),
                      ],
                    )
                  : SizedBox(),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Divider(
            color: Colors.grey[500],
            height: 1,
            thickness: 1.0,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(30.0),
          child: Column(
            children: <Widget>[
              Builder(
                builder: (context) {
                  List<DropdownMenuItem> listProvas = [];

                  List<String> provasStrings = [
                    'Não possui provas',
                    'P1, P2 e PS1',
                    'P1, P2, PS1, P3, P4 e PS2',
                  ];

                  for (int index = 0; index < provasStrings.length; index++) {
                    listProvas.add(
                      DropdownMenuItem(
                        value: [
                          QuantidadeDeProvas.zero,
                          QuantidadeDeProvas.umSemestre,
                          QuantidadeDeProvas.doisSemestres
                        ][index],
                        child: Text(
                          provasStrings[index],
                          style: TextStyle(color: Colors.grey[700]),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            child: Text(
                              '2. Esta disciplina possui quais provas?',
                              style: TextStyle(
                                fontSize: 25.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Material(
                        elevation: 2.0,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: DropdownButton(
                            isExpanded: true,
                            style: TextStyle(
                                color: Colors.grey[700], fontSize: 16.5),
                            underline: Container(),
                            hint: Text(
                              'Selecione provas',
                              style: TextStyle(color: Colors.grey[700]),
                              overflow: TextOverflow.ellipsis,
                            ),
                            value: planoDeEnsinoBrain.provasExistentes[
                                planoDeEnsinoBrain.selectedCourse],
                            items: listProvas,
                            onChanged: (provas) {
                              planoDeEnsinoBrain
                                  .onChangeProvasDropdownButton(provas);
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              (planoDeEnsinoBrain.provasExistentes != null &&
                      planoDeEnsinoBrain.provasExistentes[
                              planoDeEnsinoBrain.selectedCourse] !=
                          QuantidadeDeProvas.zero)
                  ? Column(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: Text(
                            '2.1 Preencha os pesos individuais das provas:',
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        PesoSelector(
                          nomes: planoDeEnsinoBrain.getListaProvas,
                          pesoEditingControllers: planoDeEnsinoBrain
                                      .pesoAvaliacoesTextEditingControllers[
                                  planoDeEnsinoBrain.selectedCourse]
                              [kTipoAvaliacao.provas],
                          isStringParsableMap: planoDeEnsinoBrain
                                  .isParsable[planoDeEnsinoBrain.selectedCourse]
                              [EditorType.provas],
                          onChangePeso: (peso, avaliacao) {
                            planoDeEnsinoBrain
                                    .disciplinaDatas[
                                        planoDeEnsinoBrain.selectedCourse]
                                    .avaliacoes[kTipoAvaliacao.provas]
                                [avaliacao] = AvaliacaoData(
                              peso: peso,
                              substituiAvaliacoes: null,
                            );

                            if (planoDeEnsinoBrain
                                    .disciplinaDatas[
                                        planoDeEnsinoBrain.selectedCourse]
                                    .avaliacoes[kTipoAvaliacao.provas]
                                        [avaliacao]
                                    .peso >=
                                10.0) {
                              planoDeEnsinoBrain.isParsable[
                                      planoDeEnsinoBrain.selectedCourse]
                                  [EditorType.provas][avaliacao] = false;
                            } else {
                              planoDeEnsinoBrain.isParsable[
                                      planoDeEnsinoBrain.selectedCourse]
                                  [EditorType.provas][avaliacao] = true;
                            }
                            setState(() {});
                          },
                        ),
                      ],
                    )
                  : SizedBox(),
            ],
          ),
        ),
        Visibility(
          visible: planoDeEnsinoBrain.shouldEscolhaPesosGeraisAparecer,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Divider(
              color: Colors.grey[500],
              height: 1,
              thickness: 1.0,
            ),
          ),
        ),
        Visibility(
          visible: planoDeEnsinoBrain.shouldEscolhaPesosGeraisAparecer,
          child: Padding(
            padding: EdgeInsets.all(30.0),
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    '3. Qual é o peso de prova e trabalho da disciplina?',
                    style: TextStyle(
                      fontSize: 25.0,
                    ),
                  ),
                ),
                PesoSelector(
                  nomes: ['Trabalho', 'Prova'],
                  pesoEditingControllers:
                      planoDeEnsinoBrain.pesosGeraisTextEditingControllers[
                          planoDeEnsinoBrain.selectedCourse],
                  isStringParsableMap: planoDeEnsinoBrain
                          .isParsable[planoDeEnsinoBrain.selectedCourse]
                      [EditorType.pesosGerais],
                  onChangePeso: (peso, tipo) {
                    planoDeEnsinoBrain
                            .disciplinaDatas[planoDeEnsinoBrain.selectedCourse]
                            .pesosGerais[
                        planoDeEnsinoBrain
                            .getTipoAvaliacaoFromString(tipo)] = peso;
                    if (planoDeEnsinoBrain
                            .disciplinaDatas[planoDeEnsinoBrain.selectedCourse]
                            .pesosGerais[{
                          'Trabalho': kTipoAvaliacao.trabalhos,
                          'Prova': kTipoAvaliacao.provas
                        }[tipo]] >=
                        10.0) {
                      planoDeEnsinoBrain
                              .isParsable[planoDeEnsinoBrain.selectedCourse]
                          [EditorType.pesosGerais][tipo] = false;
                    } else {
                      planoDeEnsinoBrain
                              .isParsable[planoDeEnsinoBrain.selectedCourse]
                          [EditorType.pesosGerais][tipo] = true;
                    }
                    setState(() {});
                  },
                  textOnTop: true,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Divider(
            color: Colors.grey[500],
            height: 1,
            thickness: 1.0,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(30.0),
          child: Text(
            'Obs.: Todos os pesos precisam ser menores ou iguais a 10,0.',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 30.0, right: 80.0, left: 80.0),
          child: RoundedButton(
            backgroundColor: planoDeEnsinoBrain.isDisciplinaReady
                ? Color(0xFF0D47A1)
                : Color(0xAA0D47A1),
            buttonText: 'Confirmar plano de ensino',
            onTap: planoDeEnsinoBrain.isDisciplinaReady
                ? () async {
                    showCupertinoModalPopup(
                        context: context,
                        builder: (context) {
                          return CupertinoActionSheet(
                            message: Text(
                              planoDeEnsinoBrain.getConfirmText,
                              style: TextStyle(fontSize: 14.0),
                            ),
                            cancelButton: CupertinoActionSheetAction(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Cancelar',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            actions: <Widget>[
                              CupertinoActionSheetAction(
                                child: Text(
                                  'Tenho certeza',
                                  style: TextStyle(),
                                ),
                                onPressed: () async {
                                  planoDeEnsinoBrain.onTapConfirmButton(
                                    Provider.of<MediasBrain>(context)
                                        .avaliacoesSemClassificacao(),
                                  );

                                  try {
                                    await Provider.of<MediasBrain>(context)
                                        .setupDisciplinaDatas(
                                            Provider.of<NetworkBrain>(context)
                                                .lastDownloadedInfoMauaNet
                                                .planoDeEnsino);
                                    setState(() {});
                                  } catch (e) {
                                    print(e);
                                  }

                                  Navigator.popUntil(
                                      context,
                                      ModalRoute.withName(
                                          CalculoDeMediasScreen.id));
                                },
                              ),
                            ],
                          );
                        });

                    setState(() {});
                  }
                : null,
          ),
        ),
      ],
    );
  }
}
