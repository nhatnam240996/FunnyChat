import 'package:flutter/cupertino.dart';
import 'package:funny_chat/core/models/account/user.dart';
import 'package:funny_chat/core/storage_manager.dart';

class HomePageViewModel with ChangeNotifier {
  User user;
  String error;
  bool _validator = false;
  bool _visiable = true;

  HomePageViewModel() {
    //loadLocalUser();
  }

  // loadLocalUser() async {
  //   final currentUser = await StorageManager.getObjectByKey("user");
  //   print(currentUser);
  //   this.user = currentUser;
  // }

  login() {}
}
