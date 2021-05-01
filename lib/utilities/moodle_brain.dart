import 'package:flutter/cupertino.dart';

class MoodleBrain extends ChangeNotifier {
  String _selectedPage = 'Boas vindas';
  String get selectedPage => _selectedPage;
  void changeSelectedPage(String newPage) {
    _selectedPage = newPage;
    notifyListeners();
  }

  Map<String, dynamic> pageData = {
    'EFB105-Cálculo Diferencial e Integral I': {
      'Boas vindas': Column(
        children: <Widget>[
          Text(
            'Boas vindas',
          ),
          Row(
            children: <Widget>[
              Image.network(
                'https://imt.mrooms.net/pluginfile.php/2673/course/section/210/Boas%20vindas.jpg',
              ),
            ],
          ),
        ],
      ),
      '1º Bimestre': {},
    },
  };
}
