import 'package:estuda_maua/screens/explicacao_monitor_verificado/explicacao_monitor_verificado_screen.dart';
import 'package:estuda_maua/screens/user_data_selection_screen/user_data_selection_screen_2.dart';
import 'package:estuda_maua/screens/user_data_selection_screen/user_data_selection_screen_7.dart';
import 'package:estuda_maua/utilities/constants.dart';
import 'package:estuda_maua/utilities/monitoria_brain.dart';
import 'package:estuda_maua/utilities/user_brain.dart';
import 'package:estuda_maua/utilities/user_data_selection_brain.dart';
import 'package:estuda_maua/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class UserDataSelectionScreen1 extends StatefulWidget {
  static String id = 'monitoria_selection_screen_1';

  @override
  _UserDataSelectionScreen1State createState() =>
      _UserDataSelectionScreen1State();
}

class _UserDataSelectionScreen1State extends State<UserDataSelectionScreen1> {
  bool showSpinner = false;

  @override
  void initState() {
    super.initState();
    Provider.of<MonitoriaBrain>(context, listen: false).modoMonitor = false;
  }

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
                            '${userBrain.getUserMauaNetFirstName}, você gostaria de ser monitor(a) de quantas disciplinas?',
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
                        List<DropdownMenuItem> listMonitorias = [];

                        List<String> monitoriaStrings = [
                          'Não quero monitorias',
                          '1 monitoria',
                          '2 monitorias',
                          '3 monitorias'
                        ];

                        for (int index = 0;
                            index < monitoriaStrings.length;
                            index++) {
                          listMonitorias.add(
                            DropdownMenuItem(
                              value: index,
                              child: Text(
                                monitoriaStrings[index],
                                style: TextStyle(color: Colors.grey[700]),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        }

                        return DropdownButton(
                          isExpanded: true,
                          hint: Text(
                            'Selecione quantidade',
                            style: TextStyle(color: Colors.grey[700]),
                            overflow: TextOverflow.ellipsis,
                          ),
                          value: userDataSelectionBrain.quantidadeMonitorias,
                          items: listMonitorias,
                          onChanged: (quantidade) {
                            userDataSelectionBrain.quantidadeMonitorias =
                                quantidade;
                            setState(() {});
                          },
                        );
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                      width: double.infinity,
                    ),
                    RoundedButton(
                      buttonText: 'Confirmar quantidade',
                      enabled:
                          userDataSelectionBrain.quantidadeMonitorias != null,
                      onTap: () {
                        userDataSelectionBrain.monitoriasSelected = [];
                        for (int i = 1;
                            i <= userDataSelectionBrain.quantidadeMonitorias;
                            i++) {
                          userDataSelectionBrain.monitoriasSelected
                              .add(MonitoriaData());
                        }
                        print(userDataSelectionBrain.monitoriasSelected);

                        if (userDataSelectionBrain.quantidadeMonitorias == 0) {
                          Navigator.pushNamed(
                              context, UserDataSelectionScreen7.id);
                        } else {
                          Navigator.pushNamed(
                              context, UserDataSelectionScreen2.id);
                        }
                      },
                    )
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
