import 'package:estuda_maua/utilities/constants.dart';
import 'package:estuda_maua/utilities/main_navigation_brain.dart';
import 'package:estuda_maua/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mainNavigationBrain = Provider.of<MainNavigationBrain>(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: RoundedButton(
            backgroundColor:
                mainNavigationBrain.currentScreen == MainScreens.Medias
                    ? Colors.grey[600]
                    : null,
            icon: Icons.school,
            onTap: () {
              mainNavigationBrain
                  .changeMainNavigationScreen(MainScreens.Medias);
            },
          ),
        ),
        SizedBox(
          width: 15.0,
        ),
        Expanded(
          child: RoundedButton(
            backgroundColor:
                mainNavigationBrain.currentScreen == MainScreens.Monitoria
                    ? Colors.grey[600]
                    : null,
            icon: Icons.people,
            onTap: () {
              mainNavigationBrain
                  .changeMainNavigationScreen(MainScreens.Monitoria);
            },
          ),
        ),
        SizedBox(
          width: 15.0,
        ),
        Expanded(
          child: RoundedButton(
            backgroundColor:
                mainNavigationBrain.currentScreen == MainScreens.Settings
                    ? Colors.grey[600]
                    : null,
            icon: Icons.settings,
            onTap: () {
              mainNavigationBrain
                  .changeMainNavigationScreen(MainScreens.Settings);
            },
          ),
        ),
      ],
    );
  }
}
