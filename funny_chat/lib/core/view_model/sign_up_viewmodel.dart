import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:funny_chat/core/responsitory/api_firebase.dart';
import 'package:funny_chat/ui/command/Popup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpViewModel with ChangeNotifier {
  final Auth _auth;
  String _error = "";
  String get error => this._error;
  SignUpViewModel(this._auth) {
    _error = "";
  }

  Future signUp(context, String email, String password) async {
    final result = await Popup.processingDialog(
      context,
      _auth.signUp(email, password),
    );
    if (result is FirebaseUser) {
      await _storeUserToFirebase(result);
      Navigator.pushNamed(context, '/home-page');
    } else {
      _error = result;
      notifyListeners();
    }
  }

  /// Store user information into firebase database
  _storeUserToFirebase(FirebaseUser user) async {
    print(user.uid);
    try {
      await Firestore.instance
          .collection("users")
          .document("${user.uid}")
          .setData({"email": "${user.email}", "friend_request": ""});
    } catch (e) {
      print(e);
    }
  }
}
