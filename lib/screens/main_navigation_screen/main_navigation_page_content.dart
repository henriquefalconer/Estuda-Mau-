import 'dart:async';
import 'dart:math';
import 'package:estuda_maua/screens/main_navigation_screen/settings_screen/settings_screen.dart';
import 'package:estuda_maua/screens/profile_screen/profile_screen.dart';
import 'package:estuda_maua/utilities/constants.dart';
import 'package:estuda_maua/utilities/general_functions_brain.dart';
import 'package:estuda_maua/utilities/main_navigation_brain.dart';
import 'package:estuda_maua/utilities/medias_brain.dart';
import 'package:estuda_maua/utilities/monitoria_brain.dart';
import 'package:estuda_maua/utilities/network_brain.dart';
import 'package:estuda_maua/utilities/plano_de_ensino_brain.dart';
import 'package:estuda_maua/utilities/user_brain.dart';
import 'package:estuda_maua/widgets/warning_sign.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'monitoria_tab/monitoria_scroll_area.dart';
import 'cursos_tab/cursos_scroll_area.dart';
import 'medias_tab/medias_scroll_area.dart';

class MainPageContent extends StatefulWidget {
  @override
  _MainPageContentState createState() => _MainPageContentState();
}

class _MainPageContentState extends State<MainPageContent> {
  int secondsLeftForLoad = 0;
  Timer timer;

  final Map<MainScreens, Widget> scrollAreaSet = {
    MainScreens.Moodle: CursosScroll(),
    MainScreens.Medias: MediasScroll(),
    MainScreens.Monitoria: MonitoriaScroll(),
    MainScreens.Settings: SettingsScreen(),
  };

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        secondsLeftForLoad--;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  void _cancelRefresh() {
    Provider.of<NetworkBrain>(context).mauaNetRefreshController.refreshFailed();
    Provider.of<NetworkBrain>(context).cancelDownloadInfoMauaNet();
    setState(() {});
  }

  void _onRefresh() async {
    setState(() {
      secondsLeftForLoad = 30;
    });
    Provider.of<NetworkBrain>(context).notasDownloadError = false;
    Provider.of<MonitoriaBrain>(context).modoMonitor = false;
    // monitor network fetch
    InfoMauaNet mauaNetData;
    try {
      mauaNetData =
          await Provider.of<NetworkBrain>(context).downloadInfoMauaNet();
      if (mauaNetData != null &&
          !Provider.of<NetworkBrain>(context).notasDownloadError) {
        await Provider.of<MediasBrain>(context)
            .setupDisciplinaDatas(mauaNetData.planoDeEnsino);

        for (String curso
            in Provider.of<MediasBrain>(context).getCoursesList()) {
          Provider.of<PlanoDeEnsinoBrain>(context).setupPlanoDeEnsinoEditor(
            course: curso,
            avaliacoesSemClassificacao: Provider.of<MediasBrain>(context)
                .avaliacoesSemClassificacao(course: curso),
          );
        }

        await Future.delayed(Duration(milliseconds: 1000));
        // if failed,use refreshFailed()
        Provider.of<NetworkBrain>(context)
            .mauaNetRefreshController
            .refreshCompleted();
        print('_onRefresh: finished!');
        if (Provider.of<UserBrain>(context).getUserWillingnessToShareNotas()) {
          await Provider.of<MediasBrain>(context).uploadNotasUsuario(
            usuarioRA: Provider.of<UserBrain>(context).getUserRA(),
            notasMauaNet: mauaNetData.planoDeEnsino,
          );
        }
        print('_onRefresh: uploadComplete!');
      } else {
        print('_onRefresh: failed!');
        Provider.of<NetworkBrain>(context).notasDownloadError = true;
        Provider.of<NetworkBrain>(context)
            .mauaNetRefreshController
            .refreshFailed();
      }
    } catch (e) {
      print('_onRefresh: failed! $e');
      Provider.of<NetworkBrain>(context).notasDownloadError = true;
      Provider.of<NetworkBrain>(context)
          .mauaNetRefreshController
          .refreshFailed();
    }
    setState(() {});
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (mounted) setState(() {});
    Provider.of<NetworkBrain>(context).mauaNetRefreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    Widget timeSinceLastDownloadFooter = Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Stack(
        alignment: AlignmentDirectional.centerStart,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 15.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Último download do MAUAnet:',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 17.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      (Provider.of<NetworkBrain>(context)
                                  .lastDownloadMauaNetTime !=
                              null
                          ? '${GeneralFunctionsBrain.getFormattedTime(fromDateTime: Provider.of<NetworkBrain>(context).lastDownloadMauaNetTime)}'
                          : '-----'),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 20.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );

    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      controller: Provider.of<NetworkBrain>(context).mauaNetRefreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      header: ClassicHeader(
        idleText: 'Puxe para baixar informações do MAUAnet',
        releaseText: 'Solte para baixar informações do MAUAnet',
        refreshingText: '',
        completeText: 'Download concluído!',
        failedText: 'Download cancelado!',
        failedIcon: Icon(Icons.clear, color: Colors.grey),
        refreshStyle: RefreshStyle.Behind,
        refreshingIcon: Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Stack(
            alignment: AlignmentDirectional.centerStart,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(
                    width: 15.0,
                  ),
                  Text(
                    '(${secondsLeftForLoad < 1 ? 1 / (pow(2, 1 - secondsLeftForLoad)) : secondsLeftForLoad} s) Recarregando... ',
                    style: TextStyle(color: Colors.grey[500]),
                  )
                ],
              ),
              IconButton(
                icon: Icon(
                  Icons.clear,
                  color: Colors.redAccent,
                  size: 30.0,
                ),
                onPressed: () {
                  _cancelRefresh();
                },
              ),
            ],
          ),
        ),
      ),
      footer: ClassicFooter(
        idleText: '',
        idleIcon: timeSinceLastDownloadFooter,
        loadingIcon: timeSinceLastDownloadFooter,
        canLoadingIcon: timeSinceLastDownloadFooter,
        loadStyle: LoadStyle.ShowAlways,
      ),
      child: ListView(
        children: (Provider.of<NetworkBrain>(context).notasDownloadError
                ? <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        left: 15.0,
                        right: 15.0,
                        top: 13.0,
                        bottom: Provider.of<MainNavigationBrain>(context)
                                    .currentScreen ==
                                MainScreens.Monitoria
                            ? 13.0
                            : 3.0,
                      ),
                      child: WarningSign(
                        text:
                            'Não foi possível recuperar as notas do MAUAnet. Tente novamente.',
                        showLink: true,
                        linkText: 'Inserir dados provisórios',
                        linkOnTap: () {
                          Provider.of<MediasBrain>(context)
                              .setupDisciplinasProvisorias();
                          Provider.of<NetworkBrain>(context)
                              .notasDownloadError = false;
                        },
                      ),
                    )
                  ]
                : <Widget>[]) +
            <Widget>[
              scrollAreaSet[
                  Provider.of<MainNavigationBrain>(context).currentScreen],
            ],
      ),
    );
  }
}
