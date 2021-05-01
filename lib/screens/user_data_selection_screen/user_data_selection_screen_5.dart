import 'package:estuda_maua/screens/user_data_selection_screen/explicacao_telefone_monitoria_online.dart';
import 'package:estuda_maua/screens/user_data_selection_screen/user_data_selection_screen_6.dart';
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

class UserDataSelectionScreen5 extends StatefulWidget {
  static String id = 'monitoria_selection_screen_5';

  @override
  _UserDataSelectionScreen5State createState() =>
      _UserDataSelectionScreen5State();
}

class _UserDataSelectionScreen5State extends State<UserDataSelectionScreen5> {
  int numberOfMonitorias = 1;
  bool showSpinner = false;

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
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Este é seu número de telefone? Se não, digite o correto.',
                            style: TextStyle(
                              fontSize: 25.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 170.0,
                      child: TextField(
                        autocorrect: false,
                        controller:
                            userDataSelectionBrain.telefoneEditingController,
                        keyboardType: TextInputType.numberWithOptions(),
                        scrollPadding: EdgeInsets.all(0.0),
                        onChanged: (text) {
                          userDataSelectionBrain.telefone =
                              GeneralFunctionsBrain.formatTelefonePlainText(
                                  text);

                          userDataSelectionBrain
                                  .telefoneEditingController.value =
                              Provider.of<UserDataSelectionBrain>(context)
                                  .telefoneEditingController
                                  .value
                                  .copyWith(
                                    text: userDataSelectionBrain.telefone,
                                    selection: TextSelection.collapsed(
                                      offset:
                                          Provider.of<UserDataSelectionBrain>(
                                                  context)
                                              .telefone
                                              .length,
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
                                color: (Provider.of<UserDataSelectionBrain>(
                                                context)
                                            .isTelefoneReady ??
                                        true)
                                    ? ((Provider.of<UserDataSelectionBrain>(
                                                            context)
                                                        .telefoneEditingController ??
                                                    TextEditingController(
                                                        text: ''))
                                                .text ==
                                            ''
                                        ? Colors.grey
                                        : Colors.green[600])
                                    : Colors.red[700],
                                width: 1.5),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: (Provider.of<UserDataSelectionBrain>(
                                                context)
                                            .isTelefoneReady ??
                                        true)
                                    ? ((Provider.of<UserDataSelectionBrain>(
                                                            context)
                                                        .telefoneEditingController ??
                                                    TextEditingController(
                                                        text: ''))
                                                .text ==
                                            ''
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
                    SizedBox(
                      height: 20.0,
                      width: double.infinity,
                    ),
                    RoundedButton(
                      buttonText: 'Confirmar número',
                      enabled: userDataSelectionBrain.isTelefoneReady,
                      onTap: () async {
                        print('+55' +
                            GeneralFunctionsBrain
                                .getPlainPhoneNumberFromFormattedPhoneNumber(
                                    userDataSelectionBrain.telefone));
                        FirebaseAuth.instance.verifyPhoneNumber(
                          phoneNumber: '+55' +
                              GeneralFunctionsBrain
                                  .getPlainPhoneNumberFromFormattedPhoneNumber(
                                      userDataSelectionBrain.telefone),
                          timeout: Duration(seconds: 5),
                          verificationCompleted: (authCredential) =>
                              print('done'),
                          verificationFailed: (authException) =>
                              print('failed'),
                          codeAutoRetrievalTimeout: (verificationId) =>
                              print('timeout'),
                          // called when the SMS code is sent
                          codeSent: (verificationId, [code]) {
                            print(verificationId + 'df   ' + code.toString());
                            userDataSelectionBrain.realConfirmationCode =
                                code.toString();
                          },
                        );

                        Navigator.pushNamed(
                            context, UserDataSelectionScreen6.id);
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
