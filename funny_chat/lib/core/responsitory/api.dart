import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funny_chat/core/global_config.dart';
import 'package:funny_chat/core/models/account/user.dart';
import 'package:funny_chat/core/storage_manager.dart';
import 'package:http/http.dart' as http;

class Api {
  static const headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json'
  };

  /// sign in
  static Future signIn(name, String email, String password) async {
    try {
      Map<String, String> body = {
        "name": name,
        "email": email,
        "password": password
      };
      final response = await http
          .post(GlobalConfig.realDomain + "/users/register", body: body)
          .timeout(
              (Duration(
                seconds: 10,
              )), onTimeout: () async {
        return null;
      });
      debugPrint(JsonEncoder.withIndent(" ").convert(response.body),
          wrapWidth: 1024);
      if (response.statusCode == 200) {
        final User user = User.fromJson(jsonDecode(response.body)["message"]);
        return user;
      } else
        return jsonDecode(response.body)["description"];
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future login(Map map) async {
    try {
      final response = await http
          .post(
            GlobalConfig.realDomain + "/users/login",
            body: map,
          )
          .timeout(
            Duration(seconds: 10),
          );
      print(jsonDecode(response.body));
      if (response.statusCode == 200) {
        final User user = User.fromJson(jsonDecode(response.body)["message"]);
        print(jsonDecode(response.body)["message"]);
        StorageManager.setObject("user", user);
        return user;
      } else
        return jsonDecode(response.body)["message"];
    } catch (e) {
      return "No connection! Plz try again!";
    }
  }

  static Future<User> searchContact(String query) async {
    try {
      final response = await http.get(
        GlobalConfig.realDomain + "/users/search_contact/$query",
      );
      print(response.body);
      if (response.statusCode == 200) {
        print(jsonDecode(response.body)["message"]);
        final User user = User.fromJson(jsonDecode(response.body)["message"]);
        return user;
      } else
        return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  /// log out
  static logout() async {
    try {
      final user = await StorageManager.getObjectByKey("user");
      final response = await http
          .get(GlobalConfig.realDomain + "/users/logout/${user["_id"]}");
      final result = jsonDecode(response.body);
      print(result);
      if (result["status"] == "success") {
        await StorageManager.clearStorageByKey("user");
        final hasUser = await StorageManager.checkHasKey("user");
        print(hasUser);
      }
    } catch (e) {
      print(e);
    }
  }

  // static createChatRoom(Map<String, dynamic> map) async {
  //   print(json.encode(map));
  //   try {
  //     final response = await http.post(
  //       GlobalConfig.realDomain + "/rooms/create",
  //       body: json.encode(map),
  //       headers: headers,
  //     );
  //     print(response.body);
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  static createChatRoom(Map<String, dynamic> data) async {
    try {
      final response = await http
          .post(
            GlobalConfig.realDomain + "/rooms/rooms-for-two-user",
            headers: headers,
            body: jsonEncode(data),
          )
          .timeout(Duration(seconds: 10));
      print(response.body);
      final result = jsonDecode(response.body);
      if (result["status"] == "success") {
        return result["message"]["_id"];
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  // static sentMessage(Map data) async {
  //   try {
  //     final reponse = await

  //   } catch (e) {}
  // }
}
