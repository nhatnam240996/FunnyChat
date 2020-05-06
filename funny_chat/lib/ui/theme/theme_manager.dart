import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:funny_chat/core/storage_manager.dart';
import 'package:provider/provider.dart';

ThemeData builDarkTheme() {
  final ThemeData basic = ThemeData.dark();

  return basic.copyWith(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}

ThemeData buildLightTheme() {
  final ThemeData basic = ThemeData.light();
  return basic.copyWith(
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
    }),
  );
}

class ThemeManager with ChangeNotifier {
  static final ThemeManager _themeManager = ThemeManager._internal();

  factory ThemeManager() {
    return _themeManager;
  }

  ThemeManager._internal();
  bool _darkTheme = false;
  bool get darkTheme => _darkTheme;

  changeTheme(bool theme) {
    this._darkTheme = theme;
    notifyListeners();
  }

  static loadThemeConfig(BuildContext context) async {
    /// check has key before load data
    bool checkLocalConfig = await StorageManager.checkHasKey("darkTheme");

    /// load theme data
    if (checkLocalConfig) {
      final bool darkTheme = await StorageManager.getStorageByKey("darkTheme");
      log("darkTheme: $darkTheme");
      if (darkTheme) {
        Provider.of<ThemeManager>(context, listen: false).changeTheme(true);
      }
    }
  }
}
