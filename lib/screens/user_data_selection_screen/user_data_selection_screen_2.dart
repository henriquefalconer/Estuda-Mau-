import 'package:estuda_maua/screens/explicacao_monitor_verificado/explicacao_monitor_verificado_screen.dart';
import 'package:estuda_maua/screens/user_data_selection_screen/user_data_selection_screen_3.dart';
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

class UserDataSelectionScreen2 extends StatefulWidget {
  static String id = 'monitoria_selection_screen_2';

  @override
  _UserDataSelectionScreen2State createState() =>
      _UserDataSelectionScreen2State();
}

class _UserDataSelectionScreen2State extends State<UserDataSelectionScreen2> {
//  List<String> monitoriasSelected = [null, null, null];

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
                            'E de quais disciplinas você gostaria de ser monitor?',
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
                        List<DropdownButton> listMonitoriaSelections = [];

                        print(Provider.of<UserDataSelectionBrain>(context)
                            .quantidadeMonitorias);

                        for (int index = 0;
                            index <
                                Provider.of<UserDataSelectionBrain>(context)
                                    .quantidadeMonitorias;
                            index++) {
                          List<DropdownMenuItem> listMonitorias = [];

                          List<String> monitoriaStrings = List.from(
                              Provider.of<UserDataSelectionBrain>(context)
                                  .materiasCursadasEmAnosAnteriores);

                          print('dfs: $monitoriaStrings');

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

                          for (String curso in monitoriaStrings) {
                            listMonitorias.add(
                              DropdownMenuItem(
                                value: curso,
                                child: Text(
                                  curso,
                                  style: TextStyle(color: Colors.grey[700]),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            );
                          }

                          print('aa: $listMonitorias');

                          listMonitoriaSelections.add(
                            DropdownButton(
                              isExpanded: true,
                              hint: Text(
                                'Selecione sua monitoria',
                                style: TextStyle(color: Colors.grey[700]),
                                overflow: TextOverflow.ellipsis,
                              ),
                              value: userDataSelectionBrain
                                  .monitoriasSelected[index].name,
                              items: listMonitorias,
                              onChanged: (monitoria) {
                                userDataSelectionBrain
                                    .monitoriasSelected[index].name = monitoria;
                                setState(() {});
                              },
                            ),
                          );
                        }

                        return Column(
                          children: listMonitoriaSelections,
                        );
                      },
                    ),
                    SizedBox(
                      height: 20.0,
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
                            context, UserDataSelectionScreen3.id);
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
