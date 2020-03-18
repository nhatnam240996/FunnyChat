import 'package:flutter/cupertino.dart';
import 'package:funny_chat/core/responsitory/api.dart';

class SignInViewModel with ChangeNotifier {
  signIn(String name, String email, String password) {
    Api.signIn(name, email, password);
  }
}
