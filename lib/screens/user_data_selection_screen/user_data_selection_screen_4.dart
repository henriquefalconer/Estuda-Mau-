import 'package:estuda_maua/screens/user_data_selection_screen/explicacao_telefone_monitoria_online.dart';
import 'package:estuda_maua/screens/user_data_selection_screen/user_data_selection_screen_5.dart';
import 'package:estuda_maua/screens/user_data_selection_screen/user_data_selection_screen_6.dart';
import 'package:estuda_maua/screens/user_data_selection_screen/user_data_selection_screen_7.dart';
import 'package:estuda_maua/utilities/user_brain.dart';
import 'package:estuda_maua/utilities/user_data_selection_brain.dart';
import 'package:estuda_maua/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class UserDataSelectionScreen4 extends StatefulWidget {
  static String id = 'monitoria_selection_screen_4';

  @override
  _UserDataSelectionScreen4State createState() =>
      _UserDataSelectionScreen4State();
}

class _UserDataSelectionScreen4State extends State<UserDataSelectionScreen4> {
  int numberOfMonitorias = 1;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    UserBrain userBrain = Provider.of<UserBrain>(context);
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
                      padding: EdgeInsets.only(bottom: 40.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Para se tornar um monitor de nosso serviço, é necessário registrar seu número de telefone para a monitoria online. Você concorda com nosso termos de uso?',
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
                                    ExplicacaoTelefoneMonitoriaOnline.id);
                              },
                              child: Text(
                                'Termos de uso e mais informações',
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
                        List<DropdownMenuItem> list = [];

                        List<String> monitoriaStrings = [
                          'Não',
                          'Sim',
                        ];

                        for (int index = 0;
                            index < monitoriaStrings.length;
                            index++) {
                          list.add(
                            DropdownMenuItem(
                              value: index == 1,
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
                            'Selecione opção',
                            style: TextStyle(color: Colors.grey[700]),
                            overflow: TextOverflow.ellipsis,
                          ),
                          value: Provider.of<UserDataSelectionBrain>(context)
                              .escolhaRegistroTelefone,
                          items: list,
                          onChanged: (escolha) {
                            Provider.of<UserDataSelectionBrain>(context)
                                .escolhaRegistroTelefone = escolha;
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
                      buttonText: 'Confirmar escolha',
                      enabled: Provider.of<UserDataSelectionBrain>(context)
                              .escolhaRegistroTelefone ==
                          true,
                      onTap: () async {
                        Navigator.pushNamed(
                            context,
                            Provider.of<UserDataSelectionBrain>(context)
                                    .escolhaRegistroTelefone
                                ? UserDataSelectionScreen5.id
                                : UserDataSelectionScreen7.id);
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
