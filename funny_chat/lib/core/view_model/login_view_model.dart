import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funny_chat/core/models/account/user.dart';
import 'package:funny_chat/core/responsitory/api.dart';
import 'package:funny_chat/core/responsitory/api_firebase.dart';

class LoginViewModel with ChangeNotifier {
  final Auth _auth;

  LoginViewModel(this._auth);
  String _error = "";
  String get error => _error;

  signInWithFireBase(String email, String password) async {
    final result = await _auth.signIn(email, password);
  }

  signIn(Map data, BuildContext context) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Container(
          margin: EdgeInsets.symmetric(horizontal: 122.0),
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: CircularProgressIndicator(),
        ),
      ),
    ).timeout(
      (Duration(milliseconds: 300)),
      onTimeout: () async {
        final result = await Api.login(data);
        if (result is User) {
          _error = "";
          Navigator.pop(context);
          Navigator.pushNamed(context, "/home-page");
        } else {
          _error = result;
          Navigator.pop(context);
          notifyListeners();
        }
      },
    );
  }
}
