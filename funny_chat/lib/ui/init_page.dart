import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:funny_chat/core/storage_manager.dart';
import 'package:funny_chat/ui/theme/theme_manager.dart';

class InitViewState extends StatefulWidget {
  @override
  _InitViewStateState createState() => _InitViewStateState();
}

class _InitViewStateState extends State<InitViewState> {
  @override
  initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    /// load config and user in Local
    await ThemeManager.loadThemeConfig(context);
    bool checkHasUser = await StorageManager.checkHasKey("user");
    log("check has User: $checkHasUser");
    if (checkHasUser) {
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushNamed(context, '/conversation-page');
      });
    } else {
      Navigator.pushNamed(context, '/login-page');
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 238, 238, 238),
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 238, 238, 238),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                offset: Offset(10, 10),
                color: Color.fromARGB(80, 0, 0, 0),
                blurRadius: 10,
              ),
              BoxShadow(
                  offset: Offset(-10, -10),
                  color: Color.fromARGB(150, 255, 255, 255),
                  blurRadius: 10)
            ],
          ),
          child: Text(
            "Funny chat".toUpperCase(),
            style: TextStyle(
              fontSize: 45,
              shadows: [
                Shadow(
                    offset: Offset(3, 3),
                    color: Colors.black38,
                    blurRadius: 10),
                Shadow(
                    offset: Offset(-3, -3),
                    color: Colors.white.withOpacity(0.85),
                    blurRadius: 10)
              ],
              color: Colors.black.withAlpha(200),
            ),
          ),
        ),
      ),
    );
  }
}
