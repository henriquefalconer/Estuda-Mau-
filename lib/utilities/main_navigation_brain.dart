import 'package:estuda_maua/utilities/constants.dart';
import 'package:flutter/cupertino.dart';

class MainNavigationBrain extends ChangeNotifier {
  MainScreens _currentScreen;

  MainScreens get currentScreen => _currentScreen;

  void changeMainNavigationScreen(MainScreens newScreen) {
    _currentScreen = newScreen;
    notifyListeners();
  }
}
