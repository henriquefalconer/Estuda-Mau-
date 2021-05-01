import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:estuda_maua/screens/main_navigation_screen/main_navigation_screen.dart';
import 'package:estuda_maua/screens/login_screen/chora_kinhas_screen.dart';
import 'package:estuda_maua/utilities/constants.dart';
import 'package:estuda_maua/utilities/monitoria_brain.dart';
import 'package:estuda_maua/utilities/network_brain.dart';
import 'package:estuda_maua/utilities/user_brain.dart';
import 'package:estuda_maua/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'logo.dart';
import '../user_data_selection_screen/user_data_selection_screen_1.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  int logoPressCount = 0;
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();
    controllerSetup();
  }

  void controllerSetup() {
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    controller.forward();
    animation = CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  FirebaseUser loggedInUser;
  String userRA = 'null';
  String password = 'null';
  String errorText;
  final TextEditingController _userNameEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    UserBrain userBrain = Provider.of<UserBrain>(context);
    return Scaffold(
//      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    logoPressCount++;
                    if (logoPressCount == 10 && password == 'ChoraKinhas') {
                      logoPressCount = 0;
                      Navigator.pushNamed(context, ChoraKinhasScreen.id);
                    }
                    controllerSetup();
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        height: 160.0,
                        child: EstudaMauaLogo(
                          computerSize: 38 + 200 * (1 - animation.value),
                          phoneSize: 120.0 * pow(animation.value, 1 / 2),
                          textSize: pow(animation.value, 1 / 2) * 130.0,
                          logoColor: Colors.blue[900],
                        ),
                      ),
                      Flexible(
                        child: SizedBox(
                          height: 50.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child: TextField(
                        controller: _userNameEditingController,
                        keyboardType: TextInputType.number,
                        autocorrect: false,
                        onChanged: (text) {
                          userRA = text;
                          if (userRA.length == 3 && !userRA.endsWith('.')) {
                            userRA = userRA.substring(0, 2) +
                                (userRA.contains('.') ? '' : '.') +
                                userRA.substring(2);
                          }
                          if (userRA.length == 9 && !userRA.endsWith('-')) {
                            userRA = userRA.substring(0, 8) +
                                (userRA.contains('-') ? '' : '-') +
                                userRA.substring(8);
                          }

                          _userNameEditingController.value =
                              _userNameEditingController.value.copyWith(
                            text: userRA,
                            selection: TextSelection.collapsed(
                              offset: userRA.length,
                            ),
                          );

                          setState(() {});
                        },
                        decoration: kInputDecoration.copyWith(
                            hintText: 'Insira seu R.A.'),
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Flexible(
                      child: TextField(
                        autocorrect: false,
                        obscureText: true,
                        onChanged: (value) {
                          password = value;
                        },
                        decoration: kInputDecoration.copyWith(
                            hintText: 'Insira sua senha'),
                        maxLines: 1,
                      ),
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
                    Flexible(
                      child: SizedBox(
                        height: 28.0,
                      ),
                    ),
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: RoundedButton(
                              minimumWidth: 0.0,
                              buttonText: 'Login',
                              onTap: () async {
                                setState(() {
                                  errorText = null;
                                  showSpinner = true;
                                });
                                userBrain.cadastroMode = false;
                                password = password == '' || password == 'null'
                                    ? '123456'
                                    : password;
                                if (password.length < 6) {
                                  password =
                                      password + '_' * (6 - password.length);
                                }
                                String email = userRA + '@maua.br';
                                try {
                                  Provider.of<NetworkBrain>(context).usuarioRA =
                                      userRA;
                                  Provider.of<NetworkBrain>(context)
                                      .senhaUsuario = password;

                                  final newUser =
                                      await _auth.signInWithEmailAndPassword(
                                          email: email,
                                          password: password.toString());
                                  if (newUser != null) {
                                    userBrain.setUser();
                                    Provider.of<MonitoriaBrain>(context)
                                        .senderRA = userRA;
                                    errorText = null;
                                    Navigator.pushNamed(
                                        context, MainNavigationScreen.id);
                                  }
                                } catch (e) {
                                  print(e);
                                  if (e.toString() ==
                                      'PlatformException(ERROR_USER_NOT_FOUND, There is no user record corresponding to this identifier. The user may have been deleted., null)') {
                                    errorText = 'Usuário incorreto.';
                                  } else if (e.toString() ==
                                      'PlatformException(ERROR_WRONG_PASSWORD, The password is invalid or the user does not have a password., null)') {
                                    errorText = 'Senha incorreta.';
                                  } else if (e.toString() ==
                                      'PlatformException(ERROR_TOO_MANY_REQUESTS, We have blocked all requests from this device due to unusual activity. Try again later. [ Too many unsuccessful login attempts.  Please include reCaptcha verification or try again later ], null)') {
                                    errorText =
                                        'Muitas tentativas consecutivas. Acesso bloqueado temporariamente.';
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
                          SizedBox(
                            width: 13.0,
                          ),
                          Expanded(
                            child: RoundedButton(
                              minimumWidth: 0.0,
                              buttonText: 'Cadastrar',
                              backgroundColor: Colors.yellow[600],
                              textColor: Colors.grey[800],
                              onTap: () async {
                                setState(() {
                                  errorText = null;
                                  showSpinner = true;
                                });
                                userBrain.cadastroMode = true;
                                if (userRA.length > 7) {
                                  userRA = userRA.substring(0, 2) +
                                      (userRA.contains('.') ? '' : '.') +
                                      userRA.substring(2);
                                  userRA = userRA.substring(0, 8) +
                                      (userRA.contains('-') ? '' : '-') +
                                      userRA.substring(8);
                                }
                                if (password.length < 6) {
                                  password =
                                      password + 'þ' * (6 - password.length);
                                }
                                String email = userRA + '@maua.br';
                                try {
                                  await _auth.signInWithEmailAndPassword(
                                    email: email,
                                    password: password.toString(),
                                  );
                                  _auth.signOut();
                                  errorText = 'Usuário já existe.';
                                } catch (e) {
                                  if (e.toString() ==
                                      'PlatformException(ERROR_USER_NOT_FOUND, There is no user record corresponding to this identifier. The user may have been deleted., null)') {
                                    Provider.of<NetworkBrain>(context)
                                        .usuarioRA = userRA;
                                    Provider.of<NetworkBrain>(context)
                                        .senhaUsuario = password;

                                    InfoMauaNet infoMauaNet =
                                        await Provider.of<NetworkBrain>(context)
                                            .downloadInfoMauaNet();

                                    if (infoMauaNet != null) {
                                      Provider.of<UserBrain>(context)
                                              .userInfoMauaNet =
                                          infoMauaNet.infoUsuario;

                                      Provider.of<UserBrain>(context)
                                              .userPlanoDeEnsinoMauaNet =
                                          infoMauaNet.planoDeEnsino;
                                    }

                                    Navigator.pushNamed(
                                        context, UserDataSelectionScreen1.id);
                                  }
                                }
                                setState(() {
                                  showSpinner = false;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                        ],
                      ),
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
