import 'package:auto_size_text/auto_size_text.dart';
import 'package:estuda_maua/screens/login_screen/login_screen.dart';
import 'package:estuda_maua/screens/main_navigation_screen/main_navigation_screen.dart';
import 'package:estuda_maua/utilities/monitoria_brain.dart';
import 'package:estuda_maua/utilities/network_brain.dart';
import 'package:estuda_maua/utilities/user_brain.dart';
import 'package:estuda_maua/utilities/user_data_selection_brain.dart';
import 'package:estuda_maua/widgets/rounded_button.dart';
import 'package:estuda_maua/widgets/termos_de_uso.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class TermosDeUsoScreen extends StatefulWidget {
  static String id = 'termos_de_uso_screen';

  @override
  _TermosDeUsoScreenState createState() => _TermosDeUsoScreenState();
}

class _TermosDeUsoScreenState extends State<TermosDeUsoScreen> {
  bool showSpinner = false;
  String errorText;
  int timesDisagreePressed = 0;

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
                        '${userBrain.getUserMauaNetFirstName}, você aceita nossa política de privacidade?',
                        style: TextStyle(
                          fontSize: 25.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      height: 300.0,
                      width: 350.0,
                      child: PoliticaDePrivacidade(),
                    ),
                    Flexible(
                      child: SizedBox(
                        height: 40.0,
                        width: double.infinity,
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: RoundedButton(
                                minimumWidth: 0.0,
                                buttonText: 'Não, não aceito',
                                onTap: () {
                                  timesDisagreePressed++;
                                  showCupertinoModalPopup(
                                      context: context,
                                      builder: (context) {
                                        return CupertinoActionSheet(
                                          message: Text(
                                            'Você tem certeza? ' +
                                                (timesDisagreePressed < 10
                                                    ? 'Você não poderá usar nossos serviços neste caso.'
                                                    : 'Você muito provavelmente vai pegar DP e ser jubilado.'),
                                            style: TextStyle(fontSize: 14.0),
                                          ),
                                          cancelButton:
                                              CupertinoActionSheetAction(
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
                                                (timesDisagreePressed < 10
                                                    ? 'Tenho certeza'
                                                    : 'Estou a fim de pegar DP e ser jubilado'),
                                                style: TextStyle(),
                                              ),
                                              onPressed: () async {
                                                Navigator.popUntil(
                                                    context,
                                                    ModalRoute.withName(
                                                        LoginScreen.id));
                                              },
                                            ),
                                          ],
                                        );
                                      });

                                  setState(() {});
                                },
                              ),
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            Expanded(
                              child: RoundedButton(
                                buttonText: 'Sim, aceito',
                                minimumWidth: 0.0,
                                onTap: () async {
                                  setState(() {
                                    showSpinner = true;
                                  });
                                  try {
                                    final String email =
                                        Provider.of<NetworkBrain>(context)
                                                .usuarioRA +
                                            '@maua.br';
                                    final String password =
                                        Provider.of<NetworkBrain>(context)
                                            .senhaUsuario;

                                    final newUser = await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                      email: email,
                                      password: password.toString(),
                                    );
                                    if (newUser != null) {
                                      Provider.of<MonitoriaBrain>(context)
                                              .senderRA =
                                          Provider.of<NetworkBrain>(context)
                                              .usuarioRA;
                                      errorText = null;

                                      await userBrain.uploadInfoUsuarioFirebase(
                                        monitorias:
                                            Provider.of<UserDataSelectionBrain>(
                                                    context)
                                                .monitoriasSelected,
                                        escolhaDivulgacaoNotas:
                                            Provider.of<UserDataSelectionBrain>(
                                                    context)
                                                .escolhaDivulgacaoNotas,
                                        numeroDeTelefone:
                                            Provider.of<UserDataSelectionBrain>(
                                                    context)
                                                .telefone,
                                      );
                                      await userBrain.setUser();
                                      await Provider.of<NetworkBrain>(context)
                                          .assignMonitorToMonitoriaChat();
                                      Navigator.popUntil(context,
                                          ModalRoute.withName(LoginScreen.id));
                                      Navigator.pushNamed(
                                          context, MainNavigationScreen.id);
                                    }
                                  } catch (e) {
                                    print(e);
                                    if (e.toString() ==
                                        'PlatformException(ERROR_EMAIL_ALREADY_IN_USE, The email address is already in use by another account., null)') {
                                      errorText = 'Usuário já existe.';
                                    } else if (e.toString() ==
                                        '500: dados não puderam ser obtidos.') {
                                      errorText =
                                          'Usuário ou senha não existem no MAUAnet';
                                    } else if (e.toString() ==
                                        '503: dados não puderam ser obtidos.') {
                                      errorText =
                                          'Servidor indisponível. Tente novamente.';
                                    } else {
                                      errorText = 'Erro: $e';
                                    }
                                  }
                                  setState(() {
                                    showSpinner = false;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.0, left: 10.0),
                          child: AutoSizeText(
                            errorText ?? '',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ],
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
