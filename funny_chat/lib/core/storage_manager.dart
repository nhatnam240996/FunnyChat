import 'dart:async';
import 'dart:convert';
import 'package:funny_chat/core/models/account/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageManager {
  static setStorage(String keyName, dynamic keyValue) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    switch (keyValue.runtimeType) {
      case String:
        pref.setString(keyName, keyValue);
        break;
      case int:
        pref.setInt(keyName, keyValue);
        break;
      case bool:
        pref.setBool(keyName, keyValue);
        break;
      case double:
        pref.setDouble(keyName, keyValue);
        break;
      case List:
        pref.setStringList(keyName, keyValue);
        break;
      case User:
        pref.setString(keyName, jsonDecode(keyValue));
        print("Good to move on");
        break;
    }
  }

  static Future setObject(String key, dynamic value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    //print(jsonEncode(value));
    await pref.setString(key, jsonEncode(value));
  }

  static Future getStorageByKey(String keyName) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.get(keyName);
  }

  static dynamic getObjectByKey(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return jsonDecode(pref.getString(key));
  }

  static checkHasKey(String keyName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(keyName);
  }

  static clearStorage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }

  static clearStorageByKey(String keyName) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove(keyName);
  }
}

StorageManager storageManager = StorageManager();
