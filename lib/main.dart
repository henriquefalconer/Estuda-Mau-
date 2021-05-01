import 'package:estuda_maua/screens/estatisticas_screen/estatisticas_screen.dart';
import 'package:estuda_maua/screens/explicacao_monitor_verificado/explicacao_monitor_verificado_screen.dart';
import 'package:estuda_maua/screens/explicacao_plano_de_ensino_screen/explicacao_plano_de_ensino_screen.dart';
import 'package:estuda_maua/screens/login_screen/chora_kinhas_screen.dart';
import 'package:estuda_maua/screens/monitoria_chat_selection_screen/monitoria_chat_selection_screen.dart';
import 'package:estuda_maua/screens/monitoria_chat_type_selection_screen/monitoria_chat_type_selection_screen.dart';
import 'package:estuda_maua/screens/photos_grid_view_screen/gallery_grid_view_screen.dart';
import 'package:estuda_maua/screens/photos_viewer_screen/gallery_viewer_screen.dart';
import 'package:estuda_maua/screens/plano_de_ensino_viewer_screen/plano_de_ensino_viewer_screen.dart';
import 'package:estuda_maua/screens/termos_de_uso_screen/termos_de_uso_screen.dart';
import 'package:estuda_maua/screens/user_data_selection_screen/explicacao_telefone_monitoria_online.dart';
import 'package:estuda_maua/screens/user_data_selection_screen/user_data_selection_screen_1.dart';
import 'package:estuda_maua/screens/user_data_selection_screen/user_data_selection_screen_2.dart';
import 'package:estuda_maua/screens/main_navigation_screen/main_navigation_screen.dart';
import 'package:estuda_maua/screens/calculo_de_medias_screen/calculo_de_medias_screen.dart';
import 'package:estuda_maua/screens/monitoria_chat_screen/monitoria_chat_screen.dart';
import 'package:estuda_maua/screens/moodle_navigation_screen/moodle_navigation_screen.dart';
import 'package:estuda_maua/screens/profile_photo_full_screen/profile_photo_full_screen.dart';
import 'package:estuda_maua/screens/profile_screen/profile_screen.dart';
import 'package:estuda_maua/screens/login_screen/login_screen.dart';
import 'package:estuda_maua/screens/user_data_selection_screen/user_data_selection_screen_3.dart';
import 'package:estuda_maua/screens/user_data_selection_screen/user_data_selection_screen_4.dart';
import 'package:estuda_maua/screens/user_data_selection_screen/user_data_selection_screen_5.dart';
import 'package:estuda_maua/screens/user_data_selection_screen/user_data_selection_screen_6.dart';
import 'package:estuda_maua/screens/user_data_selection_screen/user_data_selection_screen_7.dart';
import 'package:estuda_maua/utilities/curso_brain.dart';
import 'package:estuda_maua/utilities/main_navigation_brain.dart';
import 'package:estuda_maua/utilities/medias_brain.dart';
import 'package:estuda_maua/utilities/monitoria_brain.dart';
import 'package:estuda_maua/utilities/moodle_brain.dart';
import 'package:estuda_maua/utilities/network_brain.dart';
import 'package:estuda_maua/utilities/plano_de_ensino_brain.dart';
import 'package:estuda_maua/utilities/profile_photo_full_screen_brain.dart';
import 'package:estuda_maua/utilities/statistics_brain.dart';
import 'package:estuda_maua/utilities/user_brain.dart';
import 'package:estuda_maua/utilities/user_data_selection_brain.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:estuda_maua/screens/main_navigation_screen/settings_screen/tabs/minhas_medias.dart';

void main() {
  runApp(EstudaMaua());
//  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
//      .then((_) {
//    runApp(EstudaMaua());
//  });
}

class EstudaMaua extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          builder: (_) => UserBrain(),
        ),
        ChangeNotifierProvider(
          builder: (_) => CursoBrain(),
        ),
        ChangeNotifierProvider(
          builder: (_) => MediasBrain(),
        ),
        ChangeNotifierProvider(
          builder: (_) => MonitoriaBrain(),
        ),
        ChangeNotifierProvider(
          builder: (_) => ProfilePhotoFullScreenBrain(),
        ),
        ChangeNotifierProvider(
          builder: (_) => MainNavigationBrain(),
        ),
        ChangeNotifierProvider(
          builder: (_) => MoodleBrain(),
        ),
        ChangeNotifierProvider(
          builder: (_) => NetworkBrain(),
        ),
        ChangeNotifierProvider(
          builder: (_) => UserDataSelectionBrain(),
        ),
        ChangeNotifierProvider(
          builder: (_) => StatisticsBrain(),
        ),
        ChangeNotifierProvider(
          builder: (_) => PlanoDeEnsinoBrain(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData().copyWith(
          scaffoldBackgroundColor: Color(0xFF1565C0),
        ),
        initialRoute: LoginScreen.id,
        routes: {
          // Login e cadastro:
          LoginScreen.id: (context) => LoginScreen(),
          UserDataSelectionScreen1.id: (context) => UserDataSelectionScreen1(),
          UserDataSelectionScreen2.id: (context) => UserDataSelectionScreen2(),
          UserDataSelectionScreen3.id: (context) => UserDataSelectionScreen3(),
          UserDataSelectionScreen4.id: (context) => UserDataSelectionScreen4(),
          UserDataSelectionScreen5.id: (context) => UserDataSelectionScreen5(),
          UserDataSelectionScreen6.id: (context) => UserDataSelectionScreen6(),
          UserDataSelectionScreen7.id: (context) => UserDataSelectionScreen7(),
          TermosDeUsoScreen.id: (context) => TermosDeUsoScreen(),
          ExplicacaoTelefoneMonitoriaOnline.id: (context) =>
              ExplicacaoTelefoneMonitoriaOnline(),
          // Navigacão geral:
          MainNavigationScreen.id: (context) => MainNavigationScreen(),
          // Moodle:
          MoodleNavigationScreen.id: (context) => MoodleNavigationScreen(),
          // Médias:
          CalculoDeMediasScreen.id: (context) => CalculoDeMediasScreen(),
          EstatisticasScreen.id: (context) => EstatisticasScreen(),
          PlanoDeEnsinoViewerScreen.id: (context) =>
              PlanoDeEnsinoViewerScreen(),
          ExplicacaoPlanoDeEnsinoScreen.id: (context) =>
              ExplicacaoPlanoDeEnsinoScreen(),
          // Monitoria Online:
          MonitoriaChatScreen.id: (context) => MonitoriaChatScreen(),
          MonitoriaChatTypeSelectionScreen.id: (context) =>
              MonitoriaChatTypeSelectionScreen(),
          ChatSelectionScreen.id: (context) => ChatSelectionScreen(),
          PhotosViewerScreen.id: (context) => PhotosViewerScreen(),
          PhotoGridViewScreen.id: (context) => PhotoGridViewScreen(),
          ExplicacaoMonitorVerificadoScreen.id: (context) =>
              ExplicacaoMonitorVerificadoScreen(),
          // Usuário:
          ProfileScreen.id: (context) => ProfileScreen(),
          ProfilePhotoFullScreen.id: (context) => ProfilePhotoFullScreen(),
          // Outros:
          ChoraKinhasScreen.id: (context) => ChoraKinhasScreen(),
          MinhasMediasSettings.id: (context) => MinhasMediasSettings(),
        },
      ),
    );
  }
}
