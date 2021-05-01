import 'package:estuda_maua/screens/monitoria_chat_screen/monitoria_chat_top_area.dart';
import 'package:estuda_maua/screens/photos_grid_view_screen/gallery_grid_view_screen.dart';
import 'package:estuda_maua/utilities/monitoria_brain.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'messages_stream_area.dart';
import 'monitoria_chat_bottom_area.dart';

class MonitoriaChatScreen extends StatefulWidget {
  static String id = 'monitoria_chat_screen';

  @override
  _MonitoriaChatScreenState createState() => _MonitoriaChatScreenState();
}

class _MonitoriaChatScreenState extends State<MonitoriaChatScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<MonitoriaBrain>(context, listen: false).viewingMessagesScreen =
        true;
  }

  @override
  void deactivate() {
    super.deactivate();
    Provider.of<MonitoriaBrain>(context, listen: false).viewingMessagesScreen =
        false;
  }

  @override
  Widget build(BuildContext context) {
    final monitoriaBrain = Provider.of<MonitoriaBrain>(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            FutureBuilder(
              future: monitoriaBrain.getMonitoriaReceiverUserInfo(),
              builder: (context, snapshot) {
                if (monitoriaBrain
                        .monitoresUserInfoMap[monitoriaBrain.receiverRA] ==
                    null) {
                  return MonitoriaChatTopArea(
                    infoOnTap: null,
                    returnOnTap: () {
                      Navigator.pop(context);
                    },
                    nome: 'Carregando...',
                    descricao: 'Carregando...',
                    isOtherUserOnline: false,
                  );
                }

                Map<String, dynamic> receiverUserInfo = monitoriaBrain
                    .monitoresUserInfoMap[monitoriaBrain.receiverRA];

                return MonitoriaChatTopArea(
                  infoOnTap: () {
                    Navigator.pushNamed(context, PhotoGridViewScreen.id);
                  },
                  returnOnTap: () {
                    Navigator.pop(context);
                  },
                  nome: receiverUserInfo['userName'],
                  foto: receiverUserInfo['userImage'],
                  descricao: monitoriaBrain.selectedMonitoriaData.monitoria,
                  isOtherUserOnline: true,
                );
              },
            ),
            Expanded(
              child: FutureBuilder(
                  future: monitoriaBrain
                      .initializeReadMessageListener(monitoriaBrain.receiverRA),
                  builder: (context, snapshot) {
                    return MessagesStream();
                  }),
            ),
            MonitoriaChatBottomArea(),
          ],
        ),
      ),
    );
  }
}
