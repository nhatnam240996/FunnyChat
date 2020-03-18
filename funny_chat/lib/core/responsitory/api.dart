import 'dart:convert';

import 'package:funny_chat/core/global_config.dart';
import 'package:funny_chat/core/models/account/user_info.dart';
import 'package:http/http.dart' as http;

class Api {
  final _headers = {'Content-Type': 'application/json'};

  /// sign in
  static Future<User> signIn(name, String email, String password) async {
    try {
      Map<String, String> body = {
        "name": name,
        "email": email,
        "password": password
      };
      final response = await http
          .post(GlobalConfig.realDomain + "/users/register", body: body);
      print(response.statusCode);
      final responseBody = jsonDecode(response.body);
      print(responseBody);
      return User.fromJson(responseBody);
    } catch (e) {
      print(e);
      return null;
    }
  }

  /// log in
  // static login({}){

  // }
}
