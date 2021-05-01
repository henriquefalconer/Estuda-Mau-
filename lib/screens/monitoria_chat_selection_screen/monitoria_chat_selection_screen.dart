import 'package:estuda_maua/screens/monitoria_chat_screen/monitoria_chat_screen.dart';
import 'package:estuda_maua/screens/monitoria_chat_type_selection_screen/monitoria_chat_type_selection_screen.dart';
import 'package:estuda_maua/utilities/constants.dart';
import 'package:estuda_maua/utilities/monitoria_brain.dart';
import 'package:estuda_maua/widgets/bland_top_area.dart';
import 'package:estuda_maua/widgets/monitor_chat_card.dart';
import 'package:estuda_maua/widgets/monitor_type_info_simple.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatSelectionScreen extends StatefulWidget {
  static String id = 'monitoria_chat_selection_screen';

  @override
  _ChatSelectionScreenState createState() => _ChatSelectionScreenState();
}

class _ChatSelectionScreenState extends State<ChatSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    MonitoriaBrain monitoriaBrain = Provider.of<MonitoriaBrain>(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: monitoriaBrain.selectedMonitoriaData.isEmpty
            ? Stack(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.speaker_notes_off,
                          size: 45.0,
                          color: Colors.grey[800],
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          monitoriaBrain.modoMonitor
                              ? 'Nenhum aluno te mandou mensagens pelo sistema interno até agora'
                              : 'Não há monitores desta disciplina registrados no sistema',
                          style: TextStyle(
                              fontSize: 25.0, color: Colors.grey[600]),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  BlandTopArea(
                    title: monitoriaBrain.selectedMonitoriaData.monitoria,
                  ),
                ],
              )
            : Column(
                children: <Widget>[
                  BlandTopArea(
                    title: monitoriaBrain.selectedMonitoriaData.monitoria,
                  ),
                  Expanded(
                    child: Builder(builder: (context) {
                      return ListView(
                        children: <Widget>[
                          Builder(
                            builder: (context) {
                              List<Widget> columnMonitoriaChatCards = [];

                              for (ChatCardInfo monitoriaCardInfo
                                  in monitoriaBrain.selectedMonitoriaData
                                      .monitorCardInfoList) {
                                try {
                                  columnMonitoriaChatCards.add(
                                    FutureBuilder(
                                        future: monitoriaBrain
                                            .getMonitorChatCardInfo(
                                          monitoria: monitoriaBrain
                                              .selectedMonitoriaData.monitoria,
                                          otherUserRA: monitoriaCardInfo.userRA,
                                        ),
                                        builder: (context, snapshot) {
                                          if ((monitoriaBrain
                                                          .monitoresChatCardInfoMap[
                                                      monitoriaBrain
                                                          .selectedMonitoriaData
                                                          .monitoria] ??
                                                  {})[monitoriaCardInfo.userRA] ==
                                              null) {
                                            return MonitorCard(
                                              fotos: [null],
                                              title: 'Carregando...',
                                            );
                                          }

                                          ChatCardInfo chatCardInfo =
                                              monitoriaBrain
                                                      .monitoresChatCardInfoMap[
                                                  monitoriaBrain
                                                      .selectedMonitoriaData
                                                      .monitoria][monitoriaCardInfo
                                                  .userRA];

                                          return MonitorCard(
                                            title: chatCardInfo.userName,
                                            fotos: [chatCardInfo.userImage],
                                            monitorTypes: [
                                              chatCardInfo.monitorType
                                            ],
                                            photoTags: [
                                              '${monitoriaBrain.selectedMonitoriaData.monitoria}: ${chatCardInfo.userRA}'
                                            ],
                                            onTap: () {
                                              monitoriaBrain.receiverRA =
                                                  chatCardInfo.userRA;
                                              monitoriaBrain.receiverUid =
                                                  chatCardInfo.userUid;
                                              monitoriaBrain
                                                      .selectedChatUnreadMessages =
                                                  chatCardInfo.unreadMessages;
                                              monitoriaBrain
                                                  .resetCurrentGallery();
                                              Navigator.pushNamed(
                                                  context,
                                                  MonitoriaChatTypeSelectionScreen
                                                      .id);
//                                              Navigator.pushNamed(context,
//                                                  MonitoriaChatScreen.id);
                                            },
                                          );
                                        }),
                                  );
                                } catch (e) {
                                  print(
                                      'ERRO em MonitoriaChatSelectionScreen: $e');
                                  columnMonitoriaChatCards.add(MonitorCard(
                                    title: 'Erro ao carregar dados.',
                                  ));
                                }
                              }

                              return Column(
                                children: columnMonitoriaChatCards +
                                    <Widget>[
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      MonitorTypeInfoSimple(),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                    ],
                              );
                            },
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              ),
      ),
    );
  }
}
