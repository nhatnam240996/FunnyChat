import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

// abstract class BaseAuth {
//   Future signIn(String email, String password);
//   Future signUp(String email, String password);
//   Future<FirebaseUser> getCurrentUser();
//   Future<void> signOut();
// }

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Future<FirebaseUser> getCurrentUser() {
    return null;
  }

  Future signIn(String email, String password) async {
    try {
      final AuthResult result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (result == null) {
        return null;
      } else {
        return result.user;
      }
    } catch (e) {
      log("[SignIn][Firebase]: $e");
    }
  }

  Future<void> signOut() {
    return null;
  }

  Future signUp(String email, String password) async {
    try {
      final AuthResult result = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .timeout((Duration(seconds: 10)));
      return result.user;
    } on PlatformException catch (e) {
      log("[SignUp][FireBase]: ${e.message}");
      return e.message;
    }
  }
}
