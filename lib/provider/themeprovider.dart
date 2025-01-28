import 'package:flutter/material.dart';

class Themeprovider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get thememode => _themeMode;
  void settheme(ThemeMode thememode) {
    _themeMode = thememode;
    notifyListeners();
  }
}
