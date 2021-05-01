import 'package:estuda_maua/screens/main_navigation_screen/monitoria_tab/monitoria_professor_scroll_area.dart';
import 'package:estuda_maua/screens/monitoria_chat_selection_screen/monitoria_chat_selection_screen.dart';
import 'package:estuda_maua/utilities/constants.dart';
import 'package:estuda_maua/utilities/monitoria_brain.dart';
import 'package:estuda_maua/utilities/user_brain.dart';
import 'package:estuda_maua/widgets/monitor_chat_card.dart';
import 'package:estuda_maua/widgets/monitor_type_info_simple.dart';
import 'package:estuda_maua/widgets/warning_sign.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class MonitoriaScroll extends StatefulWidget {
  @override
  _MonitoriaScrollState createState() => _MonitoriaScrollState();
}

class _MonitoriaScrollState extends State<MonitoriaScroll> {
  Future<void> getMonitoriasData() async {
    await Provider.of<UserBrain>(context).getDadosUsuario();
    Provider.of<MonitoriaBrain>(context).listaMonitoriasModoMonitorOff =
        Provider.of<UserBrain>(context).getUserDisciplinas();
//    await Provider.of<UserBrain>(context).getDadosUsuario();
//    Provider.of<MonitoriaBrain>(context).listaMonitoriasModoMonitorOn =
//        Provider.of<UserBrain>(context).getUserMonitorias();
  }

  @override
  Widget build(BuildContext context) {
    final monitoriaBrain = Provider.of<MonitoriaBrain>(context);

    return FutureBuilder(
      future: getMonitoriasData(),
      builder: (context, snapshot) {
        List<Widget> columnMonitoriaChatCards = [];

        if (Provider.of<UserBrain>(context).getIsUserProfessor())
          return MonitoriaProfessorScrollArea();

        try {
          List<String> monitoriasList;

          monitoriasList = monitoriaBrain.listaMonitoriasModoMonitorOff;

          if ((monitoriasList ?? []).length == 0) {
            return Padding(
              padding: EdgeInsets.only(top: 200.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (monitoriasList.length == 0) {
            return Padding(
              padding: EdgeInsets.only(top: 180.0, right: 15.0, left: 15.0),
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.not_interested,
                    size: 80.0,
                    color: Colors.grey[900],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    'Não há nenhuma disciplina registrada em nosso sistema.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            );
          }

          for (String monitoria in monitoriasList) {
            Widget monitoriaChatCard = FutureBuilder(
              future: monitoriaBrain.getMonitoriaCardInfo(
                monitoria: monitoria,
              ),
              builder: (context, snapshot) {
                MonitoriaCardInfo monitoriaCardInfo =
                    monitoriaBrain.monitoriaCardInfoMap[monitoria];

                if (monitoriaCardInfo == null) {
                  return MonitorCard(
                    title: 'Carregando...',
                    fotos: [null, null, null, null],
                  );
                }

                if (monitoriaCardInfo == null || monitoriaCardInfo.isEmpty) {
                  return MonitorCard(
                    title: monitoria,
                    onTap: () {
                      monitoriaBrain.selectedMonitoriaData =
                          MonitoriaCardInfo(monitoria: monitoria);
                      Navigator.pushNamed(context, ChatSelectionScreen.id);
                    },
                  );
                }

                List<ImageProvider> fotosUsuarios = [];
                List<MonitorType> monitoresType = [];
                List<String> photoTags = [];
                MessageData lastMessageData = MessageData();
                int unreadMessages = 0;

                for (ChatCardInfo chatData
                    in monitoriaCardInfo.monitorCardInfoList) {
                  if ((chatData.lastMessageTimeInMilliseconds ?? -1) >
                      (lastMessageData.timeInMilliseconds ?? 0)) {
                    lastMessageData = chatData.lastMessageData;
                  }

                  unreadMessages =
                      unreadMessages + (chatData.unreadMessages ?? 0);

                  monitoresType.add(chatData.monitorType);
                  fotosUsuarios.add(chatData.userImage);
                  photoTags.add('$monitoria: ${chatData.userRA}');
                }

                return MonitorCard(
                  title: monitoriaCardInfo.monitoria,
                  fotos: fotosUsuarios,
                  monitorTypes: monitoresType,
                  photoTags: photoTags,
                  onTap: () {
                    monitoriaBrain.selectedMonitoriaData = monitoriaCardInfo;
                    Navigator.pushNamed(context, ChatSelectionScreen.id);
                  },
                );
              },
            );

            columnMonitoriaChatCards.add(monitoriaChatCard);
          }
        } catch (e) {
          print(e);
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 200.0),
              child: Column(
                children: <Widget>[
                  WarningSign(
                    text:
                        'ERRO: Não foi possível carregar contatos. Clique abaixo para recarregar.',
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.refresh,
                      color: Colors.grey[800],
                      size: 30.0,
                    ),
                    onPressed: () {
                      getMonitoriasData();
                      setState(() {});
                    },
                  )
                ],
              ),
            ),
          );
        }

        return Column(
          children: <Widget>[
            SizedBox(height: 1.0),
            Column(
              children: columnMonitoriaChatCards,
            ),
            SizedBox(
              height: 15.0,
            ),
            MonitorTypeInfoSimple(),
          ],
        );
      },
    );
  }
}
