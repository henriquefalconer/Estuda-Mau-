import 'package:estuda_maua/screens/profile_screen/profile_screen.dart';
import 'package:estuda_maua/utilities/constants.dart';
import 'package:estuda_maua/utilities/main_navigation_brain.dart';
import 'package:estuda_maua/utilities/user_brain.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'medias_tab/media_top_area.dart';
// import 'monitoria_tab/monitoria_top_area.dart';

class TopScreenArea extends StatelessWidget {
  TopScreenArea({
    this.userPictureRadius,
    this.titleSize,
    this.cardHeight,
  });

  final double userPictureRadius;
  final double titleSize;
  final double cardHeight;

  final Map<MainScreens, String> screenTitleSet = {
    MainScreens.Moodle: 'Moodlerooms',
    MainScreens.Medias: 'Minhas Médias',
    MainScreens.Monitoria: 'Monitoria Online',
    MainScreens.Settings: 'Ajustes',
  };

  @override
  Widget build(BuildContext context) {
    final mainNavigationBrain = Provider.of<MainNavigationBrain>(context);
    return Stack(
      children: <Widget>[
        Visibility(
          visible: mainNavigationBrain.currentScreen == MainScreens.Medias,
          child: MediaTopArea(),
        ),
//        Visibility(
//          visible: mainNavigationBrain.currentScreen == MainScreens.Monitoria &&
//              Provider.of<UserBrain>(context).getUserMonitorias() != null,
//          child: MonitoriaTopArea(),
//        ),
        Material(
          color: kProfileBackgroundColor,
          elevation: 5.0,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15.0),
            bottomRight: Radius.circular(15.0),
          ),
          child: Container(
            height: cardHeight,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 15.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    child: Text(
                      screenTitleSet[mainNavigationBrain.currentScreen] ?? '',
                      style: TextStyle(
                        fontSize: titleSize,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: kUserNameMaxLines,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, ProfileScreen.id);
                    },
                    child: Hero(
                      tag: 'user_picture',
                      child: FutureBuilder(
                        future:
                            Provider.of<UserBrain>(context).getDadosUsuario(),
                        builder: (context, snapshot) {
                          return CircleAvatar(
                            radius: userPictureRadius,
                            backgroundImage:
                                Provider.of<UserBrain>(context).getUserImage(),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
