import 'package:flutter/cupertino.dart';

class ChatViewModel with ChangeNotifier {
  bool _selected = false;

  bool get selected => _selected;

  set chooseMessage(bool selected) {
    _selected = selected;
    notifyListeners();
  }
}
