import 'package:estuda_maua/screens/profile_screen/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:estuda_maua/screens/main_navigation_screen/settings_screen/tabs/minhas_medias.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 60,
          width: double.infinity,
          child: Material(
            elevation: 5.0,
            child: MaterialButton(
              onPressed: () {
                Navigator.pushNamed(context, MinhasMediasSettings.id);
              },
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.school,
                    color: Colors.grey[700],
                    size: 30.0,
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Expanded(
                    child: Text(
                      'Minhas Médias',
                      style: TextStyle(
                        fontSize: 19.0,
                        color: Colors.grey[900],
                      ),
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_right),
                ],
              ),
            ),
          ),
        ),
        Container(
          height: 60,
          width: double.infinity,
          child: Material(
            elevation: 5.0,
            child: MaterialButton(
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.people,
                    color: Colors.grey[700],
                    size: 30.0,
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Expanded(
                    child: Text(
                      'Monitoria Online',
                      style: TextStyle(
                        fontSize: 19.0,
                        color: Colors.grey[900],
                      ),
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_right),
                ],
              ),
            ),
          ),
        ),
        Container(
          height: 60,
          width: double.infinity,
          child: Material(
            elevation: 5.0,
            child: MaterialButton(
              onPressed: () {
                Navigator.pushNamed(context, ProfileScreen.id);
              },
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.person,
                    color: Colors.grey[700],
                    size: 30.0,
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Expanded(
                    child: Text(
                      'Dados pessoais',
                      style: TextStyle(
                        fontSize: 19.0,
                        color: Colors.grey[900],
                      ),
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_right),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
