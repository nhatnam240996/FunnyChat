import 'package:flutter/material.dart';
import 'package:funny_chat/core/router.dart';
import 'package:funny_chat/ui/home_page.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      initialRoute: '/log-in',
      onGenerateRoute: Router.generateRoute,
    );
  }
}
