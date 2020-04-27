import 'package:flutter/material.dart';
import 'package:funny_chat/core/responsitory/api_firebase.dart';
import 'package:funny_chat/core/router.dart';
import 'package:funny_chat/core/storage_manager.dart';
import 'package:funny_chat/core/view_model/home_page_viewmodel.dart';
import 'package:funny_chat/core/view_model/login_view_model.dart';
import 'package:funny_chat/core/view_model/sign_up_viewmodel.dart';
import 'package:funny_chat/ui/theme/theme_manager.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  final _auth = Auth();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (_) => LoginViewModel(_auth),
      ),
      ChangeNotifierProvider(
        create: (_) => SignUpViewModel(_auth),
      ),
      ChangeNotifierProvider(
        create: (_) => HomePageViewModel(),
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
    return Consumer<ThemeManager>(
      builder: (context, provider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateRoute: Router.generateRoute,
          initialRoute: "/",
          theme: provider.darkTheme ? builDarkTheme() : buildLightTheme(),
        );
      },
    );
  }
}
