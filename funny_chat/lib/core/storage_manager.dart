import 'dart:async';
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
    }
  }

  static Future getStorageByKey(String keyName) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.get(keyName);
  }

  static dynamic getObjectByKey(String keyName) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.get(keyName);
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
