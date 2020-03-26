import 'package:flutter/material.dart';
import 'package:funny_chat/core/router.dart';
import 'package:funny_chat/core/view_model/login_view_model.dart';
import 'package:funny_chat/ui/home_page.dart';
import 'package:funny_chat/ui/login.dart';
import 'package:funny_chat/ui/theme/theme_manager.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (_) => LoginViewModel(),
      ),
      ChangeNotifierProvider(
        create: (_) => ThemeManager(),
      ),
    ], child: MyApp());
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<ThemeManager>(context, listen: false).darkTheme;
    return MaterialApp(
      onGenerateRoute: Router.generateRoute,
      home: Login(),
      theme: provider ? builDarkTheme() : buildLightTheme(),
    );
  }
}
