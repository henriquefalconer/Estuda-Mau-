import 'package:estuda_maua/screens/login_screen/login_screen.dart';
import 'package:estuda_maua/screens/main_navigation_screen/main_navigation_screen.dart';
import 'package:estuda_maua/screens/termos_de_uso_screen/termos_de_uso_screen.dart';
import 'package:estuda_maua/utilities/monitoria_brain.dart';
import 'package:estuda_maua/utilities/network_brain.dart';
import 'package:estuda_maua/utilities/user_brain.dart';
import 'package:estuda_maua/utilities/user_data_selection_brain.dart';
import 'package:estuda_maua/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class UserDataSelectionScreen7 extends StatefulWidget {
  static String id = 'monitoria_selection_screen_7';

  @override
  _UserDataSelectionScreen7State createState() =>
      _UserDataSelectionScreen7State();
}

class _UserDataSelectionScreen7State extends State<UserDataSelectionScreen7> {
  bool showSpinner = false;

  @override
  void initState() {
    super.initState();

    Provider.of<MonitoriaBrain>(context, listen: false).modoMonitor = false;
  }

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
                      child: Text(
                        'Você gostaria de divulgar suas notas ao nosso sistema?',
                        style: TextStyle(
                          fontSize: 25.0,
                        ),
                        textAlign: TextAlign.center,
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
                              .escolhaDivulgacaoNotas,
                          items: list,
                          onChanged: (escolha) {
                            Provider.of<UserDataSelectionBrain>(context)
                                .escolhaDivulgacaoNotas = escolha;
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
                      buttonText: 'Confirmar resposta',
                      enabled: Provider.of<UserDataSelectionBrain>(context)
                              .escolhaDivulgacaoNotas !=
                          null,
                      onTap: () async {
                        if (userBrain.cadastroMode) {
                          userBrain.cadastroMode = false;
                          Navigator.pushNamed(context, TermosDeUsoScreen.id);
                        } else {
                          setState(() {
                            showSpinner = true;
                          });
                          try {
                            await userBrain.uploadInfoUsuarioFirebase(
                              monitorias:
                                  Provider.of<UserDataSelectionBrain>(context)
                                      .monitoriasSelected,
                              escolhaDivulgacaoNotas:
                                  Provider.of<UserDataSelectionBrain>(context)
                                      .escolhaDivulgacaoNotas,
                              numeroDeTelefone:
                                  Provider.of<UserDataSelectionBrain>(context)
                                      .telefone,
                            );
                            await userBrain.setUser();
                            await Provider.of<NetworkBrain>(context)
                                .assignMonitorToMonitoriaChat();
                            Navigator.popUntil(
                                context, ModalRoute.withName(LoginScreen.id));
                            Navigator.pushNamed(
                                context, MainNavigationScreen.id);
                          } catch (e) {
                            print('ERRO em user_data_selection_screen_6: $e');
                          }
                          setState(() {
                            showSpinner = false;
                          });
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
