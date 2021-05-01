import 'package:auto_size_text/auto_size_text.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:estuda_maua/screens/monitoria_chat_screen/monitoria_chat_screen.dart';
import 'package:estuda_maua/screens/profile_photo_full_screen/profile_photo_full_screen.dart';
import 'package:estuda_maua/utilities/constants.dart';
import 'package:estuda_maua/utilities/general_functions_brain.dart';
import 'package:estuda_maua/utilities/monitoria_brain.dart';
import 'package:estuda_maua/utilities/profile_photo_full_screen_brain.dart';
import 'package:estuda_maua/widgets/bland_top_area.dart';
import 'package:estuda_maua/widgets/monitor_type_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MonitoriaChatTypeSelectionScreen extends StatelessWidget {
  static String id = 'monitoria_chat_type_selection_screen';

  @override
  Widget build(BuildContext context) {
    MonitoriaBrain monitoriaBrain = Provider.of<MonitoriaBrain>(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: FutureBuilder(
          future: monitoriaBrain.getMonitoriaReceiverUserInfo(),
          builder: (context, snapshot) {
            if (monitoriaBrain
                    .monitoresUserInfoMap[monitoriaBrain.receiverRA] ==
                null) {
              return BlandTopArea(
                title: 'Carregando...',
              );
            }

            Map<String, dynamic> infoUsuario =
                monitoriaBrain.monitoresUserInfoMap[monitoriaBrain.receiverRA];

            return Stack(
              alignment: AlignmentDirectional.topCenter,
              children: <Widget>[
                Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Provider.of<ProfilePhotoFullScreenBrain>(context)
                                .nome = infoUsuario['userName'];
                            Provider.of<ProfilePhotoFullScreenBrain>(context)
                                .image = infoUsuario['userImage'];
                            Navigator.pushNamed(
                                context, ProfilePhotoFullScreen.id);
                          },
                          child: Hero(
                            tag:
                                '${monitoriaBrain.selectedMonitoriaData.monitoria}: ${monitoriaBrain.receiverRA}',
                            child: CircleAvatar(
                              backgroundImage: infoUsuario['userImage'],
                              radius: 70.0,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        AutoSizeText(
                          infoUsuario['userName'],
                          style: TextStyle(
                            fontSize: 25.0,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        AutoSizeText(
                          infoUsuario['userDescription'],
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Visibility(
                          visible: infoUsuario['monitoria'] != null,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 20.0),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    'Monitorias de que faz parte:',
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.grey[800],
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 0.0),
                                  child: Builder(
                                    builder: (context) {
                                      List<Widget> listMonitorias = [];

                                      try {
                                        for (String monitoria
                                            in infoUsuario['monitoria']) {
                                          listMonitorias.add(
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5.0,
                                                  horizontal: 15.0),
                                              child: Stack(
                                                alignment: AlignmentDirectional
                                                    .centerEnd,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 25.0),
                                                    child: Text(
                                                      '${monitoria ?? 'Carregando...'}',
                                                      style: TextStyle(
                                                        fontSize: 15.0,
                                                        color: Colors.grey[600],
                                                      ),
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  MonitorTypeIcon(
                                                    type: GeneralFunctionsBrain
                                                        .convertStringToMonitorType(
                                                      infoUsuario[
                                                              'monitorTypeMap']
                                                          [monitoria]['tipo'],
                                                    ),
                                                    size: 20.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                      } catch (e) {
                                        listMonitorias = [
                                          Text(
                                            'Erro ao carregar monitorias.',
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                              fontSize: 15.0,
                                            ),
                                          ),
                                        ];
                                      }

                                      return Column(
                                        children: listMonitorias,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                              width: 300.0,
                              child: MaterialButton(
                                onPressed: () async {
                                  String phone = '11974504505';
                                  var whatsappUrl =
                                      "whatsapp://send?phone=$phone";
                                  if (await canLaunch(whatsappUrl)) {
                                    launch(whatsappUrl);
                                  } else {
                                    showCupertinoModalPopup(
                                        context: context,
                                        builder: (context) {
                                          return CupertinoAlertDialog(
                                            title: Text('Erro ao abrir'),
                                            content: Padding(
                                              padding:
                                                  EdgeInsets.only(top: 8.0),
                                              child: Text(
                                                  'WhatApp parece não estar baixado.'),
                                            ),
                                            actions: <Widget>[
                                              CupertinoDialogAction(
                                                isDefaultAction: true,
                                                child: Text(
                                                  'OK',
                                                  style: TextStyle(
                                                      color: Colors.blue),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  }
                                },
                                child: Material(
                                  elevation: 5.0,
                                  color: Colors.green[600],
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 6.0),
                                    child: Row(
                                      children: <Widget>[
                                        Column(
                                          children: <Widget>[
                                            Icon(
                                              CommunityMaterialIcons.whatsapp,
                                              size: 30.0,
                                              color: Colors.white,
                                            ),
                                            SizedBox(
                                              height: 4.0,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Text(
                                          'Acessar WhatsApp',
                                          style: TextStyle(
                                            fontSize: 19.0,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Container(
                              width: 300.0,
                              child: MaterialButton(
                                onPressed: () async {
                                  Navigator.pushNamed(
                                      context, MonitoriaChatScreen.id);
                                },
                                child: Material(
                                  elevation: 5.0,
                                  color: Colors.grey,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 6.0),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.chat,
                                          size: 30.0,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Text(
                                          'Acessar Chat Interno',
                                          style: TextStyle(
                                            fontSize: 19.0,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                BlandTopArea(
                  title: 'Selecione a conversa',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
