import 'package:flutter/material.dart';

ThemeData builDarkTheme() {
  final ThemeData basic = ThemeData.dark();
  return basic.copyWith();
}

ThemeData buildLightTheme() {
  final ThemeData basic = ThemeData.light();
  return basic.copyWith();
}

class ThemeManager with ChangeNotifier {
  static final ThemeManager _themeManager = ThemeManager._internal();

  factory ThemeManager() {
    return _themeManager;
  }

  ThemeManager._internal();
  bool _darkTheme = false;
  bool get darkTheme => _darkTheme;

  changeTheme() {
    print(_darkTheme);
    _darkTheme = !_darkTheme;
    notifyListeners();
  }
}
