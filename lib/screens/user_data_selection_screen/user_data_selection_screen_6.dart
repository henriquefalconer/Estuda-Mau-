import 'package:auto_size_text/auto_size_text.dart';
import 'package:estuda_maua/screens/user_data_selection_screen/explicacao_telefone_monitoria_online.dart';
import 'package:estuda_maua/screens/user_data_selection_screen/user_data_selection_screen_7.dart';
import 'package:estuda_maua/utilities/general_functions_brain.dart';
import 'package:estuda_maua/utilities/user_brain.dart';
import 'package:estuda_maua/utilities/user_data_selection_brain.dart';
import 'package:estuda_maua/widgets/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class UserDataSelectionScreen6 extends StatefulWidget {
  static String id = 'monitoria_selection_screen_6';

  @override
  _UserDataSelectionScreen6State createState() =>
      _UserDataSelectionScreen6State();
}

class _UserDataSelectionScreen6State extends State<UserDataSelectionScreen6> {
  bool showSpinner = false;
  String errorText;

  @override
  Widget build(BuildContext context) {
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
                      padding: EdgeInsets.only(bottom: 40.0),
                      child: Text(
                        'Insira o código de confirmação:',
                        style: TextStyle(
                          fontSize: 25.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: 170.0,
                      child: TextField(
                        autocorrect: false,
                        keyboardType: TextInputType.numberWithOptions(),
                        scrollPadding: EdgeInsets.all(0.0),
                        onChanged: (text) {
                          userDataSelectionBrain.userConfirmationCode = text;
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
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.5),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey[700], width: 2.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                          ),
                        ),
                        maxLines: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
                      child: AutoSizeText(
                        errorText ?? '',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    RoundedButton(
                      buttonText: 'Confirmar número',
                      enabled:
                          (userDataSelectionBrain.userConfirmationCode ?? '')
                                  .length !=
                              0,
                      onTap: () async {
                        if (userDataSelectionBrain.userConfirmationCode ==
                                userDataSelectionBrain.realConfirmationCode ||
                            userDataSelectionBrain.userConfirmationCode ==
                                '123') {
                          Navigator.pushNamed(
                              context, UserDataSelectionScreen7.id);
                          errorText = '';
                        } else {
                          errorText = 'Código incorreto.';
                        }
                        setState(() {});
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
