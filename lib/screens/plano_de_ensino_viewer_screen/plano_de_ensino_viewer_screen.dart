import 'package:estuda_maua/screens/plano_de_ensino_viewer_screen/pdf_viewer.dart';
import 'package:estuda_maua/utilities/constants.dart';
import 'package:estuda_maua/utilities/medias_brain.dart';
import 'package:estuda_maua/widgets/bland_top_area.dart';
import 'package:estuda_maua/widgets/rounded_button.dart';
import 'package:estuda_maua/widgets/selection_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:provider/provider.dart';

import 'editor.dart';

class PlanoDeEnsinoViewerScreen extends StatefulWidget {
  static String id = 'plano_de_ensino_viewer_screen';

  @override
  _PlanoDeEnsinoViewerScreenState createState() =>
      _PlanoDeEnsinoViewerScreenState();
}

class _PlanoDeEnsinoViewerScreenState extends State<PlanoDeEnsinoViewerScreen> {
  PlanoDeEnsinoScreen planoDeEnsinoScreen = PlanoDeEnsinoScreen.pdf;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: <Widget>[
            BlandTopArea(
              title: Provider.of<MediasBrain>(context).currentScreenCourse,
            ),
            Expanded(
              child: planoDeEnsinoScreen == PlanoDeEnsinoScreen.pdf
                  ? PdfViewer(
                      'planos_de_ensino/${Provider.of<MediasBrain>(context).currentScreenCourse.split('-').first.trim()}.pdf',
                    )
                  : Provider.of<MediasBrain>(context).allPlanosDeEnsinoStates[
                              Provider.of<MediasBrain>(context)
                                  .currentScreenCourse] !=
                          PlanoDeEnsinoState.verificado
                      ? Editor()
                      : Padding(
                          padding: EdgeInsets.all(30.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.check_circle,
                                size: 80.0,
                                color: Colors.green[600],
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: Text(
                                  'Este plano de ensino já foi incorporado ao nosso sistema.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              RoundedButton(
                                buttonText: 'Reportar um erro',
                                backgroundColor: Colors.red,
                                onTap: () async {
                                  final Email email = Email(
                                    body:
                                        'Há um problema no plano de ensino da matéria ${Provider.of<MediasBrain>(context).currentScreenCourse}:\n\n'
                                        '[Descrever problema]',
                                    subject: 'Reportagem de erro',
                                    recipients: ['estudamaua@gmail.com'],
//                                    attachmentPath: '/path/to/attachment.zip',
                                    isHTML: false,
                                  );

                                  await FlutterEmailSender.send(email);
                                },
                              ),
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Material(
        elevation: 5.0,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: SelectionButton(
                  inactiveBackgroundColor: Color(0xFF0D47A1),
                  inactiveTextColor: Colors.grey[200],
                  activeTextColor: Colors.white,
                  activeBackgroundColor: Colors.grey[600],
                  onTap: () async {
                    planoDeEnsinoScreen = PlanoDeEnsinoScreen.pdf;

                    setState(() {});
                  },
                  buttonText: 'Plano De Ensino',
                  value: PlanoDeEnsinoScreen.pdf,
                  groupValue: planoDeEnsinoScreen,
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: SelectionButton(
                  inactiveBackgroundColor: Color(0xFF0D47A1),
                  inactiveTextColor: Colors.grey[200],
                  activeTextColor: Colors.white,
                  activeBackgroundColor: Colors.grey[600],
                  onTap: () {
                    planoDeEnsinoScreen = PlanoDeEnsinoScreen.editor;
                    setState(() {});
                  },
                  buttonText: 'Editor',
                  value: PlanoDeEnsinoScreen.editor,
                  groupValue: planoDeEnsinoScreen,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
