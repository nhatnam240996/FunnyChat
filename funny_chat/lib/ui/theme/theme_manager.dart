import 'package:flutter/material.dart';

class ThemeManager {
  static builDarkTheme() {
    final ThemeData basic = ThemeData.dark();
    return basic.copyWith();
  }

  static buildLightTheme() {
    final ThemeData basic = ThemeData.light();
    return basic.copyWith();
  }
}
