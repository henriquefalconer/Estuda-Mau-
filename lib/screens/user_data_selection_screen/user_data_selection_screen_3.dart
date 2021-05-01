import 'package:estuda_maua/screens/explicacao_monitor_verificado/explicacao_monitor_verificado_screen.dart';
import 'package:estuda_maua/screens/user_data_selection_screen/user_data_selection_screen_4.dart';
import 'package:estuda_maua/screens/user_data_selection_screen/user_data_selection_screen_6.dart';
import 'package:estuda_maua/utilities/constants.dart';
import 'package:estuda_maua/utilities/general_functions_brain.dart';
import 'package:estuda_maua/utilities/user_brain.dart';
import 'package:estuda_maua/utilities/user_data_selection_brain.dart';
import 'package:estuda_maua/widgets/monitor_type_icon.dart';
import 'package:estuda_maua/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class UserDataSelectionScreen3 extends StatefulWidget {
  static String id = 'monitoria_selection_screen_3';

  @override
  _UserDataSelectionScreen3State createState() =>
      _UserDataSelectionScreen3State();
}

class _UserDataSelectionScreen3State extends State<UserDataSelectionScreen3> {
  int numberOfMonitorias = 1;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    UserBrain userBrain = Provider.of<UserBrain>(context);
    UserDataSelectionBrain userDataSelectionBrain =
        Provider.of<UserDataSelectionBrain>(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Icon(
                    Icons.arrow_back,
                    size: 30.0,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 25.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Você é um monitor oficial da Mauá de alguma dessas disciplinas?',
                            style: TextStyle(
                              fontSize: 25.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(context,
                                    ExplicacaoMonitorVerificadoScreen.id);
                              },
                              child: Text(
                                'Mais informações',
                                style: TextStyle(
                                  fontSize: 17.0,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Builder(
                      builder: (context) {
                        List<Widget> listMonitoriaSelections = [];

                        for (int index = 0;
                            index <
                                Provider.of<UserDataSelectionBrain>(context)
                                    .quantidadeMonitorias;
                            index++) {
                          List<DropdownMenuItem> listTiposMonitoria = [];

                          List<String> monitoriaStrings =
                              List.of(userBrain.userPlanoDeEnsinoMauaNet.keys);

                          for (int indexTEMP = 0;
                              indexTEMP <
                                  Provider.of<UserDataSelectionBrain>(context)
                                      .quantidadeMonitorias;
                              indexTEMP++) {
                            try {
                              if (indexTEMP != index) {
                                monitoriaStrings.remove(userDataSelectionBrain
                                    .monitoriasSelected[indexTEMP].name);
                              }
                            } catch (e) {
                              print(e);
                            }
                          }

                          for (MonitorType monitorType in [
                            MonitorType.aguardandoOficializacao,
                            MonitorType.extraOficial
                          ]) {
                            listTiposMonitoria.add(
                              DropdownMenuItem(
                                value: monitorType,
                                child: Text(
                                  {
                                    MonitorType.aguardandoOficializacao: 'Sim',
                                    MonitorType.extraOficial: 'Não',
                                  }[monitorType],
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              ),
                            );
                          }

                          listMonitoriaSelections.add(
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      userDataSelectionBrain
                                          .monitoriasSelected[index].name,
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Container(
                                    width: 65.0,
                                    child: DropdownButton(
                                      isExpanded: true,
                                      hint: Text(
                                        '---',
                                        style:
                                            TextStyle(color: Colors.grey[700]),
                                      ),
                                      value: userDataSelectionBrain
                                          .monitoriasSelected[index].type,
                                      items: listTiposMonitoria,
                                      onChanged: (tipo) {
                                        userDataSelectionBrain
                                            .monitoriasSelected[index]
                                            .type = tipo;
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return Column(
                          children: listMonitoriaSelections,
                        );
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 20.0, top: 15.0),
                      child: Text(
                        'Obs.: Ao marcar que você é um monitor oficial, até um professor coordenador reconhecê-lo, '
                        'você apenas será classificado como aguardando oficialização.',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    RoundedButton(
                      buttonText: 'Confirmar monitoria' +
                          (Provider.of<UserDataSelectionBrain>(context)
                                      .quantidadeMonitorias >
                                  1
                              ? 's'
                              : ''),
                      enabled: userDataSelectionBrain.isSelectedMonitoriasReady,
                      onTap: () async {
                        Navigator.pushNamed(
                            context, UserDataSelectionScreen4.id);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
