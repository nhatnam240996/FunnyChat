import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funny_chat/ui/home_page.dart';
import 'package:funny_chat/ui/init_view_state.dart';
import 'package:funny_chat/ui/login.dart';
import 'package:funny_chat/ui/sign_in.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    var data = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => InitViewState(),
        );
      case '/home':
        return MaterialPageRoute(
          builder: (_) => HomePage(),
        );
      case '/log-in':
        return MaterialPageRoute(
          builder: (_) => Login(),
        );
      case '/sign-in':
        return MaterialPageRoute(
          builder: (_) => SignIn(),
        );
    }
  }
}

class Loggin {}
