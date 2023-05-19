import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class ThemeChanger with ChangeNotifier {
  var _themeMode = ThemeMode.light;

  get getTheme => _themeMode;

  toggleTheme() {
    if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.dark;
    }
print(_themeMode);
    notifyListeners();
  }
}
