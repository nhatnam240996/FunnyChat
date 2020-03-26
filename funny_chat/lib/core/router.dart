import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funny_chat/ui/chat.dart';
import 'package:funny_chat/ui/contact.dart';
import 'package:funny_chat/ui/empty_page.dart';
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
      case '/home-page':
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
      case '/search-contact':
        return MaterialPageRoute(
          builder: (_) => Contact(),
        );
      case '/chat':
        return MaterialPageRoute(
          builder: (_) => Chat(data),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => EmptyPage(),
        );
    }
  }
}

class Loggin {}
