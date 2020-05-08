import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funny_chat/ui/chat-page.dart';
import 'package:funny_chat/ui/chat_video_page.dart';
import 'package:funny_chat/ui/contact_page.dart';
import 'package:funny_chat/ui/conversation_page.dart';
import 'package:funny_chat/ui/empty_page.dart';
import 'package:funny_chat/ui/init_page.dart';
import 'package:funny_chat/ui/login_page.dart';
import 'package:funny_chat/ui/verify_number.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    var data = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => InitViewState(),
        );
      case '/login-page':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/verify-number':
        return MaterialPageRoute(builder: (_) => VerifyNumber());
      case '/chat-page':
        return MaterialPageRoute(builder: (_) => ChatPage(data));
      case '/chat-video-page':
        return MaterialPageRoute(builder: (_) => ChatVideoPage());
      case '/conversation-page':
        return MaterialPageRoute(builder: (_) => ConversationPage());
      case '/contact-page':
        return MaterialPageRoute(builder: (_) => ContactPage());
      default:
        return MaterialPageRoute(
          builder: (_) => EmptyPage(),
        );
    }
  }
}

class Loggin {}
