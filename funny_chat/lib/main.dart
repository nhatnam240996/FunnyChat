import 'package:flutter/material.dart';
import 'package:funny_chat/core/router.dart';
import 'package:funny_chat/core/view_model/login_view_model.dart';
import 'package:funny_chat/ui/home_page.dart';
import 'package:funny_chat/ui/theme/theme_manager.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LoginViewModel(),
        )
      ],
      child: MaterialApp(
        home: HomePage(),
        initialRoute: '/log-in',
        onGenerateRoute: Router.generateRoute,
        theme: ThemeManager.builDarkTheme(),
      ),
    );
  }
}
